//
//  PPRScheduleTimeTests.m
//  ppreminderer
//
//  Created by David Vincent on 17/09/14.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PPRScheduleTime.h"
#import "PPRScheduler.h"

@interface PPRScheduleTimeTests : XCTestCase

@end

static PPRScheduler *scheduler;

// Please keep these three in sync by hand.  Or find a nice way to tell computer to do so.  Perhaps fixme:  sadly, assume here that something is selecting english locale or close to it.
static NSInteger exp_eng_hh = 10;
static NSInteger exp_eng_mm = 30;
static NSString *exp_eng_descr = @"At 10:30 AM";

static NSDateComponents *dc;  // To be set up using the integers above.


@implementation PPRScheduleTimeTests

- (void)setUp
{
    scheduler = [(PPRScheduler *)[PPRScheduler sharedInstance] initWithDailyEvents:@{}];
    scheduler.calendar = [NSCalendar currentCalendar];
    dc = [[NSDateComponents alloc] init];
    dc.hour =    exp_eng_hh;
    dc.minute =  exp_eng_mm;
    // Put new setup code here. This method is called before the invocation of each test method in the class.
   [super setUp];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testEnglishDescriptionAtTime
{
    PPRScheduleTime *scheduleTime = [[PPRScheduleTime alloc] initWithTimeOfDay:dc];
    scheduler.calendar =
        [[NSCalendar alloc]
         initWithCalendarIdentifier:NSGregorianCalendar];
    NSString * d = scheduleTime.description;
    XCTAssertEqualObjects(exp_eng_descr, d);
}

- (void)testDuplicatingCalculation
{
    PPRScheduleTime *scheduleTime = [[PPRScheduleTime alloc] initWithTimeOfDay:dc];
    NSCalendar *someCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSBuddhistCalendar];
    NSDate *todayButAtOffset = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    NSCalendar *gregorian_maybe = someCalendar;
    NSDateComponents *components = [gregorian_maybe components: NSUIntegerMax fromDate: todayButAtOffset];
    [components setHour:    exp_eng_hh];
    [components setMinute:  exp_eng_mm];
    [components setSecond:  0];                      // fixme: Is this what we want?  Why?
    XCTAssertEqualObjects(exp_eng_descr, scheduleTime.description);
}

@end
