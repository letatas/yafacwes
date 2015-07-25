//
//  CWSExecutionVector.m
//  yafacwesConsole
//
//  Created by Matthias Lamoureux on 13/07/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import "CWSExecutionVector.h"

@implementation CWSExecutionVector

- (instancetype) initWithX:(NSInteger) aX andY:(NSInteger) aY andDirection:(CWSDirection) aDirection {
    self = [super init];
    
    if (self) {
        self.x = aX;
        self.y = aY;
        self.direction = aDirection;
    }
    
    return self;

}

+ (instancetype) executionVectorWithX:(NSInteger) aX andY:(NSInteger) aY andDirection:(CWSDirection) aDirection {
    return [[self alloc] initWithX:aX andY:aY andDirection:aDirection];
}

+ (instancetype) executionVectorFromString:(NSString *) line {
    if ([line hasPrefix:@"EV:"]) {
        NSScanner * scanner = [NSScanner scannerWithString: [line substringFromIndex:3]];
        scanner.charactersToBeSkipped = [NSCharacterSet characterSetWithCharactersInString:@", "];
        NSInteger x = 0;
        NSInteger y = 0;
        if ([scanner scanInteger:&x]
            && [scanner scanInteger:&y]) {
            return [CWSExecutionVector executionVectorWithX:x andY:y andDirection:directionFromString([[scanner string] substringFromIndex:[scanner scanLocation]+1])];
        }
    }
    return nil;
}

- (void) move {
    switch (self.direction) {
        case CWSDirectionNorth:
            self.y--;
            break;
        case CWSDirectionSouth:
            self.y++;
            break;
        case CWSDirectionWest:
            self.x--;
            break;
        case CWSDirectionEast:
            self.x++;
            break;
    }
}

- (NSString *) description {
    return [NSString stringWithFormat:@"EV:%ld,%ld,%@",self.x,self.y,directionToString(self.direction)];
}

@end
