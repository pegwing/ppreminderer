//
//  PPRFacilityActionScheduler.m
//  ppreminderer
//
//  Created by David Bernard on 23/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRFacilityActionScheduler.h"
#import "PPRFacility.h"
#import "PPRFacilityAction.h"
#import "PPRClientManager.h"

@implementation PPRFacilityActionScheduler

- (void)scheduleEventsForFacility:(PPRFacility *)facility {
    [facility.events enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PPRScheduledEvent * event = (PPRScheduledEvent *)obj;
        PPRFacilityAction *action = [[PPRFacilityAction alloc] initWithFacility:facility scheduledEvent:event parent:nil actions:nil];
        action.dueTime = [self.scheduler dueTimeForScheduleTime:event.scheduled parentDueTime:nil previousDueTime:nil events:facility.events];
        action.status = kStatusScheduled;
        action.context = event.eventName;
        [self.actionManager insertAction:action success:^(PPRAction *action) {
            // FIXME how to handle call backs
            PPRClient * clientFilter = [[PPRClient alloc] init];
            clientFilter.facility = facility;
            [[PPRClientManager sharedInstance] getClient:clientFilter success:^(NSArray *clients) {
                [clients enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    PPRClient * client = (PPRClient *) obj;
                    [self.clientActionScheduler scheduleEventsForClient:client forParentAction:action];
                }];
            } failure:^(NSError *error) {
                NSLog(@"Failure to get client");
            }];
            NSLog(@"Inserted action");
        } failure:^(NSError *error) {
            NSLog(@"Failure to insert action");
        }];
    }];
    
}

- (instancetype)initWithScheduler:(PPRScheduler*)scheduler actionManager:(PPRActionManager *)actionManager clientActionScheduler:(PPRClientActionScheduler *)clientActionScheduler {
    self = [super initWithScheduler:scheduler actionManager:actionManager];
    if (self) {
        _clientActionScheduler = clientActionScheduler;
    }
    return self;
}


@end
