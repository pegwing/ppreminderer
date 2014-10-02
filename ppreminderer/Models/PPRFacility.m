//
//  PPRFacility.m
//  ppreminderer
//
//  Created by David Bernard on 9/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRFacility.h"

@implementation PPRFacility

-(id)initWithName:(NSString *)name address:(NSString *)address
{
    self = [super init];
    if (self) {
        _name = name;
        _address = address;
        _events = [[NSMutableArray alloc] init];
        _instructions = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
