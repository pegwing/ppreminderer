//
//  PPRClientManagerTest.m
//  ppreminderer
//
//  Created by David Bernard on 25/08/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PPRClientManager.h"
#import "PPRTestInitialiser.h"

@interface PPRClientManagerTest : XCTestCase

@end

@implementation PPRClientManagerTest

- (void)setUp
{
    [super setUp];
    
    // Initialised the test shared instance
    // This loads the test shared instance of client manager with 3 clients.
    (void)[[PPRTestInitialiser sharedInstance] init];
}

- (void)tearDown
{
    [super tearDown];
}



- (void)testGetClientAll
{
    PPRClientManager *sharedInstance = (PPRClientManager *)[PPRClientManager sharedInstance];
    [sharedInstance getClient:nil
                      success:^(NSArray *clients) {
                          XCTAssertEqual(
                                         clients.count,
                                         8,
                                         @"Test shared instance should return 8 clients");
                      } failure:^(NSError *error) {
                          XCTFail("getClient with nil should not fail");
                      }];
}
- (void)testGetClientById
{
    PPRClientManager *sharedInstance = (PPRClientManager *)[PPRClientManager sharedInstance];
    PPRClient *clientFilter = [[PPRClient alloc]init];
    clientFilter.clientId = @"CLI2";
    [sharedInstance getClient:clientFilter
                      success:^(NSArray *clients) {
                          XCTAssertEqual(
                                         clients.count,
                                         1,
                                         @"Test shared instance should return 1 matching client");
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
    PPRClientManager *sharedInstance = (PPRClientManager *)[PPRClientManager sharedInstance];
    PPRClient *clientFilter = [[PPRClient alloc]init];
    clientFilter.clientId = @"CLIXXX";
    [sharedInstance getClient:clientFilter
                      success:^(NSArray *clients) {
                          XCTFail( @"Test shared instance should fail if no matching client and id is specified");
                      }
                      failure:^(NSError *error) {
                          // pass
                      }];
}

- (void)testInsertClient
{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *nowComponents;
    NSDate *birthDate;
    
    nowComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:now];
    nowComponents.year -= 42;
    nowComponents.month += 4;
    nowComponents.day -= 5;
    birthDate = [calendar dateFromComponents:nowComponents];
    
    PPRClient *client = [[PPRClient alloc] initWithName:@"Fred" birthDate:birthDate];
    
    // Use private client manager
    PPRClientManager *clientManager = [[PPRClientManager alloc]init];
    
    // Check no clients in client manager
    [clientManager getClient:nil
                     success:^(NSArray *clients){
                         XCTAssertEqual(
                                        0,
                                        clients.count,
                                        "Allocated client manager should be empty");
                     }
                     failure:^(NSError *error) {
                         XCTFail("Should not fail");
                     }];
    
    // Add client
    [clientManager insertClient:client
                        success:^(PPRClient *client){
                            XCTAssertNotNil(
                                            client,
                                            "Client should not be nil");
                        }
                        failure:^(NSError *error) {
                            XCTFail("Insert should not fail");
                            
                        }];
    // First and only client should be client 1
    [clientManager getClient:nil
                     success:^(NSArray *clients) {
                         XCTAssertEqual(
                                        clients.count,
                                        1,
                                        @"ClientManager should return 1 clients");
                         XCTAssertEqualObjects(
                                               ((PPRClient *)clients[0]).clientId,
                                               @"CLI1",
                                               @"ClientManager should return client CLI1");
                         XCTAssertEqualObjects(
                                               ((PPRClient *)clients[0]).name,
                                               @"Fred",
                                               @"ClientManager should return Fred");
                     }
                     failure:^(NSError *error) {
                         XCTFail("getClient with nil should not fail");
                     }];
    
    [clientManager insertClient:client
                        success:^(PPRClient *client){
                            XCTAssertNotNil(client, "Client should not be nil");
                        }
                        failure:^(NSError *error) {
                            XCTFail("Insert should not fail");
                            
                        }];
    // Should now be able to retieve client 2
    PPRClient *clientFilter = [[PPRClient alloc]init];
    clientFilter.clientId = @"CLI2";
    [clientManager getClient:clientFilter
                     success:^(NSArray *clients) {
                         XCTAssertEqual(
                                        clients.count,
                                        1,
                                        @"ClientManager should return 1 matching client");
                         XCTAssertEqualObjects(
                                               ((PPRClient *)clients[0]).clientId,
                                               @"CLI2",
                                               @"ClientManager should return CLI2");
                     }
                     failure:^(NSError *error) {
                         XCTFail("getClient with known client should not fail");
                     }];
}

@end
