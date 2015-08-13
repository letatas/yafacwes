//
//  CWSInstructionPUSH.m
//  yafacwesConsole
//
//  Created by Matthias Lamoureux on 10/08/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import "CWSInstructionPUSH.h"

@implementation CWSInstructionPUSH

- (void) pushPointedRelativePosition:(CWSPosition) position forExecutionVector:(CWSExecutionVector *) ev andCoreState:(CWSCoreState *) aCoreState {
    CWSPosition pointedPosition = CWSPositionAdd(ev.position, position);
    CWSParametrizedInstruction * pushedInstruction = [CWSParametrizedInstruction parametrizedInstructionWithCode:[aCoreState instructionCodeAtPosition:pointedPosition]
                                                                                                    andParameter:[aCoreState instructionParameterAtPosition:pointedPosition]];
    [ev pushOnStack:pushedInstruction];
}

- (BOOL) executeForCoreState:(CWSCoreState *) aCoreState {
    CWSExecutionVector * ev = aCoreState.nextExecutionVector;
    
    id parameter = [aCoreState instructionParameterAtPosition:ev.position];
    
    BOOL result = NO;
    if ([parameter respondsToSelector:@selector(positionValue)]) {
        [self pushPointedRelativePosition:[parameter positionValue] forExecutionVector:ev andCoreState:aCoreState];
               
        result = YES;
    } else if ([parameter respondsToSelector:@selector(positionAtIndex:)]) {
        for (NSUInteger i=0; i<[parameter count]; ++i) {
            [self pushPointedRelativePosition:[parameter positionAtIndex:i] forExecutionVector:ev andCoreState:aCoreState];
        }
        result = YES;
    }
    
    if (result) {
        [ev move];
    }
    return result;
}

@end
