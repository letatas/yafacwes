//
//  NSScanner+CWSCoreState.m
//  yafacwesConsole
//
//  Created by Damien Brossard on 22/07/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSScanner+CWSCoreState.m"

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
            while ([self scanInteger:NULL] && self.scanLocation <= firstLineStop) {
                width++;
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

- (BOOL) scanIntegerMatrixWithBlock:(void (^)(NSUInteger x, NSUInteger y, NSInteger value)) block {
    if ([self isAtEnd] || !block) {
        return NO;
    }
    
    NSUInteger prevScanPos = self.scanLocation;
    if ([self scanString:@"-\n" intoString: NULL]) {
        NSUInteger posy = 0;
        NSString * currentLine = nil;
        NSUInteger lineStart = self.scanLocation;
        
        while ([self scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:&currentLine]) {
            if ([currentLine isEqual:@"-"]) {
                self.scanLocation = lineStart;
                break;
            }
            NSUInteger lineStop = self.scanLocation;
            self.scanLocation = lineStart;
            
            NSUInteger posx = 0;
            NSInteger curval = 0;
            self.charactersToBeSkipped = [NSCharacterSet whitespaceCharacterSet];
            while ([self scanInteger:&curval]) {
                block(posx, posy, curval);
                posx++;
            }
            self.charactersToBeSkipped = nil;
            
            self.scanLocation = lineStop;
            [self scanCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:&currentLine];
            lineStart = self.scanLocation;
            posy++;
        }
        return YES;
    }
    
    self.scanLocation = prevScanPos;
    return NO;
}

@end