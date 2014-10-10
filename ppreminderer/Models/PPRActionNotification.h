//
//  PPRActionNotification.h
//  ppreminderer
//
//  Created by David Bernard on 18/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPRAction.h"
#import "PPRNotification.h"

/**
 The action noficiation class is used to manage the information used to manage local notifications.
 A helper method generates aUISLocalNotification object to pass to the ssytem.
 */
@interface PPRActionNotification : PPRNotification

/**
 The action that is the subject of the notification.
 */
@property (nonatomic,strong) PPRAction *action;

/**
 An initialiser given an action.
 */
- (PPRActionNotification *) initWithAction:(PPRAction *)action;

@end
