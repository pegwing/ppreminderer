//
//  PPRActionViewController.m
//  ppreminderer
//
//  Created by David Vincent on 15/08/14.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRActionViewController.h"

@interface PPRActionViewController ()

@property (nonatomic, weak) IBOutlet UILabel *actionDetails;

@end

@implementation PPRActionViewController

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
    
    [self.actionDetails setText: [NSString stringWithFormat:@"Client %@\n%@\n%@", self.details[kNameKey], self.details[kActionKey], self.details[kDueKey]]];
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
