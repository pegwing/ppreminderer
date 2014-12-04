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
                             self.scheduledEvent.eventName,
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

- (NSString *)logTextForLabel {  // cf. textForLabel
    PPRClientAction *item = (PPRClientAction *)self;
    NSString *label = [NSString stringWithFormat:@"%@ - %@", item.client.name, item.scheduledEvent.eventName];
     return label;
 
}
static const NSString *const ind0 = @"";
static const NSString *const ind4 = @"    ";
static const NSString *const ind8 = @"        ";

- (NSString *)textForLabel {
    PPRClientAction *item = (PPRClientAction *)self;
    NSString *label = [NSString stringWithFormat:@"%@ - %@", item.client.name, item.scheduledEvent.eventName];
    NSString *const labelMaybeIndented =
   [NSString stringWithFormat:@"%@%@",self.shouldGroup?ind4:ind0, label]; // Smaller indent for text rather than detail
   return labelMaybeIndented;
}


- (BOOL)isEquivalentTo:(PPRClientAction *)clientAction {
    // Equivalent if clientid same
    
    return [super isEquivalentTo:clientAction] && (![clientAction isKindOfClass:self.class] ||  [self.clientId isEqualToString:clientAction.clientId]);
}
@end
