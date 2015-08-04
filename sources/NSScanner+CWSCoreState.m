//
//  NSScanner+CWSCoreState.m
//  yafacwesConsole
//
//  Created by Damien Brossard on 22/07/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSScanner+CWSCoreState.h"
#import "NSScanner+Parameter.h"

@implementation NSScanner(CWSCoreState)

- (BOOL) scanNextExecutionVectorIndex:(NSInteger *) index {
    if ([self isAtEnd]) {
        return NO;
    }
    
    NSUInteger prevScanPos = self.scanLocation;
    if ([self scanString:@"NEXT:" intoString:NULL] && [self scanInteger:index]) {
        return YES;
    }
    
    self.scanLocation = prevScanPos;
    return NO;
}

- (BOOL) scanCoreStateWidth:(NSInteger *) aWidth andHeight:(NSInteger *) aHeight {
    if ([self isAtEnd] || aWidth == NULL || aHeight == NULL) {
        return NO;
    }
    
    NSUInteger prevScanPos = self.scanLocation;
    
    if ([self scanString:@"-\n" intoString:NULL]) {
        NSInteger width = 0;
        NSInteger height = 0;
        
        NSUInteger matrixStart = self.scanLocation;
        if ([self scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:NULL]) {
            NSUInteger firstLineStop = self.scanLocation;
            self.scanLocation = matrixStart;
            BOOL keepGoing = YES;
            while ([self scanInteger:NULL] && keepGoing) {
                [self scanParameter:NULL];
                keepGoing = self.scanLocation <= firstLineStop;
                if (keepGoing) {
                    width++;
                }
            }
            
            self.scanLocation = matrixStart;
            NSString * currentLine = nil;
            while ([self scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:&currentLine]) {
                if ([currentLine isEqual:@"-"]) {
                    break;
                }
                height++;
            }
            
            *aWidth = width;
            *aHeight = height;
        }
        
        self.scanLocation = prevScanPos;
        return YES;
    }
    
    self.scanLocation = prevScanPos;
    return NO;
}

- (BOOL) scanIntegerMatrixWithBlock:(void (^)(CWSPosition position, NSInteger value, id parameter)) block {
    if ([self isAtEnd] || !block) {
        return NO;
    }
    
    NSUInteger prevScanPos = self.scanLocation;
    if ([self scanString:@"-\n" intoString: NULL]) {
        CWSPosition pos = CWSPositionZero;
        NSString * currentLine = nil;
        NSUInteger lineStart = self.scanLocation;
        
        while ([self scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:&currentLine]) {
            if ([currentLine isEqual:@"-"]) {
                self.scanLocation = lineStart;
                break;
            }
            NSUInteger lineStop = self.scanLocation;
            self.scanLocation = lineStart;
            
            pos.x = 0;
            NSInteger curval = 0;
            self.charactersToBeSkipped = [NSCharacterSet whitespaceCharacterSet];
            while ([self scanInteger:&curval]) {
                id parameter = nil;
                [self scanParameter:&parameter];
                block(pos, curval, parameter);
                pos.x++;
            }
            self.charactersToBeSkipped = nil;
            
            self.scanLocation = lineStop;
            [self scanCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:&currentLine];
            lineStart = self.scanLocation;
            pos.y++;
        }
        return YES;
    }
    
    self.scanLocation = prevScanPos;
    return NO;
}

@end