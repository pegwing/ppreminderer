//
//  PPRSingleton.h
//  ppreminderer
//
//  Created by David Bernard on 11/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPRSingleton : NSObject
/**
 Return an instance of the class that is unique in a thread safe way.
 Subsequence calls will return the same instance.
 @return the shared instance
 */
+(PPRSingleton *)sharedInstance;
@end
