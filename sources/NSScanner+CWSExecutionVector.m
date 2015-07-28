//
//  NSScanner+CWSExecutionVector.m
//  yafacwesConsole
//
//  Created by Damien Brossard on 22/07/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import "NSScanner+CWSExecutionVector.h"

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

@end