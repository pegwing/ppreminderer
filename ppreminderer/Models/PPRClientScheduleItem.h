//
//  PPRClientScheduleItem.h
//  ppreminderer
//
//  Created by David Bernard on 8/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPRScheduleTime.h"
#import "PPRScheduledEvent.h"

@interface PPRClientScheduleItem : PPRScheduledEvent

/**
 Initialise with a context and scheduled time
 @param context a string that may match an instruction for the client
 @param eventName a string that refects the type of event
 @param scheduleTime a schedule time
 @param parent the client schedule item this item is part of
 @param children the client schedule items that make up this schedule item
 */
- (id) initWithContext:(NSString *)context eventName:(NSString *)eventName scheduledTime:(PPRScheduleTime *)scheduledTime parent:(PPRClientScheduleItem *)parent items:(NSMutableArray *)items;

- (id) initWithContext:(NSString *)context eventName:(NSString *)eventName scheduledTime:(PPRScheduleTime *)scheduledTime;

- (id) initWithContext:(NSString *)context eventName:(NSString *)eventName scheduledTime:(PPRScheduleTime *)scheduledTime parent:(PPRClientScheduleItem *)parent;

/**
 Name for the context of the activity
 - taking pills
 - applying cream
 - start PEG feed
 */
@property (nonatomic,strong) NSString *context;


@end
