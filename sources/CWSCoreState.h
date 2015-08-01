//
//  CWSCoreState.h
//  yafacwesConsole
//
//  Created by Matthias Lamoureux on 14/07/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWSExecutionVector.h"
#import "CWSInstructionCodes.h"
#import "CWSInstructionColorTag.h"
#import "CWSPosition.h"

enum {CWSNoExecutionVector = NSIntegerMax};

@interface CWSCoreState : NSObject

@property (nonatomic, strong, readonly) NSMutableArray * executionVectors;
@property (nonatomic, assign) NSInteger nextExecutionVectorIndex;

+ (instancetype) coreStateWithWidth:(NSInteger) aWidth andHeight:(NSInteger) aHeight;
+ (instancetype) coreStateWithString:(NSString *) aString;
+ (instancetype) coreStateWithContentsOfFile:(NSString *) aFileName;

- (CWSInstructionCode) instructionCodeAtPosition:(CWSPosition) aPosition;
- (void) setInstructionCode:(CWSInstructionCode) aInstructionCode atPosition:(CWSPosition) aPosition;
- (CWSInstructionColorTag) instructionColorTagAtPosition:(CWSPosition) aPosition;
- (void) setInstructionColorTag:(CWSInstructionColorTag) aInstructionColorTag atPosition:(CWSPosition) aPosition;
- (id) instructionParameterAtPosition:(CWSPosition) aPosition;
- (void) setInstructionParameter:(id) aInstructionParameter atPosition:(CWSPosition) aPosition;

- (CWSExecutionVector *) nextExecutionVector;

- (void) oneStep;

@end
