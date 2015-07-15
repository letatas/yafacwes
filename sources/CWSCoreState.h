//
//  CWSCoreState.h
//  yafacwesConsole
//
//  Created by Matthias Lamoureux on 14/07/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWSExecutionVector.h"

typedef NSInteger CWSInstructionCode;

enum {CWSNoExecutionVector = NSIntegerMax};

@interface CWSCoreState : NSObject

@property (nonatomic, strong, readonly) NSMutableArray * executionVectors;
@property (nonatomic, assign) NSInteger nextExecutionVectorIndex;

+ (instancetype) coreStateWithWidth:(NSInteger) aWidth andHeight:(NSInteger) aHeight;

- (CWSInstructionCode) instructionCodeAtPositionX:(NSInteger) aX andY:(NSInteger) aY;
- (void) setInstructionCode:(CWSInstructionCode) aInstructionCode atPositionX:(NSInteger) aX andY:(NSInteger) aY;

- (CWSExecutionVector *) nextExecutionVector;

@end
