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

- (void) testFromNSScannerInArray {
    // Arrange
    NSString * evdef = @"EV:5,12,S,42\nEV:3,10,N,5";
    
    NSInteger evx1 = 5;
    NSInteger evy1 = 12;
    CWSDirection evdir1 = CWSDirectionSouth;
    CWSInstructionColorTag evcolor1 = 42;
    NSInteger evx2 = 3;
    NSInteger evy2 = 10;
    CWSDirection evdir2 = CWSDirectionNorth;
    CWSInstructionColorTag evcolor2 = 5;
    
    // Act
    NSScanner * scanner = [NSScanner scannerWithString: evdef];
    NSMutableArray * array = [NSMutableArray array];
    BOOL bScan = [scanner scanExecutionVectorInArray: array] && [scanner scanExecutionVectorInArray: array];
    
    // Assert
    XCTAssert(bScan);
    XCTAssert(array.count == 2);
    
    CWSExecutionVector * ev = [array objectAtIndex:0];
    XCTAssertEqual(evx1, ev.x);
    XCTAssertEqual(evy1, ev.y);
    XCTAssertEqual(evdir1, ev.direction);
    XCTAssertEqual(evcolor1, ev.colorTag);
    
    ev = [array objectAtIndex:1];
    XCTAssertEqual(evx2, ev.x);
    XCTAssertEqual(evy2, ev.y);
    XCTAssertEqual(evdir2, ev.direction);
    XCTAssertEqual(evcolor2, ev.colorTag);
}

@end
