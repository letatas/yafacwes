//
//  NSScanner+CWSCoreState.h
//  yafacwesConsole
//
//  Created by Damien Brossard on 22/07/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSScanner(CWSCoreState)

- (BOOL) scanNextExecutionVectorIndex:(NSInteger *) index;
- (BOOL) scanCoreStateWidth:(NSUInteger *) aWidth andHeight:(NSUInteger *) aHeight;
- (BOOL) scanIntegerMatrixWithBlock:(void (^)(NSUInteger x, NSUInteger y, NSInteger value)) block;

@end