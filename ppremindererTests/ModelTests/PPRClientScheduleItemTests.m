//
//  PPRClientScheduleItemTests.m
//  ppreminderer
//
//  Created by David Bernard on 8/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PPRScheduleTime.h"
#import "PPRClientScheduleItem.h"
#import "PPRScheduler.h"


@interface PPRClientScheduleItemTests : XCTestCase

@end

static PPRScheduler *scheduler;
static PPRClientScheduleItem *dailyEventSchedule;
static PPRClientScheduleItem *timeOfDaySchedule;
static PPRClientScheduleItem *offsetToPreviousSchedule;
static PPRClientScheduleItem *offsetToParentSchedule;
static NSCalendar *calendar;
static NSArray *events;

@implementation PPRClientScheduleItemTests

- (void)setUp
{
    [super setUp];
    
    // Create a scheduled event for breakfast at 10am
    NSDateComponents *eventTimeOfDay =[[NSDateComponents alloc] init];
    eventTimeOfDay.hour = 10;
    eventTimeOfDay.minute = 15;

    PPRScheduleTime *eventTimeOfDayScheduleTime = [[PPRScheduleTime alloc] initWithTimeOfDay:eventTimeOfDay];
    PPRScheduledEvent *event = [[PPRScheduledEvent alloc] initWithEventName:@"Breakfast" scheduledTime:eventTimeOfDayScheduleTime];
    events = @[ event];
   
    // Inialise Scheduler with daily events
    scheduler = [[PPRScheduler alloc] initWithDailyEvents:events];
   

    calendar = [NSCalendar currentCalendar];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testDailyEventScheduleItem
{
    
    // Schedule at breakfast
    NSDateComponents *offset = [[NSDateComponents alloc] init];
    offset.minute = -30;
    PPRScheduleTime *dailyEventScheduleTime = [[PPRScheduleTime alloc]
                                               initWithDailyEvent:@"Breakfast" offset:offset];
    
    dailyEventSchedule = [[PPRClientScheduleItem alloc] initWithContext:@"take pill" eventName:@"Take green pill" scheduledTime: dailyEventScheduleTime];

    NSDate *dueTime = [scheduler dueTimeForScheduleTime:dailyEventSchedule.scheduled parentDueTime:nil previousDueTime:nil events:events];
    
    NSDateComponents *components =
    [calendar components:(NSCalendarUnitHour|NSCalendarUnitMinute) fromDate:dueTime];
    XCTAssertEqual(9, components.hour, @"Not 10 carry 15 - 30");
    XCTAssertEqual(45, components.minute, @"Not 15 - 30 minutes");
}

- (void)testTimeOfDateClientScheduleItem
{
    // Scheduled at 9am
    NSDateComponents *timeOfDay =[[NSDateComponents alloc] init];
    timeOfDay.hour = 9;
    
    PPRScheduleTime *timeOfDayScheduleTime = [[PPRScheduleTime alloc] initWithTimeOfDay:timeOfDay];
    timeOfDaySchedule = [[PPRClientScheduleItem alloc] initWithContext:@"take pill" eventName:@"Take green pill"scheduledTime: timeOfDayScheduleTime];
    NSDate *dueTime = [scheduler dueTimeForScheduleTime:timeOfDaySchedule.scheduled parentDueTime:nil previousDueTime:nil events:events];
    
    NSDateComponents *components =
    [calendar components:NSCalendarUnitHour fromDate:dueTime];
    XCTAssertEqual(9, components.hour, @"Not 9 o'clock");

}
- (void)testOffsetToPrevious
{
    // offset to previous item -30 minutes
    NSDateComponents *previousOffset = [[NSDateComponents alloc] init];
    previousOffset.minute = -30;
    PPRScheduleTime *offsetToPreviousScheduleTime = [[PPRScheduleTime alloc] initWhenRelative:PPRScheduleTimeRelativeToPreviousItem offset:previousOffset];
    
    NSDate *now = [NSDate date];
    NSDate *dueTime = [scheduler dueTimeForScheduleTime:offsetToPreviousScheduleTime
                                          parentDueTime:nil
                                        previousDueTime:now
                                                 events:events];
    NSDate *expectedDueTime = [now dateByAddingTimeInterval:-1800.0];
    XCTAssertEqualObjects(dueTime, expectedDueTime, @"Not correctly adjusted");
    
}

- (void)testOffsetToParent
{
    // offset to start of parent 30 minutes
    NSDateComponents *parentOffset = [[NSDateComponents alloc] init];
    parentOffset.minute = 30;
    PPRScheduleTime *offsetToParentScheduleTime = [[PPRScheduleTime alloc] initWhenRelative:PPRScheduleTimeRelativeToStartOfParent offset:parentOffset];
    
    NSDate *now = [NSDate date];
    NSDate *dueTime = [scheduler dueTimeForScheduleTime:offsetToParentScheduleTime
                                          parentDueTime:now
                                        previousDueTime:nil
                                                 events:events];
    NSDate *expectedDueTime = [now dateByAddingTimeInterval:1800.0];
    XCTAssertEqualObjects(dueTime, expectedDueTime, @"Not correctly adjusted");
    
}
@end
