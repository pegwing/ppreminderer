//
//  PPRScheduleTime.h
//  ppreminderer
//
//  Created by David Bernard on 8/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"

typedef NS_ENUM(int, PPRScheduleTimeType) {
    PPRScheduleTimeRelativeToDailyEvent = 1,
    PPRScheduleTimeTimeOfDay,
    PPRScheduleTimeRelativeToPreviousItem,
    PPRScheduleTimeRelativeToStartOfParent
};

/**
 An object that represents when a schedule item is due to be performed.
 */
@interface PPRScheduleTime : MTLModel <MTLJSONSerializing>

/**
 Initialise a
 */
-(id)initWithType:(PPRScheduleTimeType)type dailyEvent:(NSString *) dailyEvent offset:(NSDateComponents *)offset;

-(id)initWithTimeOfDay:(NSDateComponents *)timeOfDay;
-(id)initWithDailyEvent:(NSString *)dailyEvent offset:(NSDateComponents *)offset;
-(id)initWhenRelative:(PPRScheduleTimeType)type offset:(NSDateComponents *)offset;

/**
 Type of schedule.
 */
@property (nonatomic) PPRScheduleTimeType type;

/**
 if associated with group events such as lunch, dinner, breakfast
 */
@property (nonatomic,strong) NSString *atDailyEvent;
/**
 if a time interval from previous schedule item
 */
@property (nonatomic, strong) NSDateComponents *offset;

/**
 Whether this schedule time is equivalent to another
 @param scheduleTime the schedule time to comment
 @return true if equivalent, otherwise false
 */
- (BOOL)isEquivalentTo:(PPRScheduleTime *)scheduleTime;
@end
