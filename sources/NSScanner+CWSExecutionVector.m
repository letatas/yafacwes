//
//  NSScanner+CWSExecutionVector.m
//  yafacwesConsole
//
//  Created by Damien Brossard on 22/07/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import "NSScanner+CWSExecutionVector.h"
#import "NSScanner+Parameter.h"

@implementation NSScanner(CWSExecutionVector)

- (BOOL) scanExecutionVector: (CWSExecutionVector **) executionVector {
    *executionVector = nil;
    if ([self isAtEnd]) {
        return NO;
    }
    
    NSUInteger prevScanPos = self.scanLocation;
    NSString * currentLine = NULL;
    if (![self scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:&currentLine]) {
        return NO;
    }
    
    *executionVector = [CWSExecutionVector executionVectorFromString:currentLine];
    if (*executionVector == nil) {
        self.scanLocation = prevScanPos;
    }
    return (*executionVector != nil);
}

- (BOOL) scanExecutionVectorInArray: (NSMutableArray *) array {
    CWSExecutionVector * ev = nil;
    if ([self scanExecutionVector: &ev]) {
        [array addObject: ev];
        return YES;
    }
    return NO;
}

- (BOOL) scanParametrizedInstruction:(CWSParametrizedInstruction **) parametrizedInstruction {
    *parametrizedInstruction = nil;
    if ([self isAtEnd]) {
        return NO;
    }
    
    NSUInteger prevScanPos = self.scanLocation;
    CWSInstructionCode code = kCWSInstructionCodeNULL;
    id parameter = nil;
    if ([self scanInteger:&code]) {
        [self scanParameter:&parameter];
        *parametrizedInstruction = [CWSParametrizedInstruction parametrizedInstructionWithCode:code andParameter:parameter];
        return YES;
    }
    else {
        self.scanLocation = prevScanPos;
        return NO;
    }
}

- (BOOL) scanStackItem:(CWSParametrizedInstruction **) parametrizedInstruction {
    *parametrizedInstruction = nil;
    if ([self isAtEnd]) {
        return NO;
    }
    
    NSCharacterSet * oldSkipped = self.charactersToBeSkipped;
    self.charactersToBeSkipped = nil;

    NSUInteger prevScanPos = self.scanLocation;
    if ([self scanString:@"|" intoString:NULL] &&
        [self scanParametrizedInstruction:parametrizedInstruction]) {
        self.charactersToBeSkipped = oldSkipped;
        return YES;
    }
    else {
        self.scanLocation = prevScanPos;
        self.charactersToBeSkipped = oldSkipped;
        return NO;
    }
}

@end