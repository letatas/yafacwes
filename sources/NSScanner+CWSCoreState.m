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

@end