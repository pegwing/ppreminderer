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
#import "PPRFacility.h"
#import "PPRShift.h"

@interface PPRShiftViewController ()
-(IBAction)onShift:(id)sender;
-(IBAction)offShift:(id)sender;
-(IBAction)toggleAvailable:(id)sender;

@property (nonatomic, weak) IBOutlet UIButton *facilityButton;
@property (nonatomic, weak) IBOutlet UIButton *statusButton;
@property (nonatomic, weak) IBOutlet UITableView *tableView;


@property (nonatomic, strong) NSArray * facilities;
@property (nonatomic, strong) PPRFacility * facility;
@property (nonatomic, strong) PPRShift *shift;

- (void)setShiftStatus:(PPRShiftStatusType )shiftStatus;
- (void)setShiftAvailable:(BOOL)available;
- (void)publishShift;

- (void)setFacility:(PPRFacility *)facility;
    
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
    
    [((PPRFacilityManager *)[PPRFacilityManager sharedInstance]) getFacility:nil success:^(NSArray *facilities) {
        self.facilities = facilities;
    } failure:^(NSError *error) {
        
    }];

    [self loadShift];
    [self publishShift];
    
    // Act as the datasource for the event table view
    self.tableView.dataSource = self;
    [self.tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kShiftChangedNotificationName object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [self loadShift];
    }];
 
}

- (void)loadShift {
    // Default to first facility
    PPRFacility *facility = self.facilities[0];
    
    self.shift.shiftStatus = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsShiftStatusKey];
    
    if (self.shift.shiftStatus != nil) {
        self.shift.available = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsShiftAvailableKey];
        self.shift.facilityId = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsFacilityIdKey];
        
        // Locate facility from facility id
        NSString *facilityId = self.shift.facilityId;
        NSInteger index = [self.facilities indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            return [facilityId isEqual:((PPRFacility *)obj).facilityId];
        }];
        if (index != NSNotFound) {
            facility = self.facilities[index];
        }
        [self setFacility:facility];
    } else {
        // No shift set
        self.shift = [[PPRShift alloc]init];
        self.shift.facilityId = facility.facilityId;
        self.shift.available = [NSNumber numberWithBool:true];
        self.shift.shiftStatus = [NSNumber numberWithInt:PPRShiftStatusOff];
        [self setFacility:facility];
        
    }
    [self.statusButton setTitle:self.shift.description forState:UIControlStateNormal];
}
- (void)publishShift {
    [self.statusButton setTitle:self.shift.description forState:UIControlStateNormal];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.shift.shiftStatus forKey:kDefaultsShiftStatusKey];
    [[NSUserDefaults standardUserDefaults] setObject:self.shift.available forKey:kDefaultsShiftAvailableKey];
    [[NSUserDefaults standardUserDefaults] setObject:self.shift.facilityId forKey:kDefaultsFacilityIdKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:kShiftChangedNotificationName object:self.shift];
}

- (void)setFacility:(PPRFacility *)facility {
    _facility = facility;
    self.shift.facilityId = facility.facilityId;
    [self.facilityButton setTitle:self.facility.name forState:UIControlStateNormal];
    [self.tableView reloadData];
}

- (void)setShiftStatus:(PPRShiftStatusType )shiftStatus {
    self.shift.shiftStatus = [NSNumber numberWithInt:shiftStatus];
}

- (void)setShiftAvailable:(BOOL)available {
    self.shift.available = [NSNumber numberWithBool:available];
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
    [self setShiftStatus:PPRShiftStatusOn];
    [self publishShift];
}

- (IBAction)offShift:(id)sender {
    [self setShiftStatus:PPRShiftStatusOff];
    [self publishShift];
}

- (IBAction)toggleAvailable:(id)sender {
    [self setShiftAvailable:!self.shift.available.boolValue];
    [self publishShift];
}

- (IBAction)facilitySelected:(UIStoryboardSegue *) sender
{
    if ([sender.sourceViewController isKindOfClass:[PPRFacilitySelectionViewController class]]) {
        PPRFacilitySelectionViewController *fsvc = ((PPRFacilitySelectionViewController *)(sender.sourceViewController));
        long selectedRow = fsvc.tableView.indexPathForSelectedRow.row;
        [self setFacility:self.facilities[selectedRow]];
        [self publishShift];
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
