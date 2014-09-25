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
    // Make & init a PPRScheduleTime which will do "original" calculation.
    PPRScheduleTime *scheduleTime = [[PPRScheduleTime alloc] initWithTimeOfDay:dc];
    // Start the "duplicate" calculation.
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateStyle: NSDateFormatterNoStyle];
    [df setTimeStyle: NSDateFormatterShortStyle];
    NSString *description;
    PPRScheduler *scheduler = (PPRScheduler *)[PPRScheduler sharedInstance];
    NSDate *todayButAtOffset = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    NSCalendar *someCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSBuddhistCalendar];
    scheduler.calendar = someCalendar;
    NSDateComponents *components = [someCalendar components: NSUIntegerMax fromDate: todayButAtOffset];
    [components setHour:   dc.hour];
    [components setMinute: dc.minute];
    [components setSecond: 0];
    NSDate *d = [someCalendar dateFromComponents: dc];
    description = [NSString stringWithFormat:@"At %@", [df stringFromDate:d]];
    XCTAssertEqualObjects(description, scheduleTime.description);
}

@end
