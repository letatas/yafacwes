//
//  CWSInstructionADD.m
//  yafacwesConsole
//
//  Created by Damien Brossard on 18/08/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import "CWSInstructionADD.h"

@implementation CWSInstructionADD

- (id) computeResultWithA:(id) paramA andB:(id) paramB {
    if ([paramA respondsToSelector:@selector(positionValue)] && [paramB respondsToSelector:@selector(positionValue)]) {
        CWSPosition posA = [paramA positionValue];
        CWSPosition posB = [paramB positionValue];
        
        return [NSValue valueWithPosition:CWSPositionAdd(posA, posB)];
    }
    return nil;
}

- (BOOL) executeForCoreState:(CWSCoreState *) aCoreState {
    CWSExecutionVector * ev = aCoreState.nextExecutionVector;
      
    BOOL result = NO;
    if ([ev stackSize] > 1) {
        CWSParametrizedInstruction * operandA = [ev popOnStack];
        CWSParametrizedInstruction * operandB = [ev popOnStack];
        
        id param = [self computeResultWithA:operandA.parameter andB:operandB.parameter];
        
        operandA.parameter = param;
        [ev pushOnStack:operandA];    
        result = YES;
    }
    
    if (result) {
        [ev move];
    }
    return result;
}

@end
