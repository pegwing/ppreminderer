//
//  PPRShiftTestd.m
//  ppreminderer
//
//  Created by David Bernard on 17/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PPRShift.h"

@interface PPRShiftTests : XCTestCase

@end

@implementation PPRShiftTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testDescription
{
    PPRShift * shift = [[PPRShift alloc] init];
    shift.shiftStatus  = [NSNumber numberWithInt:PPRShiftStatusOn];
    shift.available = [NSNumber numberWithBool:true];
    
    NSString *description = [shift description];
    XCTAssertEqualObjects(description, @"Available On Shift");
    
    shift.shiftStatus  = [NSNumber numberWithInt:PPRShiftStatusOn];
    shift.available = [NSNumber numberWithBool:false];
    description = [shift description];
    XCTAssertEqualObjects(description, @"Unavailable On Shift");

    shift.shiftStatus  = [NSNumber numberWithInt:PPRShiftStatusOff];
    shift.available = [NSNumber numberWithBool:false];
    description = [shift description];
    XCTAssertEqualObjects(description, @"Unavailable Off Shift");

    shift.shiftStatus  = [NSNumber numberWithInt:PPRShiftStatusOff];
    shift.available = [NSNumber numberWithBool:true];
    description = [shift description];
    XCTAssertEqualObjects(description, @"Available Off Shift");
}

@end
