//
//  PPRShiftViewController.m
//  ppreminderer
//
//  Created by David Bernard on 19/08/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRShiftViewController.h"
#import "PPRFacilitySelectionViewController.h"

@interface PPRShiftViewController ()
-(IBAction)onShift:(id)sender;
-(IBAction)offShift:(id)sender;
@property (nonatomic, weak) IBOutlet UIButton *facilityButton;
@property (nonatomic, weak) IBOutlet UILabel *status;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableDictionary * facilities;
@property (nonatomic, strong) NSDictionary * facility;

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
    self.facilities =
       [NSMutableDictionary dictionaryWithObjectsAndKeys:
         [NSMutableDictionary dictionaryWithObjectsAndKeys:
            @"Group Home 1",
            @"Name",
            @"1 Smith Street Camperdown",
          @"Address",
          [NSMutableDictionary dictionaryWithObjectsAndKeys:
           [NSMutableDictionary dictionaryWithObjectsAndKeys:
            @"07:00",
            @"StartTime",
            @"0:45",
            @"Duration",
            nil],
           @"Breakfast",
           [NSMutableDictionary dictionaryWithObjectsAndKeys:
            @"12:00",
            @"StartTime",
            @"0:45",
            @"Duration",
            nil],
           @"Lunch",
           [NSMutableDictionary dictionaryWithObjectsAndKeys:
            @"17:00",
            @"StartTime",
            @"0:45",
            @"Duration",
            nil],
           @"Dinner",
           nil ], @"Events",
           nil],
        @"Group Home 1",
         [NSMutableDictionary dictionaryWithObjectsAndKeys:
          @"Group Home 2",
          @"Name",
          @"32 Orange Street Belmont Hills",
          @"Address",
          [NSMutableDictionary dictionaryWithObjectsAndKeys:
           [NSMutableDictionary dictionaryWithObjectsAndKeys:
            @"07:30",
            @"StartTime",
            @"0:45",
            @"Duration",
            nil],
           @"Breakfast",
           [NSMutableDictionary dictionaryWithObjectsAndKeys:
            @"12:30",
            @"StartTime",
            @"0:45",
            @"Duration",
            nil],
           @"Lunch",
           [NSMutableDictionary dictionaryWithObjectsAndKeys:
            @"17:30",
            @"StartTime",
            @"0:45",
            @"Duration",
            nil],
           @"Dinner",
           nil ], @"Events",
          nil],
         @"Group Home 2",nil];

    self.facility = self.facilities.allValues[0];
    [self.facilityButton setTitle:self.facility[@"Name"] forState:UIControlStateNormal];
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
    return [self.facility[@"Events"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventCell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *event = [self.facility[@"Events"] allValues][indexPath.row];
    [cell.textLabel setText:[self.facility[@"Events"] allKeys][indexPath.row]];
    [cell.detailTextLabel setText:event[@"StartTime"]];
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
        self.facility = self.facilities.allValues[selectedRow];
        [self.facilityButton setTitle:self.facility[@"Name"] forState:UIControlStateNormal];
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
