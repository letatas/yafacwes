//
//  CWSInstructionPOP.m
//  yafacwesConsole
//
//  Created by Matthias Lamoureux on 11/08/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import "CWSInstructionPOP.h"

@implementation CWSInstructionPOP

- (BOOL) executeForCoreState:(CWSCoreState *) aCoreState {
    CWSExecutionVector * ev = aCoreState.nextExecutionVector;
    
    id parameter = [aCoreState instructionParameterAtPosition:ev.position];
    
    if (([parameter respondsToSelector:@selector(positionValue)]) && (ev.stackSize > 0)) {
        CWSPosition delta = [parameter positionValue];
        CWSPosition pointedPosistion = CWSPositionAdd(ev.position, delta);
        
        CWSParametrizedInstruction * poppedInstruction = [ev popOnStack];
        
        [aCoreState setInstructionCode:poppedInstruction.code atPosition:pointedPosistion];
        [aCoreState setInstructionParameter:poppedInstruction.parameter atPosition:pointedPosistion];
        
        [ev move];
        
        return YES;
    }
    else {
        return NO;
    }
}

@end
