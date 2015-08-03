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
#import "CWSInstructionCodes.h"

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
    CWSExecutionVector * ev = [CWSExecutionVector executionVectorWithPosition:CWSPositionMake(10,10) andDirection:CWSDirectionNorth andInstructionColorTag:42];
    
    // Act
    [ev move];
    
    // Assert
    XCTAssertEqual((NSInteger)10, ev.position.x);
    XCTAssertEqual((NSInteger)9, ev.position.y);
}

- (void)testMovingSouth {
    // Arrange
    CWSExecutionVector * ev = [CWSExecutionVector executionVectorWithPosition:CWSPositionMake(10,10) andDirection:CWSDirectionSouth andInstructionColorTag:42];
    
    // Act
    [ev move];
    
    // Assert
    XCTAssertEqual((NSInteger)10, ev.position.x);
    XCTAssertEqual((NSInteger)11, ev.position.y);
}

- (void)testMovingWest {
    // Arrange
    CWSExecutionVector * ev = [CWSExecutionVector executionVectorWithPosition:CWSPositionMake(10,10) andDirection:CWSDirectionWest andInstructionColorTag:42];
    
    // Act
    [ev move];
    
    // Assert
    XCTAssertEqual((NSInteger)9, ev.position.x);
    XCTAssertEqual((NSInteger)10, ev.position.y);
}

- (void)testMovingEast {
    // Arrange
    CWSExecutionVector * ev = [CWSExecutionVector executionVectorWithPosition:CWSPositionMake(10,10) andDirection:CWSDirectionEast andInstructionColorTag:42];
    
    // Act
    [ev move];
    
    // Assert
    XCTAssertEqual((NSInteger)11, ev.position.x);
    XCTAssertEqual((NSInteger)10, ev.position.y);
}

- (void) testToString {
    // Arrange
    CWSExecutionVector * ev = [CWSExecutionVector executionVectorWithPosition:CWSPositionMake(3,1) andDirection:CWSDirectionNorth andInstructionColorTag:42];
    
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
    XCTAssertEqual(evx, ev.position.x);
    XCTAssertEqual(evy, ev.position.y);
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
    XCTAssertEqual(evx, ev.position.x);
    XCTAssertEqual(evy, ev.position.y);
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
    XCTAssertEqual(evx1, ev.position.x);
    XCTAssertEqual(evy1, ev.position.y);
    XCTAssertEqual(evdir1, ev.direction);
    XCTAssertEqual(evcolor1, ev.colorTag);
    
    ev = [array objectAtIndex:1];
    XCTAssertEqual(evx2, ev.position.x);
    XCTAssertEqual(evy2, ev.position.y);
    XCTAssertEqual(evdir2, ev.direction);
    XCTAssertEqual(evcolor2, ev.colorTag);
}

- (void) testStack {
    // Arrange
    CWSParametrizedInstruction * i1 = [CWSParametrizedInstruction parametrizedInstructionWithCode:kCWSInstructionCodeNULL andParameter:nil];
    CWSParametrizedInstruction * i2 = [CWSParametrizedInstruction parametrizedInstructionWithCode:kCWSInstructionCodeNULL andParameter:[NSUUID UUID]];
    CWSExecutionVector * ev = [CWSExecutionVector executionVectorWithPosition:CWSPositionZero andDirection:CWSDirectionNorth andInstructionColorTag:0];
    
    // Act
    [ev pushOnStack:i1];
    [ev pushOnStack:i2];
    
    // Assert
    XCTAssertEqual((NSUInteger) 2, ev.stackSize);
    XCTAssertFalse(ev.isStackEmpty);
    XCTAssertEqualObjects(i2, ev.peekOnStack);
    
    XCTAssertEqualObjects(i2, ev.popOnStack);

    XCTAssertEqual((NSUInteger) 1, ev.stackSize);
    XCTAssertFalse(ev.isStackEmpty);
    XCTAssertEqualObjects(i1, ev.peekOnStack);
    
    XCTAssertEqualObjects(i1, ev.popOnStack);

    XCTAssertEqual((NSUInteger) 0, ev.stackSize);
    XCTAssert(ev.isStackEmpty);
    XCTAssertNil(ev.peekOnStack);
    
    XCTAssertNil(ev.popOnStack);
}


@end
