//
//  PPRFacilityManagerTest.m
//  ppreminderer
//
//  Created by David Bernard on 25/08/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PPRFacilityManager.h"

@interface PPRFacilityManagerTest : XCTestCase

@end

@implementation PPRFacilityManagerTest

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
    [sharedClient getFacility:@{@"Id":@"FAC2"} success:^(NSArray *facilities) {
        XCTAssertEqual(facilities.count, 1, @"Shared client should return 1 matching facilities");
        XCTAssertEqual(facilities[0][@"Id"], @"FAC2", @"FacilityManager should return %@ but returned %@", @"FAC2", facilities[0][@"Id"]);
    } failure:^(NSError *error) {
        XCTFail("getFacility with nil should not fail");
    }];
}

@end
