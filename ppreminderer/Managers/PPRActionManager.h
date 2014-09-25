//
//  PPRActionManager.h
//  ppreminderer
//
//  Created by David A Vincent on 22/08/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPRAction.h"
#import "PPRSingleton.h"

/**
 *  This class is a singleton that manages access to Actions.
 */
@interface PPRActionManager : PPRSingleton

/**
 * Given a partially specified action prototype, retrieve a list of matching actions.
 * @param prototype the prototype to match
 * @param success a block to be called on success with a list of retrieved actions.
 * @param failure a block to be called on failure
 */
- (void) getAction:(PPRAction *)prototype
           success: (void(^)(NSArray *actions))success
           failure: (void(^)(NSError *error)) failure;

/**
 * Give an actionId retrieve the action
 * @param actionId the action id
 * @param success a block to be called on success with a the retrieved action.
 * @param failure a block to be called on failure if the action cannot be retrieved
 */
- (void) getActionById: (NSString *)actionId success: (void(^)(PPRAction *action))success failure: (void(^)(NSError *error)) failure;

/**
 * Given an actionID set the status of the action.
 *
 * @param actionID the id of the action
 * @param newStatus the staus to be set
 * @param success a block to be called on success
 * @param failure a block to be called on failure
 */
- (void) updateStatusOf:(NSString *) actionID
                     to:(NSString *) newStatus
                success:(void(^)(PPRAction *action)) success
                failure:(void(^)(NSError *error)) failure;

/**
 * Given an actionID set the status and dueTime of the action.
 *
 * @param actionID the id of the action
 * @param newStatus the staus to be set
 * @param dueTime the dueTime to be set
 * @param success a block to be called on success
 * @param failure a block to be called on failure
 */
- (void) updateAction:(NSString *) actionID
               status:(NSString *) newStatus
              dueTime:(NSDate *)dueTime
              success:(void(^)(PPRAction *action)) success
              failure:(void(^)(NSError *error)) failure;

/**
 * Given an actionID set the status and completionTime of the action.
 *
 * @param actionID the id of the action
 * @param newStatus the staus to be set
 * @param completionTime the completionTime to be set
 * @param success a block to be called on success
 * @param failure a block to be called on failure
 */
- (void) updateAction:(NSString *) actionID
               status:(NSString *) newStatus
       completionTime:(NSDate *)completionTime
              success:(void(^)(PPRAction *action)) success
              failure:(void(^)(NSError *error)) failure;

/**
 * Insert an action into the actions collection.
 *
 * @param action the action object to be inserted
 * @param success a block to be called on success with the repesentation of the  persisted action. This may or may not be the same object.
 * @param failure a block to be called on failure
 */
- (void)insertAction:(PPRAction *)action
             success:(void (^)(PPRAction *action))success
             failure:(void (^)(NSError *error))failure;

@end
