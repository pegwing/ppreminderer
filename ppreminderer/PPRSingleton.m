//
//  PPRSingleton.m
//  ppreminderer
//
//  Created by David Bernard on 11/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRSingleton.h"

@interface SingletonHelper : NSObject {
    @public
    dispatch_once_t token;

}
@property (nonatomic,strong) PPRSingleton *singleton;
@end
@implementation SingletonHelper

@end
@implementation PPRSingleton

+ (PPRSingleton *) sharedInstance {
    static dispatch_once_t onceToken;
    static NSMutableDictionary* singletons;

    
    dispatch_once(&onceToken, ^{
        singletons = [[NSMutableDictionary alloc]init];
    });

    SingletonHelper *singletonHelper = singletons[self];
    if (singletonHelper == nil) {
        singletonHelper = [[SingletonHelper alloc]init];
        singletons[self] = singletonHelper;
    }
    dispatch_once(&(singletonHelper->token), ^{
        singletonHelper.singleton = [self alloc];
        
    });

    return singletonHelper.singleton;
}

@end
