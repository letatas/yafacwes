//
//  NSMutableArray+Stack.h
//  yafacwesConsole
//
//  Created by Matthias Lamoureux on 02/08/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Stack)

- (void) push:(id) aObject;
- (id) pop;
- (id) peek;

@end
