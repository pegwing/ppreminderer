//
//  PPRClientActionSchedulerTests.m
//  ppreminderer
//
//  Created by David Bernard on 26/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PPRClientActionScheduler.h"
#import "PPRClientAction.h"

@interface PPRClientActionSchedulerTests : XCTestCase

@end

@implementation PPRClientActionSchedulerTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testScheduleEventsForClient
{
    PPRActionManager *actionManager = [[PPRActionManager alloc]init];
    PPRScheduler * scheduler = [[PPRScheduler alloc] init];
    PPRClientActionScheduler *clientActionScheduler = [[PPRClientActionScheduler alloc] initWithScheduler:scheduler actionManager:actionManager];
    
    PPRFacility *facility = [[PPRFacility alloc]init];
    facility.facilityId = @"FAC1";
    
    PPRClient *client = [[PPRClient alloc]init];
    client.facility = facility;
    client.scheduleItems = [[NSMutableArray alloc]init];
    
    NSDateComponents *timeOfDay = [[NSDateComponents alloc] init];
    timeOfDay.hour = 9;
    timeOfDay.minute = 10;
    
    PPRScheduleTime *scheduleTime = [[PPRScheduleTime alloc] initWithTimeOfDay:timeOfDay];
    PPRScheduledEvent *scheduledEvent = [[PPRScheduledEvent alloc]init];
    scheduledEvent.eventName = @"TestEventName";
    scheduledEvent.scheduled = scheduleTime;
    [client.scheduleItems addObject:scheduledEvent];
    
    [clientActionScheduler scheduleEventsForClient:client forParentAction:nil];

    [actionManager getAction:nil success:^(NSArray *actions) {
        XCTAssertEqual(actions.count, 1, "Should be one action");
        PPRClientAction *action = actions[0];
        XCTAssertEqualObjects(action.scheduledEvent, scheduledEvent, @"scheduled event should match");
        XCTAssertEqualObjects(action.client, client, @"client should match");
        
        XCTAssertEqualObjects(action.status, kStatusScheduled, @"status should default to scheduled");
        XCTAssertEqualObjects(action.context, scheduledEvent.eventName, @"context should default to eventname from scheduledevent");
        XCTAssertEqualObjects(action.facility, client.facility, @"facility should default to facility from client");
        // FIXME test dueTIme
        XCTAssertNotNil(action.dueTime, @"dueTime should be set");
    } failure:^(NSError *error) {
        XCTFail(@"Action should have be avalable");
    }];

}

@end
