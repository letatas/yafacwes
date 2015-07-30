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
    for (int x = 0; x < width; x++) {
        for (int y = 0; y < height; y++) {
            XCTAssertEqual(kCWSInstructionCodeNULL, [coreState instructionCodeAtPositionX:x andY:y]);
            XCTAssertEqual(intitalColorTag, [coreState instructionColorTagAtPositionX:x andY:y]);
        }
    }
    
    XCTAssertEqual((NSInteger) CWSNoExecutionVector, coreState.nextExecutionVectorIndex);
    
    XCTAssertEqual((NSUInteger) 0, coreState.executionVectors.count);
}

- (void) testSettingInstructionCode {
    // Arrange
    NSInteger width = 17;
    NSInteger height = 10;
    NSInteger x1 = 0;
    NSInteger y1 = 0;
    CWSInstructionCode i1 = kCWSInstructionCodeLEFT;
    NSInteger x2 = 4;
    NSInteger y2 = 9;
    CWSInstructionCode i2 = kCWSInstructionCodeRIGHT;
    NSInteger x3 = width - 1;
    NSInteger y3 = height - 1;
    CWSInstructionCode i3 = kCWSInstructionCodeNOP;
    CWSCoreState * coreState = [CWSCoreState coreStateWithWidth:width andHeight:height];
    
    // Act
    [coreState setInstructionCode:i1 atPositionX:x1 andY:y1];
    [coreState setInstructionCode:i2 atPositionX:x2 andY:y2];
    [coreState setInstructionCode:i3 atPositionX:x3 andY:y3];
    
    // Assert
    XCTAssertEqual(i1, [coreState instructionCodeAtPositionX:x1 andY:y1]);
    XCTAssertEqual(i2, [coreState instructionCodeAtPositionX:x2 andY:y2]);
    XCTAssertEqual(i3, [coreState instructionCodeAtPositionX:x3 andY:y3]);
}

