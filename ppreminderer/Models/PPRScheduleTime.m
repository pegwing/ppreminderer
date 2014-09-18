//
//  PPRScheduleTime.m
//  ppreminderer
//
//  Created by David Bernard on 8/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRScheduleTime.h"

@implementation PPRScheduleTime

- (id) initWithType:(PPRScheduleTimeType)type dailyEvent:(NSString *)dailyEvent offset:(NSDateComponents *)offset {
    self = [super init];
    if (self) {
        _type = type;
        _atDailyEvent = dailyEvent;
        _offset =  offset;
    }
    return self;
}
- (id)initWithDailyEvent:(NSString *)dailyEvent offset:(NSDateComponents *)offset
{
    return   [self initWithType:PPRScheduleTimeRelativeToDailyEvent  dailyEvent:dailyEvent offset:0];
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
            
            NSDate * todayButAtOffset = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
            NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: todayButAtOffset];
            [components setHour: self.offset.hour];
            [components setMinute: self.offset.minute];
            [components setSecond: 0];                      // fixme: Is this what we want?  Why?
            
            NSDate * d = [gregorian dateFromComponents: components];
            // TODO reset to midnight, poke in hour and minute from offset.hour and offset.minute
            
            description = [NSString stringWithFormat:@"At %@", [df stringFromDate:d]]; }
            break;
        case PPRScheduleTimeRelativeToStartOfParent:
            description = [NSString stringWithFormat:@"At Parent +%02.2d %02.2d",
                           self.offset.hour, self.offset.minute];
            break;
        case PPRScheduleTimeRelativeToDailyEvent:
            description = [NSString stringWithFormat:@"At %@ +%02.2d %02.2d",
                           self.atDailyEvent, self.offset.hour, self.offset.minute];
            break;

        case PPRScheduleTimeRelativeToPreviousItem:
            description = [NSString stringWithFormat:@"At Previous +%02.2d %02.2d",
                           self.offset.hour, self.offset.minute];
            break;
        default:
            description = @"Unknown schedule type";
            break;
    }
    
    return description;
}
@end
