//
//  PPRClientActionScheduler.h
//  ppreminderer
//
//  Created by David Bernard on 23/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPRActionScheduler.h"
#import "PPRClient.h"


@interface PPRClientActionScheduler : PPRActionScheduler
- (void)scheduleEventsForClient:(PPRClient *)client forParentAction:(PPRAction*)parent;

@end
