//
//  PPRScheduler.h
//  ppreminderer
//
//  Created by David Bernard on 8/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPRScheduleTime.h"
#import "PPRScheduledEvent.h"

@interface PPRScheduler : NSObject

@property (nonatomic, strong) NSDictionary *dailyEvents;
@property (nonatomic, strong) NSCalendar *calendar;

- (id)initWithDailyEvents:(NSDictionary *)dailyEvents;
- (NSDate *)dueTimeForScheduleTime: (PPRScheduleTime *)scheduleTime parentDueTime: (NSDate *)parentDueTime previousDueTime:(NSDate *)previousDueTime;
- (NSDate *)dateAtTimeOfDay:(NSDateComponents *)atTimeOfDay date:(NSDate *)date;
@end
