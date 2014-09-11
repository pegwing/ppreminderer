//
//  PPRClientManager.h
//  ppreminderer
//
//  Created by David Bernard on 22/08/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPRClient.h"
#import "PPRSingleton.h"

@interface PPRClientManager : PPRSingleton

/**
 Locate one or more clients given a "prototype" to match from the clients collection.
 
 @param prototype A "prototype" used to select matching clients
 @param success A block called with an array of matching clients
 @param failure A block called if an error occurs
 */
- (void)getClient:(PPRClient *)prototype
          success:(void (^)(NSArray *)) success
          failure:(void (^)(NSError *)) failure;

/**
 Insert a client into the clients collection.
 
 @param facility A client to persist into the clients collection
 @param success A block called on success
 @param failure A block called if an error occurs
 */
- (void)insertClient:(PPRClient *)client
             success:(void (^)()) success
             failure:(void (^)(NSError *)) failure;

@end
