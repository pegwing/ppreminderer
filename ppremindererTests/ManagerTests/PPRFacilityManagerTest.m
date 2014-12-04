//
//  PPRFacilityManagerTest.m
//  ppreminderer
//
//  Created by David Bernard on 25/08/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PPRFacilityManager.h"
#import "PPRTestInitialiser.h"

@interface PPRFacilityManagerTest : XCTestCase

@end

@implementation PPRFacilityManagerTest

- (void)setUp
{
    [super setUp];
    (void)[[PPRTestInitialiser sharedInstance] init];
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
                            XCTAssertEqual(facilities.count, 3, @"Shared instance should return 3 facilities");
                        }
                        failure:^(NSError *error) {
                            XCTFail("getFacility with nil should not fail");
                        }];
}
- (void)testGetFacilityByIdPrototype
{
    
    PPRFacilityManager *sharedClient = (PPRFacilityManager *)[PPRFacilityManager sharedInstance];
    PPRFacility *facilityFilter = [[PPRFacility alloc]init];
    facilityFilter.facilityId = @"FAC2";
    [sharedClient getFacility:facilityFilter
                      success:^(NSArray *facilities) {
                          XCTAssertEqual(facilities.count, 1, @"getFacility should return 1 matching facilities");
                          XCTAssertEqualObjects(((PPRFacility *)facilities[0]).facilityId, @"FAC2", @"getFacility should retrieve FAC2");
                      }
                      failure:^(NSError *error) {
                          XCTFail("getFacility with nil should not fail");
                      }];
}

- (void)testGetFacilityById
{
    
    PPRFacilityManager *sharedClient = (PPRFacilityManager *)[PPRFacilityManager sharedInstance];
    [sharedClient getFacilityById:@"FAC2"
                      success:^(PPRFacility *facility) {
                          XCTAssertEqualObjects(facility.facilityId, @"FAC2", @"getFacilityById should retrieve FAC2");
                      }
                      failure:^(NSError *error) {
                          XCTFail("getFacilitById with know facilityId should not fail");
                      }];
}

- (void)testGetFacilityByIdKnownBad
{
    
    PPRFacilityManager *sharedClient = (PPRFacilityManager *)[PPRFacilityManager sharedInstance];
    [sharedClient getFacilityById:@"FACXXX"
                          success:^(PPRFacility *facility) {
                              XCTFail("getFacilityById with nil should fail");
                          }
                          failure:^(NSError *error) {
                              // pass
                          }];
}

@end
