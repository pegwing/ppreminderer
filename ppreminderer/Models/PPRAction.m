//
//  PPRAction.m
//  ppreminderer
//
//  Created by David Bernard on 8/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRAction.h"

NSString * const kStatusDone =      @"Done";
NSString * const kStatusPostponed = @"Postponed";
NSString * const kStatusBlank =     @"";

@implementation PPRAction

-(id)initWithScheduledEvent:(PPRScheduledEvent *)scheduledEvent parent:(PPRAction *)parent actions:(NSMutableArray *)actions
{
    self = [super init];
    if (self) {
        _scheduledEvent = scheduledEvent;
        _parent = parent;
        _actions = actions;
        _status = kStatusBlank;
    }
    return self;
}

-(NSString *)dueTimeDescription {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    

    NSString *scheduleDescription = self.scheduledEvent.scheduled.description;
    NSDate *time;
    if ([self.status isEqualToString:kStatusDone]) {
        time = self.completionTime;
    } else {
        time = self.dueTime;
    }
    NSString *dueTimeDescription = [dateFormatter stringFromDate:time];
    return [NSString stringWithFormat:@"%@ - %@", scheduleDescription, dueTimeDescription];
}

- (NSArray *)instructionsForAction {
    return [[NSArray alloc]init];
}

@end
