//
//  NSScanner+CWSCoreState.h
//  yafacwesConsole
//
//  Created by Damien Brossard on 22/07/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWSPosition.h"

@interface NSScanner(CWSCoreState)

- (BOOL) scanNextExecutionVectorIndex:(NSInteger *) index;
- (BOOL) scanCoreStateWidth:(NSInteger *) aWidth andHeight:(NSInteger *) aHeight;
- (BOOL) scanIntegerMatrixWithBlock:(void (^)(CWSPosition position, NSInteger value)) block;

@end