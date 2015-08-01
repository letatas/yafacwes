//
//  CWSExecutionVector.h
//  yafacwesConsole
//
//  Created by Matthias Lamoureux on 13/07/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWSDirection.h"
#import "CWSInstructionColorTag.h"
#import "CWSPosition.h"

@interface CWSExecutionVector : NSObject

@property (nonatomic, assign) CWSPosition position;
@property (nonatomic, assign) CWSDirection direction;
@property (nonatomic, assign) CWSInstructionColorTag colorTag;

+ (instancetype) executionVectorWithPosition:(CWSPosition) aPosition andDirection:(CWSDirection) aDirection andInstructionColorTag:(CWSInstructionColorTag) aColorTag;
+ (instancetype) executionVectorFromString:(NSString *) line;

- (void) move;
- (void) moveToPreviousPosition;

@end
