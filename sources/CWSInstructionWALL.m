//
//  CWSInstructionWALL.m
//  yafacwesConsole
//
//  Created by Matthias Lamoureux on 28/07/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import "CWSInstructionWALL.h"

@implementation CWSInstructionWALL

- (BOOL) executeForCoreState:(CWSCoreState *) aCoreState {
    CWSExecutionVector * ev = aCoreState.nextExecutionVector;
    
    [ev moveToPreviousPosition];
    
    return YES;
}

@end
