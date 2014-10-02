//
//  PPRActionScheduleItem.m
//  ppreminderer
//
//  Created by David Bernard on 30/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRActionScheduleItem.h"

@implementation PPRActionScheduleItem

- (instancetype)initWithSchedulingStatus:(NSString *)schedulingStatus action:(PPRAction *)action dueTime:(NSDate *)dueTime {
    self = [super initWithSchedulingStatus:schedulingStatus dueTime:dueTime];
    if (self) {
        _action = action;
    }
    return self;
}
@end
