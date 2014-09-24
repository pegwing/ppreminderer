//
//  PPRShiftManagerTests.m
//  ppreminderer
//
//  Created by David Bernard on 24/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PPRShiftManager.h"

@interface PPRShiftManagerTests : XCTestCase

@end

static NSNumber * testStatus;
static NSNumber * testAvailable;
static NSString * testFacility;


@implementation PPRShiftManagerTests

- (void)setUp
{
    [super setUp];
    
    testStatus = [NSNumber numberWithInt: PPRShiftStatusOff];
    testFacility = @"TestFacility";
    testAvailable = [NSNumber numberWithBool:true];
    
    // Remove from default settings
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kDefaultsShiftStatusKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kDefaultsShiftAvailableKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kDefaultsFacilityIdKey];
    
}

- (void)tearDown
{
    [super tearDown];

}

- (void)testLoadShiftDefaults
{
    PPRShiftManager *shiftManager = [[PPRShiftManager alloc]init];
    
    NSNumber *defaultTestStatus = [NSNumber numberWithInt: PPRShiftStatusOff];
    NSNumber *defaultTestAvailable = [NSNumber numberWithBool:true];
    NSString *defaultTestFacility = nil;

    // Retrieve - should be empty
    PPRShift *shift = [shiftManager loadShift];

    XCTAssertEqualObjects(shift.shiftStatus, defaultTestStatus, @"Status should be default");
    XCTAssertEqualObjects(shift.available, defaultTestAvailable, @"Availability should be default");
    XCTAssertEqual(shift.facilityId, defaultTestFacility, @"Facility should be default");
}

- (void)testLoadShift
{
    // Assert test value in settings
    [[NSUserDefaults standardUserDefaults] setObject:testStatus forKey:kDefaultsShiftStatusKey];
    [[NSUserDefaults standardUserDefaults] setObject:testAvailable forKey:kDefaultsShiftAvailableKey];
    [[NSUserDefaults standardUserDefaults] setObject:testFacility forKey:kDefaultsFacilityIdKey];

    PPRShiftManager *shiftManager = [[PPRShiftManager alloc]init];
    
    // Retrieve
    PPRShift *shift = [shiftManager loadShift];
    
    XCTAssertEqualObjects(shift.shiftStatus, testStatus, @"Status should be retrieved");
    XCTAssertEqualObjects(shift.available, testAvailable, @"Availability should be retrieved");
    XCTAssertEqualObjects(shift.facilityId, testFacility, @"Facility should be retrieved");
}

- (void)testPublishShift
{
    PPRShiftManager *shiftManager = [[PPRShiftManager alloc]init];

    NSNumber *newTestStatus = [NSNumber numberWithInt: PPRShiftStatusOn];
    NSNumber *newTestAvailable = [NSNumber numberWithBool:false];
    NSString *newTestFacility = @"NewTestFacility";
    
    PPRShift *shift = [[PPRShift alloc]init];

    shift.shiftStatus = newTestStatus;
    shift.available = newTestAvailable;
    shift.facilityId = newTestFacility;
    
    // Publish to set the settings
    [shiftManager publishShift:shift];
    
    // Retieve from settings
    PPRShift *retrievedShift = [shiftManager loadShift];
    
    // Should be as per published
    XCTAssertEqualObjects(retrievedShift.shiftStatus, newTestStatus, @"New Status should be retrieved");
    XCTAssertEqualObjects(retrievedShift.available, newTestAvailable, @"New Availability should be retrieved");
    XCTAssertEqualObjects(retrievedShift.facilityId, newTestFacility, @"New Facility should be retrieved");
    
}

@end
