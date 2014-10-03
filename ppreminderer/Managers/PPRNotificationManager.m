//
//  PPRNotificationManager.m
//  ppreminderer
//
//  Created by David Bernard on 18/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRNotificationManager.h"


@implementation PPRNotificationManager

- (id) init {
    self = [super init];
    if (self) {
        _application = [UIApplication sharedApplication];
        _notifications = [[NSMutableArray alloc] init];
        _scheduler = [PPRScheduler sharedInstance];
        _shiftManager = [PPRShiftManager sharedInstance];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:kShiftChangedNotificationName object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            // If becoming unavailable remove an local notifications pending.
            if ( ! (self.shiftManager.shift.available.boolValue) ) {
                [self.notifications enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    PPRNotification *notification = obj;
                    if (notification.localNotification != nil) {
                        [self.application cancelLocalNotification:notification.localNotification];
                        notification.localNotification = nil;
                    }
                }];
            } else {
                // If available make sure all notifications have local notifications scheduled.
                [self.notifications enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    PPRNotification *notification = obj;
                    if (notification.localNotification == nil) {
                        notification.localNotification = [notification asLocalNotification];
                        notification.localNotification.applicationIconBadgeNumber = self.notifications.count;
                        notification.localNotification.fireDate = [self.scheduler dateAdjustedForSchedulerTimer:notification.localNotification.fireDate];
                        [self.application scheduleLocalNotification:notification.localNotification];
                        
                    }
                }];
            }
        }];
        [[NSNotificationCenter defaultCenter] addObserverForName:kSchedulerTimeChangedNotificationName object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            // Reschedule local notifications
            [self.notifications enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                PPRNotification *notification = obj;
                if (notification.localNotification != nil) {
                    [self.application cancelLocalNotification:notification.localNotification];
                    notification.localNotification.applicationIconBadgeNumber = self.notifications.count;
                    notification.localNotification.fireDate = [self.scheduler dateAdjustedForSchedulerTimer:notification.localNotification.fireDate];
                    [self.application scheduleLocalNotification:notification.localNotification];
                }
            }];
            
        }];
    }
    
    return self;
}


- (void)addNotification:(PPRNotification *)notification {
    [self.notifications addObject:notification];
}
- (void)sendNotification:(PPRNotification *)notification {
    if ([self.shiftManager.shift.shiftStatus intValue] == PPRShiftStatusOn &&
        [self.shiftManager.shift.available boolValue])
    {
    notification.localNotification = [notification asLocalNotification];
    
    //  Badge with the number of outstanding notifications
    notification.localNotification.applicationIconBadgeNumber = self.notifications.count;
    // Adjust for system time
    notification.localNotification.fireDate = [self.scheduler dateAdjustedForSchedulerTimer:notification.localNotification.fireDate];
    // Add to outstanding notifications
    [self.notifications addObject:notification];
    // Schedule
    [self.application scheduleLocalNotification:notification.localNotification];
    }
}

- (void)removeNotificationPassingTest:(BOOL (^)(PPRNotification *))test {

    NSIndexSet *removeSet = [self.notifications indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        PPRNotification *notification = obj;
        if (test(notification)) {
            [self.application cancelLocalNotification:notification.localNotification];
            return true;
        }
        else
            return false;
    }];
    [self.notifications removeObjectsAtIndexes:removeSet];
}




- (void)removeNotification:(UILocalNotification *)localNotification {
    NSDate *dueTime = localNotification.fireDate;
    NSString *notificationId = localNotification.userInfo[@"notificationId"];
    NSString *notificationType = localNotification.userInfo[@"notificationType"];
    NSIndexSet *removeSet = [self.notifications indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        PPRNotification *notification = obj;
        if ([notificationId isEqualToString:notification.notificationId] && [notificationType isEqualToString:notification.notificationType] )
            return true;
        else if ([notification.localNotification.fireDate compare: dueTime] == NSOrderedAscending) {
            [self.application cancelLocalNotification:notification.localNotification];
            return true;
        }
        else
            return false;
    }];
    [self.notifications removeObjectsAtIndexes:removeSet];
}

- (BOOL)canNotify {
    // FIXME is this the best way to determine if we can queue a notification
    return self.notifications.count < 64;
}
@end
