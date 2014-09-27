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

@interface PPRFacilityActionScheduler : PPRActionScheduler
/**
 Schedule events for a facility
 @param facility
 */
- (void)scheduleEventsForFacility:(PPRFacility *)facility;
@end
