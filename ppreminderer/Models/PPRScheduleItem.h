//
//  PPRScheduleItem.h
//  ppreminderer
//
//  Created by David Bernard on 30/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 The scheduler manages a list of schedule items with state.
 */
@interface PPRScheduleItem : NSObject
@property (nonatomic,strong) NSString *schedulingStatus;
@property (nonatomic,strong) NSDate *dueTime;
- (instancetype)initWithSchedulingStatus:(NSString *)schedulingStatus dueTime:(NSDate *)dueTime;

@end
