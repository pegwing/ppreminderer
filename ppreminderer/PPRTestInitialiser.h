//
//  PPRTestInitialiser.h
//  ppreminderer
//
//  Created by David Bernard on 9/09/2014.
//  Renamed by David Vincent on 17/10/14.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPRSingleton.h"
#import "PPRFacilityManager.h"
#import "PPRClientManager.h"
#import "PPRActionManager.h"
#import "PPRClientInstruction.h"
#import "PPRScheduledEvent.h"
#import "PPRClientAction.h"
#import "PPRScheduler.h"
#import "PPRShiftManager.h"
#import "PPRFacilityActionScheduler.h"
#import "PPRClientActionScheduler.h"
#import "PPRNotificationManager.h"

@interface PPRTestInitialiser : PPRSingleton

@property (nonatomic,strong) PPRActionManager *actionManager;
@property (nonatomic,strong) PPRNotificationManager *notificationManager;
@property (nonatomic,strong) PPRActionScheduler *actionScheduler;
@property (nonatomic,strong) PPRClientActionScheduler *clientActionScheduler;
@property (nonatomic,strong) PPRFacilityActionScheduler *facilityActionScheduler;
@property (nonatomic,strong) PPRScheduler *scheduler;
@property (nonatomic,strong) PPRShiftManager  *shiftManager;
@property (nonatomic,strong) PPRFacilityManager *facilityManager;
@property (nonatomic,strong) PPRClientManager *clientManager;

@property (nonatomic,strong) PPRDataStore *dataStore;

@property (nonatomic,strong) PPRFacility *facility1;
@property (nonatomic,strong) PPRFacility *facility2;
@property (nonatomic,strong) PPRFacility *facility3;

@property (nonatomic,strong) PPRClient *client1;
@property (nonatomic,strong) PPRClient *client2;
@property (nonatomic,strong) PPRClient *client3;
@property (nonatomic,strong) PPRClient *client4;
@property (nonatomic,strong) PPRClient *client5;
@property (nonatomic,strong) PPRClient *client6;
@property (nonatomic,strong) PPRClient *client7;
@property (nonatomic,strong) PPRClient *client8;

- (void) loadSchedule;

@end
