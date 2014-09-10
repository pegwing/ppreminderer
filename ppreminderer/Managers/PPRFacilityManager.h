//
//  PPRFacilityManager.h
//  ppreminderer
//
//  Created by David Bernard on 22/08/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPRFacility.h"

@interface PPRFacilityManager : NSObject
+ (PPRFacilityManager *) sharedClient;

- (void)getFacility:(PPRFacility *) client success:(void (^)(NSArray *)) success failure:(void (^)(NSError *)) failure;

- (void)insertFacility:(PPRFacility *)facility success:(void (^)()) success failure:(void (^)(NSError *)) failure;
@end
