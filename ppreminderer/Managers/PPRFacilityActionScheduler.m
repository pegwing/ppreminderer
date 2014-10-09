//
//  PPRFacilityActionScheduler.m
//  ppreminderer
//
//  Created by David Bernard on 23/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRFacilityActionScheduler.h"
#import "PPRFacility.h"

@implementation PPRFacilityActionScheduler


- (void)scheduleEventsForFacility:(PPRFacility *)facility {
    [facility.events enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PPRScheduledEvent * event = (PPRScheduledEvent *)obj;
        PPRAction *action = [[PPRAction alloc] init];
        action.scheduledEvent = event;
        action.dueTime = [self.scheduler dueTimeForScheduleTime:event.scheduled parentDueTime:nil previousDueTime:nil events:facility.events];
        action.status = kStatusScheduled;
        action.context = event.eventName;
        action.facility = facility;
        [self.actionManager insertAction:action success:^(PPRAction *action) {
            // FIXME how to handle call backs
            NSLog(@"Inserted action");
        } failure:^(NSError *error) {
            NSLog(@"Failure to insert action");
        }];
    }];
    
}


@end
