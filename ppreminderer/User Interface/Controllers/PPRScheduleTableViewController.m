//
//  PPRScheduleTableViewController.m
//  Was: PPRScheduleViewController.m
//  ppreminderer
//
//  Created by David Bernard on 13/08/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRScheduleTableViewController.h"
#import "PPRActionViewController.h"
#import "PPRActionManager.h"
#import "PPRClientAction.h"
#import "PPRActionScheduler.h"
#import "PPRScheduler.h"
#import "PPRShiftManager.h"



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
    // If not done then update to done and record completion time
    if (![_currentAction.status isEqualToString:kStatusCompleted]) {
        NSDate *completionTime = ((PPRScheduler *)[PPRScheduler sharedInstance]).schedulerTime;
        [[PPRActionManager sharedInstance] updateAction: _currentActionID
                                                                     status: kStatusCompleted completionTime:completionTime
                                                                    success:^(PPRAction *action)            {
                                                                        [self loadActions];
                                                                        [self.tableView reloadData]
                                                                        ;}
                                                                    failure:^(NSError * dummy) {
                                                                        // TODO error handling
                                                                    }];
    }
}


- (IBAction)cross:(UIStoryboardSegue *) sender
{
    // if done then "Undo" done
    if ([_currentAction.status isEqualToString:kStatusCompleted]) {
        [[PPRActionManager sharedInstance] updateStatusOf: _currentActionID to: kStatusScheduled
                                                                      success:^(PPRAction *action)            {
                                                                          [self loadActions];
                                                                          [self.tableView reloadData];}
                                                                      failure:^(NSError * dummy) {
                                                                      // TODO error handling
                                                                      }];
    }
}

- (IBAction)postpone:(UIStoryboardSegue *)sender
{
    NSDate *newDueTime = [[PPRActionScheduler sharedInstance] dueTimeForAction:_currentAction
                                                                                           delayedBy:300.0
                          ];
    [[PPRActionManager sharedInstance] updateAction:_currentActionID
     status:kStatusPostponed
     dueTime:newDueTime
     success:^(PPRAction *action)
     {
         [self loadActions];
         [self.tableView reloadData];
     }
     
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
        [(PPRActionViewController *)dest setAction:_currentAction];
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

BOOL inOrderOld(PPRAction *const a, PPRAction *const b) {
    return [a.dueTime compare: b.dueTime];
}

BOOL isParentOf(PPRAction *const a, PPRAction *const b) {
    // a is parent of b; i.e. b's parent is a.
    const BOOL r = (a.scheduledEvent == b.scheduledEvent.parent);
//    const NSString *const rDescribed = r ? @"YES":@"NO";
//    NSLog(@"isParentOf(%@,%@)?  %@",
//          a.description,b.description,rDescribed);
    return r;
}

BOOL isChildOf(PPRAction *const a, PPRAction *const b) {
    return isParentOf(b,a);
}

BOOL inOrder(PPRAction *const a, PPRAction *const b) {
    BOOL r;
    if (isParentOf(a,b)) {
        r = YES;
    } else {
        assert(!isParentOf(a,b));
        if(!isChildOf(a,b)) {
            r = inOrderOld(a, b);
        } else {
            assert(isChildOf(a,b));
            assert(isParentOf(b,a));
            r = NO;
        }
    }
    const NSString *const aDescribed = a.description;
    const NSString *const bDescribed = b.description;
    const NSString *const rDescribed = r ? @"YES":@"NO";
    NSLog(@"inOrder(%@, %@?  %@",aDescribed,bDescribed,rDescribed);
    return r;
}

- (void)loadActions {
    PPRAction *actionFilter = [[PPRAction alloc]init];
    PPRFacility *facility = [[PPRFacility alloc] init];
    actionFilter.facility = facility;
    actionFilter.facility.facilityId =[PPRShiftManager sharedInstance].shift.facilityId;
    
    [(PPRActionManager *)[PPRActionManager sharedInstance]
     getAction:actionFilter
     success:^(NSArray * actions) {
         NSMutableArray * nonChildActions = [NSMutableArray array];
         for (PPRAction * a in actions) {
             if (a.parent == nil ) {
                 [nonChildActions addObject:a];
             }
         }
         const size_t nNotAdded = actions.count - nonChildActions.count;
         NSLog(@"nNotAdded was %zu", nNotAdded);
         _scheduleEntries = [nonChildActions sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
             PPRAction *action1 = (PPRAction *)obj1;
             PPRAction *action2 = obj2;
             return inOrder/*Old*/(action1,action2);
         }];
     }
     failure:^(NSError * dummy)   { } ];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserverForName:kShiftChangedNotificationName
                                                      object:nil queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
        [self loadActions];
        [self.tableView reloadData];
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:kScheduleChangedNotificationName
                                                      object:nil queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      [self loadActions];
                                                      [self.tableView reloadData];
                                                  }];

    [self loadActions];
    
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
    
    PPRAction *action = (PPRAction *)(_scheduleEntries[indexPath.row]);
    // For hacking grouping by adding spaces at the start of the textLabel and the detailTextLabel.
    static const NSString *const indent0 = @"";
    static const NSString *const indent4 = @"    ";
    static const NSString *const indent8 = @"        ";
    if ( [action isKindOfClass:[PPRAction class]]) {
        PPRAction *item = (PPRAction *)action;
        const BOOL shouldIndent = item.shouldGroup;
        NSString *const detailMaybeIndented =
            [NSString stringWithFormat:@"%@%@",shouldIndent?indent8:indent4, item.dueTimeDescription];
            [cell.detailTextLabel setText:detailMaybeIndented];
//        NSLog([NSString stringWithFormat:@"item.dueTimeDescription was %@", item.dueTimeDescription]);
//        NSLog([NSString stringWithFormat:@"item.parent was %@", item.parent]);
        
        if ([item.status isEqualToString:        kStatusCompleted]){
            [cell setBackgroundColor: [UIColor                          greenColor  ]];
        } else if ([item.status isEqualToString: kStatusPostponed]){
            [cell setBackgroundColor: [UIColor                          orangeColor   ]];
        } else if ([item.status isEqualToString: kStatusScheduled]){
            if ( [item.dueTime compare:[PPRScheduler sharedInstance].schedulerTime] == NSOrderedAscending)
            [cell setBackgroundColor: [UIColor                            redColor]];
            else
            [cell setBackgroundColor: [UIColor                          yellowColor  ]];
        }
    }
    if ( [action isKindOfClass:[PPRClientAction class]]) {
        PPRClientAction *item = (PPRClientAction *)action;
        NSString *label = [NSString stringWithFormat:@"%@ - %@", item.client.name, item.context];
        NSString *const labelMaybeIndented =
            [NSString stringWithFormat:@"%@%@",action.shouldGroup?indent4:indent0, label]; // Smaller indent for text rather than detail
        [cell.textLabel setText:labelMaybeIndented];
    } else {
        NSString *const contextMaybeIndented =
            [NSString stringWithFormat:@"%@%@",action.shouldGroup?indent4:indent0, action.context]; // Smaller indent for text rather than detail
        [cell.textLabel setText:contextMaybeIndented];
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
