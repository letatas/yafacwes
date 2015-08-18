//
//  CWSInstructionADD.m
//  yafacwesConsole
//
//  Created by Damien Brossard on 18/08/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import "CWSInstructionADD.h"

@implementation CWSInstructionADD

- (NSArray *) instructionParamToArray:(id) param {
    if (param != nil) {
        NSMutableArray * result = [NSMutableArray array];
        
        // eurk ... there must be a cleaner way to do this
        if ([param isKindOfClass:[NSValue class]]) {
            if ([param isKindOfClass:[NSNumber class]]) {
                [result addObject:param];
            } else {
                CWSPosition position = [param positionValue];
                [result addObject:[NSNumber numberWithInteger:position.x]];
                [result addObject:[NSNumber numberWithInteger:position.y]];    
            }
        } else if ([param respondsToSelector:@selector(enumerateObjectsUsingBlock:)]) {
            [param enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSArray * converted = [self instructionParamToArray:obj];
                if (converted != nil) {
                    [result addObjectsFromArray:converted];
                }
            }];
        }
        
        return result;
    }
    return nil;
}

- (id) convertArray:(NSArray *) array toExpectedFormat:(id) format startingAtIndex:(NSUInteger) baseIndex convertedCountValues:(NSUInteger *) read {
    if ([format isKindOfClass:[NSValue class]]) {
        if ([format isKindOfClass:[NSNumber class]]) {
            id result = format;
            *read = 0;
            if (array.count > baseIndex) {
                result = [array objectAtIndex:baseIndex];
                *read = 1;
            }
            return result;
        } else {
            CWSPosition position = [format positionValue];
            *read = 0;
            if (array.count > baseIndex) {
                position.x = [[array objectAtIndex:baseIndex] integerValue];
                *read = 1;
                if (array.count > baseIndex + 1) {
                    position.y = [[array objectAtIndex: baseIndex + 1] integerValue];
                    *read = 2;
                }
            }
            return [NSValue valueWithPosition:position];  
        }
    } else if ([format respondsToSelector:@selector(enumerateObjectsUsingBlock:)]) {
        NSMutableArray * result = [NSMutableArray array];
        __block NSUInteger currentIndex = baseIndex;
        [format enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSUInteger lread = 0;
            id converted = [self convertArray:array toExpectedFormat:obj startingAtIndex:currentIndex convertedCountValues:&lread];
            [result addObject:converted];
            currentIndex += lread;
        }];
        return result;
    }
    return nil;
}

- (id) computeResultWithA:(id) paramA andB:(id) paramB {   
    // converts all parameters to one dimensionnal arrays
    NSArray * normalizedA = [self instructionParamToArray: paramA];
    NSArray * normalizedB = [self instructionParamToArray: paramB];
    
    // compute
    if (normalizedA != nil && normalizedB != nil) {
        NSMutableArray * result = [NSMutableArray array];
        NSUInteger count = MIN(normalizedA.count, normalizedB.count);
        for (NSUInteger i=0; i<count; ++i) {
            // good spot to use a block when refactoring towards a more generic "Arithmetic" instruction
            [result addObject:[NSNumber numberWithInteger:[[normalizedA objectAtIndex:i] integerValue] +
                                                          [[normalizedB objectAtIndex:i] integerValue]]];
        }
        
        // convert result back to expected parameter type
        NSUInteger read = 0;
        return [self convertArray:result toExpectedFormat:paramA startingAtIndex:0 convertedCountValues: &read];
    }
    return nil;
}

- (BOOL) executeForCoreState:(CWSCoreState *) aCoreState {
    CWSExecutionVector * ev = aCoreState.nextExecutionVector;
      
    BOOL result = NO;
    if ([ev stackSize] > 1) {
        CWSParametrizedInstruction * operandA = [ev popOnStack];
        CWSParametrizedInstruction * operandB = [ev popOnStack];
        
        id param = [self computeResultWithA:operandA.parameter andB:operandB.parameter];
        
        operandA.parameter = param;
        [ev pushOnStack:operandA];    
        result = YES;
    }
    
    if (result) {
        [ev move];
    }
    return result;
}

@end
