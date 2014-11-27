//
//  PPRSchedulerTest.m
//  ppreminderer
//
//  Created by David Bernard on 19/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PPRScheduler.h"
#import "PPRShiftManager.h"
#import "PPRTestInitialiser.h"
#import "PPRFacilityManager.h"

@interface PPRSchedulerTest : XCTestCase

@end

@implementation PPRSchedulerTest

static PPRScheduler *scheduler;
static NSCalendar *calendar;
static NSArray *events;



- (void)setUp
{
    [super setUp];
    (void)[[PPRTestInitialiser sharedInstance] init];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLoadEventsAndAction {
    
    // Assert FAC1 as selected facility
    PPRShiftManager *shiftManager = [(PPRShiftManager *)[PPRShiftManager sharedInstance] init];
    PPRShift *shift = shiftManager.shift;
    shift.facilityId = @"FAC1";
    
    [shiftManager publishShift:shift];
    
    PPRFacility __block *testFacility;
    
    [((PPRFacilityManager *)[PPRFacilityManager sharedInstance])
     getFacilityById:@"FAC1"
     success:^(PPRFacility *facility) {
         testFacility = facility;
     }
     failure:^(NSError *error) {
         XCTFail(@"getFacilityById should not fail");
     }];

    PPRScheduler *scheduler = [[PPRScheduler alloc] init];

    // Overried action manager
    scheduler.actionManager = (PPRActionManager *)[[PPRActionManager alloc] init];
    
    [scheduler.actionManager getAction:nil success:^(NSArray *actions) {
        XCTAssertEqual(actions.count, 0);
    } failure:^(NSError *error) {
        XCTFail(@"getAction should not fail");
    }];
    
    NSDateComponents *testTimeOfDay = [[NSDateComponents alloc]init];
    testTimeOfDay.hour = 10;
    testTimeOfDay.minute = 0;
    
    PPRScheduleTime *testScheduleTime = [[PPRScheduleTime alloc]initWithTimeOfDay:testTimeOfDay];
    
    PPRScheduledEvent *testScheduledEvent = [[PPRScheduledEvent alloc] initWithEventName:@"TestEventName" scheduledTime:testScheduleTime];
    
    PPRAction *testAction = [[PPRAction alloc] initWithFacility:testFacility scheduledEvent:testScheduledEvent parent:nil actions:nil];
    

    
    // Add one action for facility FAC1
    [scheduler.actionManager insertAction:testAction success:^(PPRAction *action) {
     
    } failure:^(NSError *error) {
        XCTFail(@"getAction should not fail");
    }];

    // Direct call
    [scheduler loadEventsAndActions];
    XCTAssertEqual(scheduler.schedule.count, 1, "Scheduler should have 1 action");
    
    
    // Add two action for facility FAC2
    [((PPRFacilityManager *)[PPRFacilityManager sharedInstance])
     getFacilityById:@"FAC2"
     success:^(PPRFacility *facility) {
         testFacility = facility;
     }
     failure:^(NSError *error) {
         XCTFail(@"getFacilityById should not fail");
     }];
    
    testAction = [[PPRAction alloc] initWithFacility:testFacility scheduledEvent:testScheduledEvent parent:nil actions:nil];
    
    // Add first action for facility FAC2
    [scheduler.actionManager insertAction:testAction success:^(PPRAction *action) {
        
    } failure:^(NSError *error) {
        XCTFail(@"getAction should not fail");
    }];

    testAction = [[PPRAction alloc] initWithFacility:testFacility scheduledEvent:testScheduledEvent parent:nil actions:nil];
        
    // Add Second action for facility FAC2
    [scheduler.actionManager insertAction:testAction success:^(PPRAction *action) {
        
    } failure:^(NSError *error) {
        XCTFail(@"getAction should not fail");
    }];

    shift = shiftManager.shift;
    shift.facilityId = @"FAC2";
    
    [shiftManager publishShift:shift];
    
    // loadEventAndAction should have been called via the notification centre
    // with the change of shift. It should have processed the two actions for FAC2
    XCTAssertEqual(scheduler.schedule.count, 2, "Scheduler should have 2 action");


}
- (void) testFindEvent
{
    PPRScheduler *scheduler = (PPRScheduler *)[PPRScheduler sharedInstance];
    
    NSArray *testEvents = @[
                         [[PPRScheduledEvent alloc]
                          initWithEventName:@"TestEventName1"
                          scheduledTime:nil],
                         [[PPRScheduledEvent alloc]
                          initWithEventName:@"TestEventName2"
                          scheduledTime:nil]
                         ];
    XCTAssertEqualObjects(@"TestEventName1", [scheduler findEvent:@"TestEventName1" events:testEvents].eventName, @"Should found test event 1");
    XCTAssertEqualObjects(@"TestEventName2", [scheduler findEvent:@"TestEventName2" events:testEvents].eventName, @"Should found test event 2");
    XCTAssertNil([scheduler findEvent:@"TestEventNameXXX" events:testEvents].eventName, @"Should not find unknown event");
}
- (void)testDueTimeForScheduleTimeTimeOfDay
{
    PPRScheduler *scheduler = [[PPRScheduler alloc] init];
    NSDateComponents *testTimeOfDay = [[NSDateComponents alloc]init];
    testTimeOfDay.hour = 10;
    testTimeOfDay.minute = 31;
    
    PPRScheduleTime *testScheduleTime = [[PPRScheduleTime alloc]initWithTimeOfDay:testTimeOfDay];

    NSDate *schedulerTime = [NSDate date];
    scheduler.schedulerTime = schedulerTime;
    NSDate *calculatedDate = [scheduler
                              dueTimeForScheduleTime:testScheduleTime
                              parentDueTime:nil
                              previousDueTime:nil
                              events:nil];
    
    NSDateComponents *calculatedDateComponents = [scheduler.calendar components:(NSCalendarUnitHour |
                                                                       NSCalendarUnitMinute) fromDate:calculatedDate];
    
    
    XCTAssertEqual(calculatedDateComponents.hour, 10, @"Time of day hour should be 10");
    XCTAssertEqual(calculatedDateComponents.minute, 31, @"Time of day hour should be 31");
    
}


- (void)testDueTimeForScheduleTimeDailyEvent
{

    PPRScheduler *scheduler = [[PPRScheduler alloc] init];
    NSDateComponents *testEventTimeOfDay = [[NSDateComponents alloc]init];
    testEventTimeOfDay.hour = 12;
    testEventTimeOfDay.minute = 15;
    
    PPRScheduleTime *testDailyEventScheduleTime = [[PPRScheduleTime alloc]
                                                   initWithTimeOfDay:testEventTimeOfDay];

    PPRScheduledEvent *testDailyEvent = [[PPRScheduledEvent alloc] initWithEventName:@"TestDailyEventName" scheduledTime:testDailyEventScheduleTime];
 
    NSArray *events = [NSArray arrayWithObject: testDailyEvent];
    
    NSDateComponents *testOffset = [[NSDateComponents alloc]init];
    testOffset.hour = 1;
    testOffset.minute = 45;
    
    PPRScheduleTime *testScheduleTime = [[PPRScheduleTime alloc]
                                  initWithDailyEvent:@"TestDailyEventName"
                                  offset:testOffset];
   
    NSDate *schedulerTime = [NSDate date];
    scheduler.schedulerTime = schedulerTime;
    NSDate *calculatedDate = [scheduler
                              dueTimeForScheduleTime:testScheduleTime
                              parentDueTime:nil
                              previousDueTime:nil
                              events:events];
    
    NSDateComponents *calculatedDateComponents = [scheduler.calendar components:(NSCalendarUnitHour |
                                                                       NSCalendarUnitMinute) fromDate:calculatedDate];
    
    XCTAssertEqual(calculatedDateComponents.hour, 14, @"Time of day hour should be 14");
    XCTAssertEqual(calculatedDateComponents.minute, 0, @"Time of day hour should be 0");

}

- (void)testOffsetToPrevious
{
    PPRScheduler *scheduler = [[PPRScheduler alloc] init];
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
    PPRScheduler *scheduler = [[PPRScheduler alloc] init];
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





- (void)testDateAdjustForSchedulerTime
{
    PPRScheduler *scheduler = [[PPRScheduler alloc] init];
    NSDate *startingDate = [NSDate date];
    NSDate *schedulerTime = [NSDate dateWithTimeInterval:60.0 sinceDate:startingDate];
    scheduler.schedulerTime = schedulerTime;
    NSDate *adjustedDate = [scheduler dateAdjustedForSchedulerTimer:startingDate];
    NSTimeInterval interval = [startingDate timeIntervalSinceDate:adjustedDate];
    
    XCTAssertEqualWithAccuracy(interval, 60.0, 1.0, "Adjusted time interval incorrect");
    
}

- (void)testDateAdjustForSchedulerTimeNegative
{
    PPRScheduler *scheduler = [[PPRScheduler alloc] init];
    NSDate *startingDate = [NSDate date];
    NSDate *schedulerTime = [NSDate dateWithTimeInterval:-60.0 sinceDate:startingDate];
    scheduler.schedulerTime = schedulerTime;
    NSDate *adjustedDate = [scheduler dateAdjustedForSchedulerTimer:startingDate];
    NSTimeInterval interval = [startingDate timeIntervalSinceDate:adjustedDate];
    
    XCTAssertEqualWithAccuracy(interval, -60.0, 1.0, "Adjusted time interval incorrect");
    
}




@end
