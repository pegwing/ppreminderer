//
//  PPRFacilityManager.h
//  ppreminderer
//
//  Created by David Bernard on 22/08/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPRFacility.h"
#import "PPRSingleton.h"

@interface PPRFacilityManager : PPRSingleton
/**
 Locate one or more facilities given a "prototype" to match from the facilities collection.
 
 @param prototype A "prototype" used to select matching facilitiies
 @param success A block called with an array of matching facilities
 @param failure A block called if an error occurs
 */
- (void)getFacility:(PPRFacility *) prototype
            success:(void (^)(NSArray *)) success
            failure:(void (^)(NSError *)) failure;

/**
 Insert a facility into the facilities collection.
 
 @param facility A facility to persist into the facilities collection
 @param success A block called on success
 @param failure A block called if an error occurs
 */
- (void)insertFacility:(PPRFacility *)facility
               success:(void (^)()) success
               failure:(void (^)(NSError *)) failure;
@end
