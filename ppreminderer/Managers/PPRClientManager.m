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
            @{@"Id": @"CLI1", @"Name": @"Fred", @"Age": @"10", @"Facility":@"FAC1"}, @"CLI1",
            @{@"Id": @"CLI2", @"Name": @"Izzy", @"Age": @"10", @"Facility":@"FAC2"}, @"CLI2",
            @{@"Id": @"CLI3", @"Name": @"Dave", @"Age": @"50", @"Facility":@"FAC1"}, @"CLI3",
            nil];
        
    });
    return _sharedClient;
}
- (void)getClient:(NSDictionary *) client success:(void (^)(NSArray *)) success failure:(void (^)(NSError *)) failure {
    if ( client == nil) {
        success(self.clients.allValues);
    } else {
        if (client[@"Facility"] != nil) {
            NSSet *clientSet = [self.clients keysOfEntriesPassingTest:^BOOL(id key, id obj, BOOL *stop) {
                return  (self.clients[key][@"Facility"] == client[@"Facility"]);
            }];
            
            success([self.clients objectsForKeys:[clientSet allObjects] notFoundMarker:@{@"Id":@""}]);
        }
        else if (client[@"Id"] != nil){
            success([self.clients objectsForKeys:@[client[@"Id"]] notFoundMarker:@{@"Id":@""}]);
        }
        else {
            NSLog(@"Unsupported client query %@", client.description);
            failure([[NSError alloc] init]);
        }
    }
}

@end
