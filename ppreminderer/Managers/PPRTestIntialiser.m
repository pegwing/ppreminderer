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
#import "PPRClientInstruction.h"
#import "PPRScheduledEvent.h"

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
    NSMutableArray *events1 =
    [NSMutableArray arrayWithObjects:
     [[PPRScheduledEvent alloc] initWithEventName:@"Breakfast"
                                    scheduledTime: [[PPRScheduleTime alloc] initWithTimeOfDay:eightOclock]],
     [[PPRScheduledEvent alloc] initWithEventName:@"Lunch"
                                    scheduledTime: [[PPRScheduleTime alloc] initWithTimeOfDay:twelveThirty]],
     [[PPRScheduledEvent alloc] initWithEventName:@"Dinner"
                                    scheduledTime: [[PPRScheduleTime alloc] initWithTimeOfDay:sixThirty]],
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
     [[PPRClientInstruction alloc]initWithContext:@"taking pills" instruction:@"Taken on desert spoon"],
     [[PPRClientInstruction alloc]initWithContext:@"communication" instruction:@"Nonverbal but has signing"],
     [[PPRClientInstruction alloc]initWithContext:@"medication" instruction:@"Usually compliant taking medication"],
     nil
     ];
    client1.notes = notes1;
    client1.instructions = instructions1;
    client1.facility = facility1;
    
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
