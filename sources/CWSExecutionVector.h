//
//  CWSExecutionVector.h
//  yafacwesConsole
//
//  Created by Matthias Lamoureux on 13/07/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWSDirection.h"

@interface CWSExecutionVector : NSObject

@property (nonatomic, assign) NSInteger x;
@property (nonatomic, assign) NSInteger y;
@property (nonatomic, assign) CWSDirection direction;

+ (instancetype) executionVectorWithX:(NSInteger) aX andY:(NSInteger) aY andDirection:(CWSDirection) aDirection;
+ (instancetype) executionVectorFromString:(NSString *) line;

- (void) move;

@end
