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
    
    // Repeat for each known param type
    CWSPosition scannedPos = CWSPositionZero;
    if (result && (scannedParam == nil) && [self scanPosition:&scannedPos]) {
        scannedParam = [NSValue valueWithPosition:scannedPos];
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
