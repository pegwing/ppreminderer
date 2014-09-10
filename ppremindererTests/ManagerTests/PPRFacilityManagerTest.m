//
//  PPRFacilityManagerTest.m
//  ppreminderer
//
//  Created by David Bernard on 25/08/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PPRFacilityManager.h"
#import "PPRTestIntialiser.h"

@interface PPRFacilityManagerTest : XCTestCase

@end

@implementation PPRFacilityManagerTest

- (void)setUp
{
    [super setUp];
    [PPRTestIntialiser sharedClient];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSharedClient
{
    
    PPRFacilityManager *sharedClient1 = [PPRFacilityManager sharedClient];
    PPRFacilityManager *sharedClient2 = [PPRFacilityManager sharedClient];
    XCTAssertEqual(sharedClient1, sharedClient2, @"Shared client should return singleton");
}

- (void)testGetFacilityAll
{
    
    PPRFacilityManager *sharedClient = [PPRFacilityManager sharedClient];
    [sharedClient getFacility:nil success:^(NSArray *facilities) {
        XCTAssertEqual(facilities.count, 2, @"Shared client should return 2 facilities");
    } failure:^(NSError *error) {
        XCTFail("getFacility with nil should not fail");
    }];
}
- (void)testGetFacilityById
{
    
    PPRFacilityManager *sharedClient = [PPRFacilityManager sharedClient];
    PPRFacility *facilityFilter = [[PPRFacility alloc]init];
    facilityFilter.facilityId = @"FAC2";
    [sharedClient getFacility:facilityFilter success:^(NSArray *facilities) {
        XCTAssertEqual(facilities.count, 1, @"Shared client should return 1 matching facilities");
        XCTAssertEqualObjects(((PPRFacility *)facilities[0]).facilityId, @"FAC2", @"FacilityManager should retrieve FAC2");
    } failure:^(NSError *error) {
        XCTFail("getFacility with nil should not fail");
    }];
}

@end
