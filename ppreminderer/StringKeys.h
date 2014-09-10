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
extern NSString * const kDueKey;    // when an action is Due
extern NSString * const kActionKey; // e.g. medication, irrigation, start feeding
extern NSString * const kClientKey; // client details (e.g. dict containing name and age)
extern NSString * const kStatusKey; // e.g. done, postponed, or blank
extern NSString * const kIdKey;                 // e.g. 1, 2, or 3 (as string)
extern NSString * const kDefaultsFacilityIdKey; // ...?

// Ditto soon redundant/wrong.
extern NSString * const kStatusDone;
extern NSString * const kStatusPostponed;
extern NSString * const kStatusBlank;

#endif