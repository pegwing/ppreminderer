//
//  PPRClientInstruction.m
//  ppreminderer
//
//  Created by David Bernard on 8/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRClientInstruction.h"

@implementation PPRClientInstruction

-(id)initWithContext:(NSString *)context instruction:(NSString *)instruction
{
    self = [super init];
    if (self) {
        _context = context;
        _instruction = instruction;
    }
    return self;
}
@end
