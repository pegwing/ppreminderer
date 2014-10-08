//
//  PPRTestIIntialiser.m
//  ppreminderer
//
//  Created by David Bernard on 9/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRTestIntialiser.h"
#import "PPRFacilityManager.h"
#import "PPRClientManager.h"
#import "PPRActionManager.h"
#import "PPRClientInstruction.h"
#import "PPRScheduledEvent.h"
#import "PPRClientAction.h"
#import "PPRScheduler.h"


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
    return facility1;
}

static PPRFacility *createTestFacility2()
{
    // Facility 2
    PPRFacility *facility2 = [[PPRFacility alloc] initWithName:@"Group Home 2" address:@"2 Jones Street Somewhereelse"];
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
    offset1.minute  = -30;
    PPRScheduleTime *scheduleTime1 =
    [[PPRScheduleTime alloc] initWithDailyEvent:@"Lunch" offset:offset1];
    PPRClientScheduleItem *item1 =
    [[PPRClientScheduleItem alloc] initWithContext:@"Pills" eventName:@"Pills" scheduledTime:scheduleTime1];
    [client1.scheduleItems addObject:item1];
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
     [[PPRClientInstruction alloc]initWithContext:@"food" instruction:@"Delusional - people poising her food"],
     [[PPRClientInstruction alloc]initWithContext:@"taking pills" instruction:@"On hand"],
     [[PPRClientInstruction alloc]initWithContext:@"communication" instruction:@"Verbal and can make her wants and needs known"],
     [[PPRClientInstruction alloc]initWithContext:@"medication" instruction:@"Can be non-compliant"],
     [[PPRClientInstruction alloc]initWithContext:@"medication" instruction:@"If resistant check if she believes medication poisoned - see notes"],
     nil
     ];
    
    
    client2.notes = notes2;
    client2.instructions = instructions2;
    client2.facility = facility1;
    
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
    PPRClient *client3 = [[PPRClient alloc] initWithName:@"Julie Jones" birthDate:birthDate];
    
    NSMutableArray *notes3 = [NSMutableArray arrayWithObjects:
                              @"Julie has down's syndrom",
                              @"Julie has schizophenia",
                              @"In good health ",
                              @"If resistant to medication check if she belives the medication poisoned",
                              @"Try (I, mother) have check medication",
                              nil
                              ];
    
    NSMutableArray *instructions3 =
    [NSMutableArray arrayWithObjects:
     [[PPRClientInstruction alloc]initWithContext:@"food" instruction:@"Delusional - people poising her food"],
     [[PPRClientInstruction alloc]initWithContext:@"taking pills" instruction:@"On hand"],
     [[PPRClientInstruction alloc]initWithContext:@"communication" instruction:@"Verbal and can make her wants and needs known"],
     [[PPRClientInstruction alloc]initWithContext:@"medication" instruction:@"Can be non-compliant"],
     [[PPRClientInstruction alloc]initWithContext:@"medication" instruction:@"If resistant check if she believes medication poisoned - see notes"],
     nil
     ];
    
    client3.notes = notes3;
    client3.instructions = instructions3;
    client3.facility = facility2;
    return client3;
    
}

static PPRClientAction *createTestAction1(PPRScheduler *scheduler, PPRClient *client) {
    PPRClientScheduleItem *item = client.scheduleItems[0];
    PPRClientAction *action = [[PPRClientAction alloc] init];
    action.scheduledEvent = item;
    action.dueTime = [scheduler dueTimeForScheduleTime:item.scheduled parentDueTime:nil previousDueTime:nil];
    action.client = client;
    action.context = item.context;

    [client.scheduleItems addObject:item];
    
    return action;
    
}

@implementation PPRTestIntialiser
- (PPRTestIntialiser *) init {

    self = [super init];
    if (self) {
        PPRFacilityManager *facilityManager = [(PPRFacilityManager *)[PPRFacilityManager sharedInstance] init];
        PPRClientManager *clientManager = [(PPRClientManager *)[PPRClientManager sharedInstance] init];
        
        PPRFacility *facility1 = createTestFacility1();
        
        [facilityManager insertFacility:facility1 success:
         ^{
         } failure:^(NSError *error) {
             NSLog(@"Error saving facility 1");
         }];
        
        PPRFacility *facility2 = createTestFacility2();
        
        [facilityManager insertFacility:facility2 success:
         ^{
         } failure:^(NSError *error) {
             NSLog(@"Error saving facility 2");
         }];
        
        PPRClient *client1 = createTestClient1(facility1);
        [clientManager insertClient:client1 success:^(PPRClient *client){
            {}
        } failure:^(NSError *error) {
            NSLog(@"Error saving client 1");
        }];
        
        PPRClient *client2 = createTestClient2(facility1);
        [clientManager insertClient:client2 success:^(PPRClient *client){
            {}
        } failure:^(NSError *error) {
            NSLog(@"Error saving client 2");
        }];
        
        PPRClient *client3 = createTestClient3(facility1);
        [clientManager insertClient:client3 success:^(PPRClient *client){
            {}
        } failure:^(NSError *error) {
            NSLog(@"Error saving client 3");
        }];
    }
    
    return self;
}
@end
