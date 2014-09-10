//
//  PPRScheduledEvent.m
//  ppreminderer
//
//  Created by David Bernard on 8/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRScheduledEvent.h"

@implementation PPRScheduledEvent
-(id)initWithEventName:(NSString *)eventName scheduledTime:(PPRScheduleTime *)scheduledTime parent:(PPRScheduledEvent *)parent events:(NSMutableArray *)events
{
    self = [super init];
    if (self) {
        _eventName = eventName;
        _scheduled = scheduledTime;
        _parent = parent;
        _events = events;
    }
    return self;
}

-(id)initWithEventName:(NSString *)eventName scheduledTime:(PPRScheduleTime *)scheduledTime
{
    return [self initWithEventName:eventName scheduledTime:scheduledTime parent:nil events:nil];

}
@end
