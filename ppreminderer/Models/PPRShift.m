//
//  PPRShift.m
//  ppreminderer
//
//  Created by David Bernard on 17/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRShift.h"

@implementation PPRShift

-(NSString *)description {
    // FIXME -
    NSString *status;
    NSString *description;
    
    switch (self.shiftStatus.intValue) {
        case PPRShiftStatusOff:
            status = @"Off Shift";
            break;
        case PPRShiftStatusOn:
            status = @"On Shift";
            break;
        default:
            status = [NSString stringWithFormat:@"Unknown status %d", self.shiftStatus.intValue];
            break;
    }
    if (self.available.boolValue) {
        description = [NSString stringWithFormat:@"Available %@", status];
    } else {
        description = [NSString stringWithFormat:@"Unavailable %@", status];
    }
    return description;
}

@end
