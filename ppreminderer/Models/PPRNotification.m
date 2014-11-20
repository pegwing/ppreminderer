//
//  PPRNotification.m
//  
//
//  Created by David Bernard on 29/09/2014.
//
//

#import "PPRNotification.h"

@implementation PPRNotification

- (instancetype)initWithId:(NSString *)notifiactionId type:(NSString *)notificationType title:(NSString *)title description:(NSString *)notificationDescription dueTime:(NSDate *)dueTime {
    self = [super init];
    if (self) {
        _notificationId = notifiactionId;
        _notificationType = notificationType;
        _title = title;
        _notificationDescription = notificationDescription;
        _dueTime = dueTime;
        
    }
    return self;
}
- (UILocalNotification *)asLocalNotification {
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    localNotification.fireDate = self.dueTime;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.alertAction = self.title;
    
    localNotification.alertBody = self.notificationDescription;
    localNotification.userInfo = @{@"notificationType":@"PPRNotification", @"notificationId":self.notificationId};
    localNotification.soundName = @"/System/Library/Audio/UISounds/new-mail.caf";
    
    return localNotification;
}

@end
