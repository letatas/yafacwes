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

enum {CWSNoExecutionVector = NSIntegerMax};

@interface CWSCoreState : NSObject

@property (nonatomic, strong, readonly) NSMutableArray * executionVectors;
@property (nonatomic, assign) NSInteger nextExecutionVectorIndex;

+ (instancetype) coreStateWithWidth:(NSInteger) aWidth andHeight:(NSInteger) aHeight;
+ (instancetype) coreStateWithString:(NSString *) aString;
+ (instancetype) coreStateWithContentsOfFile:(NSString *) aFileName;

- (CWSInstructionCode) instructionCodeAtPositionX:(NSInteger) aX andY:(NSInteger) aY;
- (void) setInstructionCode:(CWSInstructionCode) aInstructionCode atPositionX:(NSInteger) aX andY:(NSInteger) aY;
- (CWSInstructionColorTag) instructionColorTagAtPositionX:(NSInteger) aX andY:(NSInteger) aY;
- (void) setInstructionColorTag:(CWSInstructionColorTag) aInstructionColorTag atPositionX:(NSInteger) aX andY:(NSInteger) aY;
- (id) instructionParameterAtPositionX:(NSInteger) aX andY:(NSInteger) aY;
- (void) setInstructionParameter:(id) aInstructionParameter atPositionX:(NSInteger) aX andY:(NSInteger) aY;

- (CWSExecutionVector *) nextExecutionVector;

- (void) oneStep;

@end
