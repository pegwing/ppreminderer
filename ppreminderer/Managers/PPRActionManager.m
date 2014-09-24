//
//  PPRActionManager.m
//  ppreminderer
//
//  Created by David A Vincent on 22/08/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRActionManager.h"

@interface PPRActionManager ()
@property (nonatomic,strong) NSMutableDictionary* actions;
@end

@implementation PPRActionManager

- (id) init {
    self = [super init];
    if (self) {
        _actions = [[NSMutableDictionary alloc] init];
    }
    return self;
}



- (void) getAction: (PPRAction *)action success: (void(^)(NSArray *))success failure: (void(^)(NSError *)) failure {
    success(self.actions.allValues);
}

- (void) updateStatusOf: (NSString *) actionID
                     to: (NSString *) newStatus      success: (void(^)()) success                     failure: (void(^)(NSError *)) failure
{
    ((PPRAction *)(self.actions[actionID])).status = newStatus;
    success();
};

- (void)insertAction:(PPRAction *)action
             success:(void (^)(PPRAction *))success
             failure:(void (^)(NSError *))failure {
    

    NSString *actionId = [NSString stringWithFormat:@"ACT%lu", (unsigned long)self.actions.count];
    action.actionId = actionId;
    self.actions[actionId] = action;
    success(action);
}
@end
