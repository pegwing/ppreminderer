//
//  PPRStatusBarButtonItem.m
//  ppreminderer
//
//  Created by David Bernard on 24/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRStatusBarButtonItem.h"
#import "PPRShiftManager.h"

@implementation PPRStatusBarButtonItem
- (void) showStatus
{
    PPRShift *shift = ((PPRShiftManager *)[PPRShiftManager sharedInstance]).shift;
    
    if (shift.shiftStatus.intValue == PPRShiftStatusOff) {
        self.title = @"Off Shift";
    }
    else if (shift.shiftStatus.intValue == PPRShiftStatusOn && shift.available.boolValue) {
        self.title = @"On Shift";
    }
    else {
        self.title = @"Unavailable";
    }
}


@end
