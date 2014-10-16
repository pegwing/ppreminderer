//
//  StringKeys.h
//  ppreminderer
//
//  Created by David Bernard on 13/08/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#ifndef ppreminderer_StringKeys_h
#define ppreminderer_StringKeys_h

// The comments to the right of the following definitions should soon be redundant.  Examples should soon be wrong.  --dav, 2014-08-31.

extern NSString * const kNameKey;   // Name of a person
extern NSString * const kAgeKey;    // Age of a person

extern NSString * const kDefaultsShiftStatusKey; // Key used to store the shift status in default settings
extern NSString * const kDefaultsShiftAvailableKey; // Key used to store the shift available in default settings
extern NSString * const kDefaultsFacilityIdKey; // Key used to store the facility id in default settings

// Ditto soon redundant/wrong.
extern NSString * const kStatusScheduled;   // Has a calculated due time
extern NSString * const kStatusPostponed;   // Has a delayed due time
extern NSString * const kStatusCompleted;   // No further action
extern NSString * const kStatusCompletedAway;   // No further action - away

extern NSString * const kSchedulingStatusScheduled; // Has a calculated due time
extern NSString * const kSchedulingStatusNotified;  // Has notification pending
extern NSString * const kSchedulingStatusDue;       // Has notification pending
extern NSString * const kSchedulingStatusCompleted;  // No further action


// Names used when sending and processing notification center notifications
extern NSString * const kShiftChangedNotificationName;
extern NSString * const kSchedulerTimeChangedNotificationName;
extern NSString * const kSchedulerTimeTickNotificationName;
extern NSString * const kScheduleChangedNotificationName;
extern NSString * const kActionStateChangedNotificationName;
#endif