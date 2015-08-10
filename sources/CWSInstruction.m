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
        case kCWSInstructionCodeNULL: return [CWSInstructionNULL class];
        case kCWSInstructionCodeLEFT: return [CWSInstructionLEFT class];
        case kCWSInstructionCodeRIGHT: return [CWSInstructionRIGHT class];
        case kCWSInstructionCodeNOP: return [CWSInstructionNOP class];
        case kCWSInstructionCodeWALL: return [CWSInstructionWALL class];
        case kCWSInstructionCodeSTOP: return [CWSInstructionSTOP class];
        case kCWSInstructionCodePUSH: return [CWSInstructionPUSH class];
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
