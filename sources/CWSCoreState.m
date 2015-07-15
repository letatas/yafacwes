//
//  CWSCoreState.m
//  yafacwesConsole
//
//  Created by Matthias Lamoureux on 14/07/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import "CWSCoreState.h"
#import "CWSInstructions.h"

@interface CWSCoreState ()

@property (nonatomic, assign) CWSInstructionCode * instructionCodes;
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, strong) NSMutableArray * executionVectors;

@end

@implementation CWSCoreState

- (instancetype) initWithWidth:(NSInteger) aWidth andHeight:(NSInteger) aHeight {
    self = [super init];
    
    if (self) {
        self.width = aWidth;
        self.height = aHeight;
        
        [self createInitialInstructionCodes];
        
        self.executionVectors = [NSMutableArray array];
        self.nextExecutionVectorIndex = CWSNoExecutionVector;
    }
    
    return self;
}

+ (instancetype) coreStateWithWidth:(NSInteger) aWidth andHeight:(NSInteger) aHeight {
    return [[self alloc] initWithWidth:aWidth andHeight:aHeight];
}

- (void)createInitialInstructionCodes {
    self.instructionCodes = calloc(self.width*self.height, sizeof(CWSInstructionCode));
}

- (void)dealloc {
    free(self.instructionCodes);
    self.instructionCodes = NULL;
}

- (CWSExecutionVector *) nextExecutionVector {
    if (self.nextExecutionVectorIndex == CWSNoExecutionVector) {
        return nil;
    }
    else {
        return (CWSExecutionVector *)self.executionVectors[self.nextExecutionVectorIndex];
    }
}

#pragma mark - Instructions Codes

- (CWSInstructionCode) instructionCodeAtPositionX:(NSInteger) aX andY:(NSInteger) aY {
    return self.instructionCodes[aX + aY*self.width];
}

- (void) setInstructionCode:(CWSInstructionCode) aInstructionCode atPositionX:(NSInteger) aX andY:(NSInteger) aY {
    self.instructionCodes[aX + aY*self.width] = aInstructionCode;
}

#pragma mark - Execution

- (void) oneStep {
    CWSExecutionVector * ev = self.nextExecutionVector;
    if (ev != nil) {
        CWSInstructionCode code = [self instructionCodeAtPositionX:ev.x andY:ev.y];
        CWSInstruction * instruction = [CWSInstruction instructionForCode:code];
        BOOL success = [instruction executeForCoreState:self];
        
        if (success) {
            self.nextExecutionVectorIndex++;
        }
        else {
            [self.executionVectors removeObject:ev];
        }
        
        if (self.executionVectors.count == 0) {
            self.nextExecutionVectorIndex = CWSNoExecutionVector;
        }
        else {
            self.nextExecutionVectorIndex = self.nextExecutionVectorIndex % self.executionVectors.count;
        }
    }
}

@end
