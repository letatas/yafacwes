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
#import "NSScanner+CWSExecutionVector.h"

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
    CWSExecutionVector * ev = [CWSExecutionVector executionVectorWithX:10 andY:10 andDirection:CWSDirectionNorth andInstructionColorTag:42];
    
    // Act
    [ev move];
    
    // Assert
    XCTAssertEqual((NSInteger)10, ev.x);
    XCTAssertEqual((NSInteger)9, ev.y);
}

- (void)testMovingSouth {
    // Arrange
    CWSExecutionVector * ev = [CWSExecutionVector executionVectorWithX:10 andY:10 andDirection:CWSDirectionSouth andInstructionColorTag:42];
    
    // Act
    [ev move];
    
    // Assert
    XCTAssertEqual((NSInteger)10, ev.x);
    XCTAssertEqual((NSInteger)11, ev.y);
}

- (void)testMovingWest {
    // Arrange
    CWSExecutionVector * ev = [CWSExecutionVector executionVectorWithX:10 andY:10 andDirection:CWSDirectionWest andInstructionColorTag:42];
    
    // Act
    [ev move];
    
    // Assert
    XCTAssertEqual((NSInteger)9, ev.x);
    XCTAssertEqual((NSInteger)10, ev.y);
}

- (void)testMovingEast {
    // Arrange
    CWSExecutionVector * ev = [CWSExecutionVector executionVectorWithX:10 andY:10 andDirection:CWSDirectionEast andInstructionColorTag:42];
    
    // Act
    [ev move];
    
    // Assert
    XCTAssertEqual((NSInteger)11, ev.x);
    XCTAssertEqual((NSInteger)10, ev.y);
}

- (void) testToString {
    // Arrange
    CWSExecutionVector * ev = [CWSExecutionVector executionVectorWithX:3 andY:1 andDirection:CWSDirectionNorth andInstructionColorTag:42];
    
    // Act
    NSString * string = ev.description;
    NSString * expected = @"EV:3,1,N,42";
    
    // Assert
    XCTAssertEqualObjects(expected, string);
}

- (void) testFromString {
    // Arrange
    NSString * evdef = @"EV:5,12,S,42";
    NSInteger evx = 5;
    NSInteger evy = 12;
    CWSDirection evdir = CWSDirectionSouth;
    CWSInstructionColorTag evcolor = 42;
    
    // Act
    CWSExecutionVector * ev = [CWSExecutionVector executionVectorFromString:evdef];
    
    // Assert
    XCTAssertEqual(evx, ev.x);
    XCTAssertEqual(evy, ev.y);
    XCTAssertEqual(evdir, ev.direction);
    XCTAssertEqual(evcolor, ev.colorTag);
}

- (void) testFromNSScanner {
    // Arrange
    NSString * evdef = @"EV:5,12,S,42\n";
    
    NSInteger evx = 5;
    NSInteger evy = 12;
    CWSDirection evdir = CWSDirectionSouth;
    CWSInstructionColorTag evcolor = 42;
    
    // Act
    NSScanner * scanner = [NSScanner scannerWithString: evdef];
    CWSExecutionVector * ev = nil;
    BOOL bScan = [scanner scanExecutionVector: &ev];
    
    // Assert
    XCTAssert(bScan);
    XCTAssert(ev != nil);
    XCTAssertEqual(evx, ev.x);
    XCTAssertEqual(evy, ev.y);
    XCTAssertEqual(evdir, ev.direction);
    XCTAssertEqual(evcolor, ev.colorTag);
}

@end
