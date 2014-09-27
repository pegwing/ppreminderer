//
//  ActionScheduler.h
//  
//
//  Created by David Bernard on 23/09/2014.
//
//

#import <Foundation/Foundation.h>
#import "PPRActionManager.h"
#import "PPRScheduler.h"
#import "PPRSingleton.h"

/**
 Singleton for calculating action due time.
 */
@interface PPRActionScheduler : PPRSingleton
@property (nonatomic,weak)PPRScheduler *scheduler;
@property (nonatomic,weak)PPRActionManager *actionManager;

 /**
 Calculate the due time for action action.If a delay is specified, if the action is overdue then delay from "now", otherwise delay from due time.
  
 @param action The action
 @param delayedBy An interval the action's due time is delayed by
 @return the due time
 */
- (NSDate *)dueTimeForAction:(PPRAction *)action delayedBy:(NSTimeInterval)delay;

/**
 Initialise with a specific scheduler and action manager
 @param scheduler
 @param actionManager
 @return initialised self or nil
 */
- (instancetype)initWithScheduler:(PPRScheduler*)scheduler actionManager:(PPRActionManager *)actionManager;

@end
