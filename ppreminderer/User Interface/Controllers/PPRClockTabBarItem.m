//
//  PPRClockTabBarItem.m
//  ppreminderer
//
//  Created by David Bernard on 19/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRClockTabBarItem.h"
#import "PPRScheduler.h"

@interface PPRClockTabBarItem()
@property (nonatomic,weak) PPRScheduler *scheduler;

@end
@implementation PPRClockTabBarItem


- (void) showTime {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeStyle:NSDateFormatterShortStyle];
    [df setDateStyle:NSDateFormatterNoStyle];

    self.title = [df stringFromDate:((PPRScheduler *)[PPRScheduler sharedInstance]).schedulerTime];
}

@end
