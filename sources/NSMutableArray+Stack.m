//
//  NSMutableArray+Stack.m
//  yafacwesConsole
//
//  Created by Matthias Lamoureux on 02/08/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import "NSMutableArray+Stack.h"

@implementation NSMutableArray (Stack)

- (void) push:(id) aObject {
    [self addObject:aObject];
}

- (id) pop {
    id last = self.lastObject;
    if (last != nil) {
        [self removeLastObject];
    }
    return last;
}

- (id) peek {
    return self.lastObject;
}

@end
