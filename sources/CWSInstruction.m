//
//  CWSInstructions.m
//  yafacwesConsole
//
//  Created by Matthias Lamoureux on 15/07/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import "CWSInstruction.h"
#import "CWSInstructions.h"

@implementation CWSInstruction

+ (Class) instructionClassForCode:(CWSInstructionCode) aCode {
    switch (aCode) {
        case 0: return [CWSInstructionNULL class];
        case 1: return [CWSInstructionLEFT class];
        case 2: return [CWSInstructionRIGHT class];
        case 3: return [CWSInstructionNOP class];
        default: return Nil;
    }
}

+ (instancetype) instructionForCode:(CWSInstructionCode) aCode {
    Class instructionClass = [self instructionClassForCode:aCode];
    
    if (instructionClass == Nil) {
        return nil;
    }
    else {
        return [[instructionClass alloc] init];
    }
}

- (BOOL) executeForCoreState:(CWSCoreState *) aCoreState {
    return NO;
}


@end
