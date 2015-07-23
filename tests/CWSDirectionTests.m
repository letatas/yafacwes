//
//  CWSDirectionTests.m
//  yafacwesConsole
//
//  Created by Matthias Lamoureux on 13/07/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "CWSDirection.h"

@interface CWSDirectionTests : XCTestCase

@end

@implementation CWSDirectionTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLeftDirection {
    // Arrange
    CWSDirection direction = CWSDirectionNorth;
    
    // Act
    CWSDirection direction1 = leftDirection(direction);
    CWSDirection direction2 = leftDirection(direction1);
    CWSDirection direction3 = leftDirection(direction2);
    CWSDirection direction4 = leftDirection(direction3);
    
    // Assert
    XCTAssertEqual(direction1, CWSDirectionWest);
    XCTAssertEqual(direction2, CWSDirectionSouth);
    XCTAssertEqual(direction3, CWSDirectionEast);
    XCTAssertEqual(direction4, CWSDirectionNorth);
}

- (void)testRightDirection {
    // Arrange
    CWSDirection direction = CWSDirectionNorth;
    
    // Act
    CWSDirection direction1 = rightDirection(direction);
    CWSDirection direction2 = rightDirection(direction1);
    CWSDirection direction3 = rightDirection(direction2);
    CWSDirection direction4 = rightDirection(direction3);
    
    // Assert
    XCTAssertEqual(direction1, CWSDirectionEast);
    XCTAssertEqual(direction2, CWSDirectionSouth);
    XCTAssertEqual(direction3, CWSDirectionWest);
    XCTAssertEqual(direction4, CWSDirectionNorth);
}

- (void)testDirectionFromString {  
    // Assert
    XCTAssertEqual(CWSDirectionNorth, directionFromString(@"N"));
    XCTAssertEqual(CWSDirectionEast, directionFromString(@"E"));
    XCTAssertEqual(CWSDirectionSouth, directionFromString(@"S"));
    XCTAssertEqual(CWSDirectionWest, directionFromString(@"W"));
    XCTAssertThrows(directionFromString(nil));
    XCTAssertThrows(directionFromString(@"toto"));
}

@end
