//
//  PPRClientAction.m
//  ppreminderer
//
//  Created by David Bernard on 9/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRClientAction.h"

@implementation PPRClientAction
-(id)initWithClient:(PPRClient *)client
{
    self = [super init];
    if (self) {
        _client = client;
    }
    return self;
}
@end
