//
//  CWSCoreStateTests.m
//  yafacwesConsole
//
//  Created by Matthias Lamoureux on 14/07/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "CWSCoreState.h"
#import "CWSCoreState_Private.h"
#import "NSScanner+CWSCoreState.h"

@interface CWSCoreStateTests : XCTestCase

@end

@implementation CWSCoreStateTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testEmptyNewCoreState {
    // Arrange
    NSInteger width = 17;
    NSInteger height = 10;
    CWSInstructionColorTag intitalColorTag = 0;
    
    // Act
    CWSCoreState * coreState = [CWSCoreState coreStateWithWidth:width andHeight:height];
    
    // Assert
    CWSPosition position = CWSPositionZero;
    for (position.x = 0; position.x < width; position.x++) {
        for (position.y = 0; position.y < height; position.y++) {
            XCTAssertEqual(kCWSInstructionCodeNULL, [coreState instructionCodeAtPosition:position]);
            XCTAssertEqual(intitalColorTag, [coreState instructionColorTagAtPosition:position]);
        }
    }
    
    XCTAssertEqual((NSInteger) CWSNoExecutionVector, coreState.nextExecutionVectorIndex);
    
    XCTAssertEqual((NSUInteger) 0, coreState.executionVectors.count);
}

- (void) testSettingInstructionCode {
    // Arrange
    NSInteger width = 17;
    NSInteger height = 10;
    CWSPosition pos1 = CWSPositionMake(0, 0);
    CWSInstructionCode i1 = kCWSInstructionCodeLEFT;
    CWSPosition pos2 = CWSPositionMake(4, 9);
    CWSInstructionCode i2 = kCWSInstructionCodeRIGHT;
    CWSPosition pos3 = CWSPositionMake(width - 1, height - 1);
    CWSInstructionCode i3 = kCWSInstructionCodeNOP;
    CWSCoreState * coreState = [CWSCoreState coreStateWithWidth:width andHeight:height];
    
    // Act
    [coreState setInstructionCode:i1 atPosition:pos1];
    [coreState setInstructionCode:i2 atPosition:pos2];
    [coreState setInstructionCode:i3 atPosition:pos3];
    
    // Assert
    XCTAssertEqual(i1, [coreState instructionCodeAtPosition:pos1]);
    XCTAssertEqual(i2, [coreState instructionCodeAtPosition:pos2]);
    XCTAssertEqual(i3, [coreState instructionCodeAtPosition:pos3]);
}

- (void) testSettingInstructionColorTag {
    // Arrange
    NSInteger width = 17;
    NSInteger height = 10;
    CWSPosition position1 = CWSPositionMake(0,0);
    CWSInstructionColorTag t1 = 1;
    CWSPosition position2 = CWSPositionMake(4,9);
    CWSInstructionColorTag t2 = 2;
    CWSPosition position3 = CWSPositionMake(width - 1,height - 1);
    CWSInstructionColorTag t3 = kCWSInstructionCodeNOP;
    CWSCoreState * coreState = [CWSCoreState coreStateWithWidth:width andHeight:height];
    
    // Act
    [coreState setInstructionColorTag:t1 atPosition:position1];
    [coreState setInstructionColorTag:t2 atPosition:position2];
    [coreState setInstructionColorTag:t3 atPosition:position3];
    
    // Assert
    XCTAssertEqual(t1, [coreState instructionColorTagAtPosition:position1]);
    XCTAssertEqual(t2, [coreState instructionColorTagAtPosition:position2]);
    XCTAssertEqual(t3, [coreState instructionColorTagAtPosition:position3]);
}

- (void) testScanCoreStateWidth {
    // Arrange
    NSString * coreStateMatrix =
    @"-\n"
    "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0\n"
    "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0\n"
    "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0\n"
    "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0\n"
    "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0\n"
    "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0\n"
    "0 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0\n"
    "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0\n"
    "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0\n"
    "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0\n";
    NSInteger width = 17;
    NSInteger height = 10;
    
    // Act
    NSScanner * scanner = [NSScanner scannerWithString:coreStateMatrix];
    
    // Assert
    NSInteger readWidth = 0;
    NSInteger readHeight = 0;
    XCTAssert([scanner scanCoreStateWidth: &readWidth andHeight: &readHeight]);
    XCTAssertEqual(readWidth, width);
    XCTAssertEqual(readHeight, height);
    XCTAssert(![scanner scanCoreStateWidth: NULL andHeight: &readHeight]);
    XCTAssert(![scanner scanCoreStateWidth: NULL andHeight: NULL]);
    XCTAssert(![scanner scanCoreStateWidth: &readWidth andHeight: NULL]);
}

