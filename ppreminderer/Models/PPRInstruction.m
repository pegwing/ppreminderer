//
//  PPRInstruction.m
//  
//
//  Created by David Bernard on 29/09/2014.
//
//

#import "PPRInstruction.h"

@implementation PPRInstruction

-(id)initWithContext:(NSString *)context instruction:(NSString *)instruction
{
    self = [super init];
    if (self) {
        _context = context;
        _instruction = instruction;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ - %@", self.context, self.instruction];
}
@end
