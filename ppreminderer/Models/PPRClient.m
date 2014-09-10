//
//  PPRClient.m
//  ppreminderer
//
//  Created by David Bernard on 7/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRClient.h"

@implementation PPRClient

-(id)initWithName:(NSString *)name birthDate:(NSDate *)birthDate
{
    self = [super init];
    if (self) {
        _name = name;
        _birthDate = birthDate;
        _instructions = [[NSMutableArray alloc] init];
        _notes = [[NSMutableArray alloc] init];
        _scheduleItems = [[NSMutableArray alloc] init];
    }
    return self;
}
@end
