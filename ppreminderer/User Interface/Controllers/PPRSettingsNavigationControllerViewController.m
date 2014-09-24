//
//  PPRSettingsNavigationControllerViewController.m
//  ppreminderer
//
//  Created by David Bernard on 19/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRSettingsNavigationControllerViewController.h"
#import "PPRClockTabBarItem.h"

@interface PPRSettingsNavigationControllerViewController ()

@end

@implementation PPRSettingsNavigationControllerViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
 
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    PPRClockTabBarItem *clock = (PPRClockTabBarItem *)self.tabBarItem;
    [[NSNotificationCenter defaultCenter] addObserver:clock selector:@selector(showTime) name:kSchedulerTimeChangedNotificationName object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
