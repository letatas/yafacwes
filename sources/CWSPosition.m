//
//  CWSPosition.m
//  yafacwesConsole
//
//  Created by Matthias Lamoureux on 01/08/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import "CWSPosition.h"

#pragma mark - Helpers

inline CWSPosition CWSPositionMake(NSInteger x, NSInteger y) {
    CWSPosition position;
    position.x = x;
    position.y = y;
    return position;
}

inline NSString * NSStringFromPosition(CWSPosition aPosition) {
    return [NSString stringWithFormat:@"(%ld,%ld)",(long)aPosition.x,(long)aPosition.y];
}

const CWSPosition CWSPositionZero = {.x=0, .y=0};

CWSPosition CWSPositionAdd(CWSPosition a, CWSPosition b) {
    return CWSPositionMake(a.x + b.x, a.y + b.y);
}

#pragma mark - NSValue

@implementation NSValue (CWSPosition)

+ (NSValue *)valueWithPosition:(CWSPosition)position {
    return [NSValue value:&position withObjCType:@encode(CWSPosition)];
}

- (CWSPosition)positionValue {
    CWSPosition result = CWSPositionZero;
    [self getValue:&result];
    return result;
}

- (NSString *) parameterDescription {
    return NSStringFromPosition(self.positionValue);
}

@end

#pragma mark - NSArray

@implementation NSArray (CWSPosition)

- (CWSPosition) positionAtIndex:(NSUInteger) index {
    CWSPosition result = CWSPositionZero;
    NSValue * value = [self objectAtIndex:index];
    if ([value respondsToSelector:@selector(positionValue)]) {
        result = [value positionValue];
    }
    return result;
}

- (NSString *) parameterDescription {
    NSMutableString * description = [NSMutableString stringWithCapacity:[self count]*7];
    
    [description appendString:@"["];
    
    for (NSUInteger i=0; i<[self count]; ++i) {
        [description appendString:NSStringFromPosition([self positionAtIndex:i])];        
    }
    
    [description appendString:@"]"];
    
    return description;
}

@end

#pragma mark - NSScanner

@implementation NSScanner (CWSPosition)

- (BOOL)scanPosition:(CWSPosition *)position {
    if ([self isAtEnd]) {
        return NO;
    }
    
    BOOL result = YES;
    NSInteger location = self.scanLocation;
    
    if (![self scanString:@"(" intoString:NULL]) {
        result = NO;
    }
    
    CWSPosition scannedPos = CWSPositionZero;
    
    if (result && ![self scanInteger:&scannedPos.x]) {
        result = NO;
    }

    if (result && ![self scanString:@"," intoString:NULL]) {
        result = NO;
    }

    if (result && ![self scanInteger:&scannedPos.y]) {
        result = NO;
    }

    if (result && ![self scanString:@")" intoString:NULL]) {
        result = NO;
    }

    if (result) {
        *position = scannedPos;
    }
    else {
        self.scanLocation = location;
    }
    
    return result;
}

- (BOOL)scanPositions:(NSMutableArray *)positions {
    if ([self isAtEnd]) {
        return NO;
    }
    
    NSMutableArray * tmpPositions = [NSMutableArray array];
    BOOL result = YES;
    NSInteger location = self.scanLocation;
    if (![self scanString:@"[" intoString:NULL]) {
        result = NO;
    }
    if (result) {
        CWSPosition pos = CWSPositionZero;
        while ([self scanPosition:&pos]) {
            [tmpPositions addObject:[NSValue valueWithPosition:pos]];
        }
    }
    if (result && ![self scanString:@"]" intoString:NULL]) {
        result = NO;
    }
    if (result) {
        [positions setArray:tmpPositions];
    } else {
        self.scanLocation = location;
    }
    
    return result;
}

@end
