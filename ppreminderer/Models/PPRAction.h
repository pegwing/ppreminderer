//
//  PPRAction.h
//  ppreminderer
//
//  Created by David Bernard on 8/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPRClientScheduleItem.h"

@interface PPRAction : NSObject

@property (nonatomic,strong) NSDate *dueTime;
@property (nonatomic,weak) PPRScheduledEvent *scheduledEvent;
@property (nonatomic,weak) PPRAction *parent;
@property (nonatomic,strong) NSMutableArray *actions;
@property (nonatomic,strong) NSMutableArray *history;

-(id)initWithScheduledEvent:(PPRScheduledEvent *)scheduledEvent parent:(PPRAction *)parent actions:(NSMutableArray *)actions;


@end
