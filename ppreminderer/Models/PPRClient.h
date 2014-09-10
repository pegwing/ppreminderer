//
//  PPRClient.h
//  ppreminderer
//
//  Created by David Bernard on 7/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPRFacility.h"

@interface PPRClient : NSObject
/**
 Id of client
 */
@property (nonatomic, strong) NSString *clientId;
/**
 Name of client
 */
@property (nonatomic,strong) NSString *name;
/**
 Birthday of client so that age can be displayed
 */
@property (nonatomic,strong) NSDate *birthDate;
/**
 Notes relevant to client
 */
@property (nonatomic,strong) NSMutableArray *notes;
/**
 Specific instructions given a context e.g. taking a tablet.
 */
@property (nonatomic,strong) NSMutableArray *instructions;
/**
 Schedule of actions
 */
@property (nonatomic, strong) NSMutableArray *scheduleItems;

/**
 Facility of client
 */
@property (nonatomic, weak) PPRFacility *facility;

-(id)initWithName:(NSString *)name birthDate:(NSDate *)birthDate;

@end
