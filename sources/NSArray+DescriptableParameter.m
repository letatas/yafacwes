//
//  NSArray+DescriptableParameter.m
//  yafacwesConsole
//
//  Created by Matthias Lamoureux on 14/08/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import "NSArray+DescriptableParameter.h"

@implementation NSArray (DescriptableParameter)

- (NSString *) parameterDescription {
    NSMutableString * description = [NSMutableString string];
    
    [description appendString:@"["];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx > 0) {
            [description appendString:@","];
        }
        
        if ([obj conformsToProtocol:@protocol(CWSDescriptableParameter) ]) {
            [description appendString:[obj parameterDescription]];
        }
        else {
            [description appendString:[obj description]];
        }
        
    }];
    
    [description appendString:@"]"];
    
    return description;
}


@end
