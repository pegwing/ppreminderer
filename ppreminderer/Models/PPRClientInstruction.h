//
//  PPRClientInstruction.h
//  ppreminderer
//
//  Created by David Bernard on 8/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPRClientInstruction : NSObject
/**
 Date instruction is effect from
 */
@property (nonatomic,strong) NSDate *effective;
/**
 Date instruction is expires and no longer applies
 */
@property (nonatomic,strong) NSDate *expires;
/**
 Instruction text
 */
@property (nonatomic,strong) NSString *instruction;
/**
 Context of instructionident identifying the context in which the instruction applies.
 */
@property (nonatomic,strong) NSString *context;

-(id)initWithContext:(NSString *)context instruction:(NSString *)instruction;
@end
