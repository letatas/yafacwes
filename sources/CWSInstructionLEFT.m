//
//  CWSInstructionLEFT.m
//  yafacwesConsole
//
//  Created by Matthias Lamoureux on 15/07/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import "CWSInstructionLEFT.h"

@implementation CWSInstructionLEFT

- (BOOL) executeForCoreState:(CWSCoreState *) aCoreState {
    CWSExecutionVector * ev = aCoreState.nextExecutionVector;
    
    ev.direction = leftDirection(ev.direction);
    [ev move];
    
    return YES;
}

@end
