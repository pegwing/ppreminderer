//
//  PPRActionScheduleItem.h
//  ppreminderer
//
//  Created by David Bernard on 30/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRScheduleItem.h"
#import "PPRAction.h"

@interface PPRActionScheduleItem : PPRScheduleItem

@property (nonatomic,strong) PPRAction *action;

- (instancetype)initWithSchedulingStatus:(NSString *)schedulingStatus action:(PPRAction *)action dueTime:(NSDate *)dueTime;
@end
