//
//  PPRScheduler.m
//  ppreminderer
//
//  Created by David Bernard on 8/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRScheduler.h"

NSString * const kSchedulerTimeChangedNotificationName = @"kSchedulerTimeChanged";

@interface PPRScheduler ()
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) void (^ticker)();

-(PPRScheduledEvent *)findEvent:(NSString *)eventName;

@end

@implementation PPRScheduler

- (id) init {
    self = [super init];
    if (self) {
        _calendar = [NSCalendar currentCalendar];
        _schedulerTime = [NSDate date];
        _warpFactor = 1.0;
    }
    return self;
}

-(id)initWithDailyEvents:(NSArray *)dailyEvents {
    self = [self init];
    if (self) {
        _dailyEvents = dailyEvents;
    }
    return self;
}

-(PPRScheduledEvent *)findEvent:(NSString *)eventName {
    NSInteger index = [self.dailyEvents
                 indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [eventName isEqualToString:((PPRScheduledEvent *)obj).eventName];
        
    }];
    if (index != NSNotFound) {
        return self.dailyEvents[index];
    }
    else {
        return nil;
    }
}

- (NSDate *)dueTimeForScheduleTime: (PPRScheduleTime *)scheduleTime
                     parentDueTime: (NSDate *)parentDueTime
                   previousDueTime:(NSDate *)previousDueTime {
    
    NSDate *dueTime;
    NSDate *currentTime = [NSDate date];
    PPRScheduledEvent * event;
    
    switch (scheduleTime.type ){
            
        case PPRScheduleTimeTimeOfDay:
            dueTime = [self dateAtTimeOfDay:scheduleTime.offset date:currentTime];
            break;
        case PPRScheduleTimeRelativeToDailyEvent:
            event = [self findEvent:scheduleTime.atDailyEvent];
            // FIXME Assumes events are all atTimeOfDay
            // FIXME event may be nil
            dueTime = [self dateAtTimeOfDay:event.scheduled.offset date:currentTime];
            break;
        case PPRScheduleTimeRelativeToPreviousItem:
            dueTime = [self.calendar dateByAddingComponents:scheduleTime.offset toDate:previousDueTime options:0];
            break;
        case PPRScheduleTimeRelativeToStartOfParent:
            dueTime = [self.calendar dateByAddingComponents:scheduleTime.offset toDate:parentDueTime options:0];
            
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

- (void)timerTick:(NSTimer *)timer {
    self.schedulerTime = [NSDate dateWithTimeInterval:self.warpFactor sinceDate:self.schedulerTime];
    self.ticker();
}

- (void)startTimerWithBlock:(void (^)()) ticker {
    self.ticker = ticker;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.warpFactor target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
}


@end
