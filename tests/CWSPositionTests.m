//
//  CWSPositionTests.m
//  yafacwesConsole
//
//  Created by Matthias Lamoureux on 01/08/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "CWSPosition.h"

@interface CWSPositionTests : XCTestCase

@end

@implementation CWSPositionTests

- (void)testMake {
    // Arrange
    NSInteger x = 3;
    NSInteger y = 9;
    
    // Act
    CWSPosition pos = CWSPositionMake(x, y);
    
    // Assert
    XCTAssertEqual(x, pos.x);
    XCTAssertEqual(y, pos.y);
}

- (void)testString {
    // Arrange
    NSInteger x = 3;
    NSInteger y = 9;
    CWSPosition pos = CWSPositionMake(x, y);
    NSString * expected = @"(3,9)";
    
    // Act
    NSString * stringPosition = NSStringFromPosition(pos);
    
    // Assert
    XCTAssertEqualObjects(expected, stringPosition);
}

- (void)testValue {
    // Arrange
    NSInteger x = 3;
    NSInteger y = 9;
    CWSPosition pos = CWSPositionMake(x, y);
    
    // Act
    NSValue * value = [NSValue valueWithPosition:pos];
    
    // Assert
    XCTAssertEqual(pos.x, value.positionValue.x);
    XCTAssertEqual(pos.y, value.positionValue.y);
}

- (void) testScanner {
    // Arrange
    NSInteger x = 3; 
    NSInteger y = 9;
    NSString * stringToScan = @"(3,9)";
    NSScanner * scanner = [NSScanner scannerWithString:stringToScan];
    CWSPosition pos = CWSPositionZero;
    
    // Act
    BOOL result = [scanner scanPosition:&pos];
    
    // Assert
    XCTAssert(result);
    XCTAssertEqual(x, pos.x);
    XCTAssertEqual(y, pos.y);
}

@end
