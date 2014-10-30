//
//  PPRAppDelegate.m
//  ppreminderer
//
//  Created by David Bernard on 13/08/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRAppDelegate.h"
#import "PPRTestInitialiser.h"
#import "PPRStickyMessageNoticeView.h"
#import "PPRNotificationManager.h"
#import "PPRScheduler.h"
#import "PPRActionNotification.h"
#import "PPRScheduleItem.h"
#import "PPRActionScheduleItem.h"
#import "PPRActionManager.h"

@implementation PPRAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.notificationManager = [[PPRNotificationManager sharedInstance] init];
    self.scheduler = [[PPRScheduler sharedInstance] init];
    
    // Load clock offset
    [self.scheduler restoreState];
    
    (void)[[PPRTestInitialiser sharedInstance] init];
    
    PPRNotificationManager __block *notificationManager;
    notificationManager = self.notificationManager;
    
    [self.scheduler setDueActionProcessor:^NSString * (PPRScheduleItem *scheduleItem) {
        if ([scheduleItem isKindOfClass:[PPRActionScheduleItem class]]) {
            PPRActionScheduleItem *item = (PPRActionScheduleItem *)scheduleItem;
            // Item has become completed
            if ([item.action.status isEqualToString:kStatusCompleted] || [item.action.status isEqualToString:kStatusCompletedAway])
                return kSchedulingStatusCompleted;
            
            // Scheduled item now due so notify and update to due
            if ([scheduleItem.schedulingStatus isEqualToString:kSchedulingStatusScheduled] ) {
                // Update action to due
                
                PPRActionNotification *actionNotification =
                [[PPRActionNotification alloc] initWithAction:item.action];
                
                // Notify due items even if it bounces other notifications
                [notificationManager sendNotification:actionNotification];
                
                return kSchedulingStatusDue;
            }
            // Notified item now due so update to due
            if ([scheduleItem.schedulingStatus isEqualToString:kSchedulingStatusNotified]) {
                return kSchedulingStatusDue;
            }
        }
        // No change
        return scheduleItem.schedulingStatus;
    }];
    
    [self.scheduler setFutureActionProcessor:^NSString * (PPRScheduleItem *scheduleItem) {
        if ([scheduleItem isKindOfClass:[PPRActionScheduleItem class]]) {
            PPRActionScheduleItem *item = (PPRActionScheduleItem *)scheduleItem;
            // Future item already completed
            if ([item.action.status isEqualToString:kStatusCompleted] || [item.action.status isEqualToString:kStatusCompletedAway]) {
                return kSchedulingStatusCompleted;
            }
            else {
                // If "space" should notify future items
                if ( [notificationManager canNotify]) {
                    // Scheduled item in future so notify
                    PPRActionNotification *actionNotification =
                    [[PPRActionNotification alloc] initWithAction:item.action];
                    [notificationManager sendNotification:actionNotification];
                    
                    return kSchedulingStatusNotified;
                }
            }
        }
        // No change
        return scheduleItem.schedulingStatus;
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kActionStateChangedNotificationName object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        // Remove from notification manager
        [self.notificationManager removeNotificationPassingTest:^BOOL(PPRNotification *notification) {
            if ([notification isKindOfClass:[PPRActionNotification class]]) {
                PPRActionNotification  *actionNotification = (PPRActionNotification *)notification;
                if ([actionNotification.action.actionId isEqualToString:note.userInfo[@"ActionId"]])
                    return true;
            }
            return false;
        }];
        // Retrieve the action
        [[PPRActionManager sharedInstance] getActionById:note.userInfo[@"ActionId"]
                                                 success:^(PPRAction *action) {
                                                     // From the action status update the scheduling status
                                                     NSString *schedulingStatus;
                                                     if ([action.status isEqualToString:kStatusCompleted] || [action.status isEqualToString:kStatusCompletedAway])
                                                         schedulingStatus = kSchedulingStatusCompleted;
                                                     else if ([action.status isEqualToString:kStatusPostponed])
                                                         schedulingStatus = kSchedulingStatusScheduled;
                                                     else if ([action.status isEqualToString:kStatusScheduled])
                                                         schedulingStatus = kSchedulingStatusScheduled;
                                                     
                                                     // Reschedule
                                                     [self.scheduler  rescheduleItemDueTime:action.dueTime
                                                                           schedulingStatus:schedulingStatus
                                                                                passingTest:^BOOL(PPRScheduleItem *item)  {
                                                                                    if ([item isKindOfClass:[PPRActionScheduleItem class]]) {
                                                                                        PPRActionScheduleItem *actionScheduleItem = (PPRActionScheduleItem *)item;
                                                                                        if ([actionScheduleItem.action.actionId isEqualToString:note.userInfo[@"ActionId"]])
                                                                                            return true;
                                                                                    }
                                                                                    return false;
                                                                                }
                                                      ];
                                                     
                                                 }
                                                 failure: ^(NSError *error) {
                                                     NSLog(@"Error getting action");
                                                 }
         ];
    }];
    
    
    [self.scheduler startTimerWithBlock:^(){
        [[NSNotificationCenter defaultCenter]
         postNotificationName:kSchedulerTimeTickNotificationName object:nil];
        
        
    }];
    
    return YES;
    
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (notification) {
        
        NSLog(@"Local notification on launch: '%@'\n%@", notification.alertAction,
              notification.alertBody);
        [self displayNotification:notification];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [self.scheduler saveState];
}

- (void) application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    NSLog(@"Received local notification: '%@'\n%@", notification.alertAction,
          notification.alertBody);
    [self displayNotification:notification];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self.scheduler saveState];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self.scheduler restoreState];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self.scheduler saveState];
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ppreminderer" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ppreminderer.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Application state restoration

-(BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder
{
    return YES;
}

-(BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder
{
    return YES;
}

# pragma mark - utilities
- (void)displayNotification:(UILocalNotification *)notification {
    // Only notification if on available
    if ([PPRShiftManager sharedInstance].shift.available.boolValue &&
        [PPRShiftManager sharedInstance].shift.shiftStatus.intValue == PPRShiftStatusOn) {
        // Locate the currently displayed root view
        UIView * view = [self.window.rootViewController view];
        
        PPRStickyMessageNoticeView *noticeView = [PPRStickyMessageNoticeView stickyMessageNoticeInView:view title:notification.alertAction message:
                                                  notification.alertBody];
        NSLog(@" alert body %@ alert action %@", notification.alertBody, notification.alertAction);
        noticeView.delay = 10.0;
        noticeView.sticky = true;
        noticeView.tapToDismissEnabled = true;
        noticeView.alpha = 0.9f;
        noticeView.floating = YES;
        noticeView.contentInset = UIEdgeInsetsMake(0,10,0,0);
        [noticeView setDismissalBlock:^(BOOL dismissedInteractively) {
            [self.notificationManager removeNotification:notification];
        }];
        
        [noticeView show];
    }
}

@end
