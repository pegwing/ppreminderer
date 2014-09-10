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
@property (atomic) int clientCount;

@end

@implementation PPRClientManager
+ (PPRClientManager *) sharedClient {
    static PPRClientManager* _sharedClient;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [PPRClientManager alloc];
        _sharedClient.clients = [[NSMutableDictionary alloc] init];

    });
    return _sharedClient;
}

- (void)getClient:(PPRClient *) client success:(void (^)(NSArray *)) success failure:(void (^)(NSError *)) failure {
    if ( client == nil) {
        success(self.clients.allValues);
    } else {
        if (client.facility != nil) {
            NSSet *clientSet = [self.clients keysOfEntriesPassingTest:^BOOL(id key, id obj, BOOL *stop) {
                return  [((PPRClient *)(self.clients[key])).facility.facilityId  isEqualToString:client.facility.facilityId];
            }];
            
            success([self.clients objectsForKeys:[clientSet allObjects] notFoundMarker:[[PPRClient alloc] initWithName:@"Missing" birthDate:nil]]);
        }
        else if (client.clientId != nil){
            
            NSDictionary *foundClient = self.clients[client.clientId];
            if (foundClient)
                success([NSArray arrayWithObject:self.clients[client.clientId]]);
            else
                failure([NSError errorWithDomain:@"ClientMananger" code:1 userInfo:nil]);
        }
        else {
            NSLog(@"Unsupported client query %@", client.description);
            failure([[NSError alloc] init]);
        }
    }
}
- (void)insertClient:(PPRClient *)client success:(void (^)())success failure:(void (^)(NSError *))failure
{
    self.clientCount++;
    NSString *clientId = [NSString stringWithFormat:@"CLI%d", self.clientCount];
    client.clientId = clientId;
    self.clients[clientId] = client;
    success();
}

@end
