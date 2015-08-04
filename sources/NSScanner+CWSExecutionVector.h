//
//  NSScanner+CWSExecutionVector.h
//  yafacwesConsole
//
//  Created by Damien Brossard on 22/07/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWSExecutionVector.h"

@interface NSScanner(CWSExecutionVector)

- (BOOL) scanExecutionVector: (CWSExecutionVector **) executionVector;
- (BOOL) scanExecutionVectorInArray: (NSMutableArray *) array;
- (BOOL) scanParametrizedInstruction:(CWSParametrizedInstruction **) parametrizedInstruction;
- (BOOL) scanStackItem:(CWSParametrizedInstruction **) parametrizedInstruction;

@end