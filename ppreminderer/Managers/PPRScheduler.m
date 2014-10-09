//
//  PPRScheduler.m
//  ppreminderer
//
//  Created by David Bernard on 8/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRScheduler.h"
#import "PPRShiftManager.h"

NSString * const kSchedulerTimeChangedNotificationName = @"kSchedulerTimeChanged";

@interface PPRScheduler ()
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) void (^ticker)();
@property (nonatomic,strong) void (^processDueAction)(PPRAction *action);

-(PPRScheduledEvent *)findEvent:(NSString *)eventName events:(NSArray *)events;

@end

@implementation PPRScheduler

- (id) init {
    self = [super init];
    if (self) {
        _calendar = [NSCalendar currentCalendar];
        _actionManager = ((PPRActionManager *)[PPRActionManager sharedInstance]);
        _facilityManager = (PPRFacilityManager *)[PPRFacilityManager sharedInstance];

        _schedulerTime = [NSDate date];
        _warpFactor = 1.0;
        
        _schedule = [[NSMutableArray alloc] init];
    }
    [[NSNotificationCenter defaultCenter] addObserverForName:kShiftChangedNotificationName object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [self loadEventsAndActions];
    }];
    
    return self;
}

- (void) loadEventsAndActions {
    
    NSString *facilityId =
    ((PPRShiftManager *)[PPRShiftManager sharedInstance]).shift.facilityId;
    
    [self.facilityManager getFacilityById:facilityId
                                  success:^(PPRFacility *facility) {
                                      self.dailyEvents = facility.events;
                                  }
                                  failure:^(NSError *error) {
                                      NSLog(@"Error getting facility");
                                      
                                  }];

    PPRAction *actionFilter = [[PPRAction alloc]init];
    PPRFacility *facility = [[PPRFacility alloc] init];
    actionFilter.facility = facility;
    actionFilter.facility.facilityId = facilityId;
    
    [self.actionManager getAction:actionFilter
                          success:^(NSArray *actions) {
                              self.schedule = [[NSMutableArray alloc] initWithArray:actions];
                              [self.schedule sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                                  return [((PPRAction *)obj1).dueTime compare:((PPRAction *)obj2).dueTime];
                              }];
                          }
                          failure:^(NSError *error) {
                              NSLog(@"Error getting actions");
                          }];
    
}

-(id)initWithDailyEvents:(NSArray *)dailyEvents {
    self = [self init];
    if (self) {
        _dailyEvents = dailyEvents;
    }
    return self;
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
            dueTime = [self dateAtTimeOfDay:scheduleTime.offset date:currentTime];
            break;
        case PPRScheduleTimeRelativeToDailyEvent:
            event = [self findEvent:scheduleTime.atDailyEvent events:events];
            // FIXME Assumes events are all atTimeOfDay
            // FIXME event may be nil
            dueTime = [self dateAtTimeOfDay:event.scheduled.offset date:currentTime];
            dueTime = [self.calendar dateByAddingComponents:scheduleTime.offset toDate:dueTime options:0];
            break;
        case PPRScheduleTimeRelativeToPreviousItem:
            dueTime = [self.calendar dateByAddingComponents:scheduleTime.offset toDate:previousDueTime options:0];
            break;
        case PPRScheduleTimeRelativeToStartOfParent:
            dueTime = [self.calendar dateByAddingComponents:scheduleTime.offset toDate:parentDueTime options:0];
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
    [self.calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    NSDate *startOfDayDate = [self.calendar dateFromComponents:startOfDay];
    NSDate *timeOfDayDate = [self.calendar dateByAddingComponents:atTimeOfDay toDate:startOfDayDate options:0];
    return timeOfDayDate;
}

- (NSDate *)dateAdjustedForSchedulerTimer:(NSDate *)date {
    NSDate *currentDate = [NSDate date];
    NSTimeInterval difference = [date timeIntervalSinceDate:self.schedulerTime];
    NSDate *adjustedDate = [currentDate dateByAddingTimeInterval:difference/self.warpFactor];
    return adjustedDate;
    
}

- (void)setDueActionProcessor:(void (^)(PPRAction *action)) dueActionProcessor{
    self.processDueAction = dueActionProcessor;
}


- (void)updateSchedule {
    [self.schedule enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PPRAction *action = (PPRAction *)obj;
        if ([action.dueTime compare:self.schedulerTime] == NSOrderedAscending) {
            self.processDueAction(action);
        }
    }];
}
- (void)timerTick:(NSTimer *)timer {
    self.schedulerTime = [NSDate dateWithTimeInterval:self.warpFactor sinceDate:self.schedulerTime];
    [self updateSchedule];
    self.ticker();
}

- (void)addEventToSchedule:(PPRAction *)action {
    [self.schedule addObject: action];
    [self.schedule sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [((PPRAction *)obj1).dueTime compare:((PPRAction *)obj2).dueTime];
    }];
}

- (void)startTimerWithBlock:(void (^)()) ticker {
    self.ticker = ticker;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.warpFactor target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
}


@end
