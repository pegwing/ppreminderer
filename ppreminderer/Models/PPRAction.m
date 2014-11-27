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
NSString * const kStatusCompletedAway = @"CompletedAway";


@implementation PPRAction

-(id)initWithFacility:(PPRFacility *)facility scheduledEvent:(PPRScheduledEvent *)scheduledEvent parent:(PPRAction *)parent actions:(NSMutableArray *)actions
{
    self = [super init];
    if (self) {
        _facilityId = facility.facilityId;
        _facility = facility;
        _scheduledEvent = scheduledEvent;
        _parentId = parent.actionId;
        _actions = actions;
        _status = nil;
    }
    return self;
}

- (NSString *)notificationDescription {
    return [self dueTimeDescription];
}

-(NSString *)dueTimeDescription {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    

    NSString *scheduleDescription = self.scheduledEvent.scheduled.description;
    NSDate *time;
    if ([self.status isEqualToString:kStatusCompleted] || [self.status isEqualToString:kStatusCompletedAway]) {
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

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             
             
             };

}
+ (NSDictionary *)encodingBehaviorsByPropertyKey {
    return @{
             @"actionId": [NSNumber numberWithUnsignedInt:MTLModelEncodingBehaviorUnconditional],
             @"context": [NSNumber numberWithUnsignedInt:MTLModelEncodingBehaviorUnconditional],
             @"status": [NSNumber numberWithUnsignedInt:MTLModelEncodingBehaviorUnconditional],
             @"dueTime": [NSNumber numberWithUnsignedInt:MTLModelEncodingBehaviorUnconditional],
             @"completionTime": [NSNumber numberWithUnsignedInt:MTLModelEncodingBehaviorUnconditional],
             @"scheduledEvent": [NSNumber numberWithUnsignedInt:MTLModelEncodingBehaviorUnconditional],
             @"parentId": [NSNumber numberWithUnsignedInt:MTLModelEncodingBehaviorUnconditional],
             @"actions": [NSNumber numberWithUnsignedInt:MTLModelEncodingBehaviorExcluded],
             @"history": [NSNumber numberWithUnsignedInt:MTLModelEncodingBehaviorExcluded],
             @"facilityId": [NSNumber numberWithUnsignedInt:MTLModelEncodingBehaviorUnconditional],
             @"facility": [NSNumber numberWithUnsignedInt:MTLModelEncodingBehaviorExcluded]
             
             };
}

- (BOOL)isEquivalentTo:(PPRAction *)action {
    // Should match facility and schedule event
    BOOL equivalent =
        (action.facilityId == nil || [self.facilityId isEqualToString:action.facilityId]) &&
        (action.context == nil || [self.context isEqualToString:action.context]) &&
        (action.scheduledEvent == nil || [self.scheduledEvent isEquivalentTo:action.scheduledEvent]);
    return equivalent;
}
@end
