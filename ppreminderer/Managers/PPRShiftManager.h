//
//  PPRShiftManager.h
//  ppreminderer
//
//  Created by David Bernard on 24/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRSingleton.h"
#import "PPRShift.h"

/**
 * The shift manager is a singleton which maintains the "shift" state 
 * of the user across restarts by storing/restoring to/from default user
 * settings.
 */
@interface PPRShiftManager : PPRSingleton

/**
 *  The user's current shift settings.
 */
@property (nonatomic,strong) PPRShift *shift;

/**
 * Load shift details from user settings
 */
- (PPRShift *)loadShift;
/**
 * Store shift details into user settings.
 * Notify via the notification centre of a change to the shift details.
 * Record a copy of the new details
 *
 * @param shift New shift details
 */
- (void)publishShift:(PPRShift *)shift;
@end
