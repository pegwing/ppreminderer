//
//  PPRClientActionScheduler.m
//  ppreminderer
//
//  Created by David Bernard on 23/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRClientActionScheduler.h"
#import "PPRClientAction.h"

@implementation PPRClientActionScheduler

- (void)scheduleEventsForClient:(PPRClient *)client {
    [client.scheduleItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PPRScheduledEvent * event = (PPRClientScheduleItem *)obj;
        PPRClientAction *action = [[PPRClientAction alloc] init];
        action.scheduledEvent = event;
        action.dueTime = [self.scheduler dueTimeForScheduleTime:event.scheduled parentDueTime:nil previousDueTime:nil events:client.facility.events];
        action.status = kStatusScheduled;
        // Promote event name to be context
        // FIXME
        action.context = event.eventName;
        action.client = client;
        action.facility = client.facility;
        [self.actionManager insertAction:action success:^(PPRAction *action) {
            // FIXME
            NSLog(@"Inserted action");
        } failure:^(NSError *error) {
            NSLog(@"Failure to insert action");
        }];
    }];
}


@end
