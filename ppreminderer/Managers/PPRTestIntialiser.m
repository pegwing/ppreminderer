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

@implementation PPRTestIntialiser
+ (PPRTestIntialiser *) sharedClient {
    static PPRTestIntialiser* _sharedClient;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [PPRTestIntialiser alloc];
        PPRFacilityManager *facilityManager = [PPRFacilityManager sharedClient];
        PPRClientManager *clientManager = [PPRClientManager sharedClient];

        // Facility 1
        PPRFacility *facility1 = [[PPRFacility alloc] initWithName:@"Group Home 1" address:@"1 Smith Street Somewhere"];
        [facilityManager insertFacility:facility1 success:
        ^{
        } failure:^(NSError *error) {
            NSLog(@"Error saving facility 1");
    
        }];
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
        // Facility 2
        PPRFacility *facility2 = [[PPRFacility alloc] initWithName:@"Group Home 2" address:@"2 Jones Street Somewhereelse"];
        [facilityManager insertFacility:facility2 success:
         ^{
         } failure:^(NSError *error) {
             NSLog(@"Error saving facility 2");
             
         }];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *now = [NSDate date];
        
        NSDateComponents *nowComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:now];
        nowComponents.year -= 67;
        nowComponents.month -= 1;
        nowComponents.day += 4;

        NSDate *birthDate = [calendar dateFromComponents:nowComponents];
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
        
        [clientManager insertClient:client1 success:^{
            {}
        } failure:^(NSError *error) {
            NSLog(@"Error saving client 1");
            
        }];
        
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
        
        [clientManager insertClient:client2 success:^{
            {}
        } failure:^(NSError *error) {
            NSLog(@"Error saving client 2");
            
        }];
    });
    return _sharedClient;
}

@end
