//
//  PPRFacilityAction.m
//  ppreminderer
//
//  Created by David Bernard on 29/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRFacilityAction.h"

@implementation PPRFacilityAction

- (NSArray *)instructionsForAction {
    NSIndexSet *instructionSet;
    instructionSet = [self.facility.instructions
                      indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                          return [((PPRFacilityInstruction *)obj).context isEqualToString:self.context];
                      }];
    NSArray *instructions = [self.facility.instructions objectsAtIndexes:instructionSet];
    
    return instructions;
}


@end
