//
//  CWSCoreState.m
//  yafacwesConsole
//
//  Created by Matthias Lamoureux on 14/07/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import "CWSCoreState.h"
#import "CWSCoreState_Private.h"
#import "CWSInstructions.h"
#import "NSScanner+CWSExecutionVector.h"
#import "NSScanner+CWSCoreState.h"
#import "CWSDescriptableParameter.h"

@interface CWSCoreState ()

@property (nonatomic, assign) CWSInstructionCode * instructionCodes;
@property (nonatomic, assign) CWSInstructionColorTag * instructionColorTags;
@property (nonatomic, strong) NSMutableArray * executionVectors;
@property (nonatomic, strong) NSMutableDictionary * instructionParameters;

@end

@implementation CWSCoreState

- (instancetype) initWithWidth:(NSInteger) aWidth andHeight:(NSInteger) aHeight {
    self = [super init];
    
    if (self) {
        self.width = aWidth;
        self.height = aHeight;
        
        [self createInitialInstructionCodes];
        [self createInitialInstructionColorTags];
        
        self.executionVectors = [NSMutableArray array];
        self.nextExecutionVectorIndex = CWSNoExecutionVector;
        
        self.instructionParameters = [NSMutableDictionary dictionary];
    }
    
    return self;
}

+ (instancetype) coreStateWithWidth:(NSInteger) aWidth andHeight:(NSInteger) aHeight {
    return [[self alloc] initWithWidth:aWidth andHeight:aHeight];
}

- (instancetype) initWithString:(NSString *) aString {
    NSScanner * scanner = [NSScanner scannerWithString: aString];
    NSMutableArray * evs = [NSMutableArray array];
    
    NSInteger nextEvIndex = 0;
    while ([scanner scanExecutionVectorInArray: evs]) {}
    if (![scanner scanNextExecutionVectorIndex: &nextEvIndex]) {
        return nil;
    }    
    
    NSInteger width = 0;
    NSInteger height = 0;
    if (![scanner scanCoreStateWidth:&width andHeight:&height]) {
        return nil;
    }
    
    self = [self initWithWidth:width andHeight:height];
    if (self == nil) {
        return nil;
    }
    
    if (![scanner scanIntegerMatrixWithBlock:^(CWSPosition position, NSInteger value, id parameter) {
        [self setInstructionCode: value atPosition:position];
        [self setInstructionParameter:parameter atPosition:position];
    }]) {
        return nil;
    }
    [scanner scanIntegerMatrixWithBlock:^(CWSPosition position, NSInteger value, id parameter) {
        [self setInstructionColorTag: value atPosition:position];
    }];
    
    self.nextExecutionVectorIndex = nextEvIndex;
    [self.executionVectors addObjectsFromArray: evs];
    return self;
}

+ (instancetype) coreStateWithString:(NSString *) aString {
    return [[self alloc] initWithString:aString];
}

+ (instancetype) coreStateWithContentsOfFile:(NSString *) aFileName {
    NSStringEncoding encoding = NSASCIIStringEncoding;
    NSString * stateString = [NSString stringWithContentsOfFile:aFileName usedEncoding:&encoding error:NULL];
    
    return [self coreStateWithString:stateString];
}

- (void)createInitialInstructionCodes {
    self.instructionCodes = calloc(self.width*self.height, sizeof(CWSInstructionCode));
}

- (void)createInitialInstructionColorTags {
    self.instructionColorTags = calloc(self.width*self.height, sizeof(CWSInstructionColorTag));
}

- (void)dealloc {
    free(self.instructionCodes);
    free(self.instructionColorTags);
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

- (NSString *)description {
    NSMutableString * result = [NSMutableString string];
    
    [self.executionVectors enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [result appendFormat:@"%@\n",obj];
    }];
    
    [result appendFormat:@"NEXT:%ld\n-\n",self.nextExecutionVectorIndex];
    
    CWSPosition position = CWSPositionZero;
    for (position.y = 0; position.y < self.height; position.y++) {
        for (position.x = 0; position.x < self.width; position.x++) {
            if (position.x > 0) {
                [result appendString:@" "];
            }
            [result appendFormat:@"%ld",[self instructionCodeAtPosition:position]];
            id parameter = [self instructionParameterAtPosition:position];
            if (parameter != nil) {
                if ([parameter conformsToProtocol:@protocol(CWSDescriptableParameter)]) {
                    [result appendFormat:@"{%@}",[parameter parameterDescription]];
                }
                else {
                    [result appendFormat:@"{%@}",[parameter description]];
                }
            }
        }
        [result appendString:@"\n"];
    }

    [result appendString:@"-\n"];

    for (position.y = 0; position.y < self.height; position.y++) {
        if (position.y > 0) {
            [result appendString:@"\n"];
        }
        for (position.x = 0; position.x < self.width; position.x++) {
            if (position.x > 0) {
                [result appendString:@" "];
            }
            [result appendFormat:@"%ld",[self instructionColorTagAtPosition:position]];
        }
    }
    
    return result;
}

#pragma mark - Instructions Codes

- (CWSInstructionCode) instructionCodeAtPosition:(CWSPosition) aPosition {
    return self.instructionCodes[aPosition.x + aPosition.y*self.width];
}

- (void) setInstructionCode:(CWSInstructionCode) aInstructionCode atPosition:(CWSPosition) aPosition {
    self.instructionCodes[aPosition.x + aPosition.y*self.width] = aInstructionCode;
}

#pragma mark - Instruction Color Tags

- (CWSInstructionColorTag) instructionColorTagAtPosition:(CWSPosition) aPosition {
    return self.instructionColorTags[aPosition.x + aPosition.y*self.width];
}

- (void) setInstructionColorTag:(CWSInstructionColorTag) aInstructionColorTag atPosition:(CWSPosition) aPosition {
    self.instructionColorTags[aPosition.x + aPosition.y*self.width] = aInstructionColorTag;
}

#pragma mark - Instruction Parameters

- (NSString *) parameterKeyForPosition:(CWSPosition) aPosition {
    return [NSString stringWithFormat:@"%ld;%ld",(long)aPosition.x,(long)aPosition.y];
}

- (id) instructionParameterAtPosition:(CWSPosition) aPosition {
    return self.instructionParameters[[self parameterKeyForPosition:aPosition]];
}

- (void) setInstructionParameter:(id) aInstructionParameter atPosition:(CWSPosition) aPosition {
    NSString * key = [self parameterKeyForPosition:aPosition];
    if (aInstructionParameter == nil) {
        [self.instructionParameters removeObjectForKey:key];
    }
    else {
        self.instructionParameters[key] = aInstructionParameter;
    }
}

#pragma mark - Execution

- (NSInteger) loop:(NSInteger) aValue onSize:(NSInteger) aSize {
    if (aValue < 0) {
        NSInteger number = 1 + (aValue / (-aSize));
        return (number * aSize + aValue) % aSize;
    }
    else {
        return aValue % aSize;
    }
}

- (void) normalizeExecutionVector:(CWSExecutionVector *) aExecutionVector {
    CWSPosition position = aExecutionVector.position;
    position.x = [self loop:position.x onSize:self.width];
    position.y = [self loop:position.y onSize:self.height];
    aExecutionVector.position = position;
}

- (void) oneStep {
    CWSExecutionVector * ev = self.nextExecutionVector;
    if (ev != nil) {
        CWSInstructionCode code = [self instructionCodeAtPosition:ev.position];
        [self setInstructionColorTag:ev.colorTag atPosition:ev.position];
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
        
        [self normalizeExecutionVector:ev];
    }
}

@end
