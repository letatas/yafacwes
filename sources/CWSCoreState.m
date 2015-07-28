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

@interface CWSCoreState ()

@property (nonatomic, assign) CWSInstructionCode * instructionCodes;
@property (nonatomic, assign) CWSInstructionColorTag * instructionColorTags;
@property (nonatomic, strong) NSMutableArray * executionVectors;

- (void) loadExecutionVectorsAndNextFromLines:(NSArray *) lines upToIndex:(NSUInteger) last;
- (void) loadCoreStateInfoFromLines:(NSArray *) lines atIndex:(NSUInteger) start upToIndex:(NSUInteger) last;
- (void) loadCoreStateColorInfoFromLines:(NSArray *) lines atIndex:(NSUInteger) start upToIndex:(NSUInteger) last;

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
    }
    
    return self;
}

+ (instancetype) coreStateWithWidth:(NSInteger) aWidth andHeight:(NSInteger) aHeight {
    return [[self alloc] initWithWidth:aWidth andHeight:aHeight];
}

- (void) loadExecutionVectorsAndNextFromLines:(NSArray *) lines upToIndex:(NSUInteger) last {
    for (NSUInteger i=0; i<last; ++i) {
        NSString * line = (NSString *) [lines objectAtIndex:i];
        if ([line hasPrefix:@"NEXT:"]) {
            NSScanner * scanner = [NSScanner scannerWithString: [line substringFromIndex:5]];
            NSInteger value = CWSNoExecutionVector;
            if ([scanner scanInteger:&value]) {
                self.nextExecutionVectorIndex = value;
            }
        // load ev
        } else {
            [self.executionVectors addObject:[CWSExecutionVector executionVectorFromString:line]];
        }
    }
}

- (void) loadCoreStateInfoFromLines:(NSArray *) lines atIndex:(NSUInteger) start upToIndex:(NSUInteger) last {
    for (NSUInteger i=start, y=0; i<last; ++i, ++y) {
        NSScanner * scanner = [NSScanner scannerWithString: [lines objectAtIndex:i]];
        for (NSInteger x=0; x<self.width; ++x) {
            NSInteger value = 0;
            if ([scanner scanInteger:&value] == YES) {
                [self setInstructionCode: value atPositionX:x andY:y];
            }
        }
    }
}

- (void) loadCoreStateColorInfoFromLines:(NSArray *) lines atIndex:(NSUInteger) start upToIndex:(NSUInteger) last {
    for (NSUInteger i=start, y=0; i<last; ++i, ++y) {
        NSScanner * scanner = [NSScanner scannerWithString: [lines objectAtIndex:i]];
        for (NSInteger x=0; x<self.width; ++x) {
            NSInteger value = 0;
            if ([scanner scanInteger:&value] == YES) {
                [self setInstructionColorTag: value atPositionX:x andY:y];
            }
        }
    }
}

- (instancetype) initWithString:(NSString *) aString {
    NSScanner * scanner = [NSScanner scannerWithString: aString];
    
    // line by line scan
    NSUInteger coreStateIndex[2] = { NSUIntegerMax, NSUIntegerMax };
    NSUInteger currentIndex = 0;
    NSMutableArray * lines = [NSMutableArray array];
    NSString * currentLine = NULL;
    while ([scanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:&currentLine] == YES) {
        if (currentLine != nil) {
            if ([currentLine isEqual:@"-"] == NO) {
                [lines addObject:currentLine];
            } else {
                coreStateIndex[currentIndex++] = lines.count;
            }
        }
    }
    
    // compute core dimensions
    NSInteger aHeight = coreStateIndex[1] - coreStateIndex[0];
    NSInteger aWidth = 0;
    if (aHeight > 0) {
        scanner = [NSScanner scannerWithString: [lines objectAtIndex: coreStateIndex[0]]];
        
        while ([scanner scanInteger: NULL] == YES) {
            aWidth++;
        }
        
        if (aWidth > 0) {
            self = [self initWithWidth: aWidth andHeight: aHeight];
            
            [self loadExecutionVectorsAndNextFromLines:lines upToIndex:coreStateIndex[0]];
            [self loadCoreStateInfoFromLines:lines atIndex:coreStateIndex[0] upToIndex:coreStateIndex[1]];
            [self loadCoreStateColorInfoFromLines:lines atIndex:coreStateIndex[1] upToIndex:lines.count];          
            
            return self;
        }
    }
    return nil;
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
    
    for (int y = 0; y < self.height; y++) {
        for (int x = 0; x < self.width; x++) {
            if (x > 0) {
                [result appendString:@" "];
            }
            [result appendFormat:@"%ld",[self instructionCodeAtPositionX:x andY:y]];
        }
        [result appendString:@"\n"];
    }

    [result appendString:@"-\n"];

    for (int y = 0; y < self.height; y++) {
        if (y > 0) {
            [result appendString:@"\n"];
        }
        for (int x = 0; x < self.width; x++) {
            if (x > 0) {
                [result appendString:@" "];
            }
            [result appendFormat:@"%ld",[self instructionColorTagAtPositionX:x andY:y]];
        }
    }
    
    return result;
}

#pragma mark - Instructions Codes

- (CWSInstructionCode) instructionCodeAtPositionX:(NSInteger) aX andY:(NSInteger) aY {
    return self.instructionCodes[aX + aY*self.width];
}

- (void) setInstructionCode:(CWSInstructionCode) aInstructionCode atPositionX:(NSInteger) aX andY:(NSInteger) aY {
    self.instructionCodes[aX + aY*self.width] = aInstructionCode;
}

#pragma mark - Instruction Color Tags

- (CWSInstructionColorTag) instructionColorTagAtPositionX:(NSInteger) aX andY:(NSInteger) aY {
    return self.instructionColorTags[aX + aY*self.width];
}

- (void) setInstructionColorTag:(CWSInstructionColorTag) aInstructionColorTag atPositionX:(NSInteger) aX andY:(NSInteger) aY {
    self.instructionColorTags[aX + aY*self.width] = aInstructionColorTag;
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
    aExecutionVector.x = [self loop:aExecutionVector.x onSize:self.width];
    aExecutionVector.y = [self loop:aExecutionVector.y onSize:self.height];
}

- (void) oneStep {
    CWSExecutionVector * ev = self.nextExecutionVector;
    if (ev != nil) {
        CWSInstructionCode code = [self instructionCodeAtPositionX:ev.x andY:ev.y];
        [self setInstructionColorTag:ev.colorTag atPositionX:ev.x andY:ev.y];
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
