//
//  PPRSettingsViewController.m
//  ppreminderer
//
//  Created by David Bernard on 17/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRSettingsViewController.h"
#import "PPRShift.h"
#import "PPRScheduler.h"
#import "PPRActionManager.h"

@interface PPRSettingsViewController ()
-(IBAction)resetDefaultSettings:(id)sender;
-(IBAction)setScheduleTime:(id)sender ;
-(IBAction)warpFactorDidChange:(id)sender;
@property (nonatomic,weak) IBOutlet UILabel *warpFactorLabel;

@property (nonatomic,strong)PPRScheduler *scheduler;

@end

@implementation PPRSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _scheduler = (PPRScheduler *)[PPRScheduler sharedInstance];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scheduler = (PPRScheduler *)[PPRScheduler sharedInstance];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)resetDefaultSettings:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:PPRShiftStatusOn] forKey:kDefaultsShiftStatusKey];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:true] forKey:kDefaultsShiftAvailableKey];
    [[NSUserDefaults standardUserDefaults] setObject:@"FAC1" forKey:kDefaultsFacilityIdKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:kShiftChangedNotificationName object:nil];
}

- (IBAction) setScheduleTime:(id)sender {
    UIDatePicker *datePicker = (UIDatePicker *)sender;
    NSDate *date = datePicker.date;
    [self.scheduler setSchedulerTime:date];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SchedulerTimeChanged" object:nil];
    
}

- (IBAction)warpFactorDidChange:(UIStepper *)sender {
    [self.warpFactorLabel setText:[NSString stringWithFormat:@"%d", (int)sender.value]];
    self.scheduler.warpFactor = sender.value;
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
