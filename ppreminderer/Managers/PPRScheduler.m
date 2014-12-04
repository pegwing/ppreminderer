//
//  PPRScheduler.m
//  ppreminderer
//
//  Created by David Bernard on 8/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRScheduler.h"
#import "PPRActionScheduleItem.h"

NSString * const kSchedulerTimeChangedNotificationName = @"SchedulerTimeChangedNotification";
NSString * const kSchedulerTimeTickNotificationName = @"SchedulerTimeTickNotification";
NSString * const kScheduleChangedNotificationName = @"ScheduleChangedNotification";

NSString * const kSchedulingStatusScheduled = @"Scheduled";
NSString * const kSchedulingStatusNotified = @"Notified";
NSString * const kSchedulingStatusDue = @"Due";
NSString * const kSchedulingStatusCompleted = @"Completed";

@interface PPRScheduler ()
// Time to drive clock
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) void (^ticker)();
@property (nonatomic,strong) NSString * (^processDueAction)(PPRScheduleItem *action);
@property (nonatomic,strong) NSString * (^processFutureAction)(PPRScheduleItem *action);

-(PPRScheduledEvent *)findEvent:(NSString *)eventName events:(NSArray *)events;
-(void)scheduleAction:(PPRAction *)action;

@end

@implementation PPRScheduler

- (id) init {
    self = [super init];
    if (self) {
        _calendar = [NSCalendar currentCalendar];
        _locale = [NSLocale currentLocale];
        
        _actionManager = [PPRActionManager sharedInstance];
        _facilityManager = [PPRFacilityManager sharedInstance];
        _shiftManager = [PPRShiftManager sharedInstance];
        
        _schedulerTime = [NSDate date];
        _lastTickTime = _schedulerTime;
        _warpFactor = 1.0;
        
        _schedule = [[NSMutableArray alloc] init];
    }
    // Register to be informed of shift state changes
    [[NSNotificationCenter defaultCenter] addObserverForName:kShiftChangedNotificationName object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [self loadEventsAndActions];
    }];
    
    return self;
}

-(id)initWithDailyEvents:(NSArray *)dailyEvents {
    self = [self init];
    if (self) {
        _dailyEvents = dailyEvents;
    }
    return self;
}

/**
 Load events from the currently selected facility manager and load actions from
 the action manager.
 */
- (void) loadEventsAndActions {
    NSString *facilityId = self.shiftManager.shift.facilityId;
    
    [self.facilityManager getFacilityById:facilityId
                                  success:^(PPRFacility *facility) {
                                      self.dailyEvents = facility.events;
                                  }
                                  failure:^(NSError *error) {
                                      NSLog(@"Error getting facility");
                                  }];
    // Filter actions by facility
    PPRAction *actionFilter = [[PPRAction alloc]init];
    actionFilter.facilityId = facilityId;
    
    [self.actionManager getAction:actionFilter
                          success:^(NSArray *actions) {
                              self.schedule = [[NSMutableArray alloc] init];
                              [actions
                               enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                   [self scheduleAction:(PPRAction *)obj];
                                   
                               }];
                          }
                          failure:^(NSError *error) {
                              NSLog(@"Error getting actions");
                          }];
    [self sortSchedule];
}

/**
 Sort the schedule by due date
 */
- (void) sortSchedule {
    // Sort the schedule
    [self.schedule
     sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
         return [((PPRScheduleItem *)obj1).dueTime compare:((PPRScheduleItem *)obj2).dueTime];
     }];
    // FIXME group schedule items (?)
}

/**
 Schedule an action
 */
- (void) scheduleAction:(PPRAction *)action {
    PPRActionScheduleItem *item =
    [[PPRActionScheduleItem alloc] initWithSchedulingStatus:kStatusScheduled
                                                     action:action
                                                    dueTime:action.dueTime];
    [self.schedule addObject:item];
}
- (void)rescheduleItemDueTime:(NSDate *)dueTime schedulingStatus:(NSString *)schedulingStatus passingTest:(BOOL (^)(PPRScheduleItem *))test {
    [self.schedule enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (test(obj)) {
            PPRScheduleItem *item = obj;
            item.dueTime = dueTime;
            item.schedulingStatus = schedulingStatus;
        }
    }];
    [self sortSchedule];
}


-(PPRScheduledEvent *)findEvent:(NSString *)eventName
                         events:(NSArray *)events {
    NSInteger index = [events
                       indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                           return [eventName
                                   isEqualToString:((PPRScheduledEvent *)obj).eventName];
                           
                       }];
    if (index != NSNotFound) {
        return events[index];
    }
    else {
        return nil;
    }
}

- (NSDate *)dueTimeForScheduleTime: (PPRScheduleTime *)scheduleTime
                     parentDueTime: (NSDate *)parentDueTime
                   previousDueTime:(NSDate *)previousDueTime
                            events: (NSArray *)events
{
    
    NSDate *dueTime;
    NSDate *currentTime = [NSDate date];
    PPRScheduledEvent * event;
    
    switch (scheduleTime.type ){
            
        case PPRScheduleTimeTimeOfDay:
            dueTime = [self dateAtTimeOfDay:scheduleTime.offset
                                       date:currentTime];
            break;
        case PPRScheduleTimeRelativeToDailyEvent:
            event = [self findEvent:scheduleTime.atDailyEvent
                             events:events];
            // FIXME Assumes events are all atTimeOfDay
            // FIXME event may be nil
            dueTime = [self dateAtTimeOfDay:event.scheduled.offset date:currentTime];
            dueTime = [self.calendar dateByAddingComponents:scheduleTime.offset
                                                     toDate:dueTime options:0];
            break;
        case PPRScheduleTimeRelativeToPreviousItem:
            dueTime = [self.calendar dateByAddingComponents:scheduleTime.offset
                                                     toDate:previousDueTime options:0];
            break;
        case PPRScheduleTimeRelativeToStartOfParent:
            dueTime = [self.calendar dateByAddingComponents:scheduleTime.offset
                                                     toDate:parentDueTime options:0];
            break;
        default:
            dueTime = [NSDate date];
            NSLog(@"Unknown schedule time type %d", scheduleTime.type);
            break;
    }
    return dueTime;
}

