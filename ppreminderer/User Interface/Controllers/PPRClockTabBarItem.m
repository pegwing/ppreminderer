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
@property (nonatomic,strong) PPRScheduler *scheduler;
@property (nonatomic,strong) NSDateFormatter *dateFormatter;

@end
@implementation PPRClockTabBarItem

- (void)initialise {
        _scheduler = [PPRScheduler sharedInstance];
        _dateFormatter  = [[NSDateFormatter alloc]init];
        [_dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [_dateFormatter setDateStyle:NSDateFormatterNoStyle];
}

- (void) showTime {
    self.title = [self.dateFormatter stringFromDate:self.scheduler.schedulerTime];
}

@end
