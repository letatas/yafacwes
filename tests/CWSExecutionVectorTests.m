//
//  CWSExecutionVectorTests.m
//  yafacwesConsole
//
//  Created by Matthias Lamoureux on 13/07/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "CWSExecutionVector.h"

@interface CWSExecutionVectorTests : XCTestCase

@end

@implementation CWSExecutionVectorTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testMovingNorth {
    // Arrange
    CWSExecutionVector * ev = [CWSExecutionVector executionVectorWithX:10 andY:10 andDirection:CWSDirectionNorth];
    
    // Act
    [ev move];
    
    // Assert
    XCTAssertEqual(10, ev.x);
    XCTAssertEqual(9, ev.y);
}

- (void)testMovingSouth {
    // Arrange
    CWSExecutionVector * ev = [CWSExecutionVector executionVectorWithX:10 andY:10 andDirection:CWSDirectionSouth];
    
    // Act
    [ev move];
    
    // Assert
    XCTAssertEqual(10, ev.x);
    XCTAssertEqual(11, ev.y);
}

- (void)testMovingWest {
    // Arrange
    CWSExecutionVector * ev = [CWSExecutionVector executionVectorWithX:10 andY:10 andDirection:CWSDirectionWest];
    
    // Act
    [ev move];
    
    // Assert
    XCTAssertEqual(9, ev.x);
    XCTAssertEqual(10, ev.y);
}

- (void)testMovingEast {
    // Arrange
    CWSExecutionVector * ev = [CWSExecutionVector executionVectorWithX:10 andY:10 andDirection:CWSDirectionEast];
    
    // Act
    [ev move];
    
    // Assert
    XCTAssertEqual(11, ev.x);
    XCTAssertEqual(10, ev.y);
}

@end
