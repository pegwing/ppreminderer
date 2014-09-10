//
//  PPRClientManagerTest.m
//  ppreminderer
//
//  Created by David Bernard on 25/08/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PPRClientManager.h"
#import "PPRTestIntialiser.h"

@interface PPRClientManagerTest : XCTestCase

@end

@implementation PPRClientManagerTest

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
    
    PPRClientManager *sharedClient1 = [PPRClientManager sharedClient];
    PPRClientManager *sharedClient2 = [PPRClientManager sharedClient];
    XCTAssertEqual(sharedClient1, sharedClient2, @"Shared client should return singleton");
}

- (void)testGetClientAll
{
    
    
    PPRClientManager *sharedClient = [PPRClientManager sharedClient];
    [sharedClient getClient:nil success:^(NSArray *clients) {
        XCTAssertEqual(clients.count, 3, @"Shared client should return 3 clients no %d", clients.count);
    } failure:^(NSError *error) {
        XCTFail("getClient with nil should not fail");
    }];
}
- (void)testGetClientById
{
    
    PPRClientManager *sharedClient = [PPRClientManager sharedClient];
    PPRClient *clientFilter = [[PPRClient alloc]init];
    clientFilter.clientId = @"CLI2";
    [sharedClient getClient:clientFilter success:^(NSArray *clients) {
        XCTAssertEqual(clients.count, 1, @"Shared client should return 1 matching client");
        XCTAssertEqualObjects(
                       ((PPRClient *)clients[0]).clientId,
        @"CLI2",
        @"ClientManager should return CLI2");
    } failure:^(NSError *error) {
        XCTFail("getClient with known client should not fail");
    }];
}

- (void)testGetClientByIdUnknown
{
    
    PPRClientManager *sharedClient = [PPRClientManager sharedClient];
    PPRClient *clientFilter = [[PPRClient alloc]init];
    clientFilter.clientId = @"CLIXXX";
    [sharedClient getClient:clientFilter success:^(NSArray *clients) {
        XCTFail( @"Shared client should fail if not matching client and id is specified");

    } failure:^(NSError *error) {
        return;
    }];
    
}

@end
