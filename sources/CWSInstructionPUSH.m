//
//  CWSInstructionPUSH.m
//  yafacwesConsole
//
//  Created by Matthias Lamoureux on 10/08/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import "CWSInstructionPUSH.h"

@implementation CWSInstructionPUSH

- (BOOL) executeForCoreState:(CWSCoreState *) aCoreState {
    CWSExecutionVector * ev = aCoreState.nextExecutionVector;
    
    id parameter = [aCoreState instructionParameterAtPosition:ev.position];
    
    if ([parameter respondsToSelector:@selector(positionValue)]) {
        CWSPosition delta = [parameter positionValue];
        CWSPosition pointedPosistion = CWSPositionAdd(ev.position, delta);
        
        CWSParametrizedInstruction * pushedInstruction = [CWSParametrizedInstruction parametrizedInstructionWithCode:[aCoreState instructionCodeAtPosition:pointedPosistion]
                                                                                                        andParameter:[aCoreState instructionParameterAtPosition:pointedPosistion]];
        
        [ev pushOnStack:pushedInstruction];
        
        [ev move];
        
        return YES;
    }
    else {
        return NO;
    }
}

@end
