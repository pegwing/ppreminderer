//
//  PPRClientAction.m
//  ppreminderer
//
//  Created by David Bernard on 9/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRClientAction.h"
#import "PPRClientInstruction.h"

@implementation PPRClientAction
-(id)initWithClient:(PPRClient *)client scheduledEvent:(PPRScheduledEvent *)scheduledEvent
{
    self = [super initWithFacility:client.facility scheduledEvent:scheduledEvent parent:nil actions:nil];
    if (self) {
        _client = client;
        _clientId = client.clientId;
    }
    return self;
}
- (NSString *)notificationDescription {
    NSString *description = [NSString stringWithFormat:@"Client:%@ Action:%@\n%@\n",
                             self.client.name,
                             self.context,
                             [self dueTimeDescription]
                             ];
    
    
    NSArray *instructions = [self instructionsForAction];
    NSString *instructionsDescription = [[instructions valueForKey:@"description"] componentsJoinedByString:@"\n"];
    
    return [description stringByAppendingString:instructionsDescription];
}


- (NSArray *)instructionsForAction {
    NSIndexSet *instructionSet;
    instructionSet = [self.client.instructions
                      indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                          return [((PPRClientInstruction *)obj).context isEqualToString:self.context];
                      }];
    NSArray *instructions = [self.client.instructions objectsAtIndexes:instructionSet];
    
    return instructions;
}

- (BOOL)isEquivalentTo:(PPRClientAction *)clientAction {
    // Equivalent if clientid same
    
    return [super isEquivalentTo:clientAction] && (![clientAction isKindOfClass:self.class] ||  [self.clientId isEqualToString:clientAction.clientId]);
}
@end
