//
//  PPRActionTests.m
//  ppreminderer
//
//  Created by David Bernard on 2/10/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PPRAction.h"
#import "PPRScheduler.h"

@interface PPRActionTests : XCTestCase

@end

@implementation PPRActionTests

- (void)setUp
{
    [super setUp];
    // Ensure the the scheudler is initialised
    (void)[[PPRScheduler sharedInstance]init];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testNotificationDueTimeDescription
{

    
    NSDateComponents *dateComponents = [[NSDateComponents alloc]init];
    dateComponents.hour = 9;
    dateComponents.minute = 15;
    
    PPRScheduleTime *scheduleTime = [[PPRScheduleTime alloc]initWithTimeOfDay:dateComponents
                                     ];
    PPRScheduledEvent *scheduledEvent =
    [[PPRScheduledEvent alloc]initWithEventName:@"TestEventName" scheduledTime:scheduleTime];
    PPRFacility *facility = [[PPRFacility alloc]init];
    
    PPRAction *action = [[PPRAction alloc ]initWithFacility:facility scheduledEvent:scheduledEvent parent:nil actions:nil];
    action.status = kStatusScheduled;
    
    NSDateComponents *dueDateComponents = [[NSDateComponents alloc]init];
    dueDateComponents.hour = 9;
    dueDateComponents.minute = 20;
    action.dueTime = [[NSCalendar currentCalendar] dateFromComponents:dueDateComponents];
    
    NSString *dueTimeDescription = [action dueTimeDescription];
    
    XCTAssertEqualObjects(dueTimeDescription, @"At 9:15 AM - 9:20:00 AM");
    
 
}

- (void)testNotificationDueTimeDescriptionWhenCompleted
{
    
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc]init];
    dateComponents.hour = 9;
    dateComponents.minute = 15;
    
    PPRScheduleTime *scheduleTime = [[PPRScheduleTime alloc]initWithTimeOfDay:dateComponents
                                     ];
    PPRScheduledEvent *scheduledEvent =
    [[PPRScheduledEvent alloc]initWithEventName:@"TestEventName" scheduledTime:scheduleTime];
    PPRFacility *facility = [[PPRFacility alloc]init];
    
    PPRAction *action = [[PPRAction alloc ]initWithFacility:facility scheduledEvent:scheduledEvent parent:nil actions:nil];
    action.status = kStatusCompleted;
    
    NSDateComponents *dueDateComponents = [[NSDateComponents alloc]init];
    dueDateComponents.hour = 9;
    dueDateComponents.minute = 20;
    action.dueTime = [[NSCalendar currentCalendar] dateFromComponents:dueDateComponents];
    
    NSDateComponents *completionDateComponents = [[NSDateComponents alloc]init];
    completionDateComponents.hour = 9;
    completionDateComponents.minute = 21;
    action.completionTime = [[NSCalendar currentCalendar] dateFromComponents:completionDateComponents];

    NSString *dueTimeDescription = [action dueTimeDescription];
    
    XCTAssertEqualObjects(dueTimeDescription, @"At 9:15 AM - 9:21:00 AM");
    
    
}

- (void)testTextForDetail
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc]init];
    dateComponents.hour = 9;
    dateComponents.minute = 15;
    
    PPRScheduleTime *scheduleTime = [[PPRScheduleTime alloc]initWithTimeOfDay:dateComponents
                                     ];
    PPRScheduledEvent *scheduledEvent =
    [[PPRScheduledEvent alloc]initWithEventName:@"TestEventName" scheduledTime:scheduleTime];
    PPRFacility *facility = [[PPRFacility alloc]init];
    
    PPRAction *action = [[PPRAction alloc ]initWithFacility:facility scheduledEvent:scheduledEvent parent:nil actions:nil];
    action.status = kStatusCompleted;
    XCTAssertEqualObjects(action.textForDetail, @"    At 9:15 AM - (null)");
}

- (void)testTextForLabel
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc]init];
    dateComponents.hour = 9;
    dateComponents.minute = 15;
    
    PPRScheduleTime *scheduleTime = [[PPRScheduleTime alloc]initWithTimeOfDay:dateComponents
                                     ];
    PPRScheduledEvent *scheduledEvent =
    [[PPRScheduledEvent alloc]initWithEventName:@"TestEventName" scheduledTime:scheduleTime];
    PPRFacility *facility = [[PPRFacility alloc]init];
    
    PPRAction *action = [[PPRAction alloc ]initWithFacility:facility scheduledEvent:scheduledEvent parent:nil actions:nil];
    action.status = kStatusCompleted;
    XCTAssertEqualObjects(action.textForLabel, @"TestEventName");
}

@end
