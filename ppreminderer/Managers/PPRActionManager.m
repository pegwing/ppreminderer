//
//  PPRActionManager.m
//  ppreminderer
//
//  Created by David A Vincent on 22/08/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRActionManager.h"

@interface PPRActionManager ()
@property (nonatomic,strong) NSMutableDictionary* actions;
@end

@implementation PPRActionManager

+ (PPRActionManager *)sharedClient {
    static PPRActionManager * _sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [PPRActionManager alloc];
        _sharedClient.actions = [NSMutableDictionary dictionaryWithObjectsAndKeys:
            [NSMutableDictionary dictionaryWithObjectsAndKeys:
             @{kNameKey: @"Fred", kAgeKey: @"10"}, kClientKey,
             @"Medication",kActionKey,
             @"14:35", kDueKey,
             @"",kStatusKey,
                                 @"1",kIdKey,
             nil],
                                 @"1",
            [NSMutableDictionary dictionaryWithObjectsAndKeys:
             @{kNameKey: @"Izzy", kAgeKey: @"10"},kClientKey,
             @"Irrigation",kActionKey,
             @"15:15",kDueKey,
             @"",kStatusKey,
                                 @"2",kIdKey,
             nil],
                                 @"2",
            [NSMutableDictionary dictionaryWithObjectsAndKeys:
             @{kNameKey: @"Dave", kAgeKey: @"50"}, kClientKey,
             @"Start Feed",kActionKey,
             @"15:30",kDueKey,
             @"",kStatusKey,
                                 @"3",kIdKey,
             nil],
                                 @"3",
            nil
        ];
    });
    return _sharedClient;
}

- (void) getAction: (NSDictionary *)action success: (void(^)(NSArray *))success failure: (void(^)(NSError *)) failure {
    success(self.actions.allValues);
}

- (void) updateAction: (NSMutableDictionary *)action success: (void(^)(NSMutableDictionary *))success failure: (void(^)(NSError *)) failure {
    self.actions[action[kIdKey]] = action;
    success(action);
}

@end
