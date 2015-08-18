//
//  CWSInstructionADD.m
//  yafacwesConsole
//
//  Created by Damien Brossard on 18/08/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import "CWSInstructionADD.h"

@implementation CWSInstructionADD

- (BOOL) executeForCoreState:(CWSCoreState *) aCoreState {
    CWSExecutionVector * ev = aCoreState.nextExecutionVector;
      
    BOOL result = NO;
    
    if (result) {
        [ev move];
    }
    return result;
}

@end
