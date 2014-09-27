//
//  PPRFacilityActionSchedulerTests.m
//  ppreminderer
//
//  Created by David Bernard on 26/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PPRFacilityActionScheduler.h"
#import "PPRAction.h"

@interface PPRFacilityActionSchedulerTests : XCTestCase

@end

@implementation PPRFacilityActionSchedulerTests


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

- (void)testScheduleEventsForFacility
{
    PPRActionManager *actionManager = [[PPRActionManager alloc]init];
    PPRScheduler * scheduler = [[PPRScheduler alloc] init];
    PPRFacilityActionScheduler *facilityActionScheduler = [[PPRFacilityActionScheduler alloc] initWithScheduler:scheduler actionManager:actionManager];
    
    PPRFacility *facility = [[PPRFacility alloc]init];
    facility.facilityId = @"FAC1";
    
    facility.events = [[NSMutableArray alloc]init];
    
    NSDateComponents *timeOfDay = [[NSDateComponents alloc] init];
    timeOfDay.hour = 9;
    timeOfDay.minute = 10;
    
    PPRScheduleTime *scheduleTime = [[PPRScheduleTime alloc] initWithTimeOfDay:timeOfDay];
    PPRScheduledEvent *scheduledEvent = [[PPRScheduledEvent alloc]init];
    scheduledEvent.eventName = @"TestEventName";
    scheduledEvent.scheduled = scheduleTime;
    [facility.events addObject:scheduledEvent];
    
    [facilityActionScheduler scheduleEventsForFacility:facility];
    
    [actionManager getAction:nil success:^(NSArray *actions) {
        XCTAssertEqual(actions.count, 1, "Should be one action");
        PPRAction *action = actions[0];
        XCTAssertEqualObjects(action.scheduledEvent, scheduledEvent, @"scheduled event should match");
        XCTAssertEqualObjects(action.facility, facility, @"facility should match");
        
        XCTAssertEqualObjects(action.status, kStatusScheduled, @"status should default to scheduled");
        XCTAssertEqualObjects(action.context, scheduledEvent.eventName, @"context should default to eventname from scheduledevent");
        // FIXME test dueTIme
        XCTAssertNotNil(action.dueTime, @"dueTime should be set");
    } failure:^(NSError *error) {
        XCTFail(@"Action should have be avalable");
    }];
    
}

@end


