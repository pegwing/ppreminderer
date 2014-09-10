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
@property (atomic) int facilityCounter;
@end

@implementation PPRFacilityManager
+ (PPRFacilityManager *) sharedClient {
    static PPRFacilityManager* _sharedClient;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [PPRFacilityManager alloc];
        _sharedClient.facilities = [[NSMutableDictionary alloc]init];
    });
    return _sharedClient;
}
- (void)getFacility:(PPRFacility *)facility success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    if ( facility == nil) {
        success(self.facilities.allValues);
    } else {
        // FIXME handle more keys.
        success([NSArray arrayWithObject:self.facilities[facility.facilityId]]);
    }
}
- (void)insertFacility:(PPRFacility *)facility success:(void (^)())success failure:(void (^)(NSError *))failure
{
    self.facilityCounter++;
    NSString *facilityId = [NSString stringWithFormat:@"FAC%d", self.facilityCounter];
    facility.facilityId = facilityId;
    self.facilities[facilityId] = facility;
    success();
}
@end
