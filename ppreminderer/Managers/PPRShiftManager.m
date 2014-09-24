//
//  PPRShiftManager.m
//  ppreminderer
//
//  Created by David Bernard on 24/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRShiftManager.h"

// Setting strings
NSString * const kDefaultsShiftStatusKey =     @"ShiftStatus";
NSString * const kDefaultsShiftAvailableKey =     @"Available";
NSString * const kDefaultsFacilityIdKey =     @"FacilityId";

// Notification strings
NSString * const kShiftChangedNotificationName = @"ShiftChanged";

@implementation PPRShiftManager

- (PPRShiftManager *) init {
    self = [super init];
    if (self) {
        _shift = [[PPRShift alloc] init];
    }
    return self;
}

- (PPRShift *)loadShift {
    
    // Retrieve from default settings
    self.shift.shiftStatus =[[NSUserDefaults standardUserDefaults]
                             objectForKey:kDefaultsShiftStatusKey];
    
    // Assume others set if status set
    if (self.shift.shiftStatus != nil) {
        self.shift.available = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsShiftAvailableKey];
        self.shift.facilityId = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsFacilityIdKey];
    }
    else
    {
        // Defaults
        self.shift.facilityId = nil;
        self.shift.available = [NSNumber numberWithBool:true];
        self.shift.shiftStatus = [NSNumber numberWithInt:PPRShiftStatusOff];
        
    }
    return self.shift;
}
- (void)publishShift:(PPRShift *)shift {
    
    self.shift = shift;
    
    // Store in default settings for the user
    [[NSUserDefaults standardUserDefaults] setObject:self.shift.shiftStatus
                                              forKey:kDefaultsShiftStatusKey];
    [[NSUserDefaults standardUserDefaults] setObject:self.shift.available
                                              forKey:kDefaultsShiftAvailableKey];
    [[NSUserDefaults standardUserDefaults] setObject:self.shift.facilityId forKey:kDefaultsFacilityIdKey];
    
    // Notify
    [[NSNotificationCenter defaultCenter]
     postNotificationName:kShiftChangedNotificationName
     object:self.shift];
}

@end
