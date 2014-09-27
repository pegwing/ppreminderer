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
#import "PPRClientInstruction.h"

@interface PPRActionViewController ()

@property (nonatomic, weak) IBOutlet UILabel *actionDetails;
@property (nonatomic, strong) NSArray *instructions;
@property (nonatomic, weak) IBOutlet UIButton *client;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
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
    
    if ([self.action isKindOfClass:[PPRClientAction class]]) {
        PPRClientAction *clientAction = (PPRClientAction *)self.action;
        
    [self.client setTitle:clientAction.client.name forState: UIControlStateNormal] ;
    }
    [self.actionDetails setText: [NSString stringWithFormat:@"%@\n%@", self.action.scheduledEvent.eventName, self.action.dueTimeDescription]];

    self.instructions = [self.action instructionsForAction];
    
    // Act as the datasource for the event table view
    self.tableView.dataSource = self;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.instructions.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActionInstructionCell" forIndexPath:indexPath];
    
    // Configure the cell...
    PPRClientInstruction *instruction = self.instructions[indexPath.row];
    [cell.textLabel setText:instruction.context];
    [cell.detailTextLabel setText:instruction.instruction];
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *dest =  [segue destinationViewController];
    if ( [dest isKindOfClass: [PPRClientViewController class]] &&
        [self.action isKindOfClass: [PPRClientAction class]]) {
        PPRClientAction *clientAction = (PPRClientAction *)self.action;
        ((PPRClientViewController *)dest).details = clientAction.client;
    }
    // Pass the selected object to the new view controller.
}


@end
