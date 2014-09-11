//
//  PPRClientManager.m
//  ppreminderer
//
//  Created by David Bernard on 22/08/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRClientManager.h"

@interface PPRClientManager ()

// Properties for trivial implementation
@property (nonatomic, strong) NSMutableDictionary *clients;
@property (atomic) int clientCount;
@end

@implementation PPRClientManager

- (id)init
{
    self = [super init];
    if (self) {
        _clients = [[NSMutableDictionary alloc] init];
        _clientCount = 0;
    }
    return self;
}

- (void)getClient:(PPRClient *)prototype
          success:(void (^)(NSArray *))success
          failure:(void (^)(NSError *))failure {
    
    if ( prototype == nil) {
        success(self.clients.allValues);
    } else {
        if (prototype.facility != nil) {
            NSSet *clientSet = [self.clients keysOfEntriesPassingTest:^BOOL(id key, id obj, BOOL *stop) {
                return  [((PPRClient *)(self.clients[key])).facility.facilityId  isEqualToString:prototype.facility.facilityId];
            }];
            
            success([self.clients objectsForKeys:[clientSet allObjects] notFoundMarker:[[PPRClient alloc] initWithName:@"Missing" birthDate:nil]]);
        }
        else if (prototype.clientId != nil){
            
            NSDictionary *foundClient = self.clients[prototype.clientId];
            if (foundClient)
                success([NSArray arrayWithObject:foundClient]);
            else
                failure([NSError errorWithDomain:@"ClientManager" code:1 userInfo:nil]);
        }
        else {
            NSLog(@"Unsupported client query %@", prototype.description);
            failure([[NSError alloc] init]);
        }
    }
}

- (void)insertClient:(PPRClient *)client
             success:(void (^)())success
             failure:(void (^)(NSError *))failure {
    
    self.clientCount++;
    NSString *clientId = [NSString stringWithFormat:@"CLI%d", self.clientCount];
    client.clientId = clientId;
    self.clients[clientId] = client;
    success();
}

@end
