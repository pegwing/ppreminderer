//
//  PPRShiftViewController.m
//  ppreminderer
//
//  Created by David Bernard on 19/08/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRShiftViewController.h"
#import "PPRFacilitySelectionViewController.h"
#import "PPRFacilityManager.h"
#import "PPRScheduledEvent.h"

NSString * const kDefaultsFacilityIdKey =     @"Facility";

@interface PPRShiftViewController ()
-(IBAction)onShift:(id)sender;
-(IBAction)offShift:(id)sender;
@property (nonatomic, weak) IBOutlet UIButton *facilityButton;
@property (nonatomic, weak) IBOutlet UILabel *status;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray * facilities;
@property (nonatomic, strong) PPRFacility * facility;

@end


@implementation PPRShiftViewController {
 NSDictionary * events;
}

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
    // Do any additional setup after loading the view.
    
    [[PPRFacilityManager sharedClient] getFacility:nil success:^(NSArray *facilities) {
        self.facilities = facilities;
    } failure:^(NSError *error) {
        
    }];

    self.facility = self.facilities[0];
    // FIXME
    [[NSUserDefaults standardUserDefaults] setObject:self.facility.facilityId forKey:kDefaultsFacilityIdKey];
    [self.facilityButton setTitle:self.facility.name forState:UIControlStateNormal];
    self.tableView.dataSource = self;
    [self.tableView reloadData];
 
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.facility.events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventCell" forIndexPath:indexPath];
    
    // Configure the cell...
    PPRScheduledEvent *event = self.facility.events[indexPath.row];
    [cell.textLabel setText:event.eventName];
    // FIXME
    [cell.detailTextLabel setText:event.scheduled.description];
    return cell;
}

- (IBAction)onShift:(id)sender {
    [self.status setText: @"On Shift"];
}

- (IBAction)offShift:(id)sender {
    [self.status setText: @"Off Shift"];
}

- (IBAction)facilitySelected:(UIStoryboardSegue *) sender
{
    if ([sender.sourceViewController isKindOfClass:[PPRFacilitySelectionViewController class]]) {
        PPRFacilitySelectionViewController *fsvc = ((PPRFacilitySelectionViewController *)(sender.sourceViewController));
        long selectedRow = fsvc.tableView.indexPathForSelectedRow.row;
        self.facility = self.facilities[selectedRow];
        [[NSUserDefaults standardUserDefaults] setObject:self.facility.facilityId forKey:kDefaultsFacilityIdKey];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Facility" object:self userInfo:@{@"Facility" : self.facility.facilityId}];
        [self.facilityButton setTitle:self.facility.name forState:UIControlStateNormal];
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    UIViewController *dest = [segue destinationViewController];
    if ([dest isKindOfClass:[PPRFacilitySelectionViewController class]]) {
        ((PPRFacilitySelectionViewController *)dest).facilities = self.facilities;
    }
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
