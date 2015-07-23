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

- (instancetype) initWithString:(NSString *) aString {    
    NSScanner * scanner = [NSScanner scannerWithString: aString];
      
    // line by line scan
    NSUInteger coreStateIndex = NSUIntegerMax;
    NSMutableArray * lines = [NSMutableArray array];
    NSString * currentLine = NULL;
    while ([scanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:&currentLine] == YES) {
      if (currentLine != nil) {
	if ([currentLine isEqual:@"-"] == NO) {
	  [lines addObject:currentLine];
	} else {
	  coreStateIndex = lines.count;
	}
      }      
    }

    // compute core dimensions
    NSInteger aHeight = lines.count - coreStateIndex;
    NSInteger aWidth = 0;
    if (aHeight > 0) {      
      scanner = [NSScanner scannerWithString: [lines objectAtIndex: coreStateIndex]];
      
      while ([scanner scanInteger: NULL] == YES) {
	  aWidth++;
      }
      
      if (aWidth > 0) {
	  self = [self initWithWidth: aWidth andHeight: aHeight];
	  
	  NSInteger pos = 0;
	  NSInteger y = 0;
	  for (id obj in lines) {
	    // read ev / next info
	    if (pos < coreStateIndex) {
	      // load execution vector
	      if ([obj hasPrefix:@"EV:"]) {
		scanner = [NSScanner scannerWithString: [obj substringFromIndex:3]];
		scanner.charactersToBeSkipped = [NSCharacterSet characterSetWithCharactersInString:@", "];
		NSInteger x = 0;
		NSInteger y = 0;
		if ([scanner scanInteger:&x]
		 && [scanner scanInteger:&y]) {
		  CWSExecutionVector * ev = [CWSExecutionVector executionVectorWithX:x andY:y andDirection:directionFromString([[scanner string] substringFromIndex:[scanner scanLocation]+1])];
		  [self.executionVectors addObject:ev];
		}
		
	      // load next EV
	      } else if ([obj hasPrefix:@"NEXT:"]) {
		scanner = [NSScanner scannerWithString: [obj substringFromIndex:5]];
		NSInteger value = CWSNoExecutionVector;
		if ([scanner scanInteger:&value]) {
		  self.nextExecutionVectorIndex = value;
		}
	      }
	      // else throw ?
	    // read core state
	    } else {
	      scanner = [NSScanner scannerWithString: obj];
	      for (NSInteger x=0; x<aWidth; ++x) {
		NSInteger value = 0;
		if ([scanner scanInteger:&value] == YES) {
		  [self setInstructionCode: value atPositionX:x andY:y];
		}
	      }	    
	      y++;
	    }
	    
	    pos++;
	  }
	  
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

- (NSString *)description {
    NSMutableString * result = [NSMutableString string];
    
    [self.executionVectors enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [result appendFormat:@"%@\n",obj];
    }];

    [result appendFormat:@"NEXT:%ld\n-\n",self.nextExecutionVectorIndex];
    
    for (int y = 0; y < self.height; y++) {
        if (y > 0) {
            [result appendString:@"\n"];
        }
        for (int x = 0; x < self.width; x++) {
            if (x > 0) {
                [result appendString:@" "];
            }
            [result appendFormat:@"%ld",[self instructionCodeAtPositionX:x andY:y]];
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
