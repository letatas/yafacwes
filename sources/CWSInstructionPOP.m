//
//  CWSInstructionPOP.m
//  yafacwesConsole
//
//  Created by Matthias Lamoureux on 11/08/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import "CWSInstructionPOP.h"

@implementation CWSInstructionPOP

- (void) popPointedRelativePosition:(CWSPosition) position forExecutionVector:(CWSExecutionVector *) ev andCoreState:(CWSCoreState *) aCoreState {
    CWSPosition pointedPosistion = CWSPositionAdd(ev.position, position);

    CWSParametrizedInstruction * poppedInstruction = [ev popOnStack];

    [aCoreState setInstructionCode:poppedInstruction.code atPosition:pointedPosistion];
    [aCoreState setInstructionParameter:poppedInstruction.parameter atPosition:pointedPosistion];
}

- (BOOL) executeForCoreState:(CWSCoreState *) aCoreState {
    CWSExecutionVector * ev = aCoreState.nextExecutionVector;
    
    id parameter = [aCoreState instructionParameterAtPosition:ev.position];
    
    BOOL result = NO;
    if (([parameter respondsToSelector:@selector(positionValue)]) && (ev.stackSize > 0)) {
        [self popPointedRelativePosition:[parameter positionValue] forExecutionVector:ev andCoreState:aCoreState];
        
        result = YES;
    } else if (([parameter respondsToSelector:@selector(positionAtIndex:)]) && (ev.stackSize >= [parameter count])) {
        for (NSUInteger i=0; i<[parameter count]; ++i) {        
            [self popPointedRelativePosition:[parameter positionAtIndex:i] forExecutionVector:ev andCoreState:aCoreState];
        }
        
        result = YES;
    }
    
    if (result) {
        [ev move];
    }
    return result;
}

@end
