//
//  PPRScheduleItem.m
//  ppreminderer
//
//  Created by David Bernard on 30/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRScheduleItem.h"

@implementation PPRScheduleItem

- (instancetype)initWithSchedulingStatus:(NSString *)schedulingStatus dueTime:(NSDate *)dueTime{
    self = [super init];
    if (self) {
        _schedulingStatus = schedulingStatus;
        _dueTime = dueTime;
    }
    return self;
}
@end
