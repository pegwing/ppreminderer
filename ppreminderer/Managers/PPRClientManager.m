//
//  PPRClientManager.m
//  ppreminderer
//
//  Created by David Bernard on 22/08/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRClientManager.h"
@interface PPRClientManager ()
    @property (nonatomic, strong) NSMutableDictionary *clients;
@end

@implementation PPRClientManager
+ (PPRClientManager *) sharedClient {
    static PPRClientManager* _sharedClient;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [PPRClientManager alloc];
        _sharedClient.clients =
        
        [NSMutableDictionary dictionaryWithObjectsAndKeys:
            @{@"Id": @"1", @"Name": @"Fred", @"Age": @"10"}, @"Fred",
            @{@"Id": @"2", @"Name": @"Izzy", @"Age": @"10"}, @"Izzy",
            @{@"Id": @"3", @"Name": @"Dave", @"Age": @"50"}, @"Dave",
            nil];
        
    });
    return _sharedClient;
}
- (void)getClient:(NSDictionary *) client success:(void (^)(NSArray *)) success failure:(void (^)(NSError *)) failure {
    if ( client == nil) {
        success(self.clients.allValues);
    } else {
        success(self.clients[client[@"Id"]]);
    }
}

@end
