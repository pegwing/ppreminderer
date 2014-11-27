//
//  PPRTestIIntialiser.m
//  ppreminderer
//
//  Created by David Bernard on 9/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRTestIntialiser.h"


static PPRFacility * createTestFacility1() {
    
    // Facility 1
    PPRFacility *facility1 = [[PPRFacility alloc] initWithName:@"Group Home 1" address:@"1 Smith Street Somewhere"];
    NSDateComponents *eightOclock = [[NSDateComponents alloc] init];
    eightOclock.hour = 8;
    eightOclock.minute = 0;
    NSDateComponents *twelveThirty = [[NSDateComponents alloc] init];
    twelveThirty.hour = 12;
    twelveThirty.minute = 30;
    
    NSDateComponents *sixThirty = [[NSDateComponents alloc] init];
    sixThirty.hour = 18;
    sixThirty.minute = 30;
    NSDateComponents *ninePm = [[NSDateComponents alloc] init];
    ninePm.hour = 21;
    ninePm.minute = 0;
    NSMutableArray *events1 =
    [NSMutableArray arrayWithObjects:
     [[PPRScheduledEvent alloc] initWithEventName:@"Breakfast"
                                    scheduledTime: [[PPRScheduleTime alloc] initWithTimeOfDay:eightOclock]],
     [[PPRScheduledEvent alloc] initWithEventName:@"Lunch"
                                    scheduledTime: [[PPRScheduleTime alloc] initWithTimeOfDay:twelveThirty]],
     [[PPRScheduledEvent alloc] initWithEventName:@"Dinner"
                                    scheduledTime: [[PPRScheduleTime alloc] initWithTimeOfDay:sixThirty]],
     [[PPRScheduledEvent alloc] initWithEventName:@"Bed"
                                    scheduledTime: [[PPRScheduleTime alloc] initWithTimeOfDay:ninePm]],
     nil];
    facility1.events = events1;
    NSMutableArray *instructions1 =
    [NSMutableArray arrayWithObjects:
     [[PPRFacilityInstruction alloc]initWithContext:@"Breakfast"
                                      instruction:@"At outside table if warm"],
     nil
     ];
    facility1.instructions = instructions1;
    return facility1;
}

static PPRFacility *createTestFacility2()
{
    // Facility 2
    PPRFacility *facility2 = [[PPRFacility alloc] initWithName:@"Group Home 2" address:@"2 Jones Street Somewhereelse"];
    NSDateComponents *sevenThirty = [[NSDateComponents alloc] init];
    sevenThirty.hour = 7;
    sevenThirty.minute = 30;
    NSDateComponents *twelveOclock = [[NSDateComponents alloc] init];
    twelveOclock.hour = 12;
    twelveOclock.minute = 0;
    
    NSDateComponents *sixThirty = [[NSDateComponents alloc] init];
    sixThirty.hour = 18;
    sixThirty.minute = 30;
    NSDateComponents *ninePm = [[NSDateComponents alloc] init];
    ninePm.hour = 21;
    ninePm.minute = 0;
    NSMutableArray *events2 =
    [NSMutableArray arrayWithObjects:
     [[PPRScheduledEvent alloc] initWithEventName:@"Breakfast"
                                    scheduledTime: [[PPRScheduleTime alloc] initWithTimeOfDay:sevenThirty]],
     [[PPRScheduledEvent alloc] initWithEventName:@"Lunch"
                                    scheduledTime: [[PPRScheduleTime alloc] initWithTimeOfDay:twelveOclock]],
     [[PPRScheduledEvent alloc] initWithEventName:@"Dinner"
                                    scheduledTime: [[PPRScheduleTime alloc] initWithTimeOfDay:sixThirty]],
     [[PPRScheduledEvent alloc] initWithEventName:@"Bed"
                                    scheduledTime: [[PPRScheduleTime alloc] initWithTimeOfDay:ninePm]],
     nil];
    facility2.events = events2;
    return facility2;
}

