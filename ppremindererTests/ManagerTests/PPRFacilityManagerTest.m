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
    [[PPRTestIntialiser sharedInstance] init];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testInsertFacility
{
    // FIXME add tests
}
- (void)testGetFacilityAll
{
    
    PPRFacilityManager *sharedInstance = (PPRFacilityManager *)[PPRFacilityManager sharedInstance];
    [sharedInstance getFacility:nil
                        success:^(NSArray *facilities) {
                            XCTAssertEqual(facilities.count, 2, @"Shared instance should return 2 facilities");
                        }
                        failure:^(NSError *error) {
                            XCTFail("getFacility with nil should not fail");
                        }];
}
- (void)testGetFacilityById
{
    
    PPRFacilityManager *sharedClient = (PPRFacilityManager *)[PPRFacilityManager sharedInstance];
    PPRFacility *facilityFilter = [[PPRFacility alloc]init];
    facilityFilter.facilityId = @"FAC2";
    [sharedClient getFacility:facilityFilter
                      success:^(NSArray *facilities) {
                          XCTAssertEqual(facilities.count, 1, @"Shared client should return 1 matching facilities");
                          XCTAssertEqualObjects(((PPRFacility *)facilities[0]).facilityId, @"FAC2", @"FacilityManager should retrieve FAC2");
                      }
                      failure:^(NSError *error) {
                          XCTFail("getFacility with nil should not fail");
                      }];
}

@end
