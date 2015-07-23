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
