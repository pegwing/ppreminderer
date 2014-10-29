//
//  PPRAction.m
//  ppreminderer
//
//  Created by David Bernard on 8/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRAction.h"

NSString * const kStatusScheduled = @"Scheduled";
NSString * const kStatusPostponed = @"Postponed";
NSString * const kStatusDue =       @"Due";
NSString * const kStatusCompleted = @"Completed";


@implementation PPRAction

-(id)initWithFacility:(PPRFacility *)facility scheduledEvent:(PPRScheduledEvent *)scheduledEvent parent:(PPRAction *)parent actions:(NSMutableArray *)actions
{
    self = [super init];
    if (self) {
        _facility = facility;
        _scheduledEvent = scheduledEvent;
        _parent = parent;
        _actions = actions;
        _status = nil;
    }
    return self;
}

- (NSString *)notificationDescription {
    return [self dueTimeDescription];
}

-(BOOL) shouldGroup {
    const PPRScheduleTime *const t = self.scheduledEvent.scheduled;
    NSLog(@"shouldGroup entered");
    NSLog(@"t was %@;",t.description);
    return t.type != PPRScheduleTimeTimeOfDay;
}

-(NSString *)dueTimeDescription {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    

    NSString *scheduleDescription = self.scheduledEvent.scheduled.description;
    NSDate *time;
    if ([self.status isEqualToString:kStatusCompleted]) {
        time = self.completionTime;
    } else {
        time = self.dueTime;
        
    }
    NSString *dueTimeDescription = [dateFormatter stringFromDate:time];
//    NSLog(@"%s:scheduleDescription was %@",__func__,scheduleDescription);
    //NSLog(@"%s:dueTimeDescription  was %@",__func__,dueTimeDescription);
    return [NSString stringWithFormat:@"%@ - %@", scheduleDescription, dueTimeDescription];
}

- (NSArray *)instructionsForAction {
    return [[NSArray alloc]init];
}

@end
