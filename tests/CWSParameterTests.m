//
//  CWSParameterTests.m
//  yafacwesConsole
//
//  Created by Matthias Lamoureux on 14/08/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "NSScanner+Parameter.h"
#import "CWSPosition.h"

@interface CWSParameterTests : XCTestCase

@end

@implementation CWSParameterTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testScannerPosition {
    // Arrange
    CWSPosition pos = CWSPositionMake(12, 5);
    NSString * arrayParam = @"{(12,5)}";
    NSScanner * scanner = [NSScanner scannerWithString:arrayParam];
    id scannedParameter = nil;
    
    // Act
    BOOL result = [scanner scanParameter:&scannedParameter];
    
    // Assert
    XCTAssert(result);
    CWSPosition position = [scannedParameter positionValue];
    
    XCTAssertEqual(pos.x, position.x);
    XCTAssertEqual(pos.y, position.y);
}

- (void) testScannerArrayOfPositions {
    // Arrange
    CWSPosition pos[3] = { { 12, 5 }, { 4, 9 }, { 15, 2 } };
    NSString * arrayParam = @"{[(12,5),(4,9),(15,2)]}";
    NSScanner * scanner = [NSScanner scannerWithString:arrayParam];
    NSArray * scannedParameter = nil;
    
    // Act
    BOOL result = [scanner scanParameter:&scannedParameter];
    
    // Assert
    XCTAssert(result);
    XCTAssertEqual((NSUInteger) 3, scannedParameter.count);
    for (int i=0; i<3; ++i) {
        CWSPosition position = [scannedParameter positionAtIndex:i];
        
        XCTAssertEqual(pos[i].x, position.x);
        XCTAssertEqual(pos[i].y, position.y);
    }
}

- (void) testScannerArrayOfMixedParameters {
    // Arrange
    CWSPosition pos[2] = { { 12, 5 }, { 4, 9 } };
    CWSPosition pos2 = { 15, 2 };
    NSString * arrayParam = @"{[[(12,5),(4,9)],(15,2)]}";
    NSScanner * scanner = [NSScanner scannerWithString:arrayParam];
    NSArray * scannedParameter = nil;
    
    // Act
    BOOL result = [scanner scanParameter:&scannedParameter];
    
    // Assert
    XCTAssert(result);
    XCTAssertEqual((NSUInteger) 2, scannedParameter.count);

    NSArray * firstParam = scannedParameter[0];
    XCTAssertEqual((NSUInteger) 2, firstParam.count);
    for (int i=0; i<2; ++i) {
        CWSPosition position = [firstParam positionAtIndex:i];
        
        XCTAssertEqual(pos[i].x, position.x);
        XCTAssertEqual(pos[i].y, position.y);
    }
    
    NSValue * secondParam = scannedParameter[1];
    CWSPosition position = [secondParam positionValue];
    XCTAssertEqual(pos2.x, position.x);
    XCTAssertEqual(pos2.y, position.y);
}

@end
