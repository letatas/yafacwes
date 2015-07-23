//
//  CWSInstructionRIGHT.m
//  yafacwesConsole
//
//  Created by Matthias Lamoureux on 15/07/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import "CWSInstructionRIGHT.h"

@implementation CWSInstructionRIGHT

- (BOOL) executeForCoreState:(CWSCoreState *) aCoreState {
    CWSExecutionVector * ev = aCoreState.nextExecutionVector;
    
    ev.direction = rightDirection(ev.direction);
    [ev move];
    
    return YES;
}

@end
