//
//  PPRNotification.h
//  
//
//  Created by David Bernard on 29/09/2014.
//
//

#import <Foundation/Foundation.h>

@interface PPRNotification : NSObject

@property (nonatomic,strong)NSDate *dueTime;
@property (nonatomic,strong)NSString *notificationDescription;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *notificationId;
@property (nonatomic,strong)NSString *notificationType;
@property (nonatomic,strong)UILocalNotification *localNotification;

/**
 A method to generate a UILocalNotification representing this notification.
 */
- (UILocalNotification *)asLocalNotification;

- (instancetype)initWithId:(NSString *)notificationId type:(NSString *)notificationType title:(NSString *)title decription:(NSString *)description dueTime:(NSDate *)dueTime;

@end
