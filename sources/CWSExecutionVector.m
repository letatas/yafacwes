//
//  CWSExecutionVector.m
//  yafacwesConsole
//
//  Created by Matthias Lamoureux on 13/07/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import "CWSExecutionVector.h"
#import "NSMutableArray+Stack.h"

@interface CWSExecutionVector()

@property (nonatomic, assign) CWSPosition prevPosition;
@property (nonatomic, strong) NSMutableArray * stack;

@end

@implementation CWSExecutionVector

- (instancetype) initWithPosition:(CWSPosition) aPosition andDirection:(CWSDirection) aDirection andInstructionColorTag:(CWSInstructionColorTag) aColorTag {
    self = [super init];
    
    if (self) {
        self.position = aPosition;
        self.prevPosition = aPosition;
        self.direction = aDirection;
        self.colorTag = aColorTag;
        self.stack = [NSMutableArray array];
    }
    
    return self;

}

+ (instancetype) executionVectorWithPosition:(CWSPosition)aPosition andDirection:(CWSDirection)aDirection andInstructionColorTag:(CWSInstructionColorTag)aColorTag {
    return [[self alloc] initWithPosition:aPosition andDirection:aDirection andInstructionColorTag:aColorTag];
}

+ (instancetype) executionVectorFromString:(NSString *) line {
    if ([line hasPrefix:@"EV:"]) {
        NSScanner * scanner = [NSScanner scannerWithString: [line substringFromIndex:3]];
        scanner.charactersToBeSkipped = [NSCharacterSet characterSetWithCharactersInString:@", "];
        CWSPosition position = CWSPositionZero;
        NSString * dir = @"";
        CWSInstructionColorTag color = 0;
        if ([scanner scanInteger:&position.x]
         && [scanner scanInteger:&position.y]
         && [scanner scanUpToString:@"," intoString:&dir]
         && [scanner scanInteger:&color]) {
            return [CWSExecutionVector executionVectorWithPosition:position andDirection:directionFromString(dir) andInstructionColorTag:color];
        }
    }
    return nil;
}

- (void) move {
    self.prevPosition = self.position;
    
    CWSPosition newPosition = self.position;
    switch (self.direction) {
        case CWSDirectionNorth:
            newPosition.y--;
            break;
        case CWSDirectionSouth:
            newPosition.y++;
            break;
        case CWSDirectionWest:
            newPosition.x--;
            break;
        case CWSDirectionEast:
            newPosition.x++;
            break;
    }
    
    self.position = newPosition;
}

- (void) moveToPreviousPosition {
    self.position = self.prevPosition;
}

- (NSString *) description {
    return [NSString stringWithFormat:@"EV:%ld,%ld,%@,%ld",self.position.x,self.position.y,directionToString(self.direction),self.colorTag];
}

#pragma mark - Stack

- (void) pushOnStack:(CWSParametrizedInstruction *) aParametrizedInstruction {
    [self.stack push:aParametrizedInstruction];
}

- (CWSParametrizedInstruction *) popOnStack {
    return self.stack.pop;
}

- (CWSParametrizedInstruction *) peekOnStack {
    return self.stack.peek;
}

- (NSUInteger) stackSize {
    return self.stack.count;
}

- (BOOL) isStackEmpty {
    return self.stackSize == 0;
}

@end
