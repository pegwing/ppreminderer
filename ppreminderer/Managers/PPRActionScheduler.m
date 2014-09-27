//
//  ActionScheduler.m
//
//
//  Created by David Bernard on 23/09/2014.
//
//

#import "PPRActionScheduler.h"

@implementation PPRActionScheduler

- (instancetype)init {
    return [self initWithScheduler:(PPRScheduler *)[PPRScheduler sharedInstance]
                     actionManager:(PPRActionManager *)[PPRActionManager sharedInstance]];
}

- (instancetype)initWithScheduler:(PPRScheduler*)scheduler actionManager:(PPRActionManager *)actionManager {
    self = [super init];
    if (self) {
        _scheduler = scheduler;
        _actionManager = actionManager;
    }
    return self;
}

- (NSDate *)dueTimeForAction:(PPRAction *)action delayedBy:(NSTimeInterval)delay  {
    NSDate *newDueTime;
    // Is action overdue?
    if ([self.scheduler.schedulerTime compare:action.dueTime] == NSOrderedAscending) {
        // No - delay from dueTime
        newDueTime = [action.dueTime dateByAddingTimeInterval:delay];
    }
    else
    {
        // Overdue action delay from "now"
        newDueTime = [self.scheduler.schedulerTime dateByAddingTimeInterval:delay];
    }
    return newDueTime;
    
}
@end
