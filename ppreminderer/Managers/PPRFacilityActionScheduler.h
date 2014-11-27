//
//  PPRFacilityActionScheduler.h
//  ppreminderer
//
//  Created by David Bernard on 23/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPRActionScheduler.h"
#import "PPRFacility.h"
#import "PPRClientActionScheduler.h"

@interface PPRFacilityActionScheduler : PPRActionScheduler
@property (nonatomic,strong) PPRClientActionScheduler* clientActionScheduler;
/**
 Schedule events for a facility
 @param facility
 */
- (void)scheduleEventsForFacility:(PPRFacility *)facility;

/**
 Initialise with a specific scheduler and action manager
 @param scheduler
 @param actionManager
 @return initialised self or nil
 */
- (instancetype)initWithScheduler:(PPRScheduler*)scheduler actionManager:(PPRActionManager *)actionManager clientActionScheduler:(PPRClientActionScheduler *)clientActionScheduler;

@end
