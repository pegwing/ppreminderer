//
//  PPRClientViewControllerTableViewController.m
//  ppreminderer
//
//  Created by David Bernard on 13/08/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRClientTableViewController.h"
#import "PPRClientViewController.h"
#import "PPRClientManager.h"

@interface PPRClientTableViewController ()
-(void) loadClients;
@end

@implementation PPRClientTableViewController {
    // NSMutableArray *_clientEntries;
    NSArray *_clientEntries;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *dest = [segue destinationViewController];
    if ([dest isKindOfClass:[PPRClientViewController class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        [(PPRClientViewController *)dest setDetails:_clientEntries[indexPath.row]];
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

-(void)loadClients
{
    PPRClient * clientFilter = [[PPRClient alloc] init];
    PPRFacility *facility = [[PPRFacility alloc] init];
    clientFilter.facility = facility;
    clientFilter.facility.facilityId = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsFacilityIdKey];
    [[PPRClientManager sharedClient] getClient:clientFilter success:^(NSArray *clients) {
        _clientEntries = clients;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadClients];
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"Facility" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [self loadClients];
    }];

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
    return [_clientEntries count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ClientCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PPRClient *client = _clientEntries[indexPath.row];
    
    [cell.textLabel setText:client.name];
    
    // FIXME
    [cell.detailTextLabel setText:client.birthDate.description];
    
#ifdef DEBUG
    [cell setAccessibilityLabel:[NSString stringWithFormat:@"Section %ld Row %ld", (long)indexPath.section, (long)indexPath.row]];
#endif
    
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
