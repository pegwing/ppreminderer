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



- (void) getAction: (PPRAction *)prototype success: (void(^)(NSArray *))success failure: (void(^)(NSError *)) failure {
    if ( prototype == nil) {
        success(self.actions.allValues);
        
    } else {
        if (prototype.facility != nil) {
            NSSet *actionSet = [self.actions keysOfEntriesPassingTest:^BOOL(id key, id obj, BOOL *stop) {
                return  [((PPRAction *)(self.actions[key])).facility.facilityId  isEqualToString:prototype.facility.facilityId];
            }];
            
            success([self.actions objectsForKeys:[actionSet allObjects] notFoundMarker:[[PPRAction alloc] init]]);
        }
        else if (prototype.actionId != nil){
            
            PPRAction *foundAction = self.actions[prototype.actionId];
            if (foundAction)
                success([NSArray arrayWithObject:foundAction]);
            else
                failure([NSError errorWithDomain:@"ActionManager" code:1 userInfo:nil]);
        }
        else {
            NSLog(@"Unsupported client query %@", prototype.description);
            failure([[NSError alloc] init]);
        }
    }
}

- (void) getActionById: (NSString *)actionId success: (void(^)(PPRAction *))success failure: (void(^)(NSError *)) failure {
    
    PPRAction *foundAction = self.actions[actionId];
    if (foundAction)
        success(foundAction);
    else
        failure([NSError errorWithDomain:@"ActionManager" code:1 userInfo:nil]);
    
}

- (void) updateStatusOf: (NSString *) actionID
                     to: (NSString *) newStatus      success: (void(^)(PPRAction *action)) success                     failure: (void(^)(NSError *)) failure
{
    [self getActionById:actionID success:^(PPRAction *action) {
        action.status = newStatus;
        success(action);
    } failure:failure ];
    
}

- (void) updateAction: (NSString *) actionID
               status: (NSString *) newStatus
              dueTime: (NSDate *)dueTime
              success: (void(^)(PPRAction *action)) success
              failure: (void(^)(NSError *)) failure
{
    [self getActionById:actionID success:^(PPRAction *action) {
        action.status = newStatus;
        action.dueTime = dueTime;
        success(action);
    } failure:failure ];
}

- (void) updateAction: (NSString *) actionID
               status: (NSString *) newStatus
       completionTime:(NSDate *)completionTime
              success: (void(^)(PPRAction *action)) success
              failure: (void(^)(NSError *)) failure
{
    [self getActionById:actionID success:^(PPRAction *action) {
        action.status = newStatus;
        action.completionTime = completionTime;
        success(action);
    } failure:failure ];
}

- (void)insertAction:(PPRAction *)action
             success:(void (^)(PPRAction *))success
             failure:(void (^)(NSError *))failure {
    
    
    NSString *actionId = [NSString stringWithFormat:@"ACT%lu", (unsigned long)self.actions.count];
    action.actionId = actionId;
    self.actions[actionId] = action;
    success(action);
}
@end