- (void) testScanIntegerMatrix {
    // Arrange
    NSString * coreStateMatrix =
    @"-\n"
    "1 2 3 4\n"
    "5 6 7 8\n"
    "9 10 11 12\n"
    "13 14 15 16\n"
    "-\n"
    "16 15 14 13\n"
    "12 11 10 9\n"
    "8 7 6 5\n"
    "4 3 2 1\n";
    NSUInteger expectedCount = 16;
    
    // Act
    NSScanner * scanner = [NSScanner scannerWithString:coreStateMatrix];
    
    // Assert
    XCTAssert(![scanner scanIntegerMatrixWithBlock: nil]);
    __block NSUInteger readCount = 0;
    BOOL bLoad = [scanner scanIntegerMatrixWithBlock:^ (CWSPosition position, NSInteger value) {
        NSInteger expected = position.y * 4 + position.x + 1;
        XCTAssertEqual(value, expected);
        readCount++;
    }];
    XCTAssert(bLoad);
    XCTAssertEqual(expectedCount, readCount);
    
    readCount = 0;
    bLoad = [scanner scanIntegerMatrixWithBlock:^ (CWSPosition position, NSInteger value) {
        NSInteger expected = 16 - (position.y * 4 + position.x);
        XCTAssertEqual(value, expected);
        readCount++;
    }];
    XCTAssert(bLoad);
    XCTAssertEqual(expectedCount, readCount);
}

- (void) testCoreStateFromString {
    // Arrange
    NSString * coreStateData =
    @"EV:5,6,S,1\n"
    "EV:7,3,E,2\n"
    "NEXT:1\n"
    "-\n"
    "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0\n"
    "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0\n"
    "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0\n"
    "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0\n"
    "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0\n"
    "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0\n"
    "0 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0\n"
    "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0\n"
    "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0\n"
    "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0\n"
    "-\n"
    "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0\n"
    "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0\n"
    "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0\n"
    "0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0\n"
    "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0\n"
    "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0\n"
    "0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0\n"
    "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0\n"
    "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0\n"
    "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0";
    
    CWSPosition position1 = CWSPositionMake(5,6);
    NSInteger width = 17;
    NSInteger height = 10;
    CWSInstructionCode i1 = 3;
    CWSInstructionColorTag c1 = 1;
    
    // Act
    CWSCoreState * coreState = [CWSCoreState coreStateWithString: coreStateData];
    
    // Assert
    XCTAssertEqual(i1, [coreState instructionCodeAtPosition:position1]);
    XCTAssertEqual((NSInteger) 1, coreState.nextExecutionVectorIndex);
    XCTAssertEqual((NSUInteger) 2, coreState.executionVectors.count);
    XCTAssertEqual(c1, [coreState instructionColorTagAtPosition:position1]);
    XCTAssertEqual(width, coreState.width);
    XCTAssertEqual(height, coreState.height);
}

