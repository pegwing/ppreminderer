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
    
    NSString *description;
    switch (self.type) {
        case PPRScheduleTimeTimeOfDay:
            description = [NSString stringWithFormat:@"At %02.2d %02.2d",
                           (int)self.offset.hour, (int)self.offset.minute];
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
