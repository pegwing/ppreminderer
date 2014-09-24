//
//  PPRAction.m
//  ppreminderer
//
//  Created by David Bernard on 8/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRAction.h"

@implementation PPRAction

-(id)initWithScheduledEvent:(PPRScheduledEvent *)scheduledEvent parent:(PPRAction *)parent actions:(NSMutableArray *)actions
{
    self = [super init];
    if (self) {
        _scheduledEvent = scheduledEvent;
        _parent = parent;
        _actions = actions;
    }
    return self;
}

-(NSString *)dueTimeDescription {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    

    NSString *scheduleDescription = self.scheduledEvent.scheduled.description;
    NSString *dueTimeDescription = [dateFormatter stringFromDate:self.dueTime];
    return [NSString stringWithFormat:@"%@ - %@", scheduleDescription, dueTimeDescription];
}

@end
