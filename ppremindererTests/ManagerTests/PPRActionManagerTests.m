//
//  PPRActionManagerTests.m
//  ppreminderer
//
//  Created by David Bernard on 24/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PPRTestIntialiser.h"
#import "PPRActionManager.h"

@interface PPRActionManagerTests : XCTestCase

@end

@implementation PPRActionManagerTests


- (void)setUp
{
    [super setUp];
    
    // Initialised the test shared instance
    // This loads the test shared instance of action manager with 3 actions.
    (void)[[PPRTestIntialiser sharedInstance] init];
}

- (void)tearDown
{
    [super tearDown];
}



- (void)testGetActionAll
{
    PPRActionManager *sharedInstance = (PPRActionManager *)[PPRActionManager sharedInstance];
    [sharedInstance getAction:nil
                      success:^(NSArray *actions) {
                          XCTAssertEqual(
                                         actions.count,
                                         1,
                                         @"Test shared instance should return 1 actions");
                      } failure:^(NSError *error) {
                          XCTFail("getAction with nil should not fail");
                      }];
}
- (void)testGetactionById
{
    PPRActionManager *sharedInstance = (PPRActionManager *)[PPRActionManager sharedInstance];
    PPRAction *actionFilter= [[PPRAction alloc]init];
    actionFilter.actionId = @"ACT0";
    [sharedInstance getAction:actionFilter
                      success:^(NSArray *actions) {
                          XCTAssertEqual(
                                         actions.count,
                                         1,
                                         @"Test shared instance should return 1 matching action");
                          XCTAssertEqualObjects(
                                                ((PPRAction *)actions[0]).actionId,
                                                @"ACT0",
                                                @"actionManager should return ACT1");
                      } failure:^(NSError *error) {
                          XCTFail("getAction with known action should not fail");
                      }];
}

- (void)testGetactionByIdUnknown
{
    PPRActionManager *sharedInstance = (PPRActionManager *)[PPRActionManager sharedInstance];
    PPRAction *actionFilter= [[PPRAction alloc]init];
    actionFilter.actionId = @"ACTXXX";
    [sharedInstance getAction:actionFilter
                      success:^(NSArray *actions) {
                          XCTFail( @"Test shared instance getAciton should fail if no action matches id specified");
                      }
                      failure:^(NSError *error) {
                          // pass
                      }];
}

static PPRAction *createTestAction(NSString *testEventName, NSString *testContext,
                                   NSDateComponents *testDateComponents)
{
    PPRScheduleTime *testScheduleTime = [[PPRScheduleTime alloc] initWithTimeOfDay:testDateComponents];
    PPRScheduledEvent *scheduledEvent = [[PPRScheduledEvent alloc] initWithEventName:testEventName scheduledTime:testScheduleTime];
    
    PPRAction *action = [[PPRAction alloc] initWithScheduledEvent:scheduledEvent parent:nil actions:nil];
    action.context = testContext;
    return action;
}

- (void)testInsertaction
{
    NSDateComponents *testDateComponents = [[NSDateComponents alloc] init];
    testDateComponents.hour = 10;
    testDateComponents.minute = 30;
    
    NSString *testEventName = @"TestEvent";
    NSString *testContext = @"TestContext";
    
    PPRAction *action = createTestAction(testEventName, testContext, testDateComponents);
    // Use private action manager
    PPRActionManager *actionManager = [[PPRActionManager alloc]init];
    
    // Check no actions in action manager
    [actionManager getAction:nil
                     success:^(NSArray *actions){
                         XCTAssertEqual(
                                        0,
                                        actions.count,
                                        "Allocated action manager should be empty");
                     }
                     failure:^(NSError *error) {
                         XCTFail("Should not fail");
                     }];
    
    // Add action
    [actionManager insertAction:action
                        success:^(PPRAction *action){
                            XCTAssertNotNil(
                                            action,
                                            "Provided action should not be nil");
                            XCTAssertNotNil(
                                            action.actionId,
                                            "Action id should have been allocated");
                        }
                        failure:^(NSError *error) {
                            XCTFail("Insert should not fail");
                            
                        }];
    // First and only action should be action 0
    [actionManager getAction:nil
                     success:^(NSArray *actions) {
                         XCTAssertEqual(
                                        actions.count,
                                        1,
                                        @"Should return 1 actions");
                         PPRAction *storedAction = (PPRAction *)actions[0];
                         XCTAssertEqualObjects(
                                               storedAction.actionId,
                                               @"ACT0",
                                               @"Assigned action id should be ACT0");
                         XCTAssertEqualObjects(
                                               storedAction.context,
                                               testContext,
                                               @"Stored action should have correct context");
                         XCTAssertNotNil(
                                         storedAction.scheduledEvent,
                                         @"Stored action should have a scheduled event");
                         PPRScheduledEvent *storedScheduledEvent = storedAction.scheduledEvent;
                         XCTAssertEqualObjects(
                                               storedScheduledEvent.eventName,
                                               testEventName,
                                               @"Stored scheduled event should have correct event name");
                         
                         XCTAssertEqualObjects(
                                               storedScheduledEvent.eventName,
                                               testEventName,
                                               @"Stored scheduled event should have correct event name");
                         XCTAssertNotNil(
                                         storedScheduledEvent.scheduled,
                                         @"Stored scheduled event should have a schedule time");
                         PPRScheduleTime *storedScheduledTime = storedScheduledEvent.scheduled;
                         XCTAssertEqualObjects(
                                               storedScheduledTime.offset,
                                               testDateComponents,
                                               @"Stored schedule time should have correct offset");
                         XCTAssertEqual(
                                        storedScheduledTime.type,
                                        PPRScheduleTimeTimeOfDay,
                                        @"Stored schedule time should have correct type");
                     }
                     failure:^(NSError *error) {
                         XCTFail("getaction with nil should not fail");
                     }];
    
    // Insert action a second time
    PPRAction *action2 = createTestAction(testEventName, testContext, testDateComponents);
    [actionManager insertAction:action2
                        success:^(PPRAction *action){
                            XCTAssertNotNil(
                                            action,
                                            "Provided action should not be nil");
                            XCTAssertNotNil(
                                            action.actionId,
                                            "Action id should have been allocated");
                        }
                        failure:^(NSError *error) {
                            XCTFail("Insert should not fail");
                            
                        }];
    // Should now be able to retieve action 1
    PPRAction *actionFilter= [[PPRAction alloc]init];
    actionFilter.actionId = @"ACT1";
    [actionManager getAction:actionFilter
                     success:^(NSArray *actions) {
                         XCTAssertEqual(
                                        actions.count,
                                        1,
                                        @"actionManager should return 1 matching action");
                         XCTAssertEqualObjects(
                                               ((PPRAction *)actions[0]).actionId,
                                               @"ACT1",
                                               @"actionManager should return ACT1");
                     }
                     failure:^(NSError *error) {
                         XCTFail("getaction with known action should not fail");
                     }];
}

@end
