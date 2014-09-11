//
//  PPRScheduler.m
//  ppreminderer
//
//  Created by David Bernard on 8/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRScheduler.h"



@implementation PPRScheduler

-(id)initWithDailyEvents:(NSDictionary *)dailyEvents {
    self = [super init];
    if (self) {
        _calendar = [NSCalendar currentCalendar];
        _dailyEvents = dailyEvents;
    }
    return self;
}

- (NSDate *)dueTimeForScheduleTime: (PPRScheduleTime *)scheduleTime
                     parentDueTime: (NSDate *)parentDueTime
                   previousDueTime:(NSDate *)previousDueTime {
    
    NSDate *dueTime;
    NSDate *currentTime = [NSDate date];

    switch (scheduleTime.type ){
            
        case PPRScheduleTimeTimeOfDay:
            dueTime = [self dateAtTimeOfDay:scheduleTime.offset date:currentTime];
            break;
        case PPRScheduleTimeRelativeToDailyEvent:
            // FIXME Assumes events are all atTimeOfDay
           dueTime = [self dateAtTimeOfDay:((PPRScheduledEvent *)(self.dailyEvents[scheduleTime.atDailyEvent])).scheduled.offset date:currentTime];
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
@end
