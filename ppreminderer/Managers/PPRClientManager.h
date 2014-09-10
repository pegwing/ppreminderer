//
//  PPRClientManager.h
//  ppreminderer
//
//  Created by David Bernard on 22/08/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPRClient.h"

@interface PPRClientManager : NSObject
+ (PPRClientManager *) sharedClient;
- (void)getClient:(PPRClient *) client success:(void (^)(NSArray *)) success failure:(void (^)(NSError *)) failure;
- (void)insertClient:(PPRClient *)client success:(void (^)()) success failure:(void (^)(NSError *)) failure;
@end
