//
//  PPRActionViewController.m
//  ppreminderer
//
//  Created by David Vincent on 15/08/14.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRActionViewController.h"
#import "PPRClientViewController.h"
#import "PPRClientAction.h"

@interface PPRActionViewController ()

@property (nonatomic, weak) IBOutlet UILabel *actionDetails;
@property (nonatomic, weak) IBOutlet UIButton *client;
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
    
    if ([self.details isKindOfClass:[PPRClientAction class]]) {
        PPRClientAction *clientAction = (PPRClientAction *)self.details;
        
    [self.client setTitle:clientAction.client.name forState: UIControlStateNormal] ;
    }
    [self.actionDetails setText: [NSString stringWithFormat:@"%@\n%@", self.details.scheduledEvent.eventName, self.details.dueTimeDescription]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *dest =  [segue destinationViewController];
    if ( [dest isKindOfClass: [PPRClientViewController class]] &&
        [self.details isKindOfClass: [PPRClientAction class]]) {
        PPRClientAction *clientAction = (PPRClientAction *)self.details;
        ((PPRClientViewController *)dest).details = clientAction.client;
    }
    // Pass the selected object to the new view controller.
}


@end
