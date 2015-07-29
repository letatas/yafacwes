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

- (BOOL) scanCoreStateWidth:(NSUInteger *) aWidth andHeight:(NSUInteger *) aHeight {
    if ([self isAtEnd] || aWidth == NULL || aHeight == NULL) {
        return NO;
    }
    
    NSUInteger prevScanPos = self.scanLocation;
    
    if ([self scanString:@"-\n" intoString:NULL]) {
        NSUInteger width = 0;
        NSUInteger height = 0;
        
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
        
        self.scanLocation = matrixStart;
        return YES;
    }
    
    self.scanLocation = prevScanPos;
    return NO;
}

- (BOOL) scanMatrix {
    return NO;
}

@end