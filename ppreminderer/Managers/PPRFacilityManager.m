//
//  PPRFacilityManager.m
//  ppreminderer
//
//  Created by David Bernard on 22/08/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRFacilityManager.h"


@interface PPRFacilityManager ()
@property (nonatomic, strong) NSMutableDictionary *facilities;
@end

@implementation PPRFacilityManager
+ (PPRFacilityManager *) sharedClient {
    static PPRFacilityManager* _sharedClient;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [PPRFacilityManager alloc];
        _sharedClient.facilities =
        
        [NSMutableDictionary dictionaryWithObjectsAndKeys:
         [NSMutableDictionary dictionaryWithObjectsAndKeys:
          @"FAC1",
          @"Id",
          @"Group Home 1",
          @"Name",
          @"1 Smith Street Camperdown",
          @"Address",
          [NSMutableDictionary dictionaryWithObjectsAndKeys:
           [NSMutableDictionary dictionaryWithObjectsAndKeys:
            @"07:00",
            @"StartTime",
            @"0:45",
            @"Duration",
            nil],
           @"Breakfast",
           [NSMutableDictionary dictionaryWithObjectsAndKeys:
            @"12:00",
            @"StartTime",
            @"0:45",
            @"Duration",
            nil],
           @"Lunch",
           [NSMutableDictionary dictionaryWithObjectsAndKeys:
            @"17:00",
            @"StartTime",
            @"0:45",
            @"Duration",
            nil],
           @"Dinner",
           nil ], @"Events",
          nil],
         @"FAC1",
         [NSMutableDictionary dictionaryWithObjectsAndKeys:
          @"FAC2",
          @"Id",
          @"Group Home 2",
          @"Name",
          @"32 Orange Street Belmont Hills",
          @"Address",
          [NSMutableDictionary dictionaryWithObjectsAndKeys:
           [NSMutableDictionary dictionaryWithObjectsAndKeys:
            @"07:30",
            @"StartTime",
            @"0:45",
            @"Duration",
            nil],
           @"Breakfast",
           [NSMutableDictionary dictionaryWithObjectsAndKeys:
            @"12:30",
            @"StartTime",
            @"0:45",
            @"Duration",
            nil],
           @"Lunch",
           [NSMutableDictionary dictionaryWithObjectsAndKeys:
            @"17:30",
            @"StartTime",
            @"0:45",
            @"Duration",
            nil],
           @"Dinner",
           nil ], @"Events",
          nil],
         @"FAC2",nil];
        
    });
    return _sharedClient;
}
- (void)getFacility:(NSDictionary *) facility success:(void (^)(NSArray *)) success failure:(void (^)(NSError *)) failure {
    if ( facility == nil) {
        success(self.facilities.allValues);
    } else {
        // FIXME handle more keys.
        success([NSArray arrayWithObject:self.facilities[facility[@"Id"]]]);
    }
}
@end