- (void) testSettingInstructionColorTag {
    // Arrange
    NSInteger width = 17;
    NSInteger height = 10;
    NSInteger x1 = 0;
    NSInteger y1 = 0;
    CWSInstructionColorTag t1 = 1;
    NSInteger x2 = 4;
    NSInteger y2 = 9;
    CWSInstructionColorTag t2 = 2;
    NSInteger x3 = width - 1;
    NSInteger y3 = height - 1;
    CWSInstructionColorTag t3 = kCWSInstructionCodeNOP;
    CWSCoreState * coreState = [CWSCoreState coreStateWithWidth:width andHeight:height];
    
    // Act
    [coreState setInstructionColorTag:t1 atPositionX:x1 andY:y1];
    [coreState setInstructionColorTag:t2 atPositionX:x2 andY:y2];
    [coreState setInstructionColorTag:t3 atPositionX:x3 andY:y3];
    
    // Assert
    XCTAssertEqual(t1, [coreState instructionColorTagAtPositionX:x1 andY:y1]);
    XCTAssertEqual(t2, [coreState instructionColorTagAtPositionX:x2 andY:y2]);
    XCTAssertEqual(t3, [coreState instructionColorTagAtPositionX:x3 andY:y3]);
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
    BOOL bLoad = [scanner scanIntegerMatrixWithBlock:^ (NSUInteger x, NSUInteger y, NSInteger value) {
        NSInteger expected = y * 4 + x + 1;
        XCTAssertEqual(value, expected);
        readCount++;
    }];
    XCTAssert(bLoad);
    XCTAssertEqual(expectedCount, readCount);
    
    readCount = 0;
    bLoad = [scanner scanIntegerMatrixWithBlock:^ (NSUInteger x, NSUInteger y, NSInteger value) {
        NSInteger expected = 16 - (y * 4 + x);
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
    
    NSInteger x1 = 5;
    NSInteger y1 = 6;
    NSInteger width = 17;
    NSInteger height = 10;
    CWSInstructionCode i1 = 3;
    CWSInstructionColorTag c1 = 1;

    // Act
    CWSCoreState * coreState = [CWSCoreState coreStateWithString: coreStateData];
        
    // Assert
    XCTAssertEqual(i1, [coreState instructionCodeAtPositionX:x1 andY:y1]);
    XCTAssertEqual((NSInteger) 1, coreState.nextExecutionVectorIndex);
    XCTAssertEqual((NSUInteger) 2, coreState.executionVectors.count);
    XCTAssertEqual(c1, [coreState instructionColorTagAtPositionX:x1 andY:y1]);
    XCTAssertEqual(width, coreState.width);
    XCTAssertEqual(height, coreState.height);
}

- (void) testOneStep {
    // Arrange
    CWSCoreState * coreState = [CWSCoreState coreStateWithWidth:17 andHeight:10];
    NSInteger posX1 = 5;
    NSInteger posY1 = 6;
    CWSInstructionColorTag tag1 = 42;
    CWSExecutionVector * ev1 = [CWSExecutionVector executionVectorWithX:posX1 andY:posY1 andDirection:CWSDirectionSouth andInstructionColorTag:tag1];
    [coreState.executionVectors addObject:ev1];
    NSInteger posX2 = 7;
    NSInteger posY2 = 3;
    CWSInstructionColorTag tag2 = 33;
    CWSExecutionVector * ev2 = [CWSExecutionVector executionVectorWithX:posX2 andY:posY2 andDirection:CWSDirectionEast andInstructionColorTag:tag2];
    [coreState.executionVectors addObject:ev2];
    coreState.nextExecutionVectorIndex = 0;
    [coreState setInstructionCode:kCWSInstructionCodeNOP atPositionX:posX1 andY:posY1];    
    
    // Act
    [coreState oneStep];
    
    // Assert
    XCTAssertEqual(ev1.x, posX1);
    XCTAssertEqual(ev1.y, posY1+1);
    XCTAssertEqual(ev1.direction, CWSDirectionSouth);
    XCTAssertEqual((NSInteger) 1, coreState.nextExecutionVectorIndex);
    XCTAssertEqual((NSUInteger) 2, coreState.executionVectors.count);
    XCTAssertEqual(tag1, [coreState instructionColorTagAtPositionX:posX1 andY:posY1]);

    // Act
    [coreState oneStep];
    
    // Assert
    XCTAssertEqual(ev1.x, posX1);
    XCTAssertEqual(ev1.y, posY1+1);
    XCTAssertEqual(ev1.direction, CWSDirectionSouth);
    XCTAssertEqual((NSInteger) 0, coreState.nextExecutionVectorIndex);
    XCTAssertEqual((NSUInteger) 1, coreState.executionVectors.count);
    XCTAssertEqual(NSNotFound, [coreState.executionVectors indexOfObject:ev2]);
    XCTAssertEqual(tag2, [coreState instructionColorTagAtPositionX:posX2 andY:posY2]);
}

- (void) testToString {
    // Arrange
    CWSCoreState * coreState = [CWSCoreState coreStateWithWidth:17 andHeight:10];
    NSInteger posX1 = 5;
    NSInteger posY1 = 6;
    CWSExecutionVector * ev1 = [CWSExecutionVector executionVectorWithX:posX1 andY:posY1 andDirection:CWSDirectionSouth andInstructionColorTag:42];
    [coreState.executionVectors addObject:ev1];
    NSInteger posX2 = 7;
    NSInteger posY2 = 3;
    CWSExecutionVector * ev2 = [CWSExecutionVector executionVectorWithX:posX2 andY:posY2 andDirection:CWSDirectionEast andInstructionColorTag:42];
    [coreState.executionVectors addObject:ev2];
    coreState.nextExecutionVectorIndex = 0;
    [coreState setInstructionCode:3 atPositionX:posX1 andY:posY1];
    [coreState setInstructionColorTag:9 atPositionX:posX1+1 andY:posY1+1];

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
    NSInteger x1 = 16;
    NSInteger y1 = 5;
    CWSInstructionCode i1 = kCWSInstructionCodeNOP;
    NSInteger x2 = 0;
    NSInteger y2 = 5;
    CWSCoreState * coreState = [CWSCoreState coreStateWithWidth:width andHeight:height];
    [coreState setInstructionCode:i1 atPositionX:x1 andY:y1];
    [coreState setInstructionCode:kCWSInstructionCodeNULL atPositionX:x2 andY:y2];
    
    CWSExecutionVector * ev = [CWSExecutionVector executionVectorWithX:x1 andY:y1 andDirection:CWSDirectionEast andInstructionColorTag:0];
    [coreState.executionVectors addObject:ev];
    coreState.nextExecutionVectorIndex = 0;
    
    // Act
    [coreState oneStep];
    
    // Assert
    XCTAssertEqual(x2, ev.x);
    XCTAssertEqual(y2, ev.y);
}

- (void) testLoopingWestInstructionCode {
    // Arrange
    NSInteger width = 17;
    NSInteger height = 10;
    NSInteger x1 = 0;
    NSInteger y1 = 5;
    CWSInstructionCode i1 = kCWSInstructionCodeNOP;
    NSInteger x2 = 16;
    NSInteger y2 = 5;
    CWSCoreState * coreState = [CWSCoreState coreStateWithWidth:width andHeight:height];
    [coreState setInstructionCode:i1 atPositionX:x1 andY:y1];
    [coreState setInstructionCode:kCWSInstructionCodeNULL atPositionX:x2 andY:y2];
    
    CWSExecutionVector * ev = [CWSExecutionVector executionVectorWithX:x1 andY:y1 andDirection:CWSDirectionWest andInstructionColorTag:0];
    [coreState.executionVectors addObject:ev];
    coreState.nextExecutionVectorIndex = 0;
    
    // Act
    [coreState oneStep];
    
    // Assert
    XCTAssertEqual(x2, ev.x);
    XCTAssertEqual(y2, ev.y);
}

- (void) testLoopingNorthInstructionCode {
    // Arrange
    NSInteger width = 17;
    NSInteger height = 10;
    NSInteger x1 = 8;
    NSInteger y1 = 0;
    CWSInstructionCode i1 = kCWSInstructionCodeNOP;
    NSInteger x2 = 8;
    NSInteger y2 = 9;
    CWSCoreState * coreState = [CWSCoreState coreStateWithWidth:width andHeight:height];
    [coreState setInstructionCode:i1 atPositionX:x1 andY:y1];
    [coreState setInstructionCode:kCWSInstructionCodeNULL atPositionX:x2 andY:y2];
    
    CWSExecutionVector * ev = [CWSExecutionVector executionVectorWithX:x1 andY:y1 andDirection:CWSDirectionNorth andInstructionColorTag:0];
    [coreState.executionVectors addObject:ev];
    coreState.nextExecutionVectorIndex = 0;
    
    // Act
    [coreState oneStep];
    
    // Assert
    XCTAssertEqual(x2, ev.x);
    XCTAssertEqual(y2, ev.y);
}

- (void) testLoopingSouthInstructionCode {
    // Arrange
    NSInteger width = 17;
    NSInteger height = 10;
    NSInteger x1 = 8;
    NSInteger y1 = 9;
    CWSInstructionCode i1 = kCWSInstructionCodeNOP;
    NSInteger x2 = 8;
    NSInteger y2 = 0;
    CWSCoreState * coreState = [CWSCoreState coreStateWithWidth:width andHeight:height];
    [coreState setInstructionCode:i1 atPositionX:x1 andY:y1];
    [coreState setInstructionCode:kCWSInstructionCodeNULL atPositionX:x2 andY:y2];
    
    CWSExecutionVector * ev = [CWSExecutionVector executionVectorWithX:x1 andY:y1 andDirection:CWSDirectionSouth andInstructionColorTag:0];
    [coreState.executionVectors addObject:ev];
    coreState.nextExecutionVectorIndex = 0;
    
    // Act
    [coreState oneStep];
    
    // Assert
    XCTAssertEqual(x2, ev.x);
    XCTAssertEqual(y2, ev.y);
}


@end
