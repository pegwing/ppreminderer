//
//  PPRStatusShowingTableViewController.m
//  ppreminderer
//
//  Created by David Bernard on 19/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRStatusShowingTableViewController.h"
#import "PPRStatusBarButtonItem.h"
#import "PPRShiftManager.h"

@interface PPRStatusShowingTableViewController ()
@property (nonatomic,weak)PPRShiftManager *shiftManager;
@end

@implementation PPRStatusShowingTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.shiftManager = (PPRShiftManager *)[PPRShiftManager sharedInstance];


    UIBarButtonItem *button = self.navigationItem.rightBarButtonItem;
    if ( [button isKindOfClass:[PPRStatusBarButtonItem class]]) {
        button.target = self;
        button.action = @selector(toggleAvailability:);
        [[NSNotificationCenter defaultCenter] addObserver:button selector:@selector(showStatus) name:kShiftChangedNotificationName object:nil];
        [self.shiftManager publishShift:self.shiftManager.shift];
    }
}

- (IBAction)toggleAvailability:(id)sender {
    // FIXME
    self.shiftManager.shift.available =  [NSNumber numberWithBool:!self.shiftManager.shift.available.boolValue];
    [self.shiftManager publishShift:self.shiftManager.shift];
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
