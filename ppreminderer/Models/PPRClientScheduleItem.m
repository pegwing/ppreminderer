//
//  PPRClientScheduleItem.m
//  ppreminderer
//
//  Created by David Bernard on 8/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRClientScheduleItem.h"

@implementation PPRClientScheduleItem

- (id) initWithContext:(NSString *)context eventName:(NSString *)eventName scheduledTime:(PPRScheduleTime *)scheduledTime parent:(PPRClientScheduleItem *)parent items:(NSMutableArray *)items {
    self = [super initWithEventName:eventName scheduledTime:scheduledTime
                             parent:parent events:items];
    if (self) {
        _context = context;
    }
    return self;
}
- (id)initWithContext:(NSString *)context eventName:(NSString *)eventName scheduledTime:(PPRScheduleTime *)scheduledTime {
    return [self initWithContext:context eventName:eventName scheduledTime:scheduledTime parent:nil items:nil];
}
-(id)initWithContext:(NSString *)context eventName:(NSString *)eventName scheduledTime:(PPRScheduleTime *)scheduledTime parent:(PPRClientScheduleItem *)parent {
    
    return [self initWithContext:context eventName:eventName scheduledTime:scheduledTime parent:parent items:nil];
}
@end
