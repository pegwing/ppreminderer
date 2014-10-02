//
//  PPRFacility.h
//  ppreminderer
//
//  Created by David Bernard on 9/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPRFacilityInstruction.h"

@interface PPRFacility : NSObject
@property (nonatomic,strong) NSString *facilityId;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSMutableArray *instructions;
@property (nonatomic,strong) NSMutableArray *events;

-(id)initWithName:(NSString *)name address:(NSString *)address;
@end
