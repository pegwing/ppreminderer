//
//  PPRScheduleViewController.m
//  ppreminderer
//
//  Created by David Bernard on 13/08/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRScheduleTableViewController.h"
#import "PPRActionViewController.h"
#import "PPRActionManager.h"
#import "PPRClientAction.h"



NSString * const kDueKey =    @"Due";
NSString * const kActionKey = @"Action";
NSString * const kStatusKey = @"Status";
NSString * const kClientKey = @"Client";
NSString * const kIdKey =     @"Key";

NSString * const kStatusDone =      @"Done";
NSString * const kStatusPostponed = @"Postponed";
NSString * const kStatusBlank =     @"";

// Note about the above:  'blank' is related to a 'Not done' state, perhaps for historical reasons only.

@interface PPRScheduleTableViewController ()

@end

@implementation PPRScheduleTableViewController{
    NSArray *_scheduleEntries;
    NSString *_currentActionID;
    PPRAction *_currentAction;
}

- (IBAction)tick:(UIStoryboardSegue *) sender
{
    [(PPRActionManager *)[PPRActionManager sharedInstance] updateStatusOf: _currentActionID to: kStatusDone
                                            success:^(PPRAction *action)            {[self.tableView reloadData];}
                                            failure:^(NSError * dummy) {}];
}

- (IBAction)cross:(UIStoryboardSegue *) sender
{
    [(PPRActionManager *)[PPRActionManager sharedInstance] updateStatusOf: _currentActionID to: kStatusBlank
                                            success:^(PPRAction *action)            {[self.tableView reloadData];}
                                            failure:^(NSError * dummy) {}];
}

- (IBAction)postpone:(UIStoryboardSegue *)sender
{
    [(PPRActionManager *)[PPRActionManager sharedInstance] updateStatusOf: _currentActionID to: kStatusPostponed
                                            success:^(PPRAction *action)            {[self.tableView reloadData];}
                                            failure:^(NSError * dummy) {}];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *dest = [segue destinationViewController];
    if ([dest isKindOfClass:[PPRActionViewController class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        PPRAction *item = _scheduleEntries[indexPath.row];
        _currentActionID = item.actionId;
        _currentAction = item;
        [(PPRActionViewController *)dest setDetails:_currentAction];
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [(PPRActionManager *)[PPRActionManager sharedInstance]
        getAction:nil
        success:^(NSArray * actions) { _scheduleEntries = actions;}
        failure:^(NSError * dummy)   { } ];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return [_scheduleEntries count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ActionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PPRClientAction *item = (PPRClientAction *)(_scheduleEntries[indexPath.row]);
    NSString *label = [NSString stringWithFormat:@"%@ - %@", item.client.name, item.context];
    [cell.textLabel setText:label ];
    
    [cell.detailTextLabel setText:item.dueTimeDescription];
    
    if ([item.status isEqualToString:        kStatusDone]){
        [cell setBackgroundColor: [UIColor                          greenColor  ]];
    } else if ([item.status isEqualToString: kStatusPostponed]){
        [cell setBackgroundColor: [UIColor                          grayColor   ]];
    } else if ([item.status isEqualToString: kStatusBlank]){
        [cell setBackgroundColor: [UIColor                          whiteColor  ]];
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
