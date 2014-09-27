//
//  PPRActionViewController.h
//  ppreminderer
//
//  Created by David Vincent on 15/08/14.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPRAction.h"

@interface PPRActionViewController : UIViewController<UITableViewDataSource>

@property (nonatomic, strong) PPRAction *action;

@end
