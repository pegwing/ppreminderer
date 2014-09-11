//
//  PPRScheduledEvent.h
//  ppreminderer
//
//  Created by David Bernard on 8/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPRScheduleTime.h"

@interface PPRScheduledEvent : NSObject
@property (nonatomic,strong) NSString *eventName;
/**
 Time scheduled
 */
@property (nonatomic, strong) PPRScheduleTime *scheduled;
/**
 Parent Schedule item
 */
@property (nonatomic, weak) PPRScheduledEvent *parent;

/**
 Included items
 */
@property (nonatomic, strong) NSMutableArray *events;
/**
 @param eventName Name of event
 @param scheduledTime Scheduled time
 @param parent the parent event
 @param events the children or sub events
 */
- (id) initWithEventName:(NSString *)eventName scheduledTime:(PPRScheduleTime *)scheduledTime parent:(PPRScheduledEvent *)parent events:(NSMutableArray *)events;
- (id) initWithEventName:(NSString *)eventName scheduledTime:(PPRScheduleTime *)scheduledTime;
@end
