//
//  PPRActionManager.h
//  ppreminderer
//
//  Created by David A Vincent on 22/08/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPRActionManager : NSObject
+ (PPRActionManager *)sharedClient;

- (void) getAction: (id)action success: (void(^)(NSArray *))success failure: (void(^)(NSError *)) failure;
@end
