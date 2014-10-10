//
//  PPRNotification.m
//  
//
//  Created by David Bernard on 29/09/2014.
//
//

#import "PPRNotification.h"

@implementation PPRNotification

- (instancetype)initWithId:(NSString *)notifiactionId type:(NSString *)notificationType title:(NSString *)title decription:(NSString *)description dueTime:(NSDate *)dueTime {
    self = [super init];
    if (self) {
        _notificationId = notifiactionId;
        _notificationType = notificationType;
        _title = title;
        _description = description;
        _dueTime = dueTime;
        
    }
    return self;
}
- (UILocalNotification *)asLocalNotification {
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    localNotification.fireDate = self.dueTime;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.alertAction = self.title;
    
    localNotification.alertBody = self.description;
    localNotification.userInfo = @{@"notificationType":@"PPRNotification", @"notificationId":self.notificationId};
    localNotification.soundName = @"/System/Library/Audio/UISounds/new-mail.caf";
    
    return localNotification;
}

@end
