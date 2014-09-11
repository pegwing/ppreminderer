//
//  PPRSingletonTests.m
//  ppreminderer
//
//  Created by David Bernard on 11/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PPRSingleton.h"

@interface PPRSingletonTests : XCTestCase

@end

@interface SingletonSubClass :PPRSingleton

@end

@implementation SingletonSubClass

@end

@implementation PPRSingletonTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testSharedInstance
{
    PPRSingleton *sharedInstance1 = [PPRSingleton sharedInstance];
    PPRSingleton *sharedInstance2 = [PPRSingleton sharedInstance];
    XCTAssertEqual(sharedInstance1, sharedInstance2, @"Shared instance should return singleton");
}

- (void)testNonSharedInstances
{
    PPRSingleton *sharedInstance1 = [PPRSingleton sharedInstance];
    PPRSingleton *sharedInstance2 = [[PPRSingleton alloc] init];
    XCTAssertNotEqual(sharedInstance1, sharedInstance2, @"Shared instance and alloc should return different objects");
}

- (void)testSingletonSubClass
{
    PPRSingleton *sharedInstance = [PPRSingleton sharedInstance];
    SingletonSubClass *sharedSubInstance1 = (SingletonSubClass*)[SingletonSubClass sharedInstance];
    SingletonSubClass *sharedSubInstance2 = (SingletonSubClass *)[SingletonSubClass sharedInstance];
    XCTAssertNotEqual(sharedInstance, sharedSubInstance1, @"Shared instances of different classes should return different objects");
    XCTAssertEqual(sharedSubInstance1, sharedSubInstance2, @"Shared instance should return singleton");
}


@end
