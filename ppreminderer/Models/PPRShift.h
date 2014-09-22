//
//  PPRShift.h
//  ppreminderer
//
//  Created by David Bernard on 17/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(int, PPRShiftStatusType) {
    PPRShiftStatusOn = 1,
    PPRShiftStatusOff

};

@interface PPRShift : NSObject

@property (nonatomic) NSNumber* shiftStatus;
@property (nonatomic,strong) NSString *facilityId;
@property (nonatomic) NSNumber *available;


@end