- (NSDate *)dateAtTimeOfDay:(NSDateComponents *)atTimeOfDay
                       date:(NSDate *)date {
    
    // FIXME wrap of schedule to go into next day for evening shift
    NSDateComponents *startOfDay =
    [self.calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                     fromDate:date];
    NSDate *startOfDayDate = [self.calendar dateFromComponents:startOfDay];
    NSDate *timeOfDayDate = [self.calendar dateByAddingComponents:atTimeOfDay
                                                           toDate:startOfDayDate options:0];
    return timeOfDayDate;
}

- (NSDate *)dateAdjustedForSchedulerTimer:(NSDate *)date {
    NSDate *currentDate = [NSDate date];
    NSTimeInterval difference = [date timeIntervalSinceDate:self.schedulerTime];
    NSDate *adjustedDate = [currentDate dateByAddingTimeInterval:difference/self.warpFactor];
    return adjustedDate;
    
}

- (void)setDueActionProcessor:(NSString * (^)(PPRScheduleItem *action)) dueActionProcessor{
    self.processDueAction = dueActionProcessor;
}

- (void)setFutureActionProcessor:(NSString * (^)(PPRScheduleItem *action)) furtureActionProcessor{
    self.processFutureAction = furtureActionProcessor;
}


- (void)updateSchedule {
    BOOL __block updated = false;
    [self.schedule
     enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
         PPRScheduleItem *item = (PPRScheduleItem *)obj;
         NSString *initialSchedulingStatus = item.schedulingStatus;
         if ([item.dueTime compare:self.schedulerTime] == NSOrderedAscending) {
             // If becoming due call due processor and mark as notified
             if ([item.schedulingStatus isEqualToString:kSchedulingStatusScheduled]
                 || [item.schedulingStatus isEqualToString:kSchedulingStatusNotified]) {
                 item.schedulingStatus = self.processDueAction(item);
                 
             }
         } else {
             // If scheduled and can be processed then update oo Notified.
             if ( [item.schedulingStatus isEqualToString:kSchedulingStatusScheduled]) {
                 item.schedulingStatus = self.processFutureAction(item);
             }
             
         }
         // If the status has changed then notify
         if (![initialSchedulingStatus isEqualToString:item.schedulingStatus])
             updated = true;
         
     }];
    if (updated) {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:kScheduleChangedNotificationName object:nil];
        
    }
}
- (void)timerTick:(NSTimer *)timer {
    NSDate *now = [NSDate date];
    
    // Time since schedule time last set
    NSTimeInterval elapsedTime = [now timeIntervalSinceDate:self.lastTickTime];
    
    // Update scheduler time adjusted by warp factor
    NSTimeInterval timeAdjustment = elapsedTime * self.warpFactor;
    self.schedulerTime = [self.schedulerTime dateByAddingTimeInterval:timeAdjustment];
    self.lastTickTime = now;
    
    // Process tick
    [self updateSchedule];
    self.ticker();
}

- (void)addEventToSchedule:(PPRScheduleItem *)action {
    [self.schedule addObject: action];
    [self.schedule
     sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
         return [((PPRScheduleItem *)obj1).dueTime compare:((PPRScheduleItem *)obj2).dueTime];
     }];
}

- (void)startTimerWithBlock:(void (^)()) ticker {
    self.ticker = ticker;
    // Run timer once every Second.
    // FIXME can this be optimised to reduce power consumption?
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self selector:@selector(timerTick:)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)saveState {
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber
                                                      numberWithDouble:([self.schedulerTime timeIntervalSinceReferenceDate])]
                                              forKey:@"SchedulerTime"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber
                                                      numberWithDouble:([self.lastTickTime timeIntervalSinceReferenceDate])]
                                              forKey:@"LastTickTime"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber
                                                      numberWithDouble:self.warpFactor]
                                              forKey:@"WarpFactor"];
    
}

- (void)restoreState {
    NSNumber *schedulerTimeOffset = (NSNumber *)([[NSUserDefaults standardUserDefaults] objectForKey:@"SchedulerTime"]);
    NSNumber *lastTickTimeOffset = (NSNumber *)([[NSUserDefaults standardUserDefaults] objectForKey:@"LastTickTime"]);
    if (schedulerTimeOffset == nil ) {
        self.schedulerTime = [NSDate date];
        self.lastTickTime = [NSDate date];
        self.warpFactor = 1.0;
    } else {
        self.warpFactor = [(NSNumber *)([[NSUserDefaults standardUserDefaults] objectForKey:@"WarpFactor"]) doubleValue];
        
        self.schedulerTime = [NSDate dateWithTimeIntervalSinceReferenceDate:[schedulerTimeOffset doubleValue] ];
        self.lastTickTime = [NSDate dateWithTimeIntervalSinceReferenceDate:[lastTickTimeOffset doubleValue] ];
    }
}

@end
