//
//  CWSInstructions.h
//  yafacwesConsole
//
//  Created by Matthias Lamoureux on 15/07/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWSCoreState.h"

@interface CWSInstruction : NSObject

+ (instancetype) instructionForCode:(CWSInstructionCode) aCode;

- (BOOL) executeForCoreState:(CWSCoreState *) aCoreState;

@end
