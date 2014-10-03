//
//  PPRClientViewController.m
//  ppreminderer
//
//  Created by David Bernard on 13/08/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRClientViewController.h"
#import "PPRClientManager.h"
#import "PPRClientInstruction.h"

NSString * const kNameKey = @"Name";
NSString * const kAgeKey = @"Age";


@interface PPRClientViewController ()

@property (nonatomic, weak) IBOutlet UITableViewCell *nameCell;
@property (nonatomic, weak) IBOutlet UITableViewCell *ageCell;

@end

@implementation PPRClientViewController

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
        
    [self.nameCell.detailTextLabel setText:self.details.name];
    // FIXME
    [self.ageCell.detailTextLabel setText:self.details.birthDate.description];

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
    return 4;
}

// fixme - Please replace the following with a nicely defined enum and/or typedef;  be careful of code that assumes the number of sections;  that include{s|d} some switch statements in this file
const NSInteger sectionNameAge =    0;
const NSInteger sectionNotes =      1;
const NSInteger sectionInstructions =   2;
const NSInteger sectionSchedItems =     3;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case sectionNameAge:
            return 2;
            break;
        case sectionNotes:
            return self.details.notes.count;
            break;
        case sectionInstructions:
            return self.details.instructions.count;
            break;
        case sectionSchedItems:
            return self.details.scheduleItems.count;
            break;
        default:
            return 0;
            break;
    }
}

// Function to convert NSTimeInterval to a rough, not rounded, number of years.  Caller shouldn't need to know about what type is used to implement NSTimeInterval.  The maintainer will have to fix it if it ever changes.
/**
 Convert an NSTimeInterval to a rough, not rounded, integer number of years.  Hide information about how NSTimeInterval is implemented.
 */
const size_t intervalAsYears(const NSTimeInterval i)
{
    const double seconds = i;
    return seconds / 365.25 / 24.0 / 60.0 / 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ClientViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    switch (indexPath.section) {
        case sectionNameAge:
            if (0 == indexPath.row) {
                [cell.textLabel setText:self.details.name];
                [cell.detailTextLabel setText:@""];
            } else {
                assert(1 == indexPath.row);
                const NSDate *const d = self.details.birthDate;
                const NSTimeInterval ageInterval = -d.timeIntervalSinceNow;
                const size_t estimatedYears = intervalAsYears(ageInterval);
                NSString *const ageDescribed = [[NSString alloc] initWithFormat:@"around %zu", estimatedYears ];
                [cell.textLabel setText:ageDescribed];
                [cell.detailTextLabel setText:@""];
            }
            break;
        case sectionNotes:
            [cell.textLabel setText:self.details.notes[indexPath.row]];
            [cell.detailTextLabel setText:@""];
            break;
        case sectionInstructions: {
            // fixme - ignoring dates for now
            const PPRClientInstruction *const inst = self.details.instructions[indexPath.row];
            [cell.textLabel setText:inst.context];
            [cell.detailTextLabel setText:inst.instruction]; }
            break;
        case sectionSchedItems:
            [cell.textLabel setText:@"(fixme)"];
            break;
        default:
            return 0;
            break;
    }

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case sectionNameAge:
            return @"Client";
            break;
        case sectionNotes:
            return @"Notes";
            break;
        case sectionInstructions:
            return @"Instructions";
            break;
        case sectionSchedItems:
            return @"Schedule";
            break;
        default:
            return @"(fixme)";
            break;
    }
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
