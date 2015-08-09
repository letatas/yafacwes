//
//  NSArray+StackDescription.m
//  yafacwesConsole
//
//  Created by Matthias Lamoureux on 04/08/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import "NSArray+StackDescription.h"

@implementation NSArray (StackDescription)

- (NSString *) stackDescription {
    NSMutableString * result = [NSMutableString string];
    
    [self enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [result appendFormat:@"|%@",obj];
    }];
    
    return result;
}

@end