static PPRClient *createTestClient1(PPRFacility *facility1)
{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *nowComponents;
    NSDate *birthDate;
    
    nowComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:now];
    nowComponents.year -= 67;
    nowComponents.month -= 1;
    nowComponents.day += 4;
    
    birthDate = [calendar dateFromComponents:nowComponents];
    PPRClient *client1 = [[PPRClient alloc] initWithName:@"Dave Smith" birthDate:birthDate];
    
    
    NSMutableArray *notes1 = [NSMutableArray arrayWithObjects:
                              @"Dave has parkinson and cannot take pills using his hands",
                              @"Dave has schizophenia", nil
                              ];
    
    NSMutableArray *instructions1 =
    [NSMutableArray arrayWithObjects:
     [[PPRClientInstruction alloc]initWithContext:@"Pills"
                                      instruction:@"Taken on desert spoon"],
     [[PPRClientInstruction alloc]initWithContext:@"Communication"
                                      instruction:@"Nonverbal but has signing"],
     [[PPRClientInstruction alloc]initWithContext:@"Medication"
                                      instruction:@"Usually compliant taking medication"],
     nil
     ];
    client1.notes = notes1;
    client1.instructions = instructions1;
    client1.facility = facility1;
    
    // Pills 30 minutes before lunch
    NSDateComponents *offset1 = [[NSDateComponents alloc] init];
    offset1.day = 0;
    offset1.minute  = -30;
    offset1.hour = 0;
    PPRScheduleTime *scheduleTime1 =
    [[PPRScheduleTime alloc] initWithDailyEvent:@"Lunch" offset:offset1];
    PPRClientScheduleItem *item1 =
    [[PPRClientScheduleItem alloc] initWithContext:@"Pills" eventName:@"Pills" scheduledTime:scheduleTime1];
    [client1.scheduleItems addObject:item1];
    
    
    // Pills at breakfast
    NSDateComponents *offset2 = [[NSDateComponents alloc] init];
    offset2.day = 0;
    offset2.hour = 0;
    offset2.minute = 0;
    PPRScheduleTime *scheduleTime2 =
    [[PPRScheduleTime alloc] initWithDailyEvent:@"Breakfast" offset:offset2];
    PPRClientScheduleItem *item2 =
    [[PPRClientScheduleItem alloc] initWithContext:@"Pills" eventName:@"Pills" scheduledTime:scheduleTime2];
    [client1.scheduleItems addObject:item2];
    return client1;
}


static PPRClient *createTestClient2(PPRFacility *facility1)
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *nowComponents;
    NSDate *birthDate;
    
    nowComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:now];
    nowComponents.year -= 42;
    nowComponents.month += 4;
    nowComponents.day -= 5;
    
    birthDate = [calendar dateFromComponents:nowComponents];
    PPRClient *client2 = [[PPRClient alloc] initWithName:@"Julie Jones" birthDate:birthDate];
    
    NSMutableArray *notes2 = [NSMutableArray arrayWithObjects:
                              @"Julie has down's syndrom",
                              @"Julie has schizophenia",
                              @"In good health ",
                              @"If resistant to medication check if she belives the medication poisoned",
                              @"Try (I, mother) have check medication",
                              nil
                              ];
    
    NSMutableArray *instructions2 =
    [NSMutableArray arrayWithObjects:
     [[PPRClientInstruction alloc]initWithContext:@"Food" instruction:@"Delusional - people poising her food"],
     [[PPRClientInstruction alloc]initWithContext:@"Pills" instruction:@"On hand"],
     [[PPRClientInstruction alloc]initWithContext:@"Communications" instruction:@"Verbal and can make her wants and needs known"],
     [[PPRClientInstruction alloc]initWithContext:@"Medication" instruction:@"Can be non-compliant"],
     [[PPRClientInstruction alloc]initWithContext:@"Medication" instruction:@"If resistant check if she believes medication poisoned - see notes"],
     nil
     ];
    
    
    client2.notes = notes2;
    client2.instructions = instructions2;
    client2.facility = facility1;
    
    // Pills 10 minutes before dinner
    NSDateComponents *offset1 = [[NSDateComponents alloc] init];
    offset1.minute  = -10;
    offset1.day = 0;
    offset1.hour = 0;
    PPRScheduleTime *scheduleTime1 =
    [[PPRScheduleTime alloc] initWithDailyEvent:@"Dinner" offset:offset1];
    PPRClientScheduleItem *item1 =
    [[PPRClientScheduleItem alloc] initWithContext:@"Pills" eventName:@"Pills" scheduledTime:scheduleTime1];
    [client2.scheduleItems addObject:item1];
    
    
    // Pills at breakfast
    NSDateComponents *offset2 = [[NSDateComponents alloc] init];
    offset2.day = 0;
    offset2.hour = 0;
    offset2.minute = 0;
    PPRScheduleTime *scheduleTime2 =
    [[PPRScheduleTime alloc] initWithDailyEvent:@"Breakfast" offset:offset2];
    PPRClientScheduleItem *item2 =
    [[PPRClientScheduleItem alloc] initWithContext:@"Pills" eventName:@"Pills" scheduledTime:scheduleTime2];
    [client2.scheduleItems addObject:item2];
    
    return client2;
}

