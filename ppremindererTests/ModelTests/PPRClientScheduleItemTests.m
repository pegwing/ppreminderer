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
    PPRScheduleTime *dailyEventScheduleTime = [[PPRScheduleTime alloc] initWithDailyEvent:@"Breakfast" offset:nil];
    dailyEventSchedule = [[PPRClientScheduleItem alloc] initWithContext:@"take pill" eventName:@"Take green pill" scheduledTime: dailyEventScheduleTime];

    NSDate *dueTime = [scheduler dueTimeForScheduleTime:dailyEventSchedule.scheduled parentDueTime:nil previousDueTime:nil];
    
    NSDateComponents *components =
    [calendar components:NSCalendarUnitHour fromDate:dueTime];
    XCTAssertEqual(10, components.hour, @"Not 10 o'clock");
}

- (void)testTimeOfDateClientScheduleItem
{
    // Scheduled at 9am
    NSDateComponents *timeOfDay =[[NSDateComponents alloc] init];
    timeOfDay.hour = 9;
    
    PPRScheduleTime *timeOfDayScheduleTime = [[PPRScheduleTime alloc] initWithTimeOfDay:timeOfDay];
    timeOfDaySchedule = [[PPRClientScheduleItem alloc] initWithContext:@"take pill" eventName:@"Take green pill"scheduledTime: timeOfDayScheduleTime];
    NSDate *dueTime = [scheduler dueTimeForScheduleTime:timeOfDaySchedule.scheduled parentDueTime:nil previousDueTime:nil];
    
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
    offsetToPreviousSchedule = [[PPRClientScheduleItem alloc] initWithContext:@"take pill" eventName:@"Take green pill" scheduledTime:offsetToPreviousScheduleTime];
    
    NSDate *now = [NSDate date];
    NSDate *dueTime = [scheduler dueTimeForScheduleTime:offsetToPreviousSchedule.scheduled parentDueTime:nil previousDueTime:now];
    NSDate *expectedDueTime = [now dateByAddingTimeInterval:-1800.0];
    XCTAssertEqualObjects(dueTime, expectedDueTime, @"Not correctly adjusted");
    
}

- (void)testOffsetToParent
{
    // offset to start of parent 30 minutes
    NSDateComponents *parentOffset = [[NSDateComponents alloc] init];
    parentOffset.minute = 30;
    PPRScheduleTime *offsetToParentScheduleTime = [[PPRScheduleTime alloc] initWhenRelative:PPRScheduleTimeRelativeToStartOfParent offset:parentOffset];
    offsetToParentSchedule = [[PPRClientScheduleItem alloc] initWithContext:@"take pill" eventName:@"Take green pill"scheduledTime:offsetToParentScheduleTime];
    
    NSDate *now = [NSDate date];
    NSDate *dueTime = [scheduler dueTimeForScheduleTime:offsetToParentSchedule.scheduled parentDueTime:now previousDueTime:nil];
    NSDate *expectedDueTime = [now dateByAddingTimeInterval:1800.0];
    XCTAssertEqualObjects(dueTime, expectedDueTime, @"Not correctly adjusted");
    
}
@end
