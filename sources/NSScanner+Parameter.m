//
//  NSScanner+Parameter.m
//  yafacwesConsole
//
//  Created by Matthias Lamoureux on 04/08/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import "NSScanner+Parameter.h"
#import "CWSPosition.h"

@implementation NSScanner (Parameter)

- (BOOL) scanSimpleParameterArray:(NSArray **) parameterArray {
    if ([self isAtEnd]) {
        return NO;
    }
    
    NSMutableArray * tmpParameters = [NSMutableArray array];
    BOOL result = YES;
    NSInteger location = self.scanLocation;
    if (![self scanString:@"[" intoString:NULL]) {
        result = NO;
    }
    if (result) {
        id parameter = nil;
        BOOL hasParameter = YES;
        do {
            parameter = [self subscanSimpleParameter];
            if (parameter != nil) {
                [tmpParameters addObject:parameter];
                [self scanString:@"," intoString:NULL];
            }
            else {
                hasParameter = NO;
            }
        } while (hasParameter);
    }
    if (result && ![self scanString:@"]" intoString:NULL]) {
        result = NO;
    }
    if (result) {
        *parameterArray = [NSArray arrayWithArray:tmpParameters];
    } else {
        self.scanLocation = location;
    }
    
    return result;

}

- (id)subscanSimpleParameter {
    id scannedParam = nil;
    
    // Repeat for each known param type
    CWSPosition scannedPos = CWSPositionZero;
    if ((scannedParam == nil) && [self scanPosition:&scannedPos]) {
        scannedParam = [NSValue valueWithPosition:scannedPos];
    }
    
    if (scannedParam == nil) {
        [self scanSimpleParameterArray:&scannedParam];
    }
    
    return scannedParam;
}

- (BOOL) scanParameter:(id *) parameter {
    if (self.isAtEnd) {
        return NO;
    }
    
    BOOL result = YES;
    NSInteger location = self.scanLocation;
    
    if (![self scanString:@"{" intoString:NULL]) {
        result = NO;
    }
    
    id scannedParam = nil;
    
    if (result) {
        scannedParam = [self subscanSimpleParameter];
    }
    
    if (result && ![self scanString:@"}" intoString:NULL]) {
        result = NO;
    }
    
    if (result) {
        if (parameter != NULL) {
            *parameter = scannedParam;
        }
    }
    else {
        self.scanLocation = location;
    }
    
    return result;
}

@end
