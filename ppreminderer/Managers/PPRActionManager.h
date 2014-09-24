//
//  PPRActionManager.h
//  ppreminderer
//
//  Created by David A Vincent on 22/08/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPRAction.h"
#import "PPRSingleton.h"

@interface PPRActionManager : PPRSingleton

- (void) getAction:(PPRAction *)action
           success: (void(^)(NSArray *))success
           failure: (void(^)(NSError *)) failure;
- (void) updateStatusOf:(NSString *) actionID
                     to:(NSString *) newStatus
                success:(void(^)()) success
                failure:(void(^)(NSError *)) failure;

- (void)insertAction:(PPRAction *)action
             success:(void (^)(PPRAction *))success
             failure:(void (^)(NSError *))failure;

@end