- (void) testOneStep {
    // Arrange
    CWSCoreState * coreState = [CWSCoreState coreStateWithWidth:17 andHeight:10];
    CWSPosition position1 = CWSPositionMake(5,6);
    CWSInstructionColorTag tag1 = 42;
    CWSExecutionVector * ev1 = [CWSExecutionVector executionVectorWithPosition:position1 andDirection:CWSDirectionSouth andInstructionColorTag:tag1];
    [coreState.executionVectors addObject:ev1];
    CWSPosition position2 = CWSPositionMake(7,3);
    CWSInstructionColorTag tag2 = 33;
    CWSExecutionVector * ev2 = [CWSExecutionVector executionVectorWithPosition:position2 andDirection:CWSDirectionEast andInstructionColorTag:tag2];
    [coreState.executionVectors addObject:ev2];
    coreState.nextExecutionVectorIndex = 0;
    [coreState setInstructionCode:kCWSInstructionCodeNOP atPosition:position1];
    
    // Act
    [coreState oneStep];
    
    // Assert
    XCTAssertEqual(ev1.position.x, position1.x);
    XCTAssertEqual(ev1.position.y, position1.y+1);
    XCTAssertEqual(ev1.direction, CWSDirectionSouth);
    XCTAssertEqual((NSInteger) 1, coreState.nextExecutionVectorIndex);
    XCTAssertEqual((NSUInteger) 2, coreState.executionVectors.count);
    XCTAssertEqual(tag1, [coreState instructionColorTagAtPosition:position1]);
    
    // Act
    [coreState oneStep];
    
    // Assert
    XCTAssertEqual(ev1.position.x, position1.x);
    XCTAssertEqual(ev1.position.y, position1.y+1);
    XCTAssertEqual(ev1.direction, CWSDirectionSouth);
    XCTAssertEqual((NSInteger) 0, coreState.nextExecutionVectorIndex);
    XCTAssertEqual((NSUInteger) 1, coreState.executionVectors.count);
    XCTAssertEqual(NSNotFound, [coreState.executionVectors indexOfObject:ev2]);
    XCTAssertEqual(tag2, [coreState instructionColorTagAtPosition:position2]);
}

- (void) testToString {
    // Arrange
    CWSCoreState * coreState = [CWSCoreState coreStateWithWidth:17 andHeight:10];
    CWSPosition position1 = CWSPositionMake(5,6);
    CWSExecutionVector * ev1 = [CWSExecutionVector executionVectorWithPosition:position1 andDirection:CWSDirectionSouth andInstructionColorTag:42];
    [coreState.executionVectors addObject:ev1];
    CWSPosition position2 = CWSPositionMake(7,3);
    CWSExecutionVector * ev2 = [CWSExecutionVector executionVectorWithPosition:position2 andDirection:CWSDirectionEast andInstructionColorTag:42];
    [coreState.executionVectors addObject:ev2];
    coreState.nextExecutionVectorIndex = 0;
    [coreState setInstructionCode:3 atPosition:position1];
    [coreState setInstructionColorTag:9 atPosition:CWSPositionMake(position1.x+1, position1.y+1)];
    
    // Act
    NSString * string = coreState.description;
    NSString * expected = @"EV:5,6,S,42\n"
    "EV:7,3,E,42\n"
    "NEXT:0\n"
    "-\n"
    "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0\n"
    "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0\n"
    "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0\n"
    "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0\n"
    "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0\n"
    "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0\n"
    "0 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0\n"
    "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0\n"
    "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0\n"
    "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0\n"
    "-\n"
    "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0\n"
    "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0\n"
    "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0\n"
    "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0\n"
    "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0\n"
    "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0\n"
    "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0\n"
    "0 0 0 0 0 0 9 0 0 0 0 0 0 0 0 0 0\n"
    "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0\n"
    "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0";
    
    // Assert
    XCTAssertEqualObjects(expected, string);
}

- (void) testLoopingEastInstructionCode {
    // Arrange
    NSInteger width = 17;
    NSInteger height = 10;
    CWSPosition position1 = CWSPositionMake(16,5);
    CWSInstructionCode i1 = kCWSInstructionCodeNOP;
    CWSPosition position2 = CWSPositionMake(0,5);
    CWSCoreState * coreState = [CWSCoreState coreStateWithWidth:width andHeight:height];
    [coreState setInstructionCode:i1 atPosition:position1];
    [coreState setInstructionCode:kCWSInstructionCodeNULL atPosition:position2];
    
    CWSExecutionVector * ev = [CWSExecutionVector executionVectorWithPosition:position1 andDirection:CWSDirectionEast andInstructionColorTag:0];
    [coreState.executionVectors addObject:ev];
    coreState.nextExecutionVectorIndex = 0;
    
    // Act
    [coreState oneStep];
    
    // Assert
    XCTAssertEqual(position2.x, ev.position.x);
    XCTAssertEqual(position2.y, ev.position.y);
}