static PPRClient *createTestClient3(PPRFacility *facility2)
{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *nowComponents;
    NSDate *birthDate;
    
    nowComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:now];
    nowComponents.year -= 42;
    nowComponents.month += 4;
    nowComponents.day -= 5;
    
    
    birthDate = [calendar dateFromComponents:nowComponents];
    PPRClient *client3 = [[PPRClient alloc] initWithName:@"Stevie Thompson" birthDate:birthDate];
    
    NSMutableArray *notes3 = [NSMutableArray arrayWithObjects:
                              @"Stevie has cerebal palsy and mild intellectual disability",
                              @"Epilepsy mild and well controlled",
                              @"Seizures 1 per year",
                              @"In good health ",
                              nil
                              ];
    
    NSMutableArray *instructions3 =
    [NSMutableArray arrayWithObjects:
     [[PPRClientInstruction alloc]initWithContext:@"Food" instruction:@"PEG fed"],
     [[PPRClientInstruction alloc]initWithContext:@"Medication" instruction:@"Visiting Nurse"],
     [[PPRClientInstruction alloc]initWithContext:@"Communications" instruction:@"Nonverbal uses ipad with good receptive language"],
     [[PPRClientInstruction alloc]initWithContext:@"Bed" instruction:@"Can go to bed with feed connected but uncoomfortable"],
     [[PPRClientInstruction alloc]initWithContext:@"medication" instruction:@"If resistant check if she believes medication poisoned - see notes"],
     nil
     ];
    
    client3.notes = notes3;
    client3.instructions = instructions3;
    client3.facility = facility2;
    
    // Medication - visiting nurse at 8am
    NSDateComponents *offset1 = [[NSDateComponents alloc] init];
    offset1.hour  = 8;
    offset1.day = 0;
    offset1.minute = 0;
    PPRScheduleTime *scheduleTime1 =
    [[PPRScheduleTime alloc] initWithTimeOfDay:offset1];
    PPRClientScheduleItem *item1 =
    [[PPRClientScheduleItem alloc] initWithContext:@"Medication" eventName:@"Visiting Nurse" scheduledTime:scheduleTime1];
    [client3.scheduleItems addObject:item1];
    
    // Medication - visiting nurse 4pm
    NSDateComponents *offset2 = [[NSDateComponents alloc] init];
    offset2.hour  = 16;
    offset2.day = 0;
    offset2.minute = 0;
    PPRScheduleTime *scheduleTime2 =
    [[PPRScheduleTime alloc] initWithTimeOfDay:offset2];
    PPRClientScheduleItem *item2 =
    [[PPRClientScheduleItem alloc] initWithContext:@"Medication" eventName:@"Visiting Nurse" scheduledTime:scheduleTime2];
    [client3.scheduleItems addObject:item2];
    
    return client3;
    
}

@implementation PPRTestIntialiser
- (PPRTestIntialiser *) init {
    
    self = [super init];
    if (self) {
        
        _facilityManager = [[PPRFacilityManager sharedInstance] init];
        _clientManager = [[PPRClientManager sharedInstance] init];
        _actionManager = [[PPRActionManager sharedInstance] init];
        
        _shiftManager = [[PPRShiftManager sharedInstance] init];
        
        _clientActionScheduler =[[PPRClientActionScheduler sharedInstance]init];
        _scheduler = [[PPRScheduler sharedInstance] init];
        _facilityActionScheduler =[[PPRFacilityActionScheduler sharedInstance]initWithScheduler:_scheduler actionManager:_actionManager clientActionScheduler:_clientActionScheduler];
        _actionScheduler = [[PPRActionScheduler sharedInstance]init];
        [self loadTestData];
        [self loadSchedule];
    }
    return self;
}

- (void)loadTestData {

        [self.shiftManager loadShift];
        
        self.facility1 = createTestFacility1();
        
        [self.facilityManager insertFacility:self.facility1 success:
         ^{
         } failure:^(NSError *error) {
             NSLog(@"Error saving facility 1");
         }];
        
        self.facility2 = createTestFacility2();
        
        [self.facilityManager insertFacility:self.facility2 success:
         ^{
         } failure:^(NSError *error) {
             NSLog(@"Error saving facility 2");
         }];
        
        self.client1 = createTestClient1(self.facility1);
        [self.clientManager insertClient:self.client1 success:^(PPRClient *client){
            {}
        } failure:^(NSError *error) {
            NSLog(@"Error saving client 1");
        }];
        
        self.client2 = createTestClient2(self.facility1);
        [self.clientManager insertClient:self.client2 success:^(PPRClient *client){
            {}
        } failure:^(NSError *error) {
            NSLog(@"Error saving client 2");
        }];
        
        self.client3 = createTestClient3(self.facility2);
        [self.clientManager insertClient:self.client3 success:^(PPRClient *client){
            {}
        } failure:^(NSError *error) {
            NSLog(@"Error saving client 3");
        }];
        
        
}
- (void) loadSchedule
{
    self.actionManager.actions = [[NSMutableDictionary alloc] init];
    self.notificationManager.notifications = [[NSMutableArray alloc] init];
    
    [self.facilityActionScheduler scheduleEventsForFacility:self.facility1];
    [self.facilityActionScheduler scheduleEventsForFacility:self.facility2];
    [self.clientActionScheduler scheduleEventsForClient:self.client1 forParentAction:nil];
    [self.clientActionScheduler scheduleEventsForClient:self.client2 forParentAction:nil];
    [self.clientActionScheduler scheduleEventsForClient:self.client3 forParentAction:nil];

}
@end
