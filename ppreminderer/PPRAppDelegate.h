//
//  PPRAppDelegate.h
//  ppreminderer
//
//  Created by David Bernard on 13/08/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPRNotificationManager.h"
#import "PPRScheduler.h"

@interface PPRAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic,strong) PPRNotificationManager * notificationManager;
@property (nonatomic,strong) PPRScheduler * scheduler;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
