//
//  PPRActionNotification.m
//  ppreminderer
//
//  Created by David Bernard on 18/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRActionNotification.h"

@implementation PPRActionNotification

- (PPRActionNotification *)initWithAction:(PPRAction *)action {
    self = [super initWithId:action.actionId type:@"PPRActionNotification" title:action.context description:action.notificationDescription dueTime:action.dueTime];
    if (self) {
        _action = action;
    }
    return self;
}

- (UILocalNotification *)asLocalNotification {
    
    UILocalNotification *localNotification = [super asLocalNotification];
    if (localNotification) {
        localNotification.soundName = @"/System/Library/Audio/UISounds/new-mail.caf";
    }
    return localNotification;
}
@end
