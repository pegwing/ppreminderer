//
//  PPRNotificationManager.h
//  ppreminderer
//
//  Created by David Bernard on 18/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRSingleton.h"
#import "PPRNotification.h"
#import "PPRScheduler.h"
#import "PPRShiftManager.h"

@interface PPRNotificationManager : PPRSingleton
/**
 A reference to the application object set on init
 */
@property (nonatomic,strong) UIApplication *application;
@property (nonatomic,strong) NSMutableArray *notifications;
@property (nonatomic,strong) PPRScheduler *scheduler;
@property (nonatomic,strong) PPRShiftManager *shiftManager;

- (void)sendNotification:(PPRNotification *)notification;
- (void)removeNotification:(UILocalNotification *)localNotification;

/**
 Can the notification manage send another notification
 @return true is more notifications can be send. Otherwise false.
 */
- (BOOL)canNotify;


@end
