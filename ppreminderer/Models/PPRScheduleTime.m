//
//  PPRScheduleTime.m
//  ppreminderer
//
//  Created by David Bernard on 8/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRScheduleTime.h"
#import "PPRScheduler.h"

@implementation PPRScheduleTime

- (id) initWithType:(PPRScheduleTimeType)type dailyEvent:(NSString *)dailyEvent offset:(NSDateComponents *)offset {
    self = [super init];
    if (self) {
        _type = type;
        _atDailyEvent = dailyEvent;
        if ( _offset.hour == NSDateComponentUndefined)
            _offset.hour = 0;
        if ( _offset.minute == NSDateComponentUndefined)
            _offset.minute = 0;
        if ( _offset.day == NSDateComponentUndefined)
            _offset.day = 0;
        _offset =  offset;
    }
    return self;
}
- (id)initWithDailyEvent:(NSString *)dailyEvent offset:(NSDateComponents *)offset
{
    return   [self initWithType:PPRScheduleTimeRelativeToDailyEvent  dailyEvent:dailyEvent offset:offset];
}

- (id)initWithTimeOfDay:(NSDateComponents *)timeOfDay
{
     return   [self initWithType:PPRScheduleTimeTimeOfDay dailyEvent:nil offset:timeOfDay];
}

- (id)initWhenRelative:(PPRScheduleTimeType)type offset:(NSDateComponents *)offset
{
    return   [self initWithType:type dailyEvent:nil offset:offset];
}

-(NSString *)description
{
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateStyle: NSDateFormatterNoStyle];
    [df setTimeStyle: NSDateFormatterShortStyle];
    NSString *description;
    switch (self.type) {
        case PPRScheduleTimeTimeOfDay: {
            
            PPRScheduler *scheduler = (PPRScheduler *)[PPRScheduler sharedInstance];
            NSDate * todayButAtOffset = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
            NSCalendar *gregorian_maybe;
            gregorian_maybe = scheduler.calendar;
            NSDateComponents *components = [gregorian_maybe components: NSUIntegerMax fromDate: todayButAtOffset];
            [components setHour: self.offset.hour];
            [components setMinute: self.offset.minute];
            [components setSecond: 0];                      // fixme: Is this what we want?  Why?
            
            NSDate *d = [gregorian_maybe dateFromComponents: components];
            description = [NSString stringWithFormat:@"At %@", [df stringFromDate:d]]; }
            break;

        case PPRScheduleTimeRelativeToStartOfParent:
            description = [NSString stringWithFormat:@"At Parent +%02.2ld %02.2ld",
                           (long)self.offset.hour, (long)self.offset.minute];
            break;
        case PPRScheduleTimeRelativeToDailyEvent:
            description = [NSString stringWithFormat:@"At %@ +%02.2ld %02.2ld",
                           self.atDailyEvent, (long)self.offset.hour, (long)self.offset.minute];
            break;

        case PPRScheduleTimeRelativeToPreviousItem:
            description = [NSString stringWithFormat:@"At Previous +%02.2ld %02.2ld",
                           (long)self.offset.hour, (long)self.offset.minute];
            break;
        default:
            description = @"Unknown schedule type";
            break;
    }
    
    return description;
}
@end