- (void) testLoopingWestInstructionCode {
    // Arrange
    NSInteger width = 17;
    NSInteger height = 10;
    CWSPosition position1 = CWSPositionMake(0,5);
    CWSInstructionCode i1 = kCWSInstructionCodeNOP;
    CWSPosition position2 = CWSPositionMake(16,5);
    CWSCoreState * coreState = [CWSCoreState coreStateWithWidth:width andHeight:height];
    [coreState setInstructionCode:i1 atPosition:position1];
    [coreState setInstructionCode:kCWSInstructionCodeNULL atPosition:position2];
    
    CWSExecutionVector * ev = [CWSExecutionVector executionVectorWithPosition:position1 andDirection:CWSDirectionWest andInstructionColorTag:0];
    [coreState.executionVectors addObject:ev];
    coreState.nextExecutionVectorIndex = 0;
    
    // Act
    [coreState oneStep];
    
    // Assert
    XCTAssertEqual(position2.x, ev.position.x);
    XCTAssertEqual(position2.y, ev.position.y);
}

- (void) testLoopingNorthInstructionCode {
    // Arrange
    NSInteger width = 17;
    NSInteger height = 10;
    CWSPosition position1 = CWSPositionMake(8,0);
    CWSInstructionCode i1 = kCWSInstructionCodeNOP;
    CWSPosition position2 = CWSPositionMake(8,9);
    CWSCoreState * coreState = [CWSCoreState coreStateWithWidth:width andHeight:height];
    [coreState setInstructionCode:i1 atPosition:position1];
    [coreState setInstructionCode:kCWSInstructionCodeNULL atPosition:position2];
    
    CWSExecutionVector * ev = [CWSExecutionVector executionVectorWithPosition:position1 andDirection:CWSDirectionNorth andInstructionColorTag:0];
    [coreState.executionVectors addObject:ev];
    coreState.nextExecutionVectorIndex = 0;
    
    // Act
    [coreState oneStep];
    
    // Assert
    XCTAssertEqual(position2.x, ev.position.x);
    XCTAssertEqual(position2.y, ev.position.y);
}

- (void) testLoopingSouthInstructionCode {
    // Arrange
    NSInteger width = 17;
    NSInteger height = 10;
    CWSPosition position1 = CWSPositionMake(8,9);
    CWSInstructionCode i1 = kCWSInstructionCodeNOP;
    CWSPosition position2 = CWSPositionMake(8,0);
    CWSCoreState * coreState = [CWSCoreState coreStateWithWidth:width andHeight:height];
    [coreState setInstructionCode:i1 atPosition:position1];
    [coreState setInstructionCode:kCWSInstructionCodeNULL atPosition:position2];
    
    CWSExecutionVector * ev = [CWSExecutionVector executionVectorWithPosition:position1 andDirection:CWSDirectionSouth andInstructionColorTag:0];
    [coreState.executionVectors addObject:ev];
    coreState.nextExecutionVectorIndex = 0;
    
    // Act
    [coreState oneStep];
    
    // Assert
    XCTAssertEqual(position2.x, ev.position.x);
    XCTAssertEqual(position2.y, ev.position.y);
}

- (void) testInstructionParametersInitialValues {
    // Arrange
    NSInteger width = 17;
    NSInteger height = 10;
    
    // Act
    CWSCoreState * coreState = [CWSCoreState coreStateWithWidth:width andHeight:height];
    
    // Assert
    CWSPosition position = CWSPositionZero;
    for (position.x = 0; position.x < width; position.x++) {
        for (position.y = 0; position.y < height; position.y++) {
            XCTAssertNil([coreState instructionParameterAtPosition:position]);
        }
    }
}

- (void) testInstructionParameters {
    // Arrange
    NSInteger width = 17;
    NSInteger height = 10;
    CWSPosition position1 = CWSPositionMake(8,9);
    CWSCoreState * coreState = [CWSCoreState coreStateWithWidth:width andHeight:height];
    NSUUID * parameter = [NSUUID UUID];
    
    // Act
    [coreState setInstructionParameter:parameter atPosition:position1];
    
    // Assert
    XCTAssertEqualObjects(parameter, [coreState instructionParameterAtPosition:position1]);
}

@end
