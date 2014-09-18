//
//  PPRScheduleTimeTests.m
//  ppreminderer
//
//  Created by David Vincent on 17/09/14.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PPRScheduleTime.h"

@interface PPRScheduleTimeTests : XCTestCase

@end

@implementation PPRScheduleTimeTests

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

- (void)testEnglishDescriptionAtTime // fixme.  sadly, assume here that something is selecting english locale or close to it
{
    NSDateComponents *eventTimeOfDay = [[NSDateComponents alloc] init];
    eventTimeOfDay.hour =   /* see below */      10;                   // Note whitespace.  Is this being too clever?
    eventTimeOfDay.minute = /* see below */         30;
    /* eventTimeOfDay should now be ready.  Is AM/PM needed here? */
    NSString * expected_description =       @"At 10:30 AM"; // should we use const here?  immutable?
    // fixme.  NSLog some kind of mention of locale issues etc.
    
    PPRScheduleTime *eventTimeOfDayScheduleTime = [[PPRScheduleTime alloc] initWithTimeOfDay:eventTimeOfDay];
    NSString * d = eventTimeOfDayScheduleTime.description;
    XCTAssertEqualObjects(expected_description, d);
}

@end
