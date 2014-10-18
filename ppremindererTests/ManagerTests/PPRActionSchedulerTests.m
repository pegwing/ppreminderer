//
//  PPRActionSchedulerTests.m
//  ppreminderer
//
//  Created by David Bernard on 26/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PPRTestInitialiser.h"
#import "PPRAction.h"
#import "PPRActionScheduler.h"
#import "PPRScheduler.h"

@interface PPRActionSchedulerTests : XCTestCase

@end

@implementation PPRActionSchedulerTests

- (void)setUp
{
    [super setUp];
    
    (void)[[PPRTestInitialiser sharedInstance] init];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testDueTimeForAction
{
    PPRActionScheduler *actionScheduler = [[PPRActionScheduler alloc] init];
    PPRScheduler *scheduler = (PPRScheduler *)[PPRScheduler sharedInstance];
    PPRAction *action = [[PPRAction alloc] init];
    NSDate *now = [NSDate date];
    action.dueTime = now;
    scheduler.schedulerTime = now;
    
    NSDate *calcuatedDueTime = [actionScheduler dueTimeForAction:action delayedBy:0];
    XCTAssertEqualObjects(now, calcuatedDueTime, "due time should be unadjusted");

    calcuatedDueTime = [actionScheduler dueTimeForAction:action delayedBy:1.0];
    XCTAssertNotEqualObjects(now, calcuatedDueTime, "due time should be adjusted");
    
    NSDate *expectedTime = [now dateByAddingTimeInterval:1];
    XCTAssertEqualObjects(expectedTime, calcuatedDueTime, "due time should be adjusted");

    // Overdue
    action.dueTime = [now dateByAddingTimeInterval:1.0];
    scheduler.schedulerTime = [now dateByAddingTimeInterval:2.0];
    expectedTime = [now dateByAddingTimeInterval:4.0];
    
    calcuatedDueTime = [actionScheduler dueTimeForAction:action delayedBy:2.0];
    XCTAssertEqualObjects(expectedTime, calcuatedDueTime, "due time should be adjusted");
}

@end
