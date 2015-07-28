//
//  CWSInstructionsTests.m
//  yafacwesConsole
//
//  Created by Matthias Lamoureux on 15/07/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>

#import "CWSInstructions.h"


@interface CWSInstructionsTests : XCTestCase

@end

@implementation CWSInstructionsTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInstructionFactory {
    XCTAssertEqualObjects([CWSInstructionNULL class], [[CWSInstruction instructionForCode:kCWSInstructionCodeNULL] class]);
    XCTAssertEqualObjects([CWSInstructionLEFT class], [[CWSInstruction instructionForCode:kCWSInstructionCodeLEFT] class]);
    XCTAssertEqualObjects([CWSInstructionRIGHT class], [[CWSInstruction instructionForCode:kCWSInstructionCodeRIGHT] class]);
    XCTAssertEqualObjects([CWSInstructionNOP class], [[CWSInstruction instructionForCode:kCWSInstructionCodeNOP] class]);
    XCTAssertEqualObjects([CWSInstructionWALL class], [[CWSInstruction instructionForCode:kCWSInstructionCodeWALL] class]);
    XCTAssertEqualObjects([CWSInstructionSTOP class], [[CWSInstruction instructionForCode:kCWSInstructionCodeSTOP] class]);
}

- (void) testNULLInstruction {
    // Arrange
    CWSInstruction * instruction = [CWSInstruction instructionForCode:kCWSInstructionCodeNULL];
    CWSCoreState * coreState = [CWSCoreState coreStateWithWidth:17 andHeight:10];
    CWSExecutionVector * ev = [CWSExecutionVector executionVectorWithX:5 andY:5 andDirection:CWSDirectionSouth andInstructionColorTag:42];
    [coreState.executionVectors addObject:ev];
    coreState.nextExecutionVectorIndex = 0;
    
    // Act
    BOOL result = [instruction executeForCoreState:coreState];
    
    // Assert
    XCTAssertFalse(result);
}

- (void) testLEFTInstruction {
    // Arrange
    CWSInstructionCode code = kCWSInstructionCodeLEFT;
    CWSInstruction * instruction = [CWSInstruction instructionForCode:code];
    CWSCoreState * coreState = [CWSCoreState coreStateWithWidth:17 andHeight:10];
    NSInteger posX = 5;
    NSInteger posY = 6;
    CWSExecutionVector * ev = [CWSExecutionVector executionVectorWithX:posX andY:posY andDirection:CWSDirectionSouth andInstructionColorTag:42];
    [coreState.executionVectors addObject:ev];
    coreState.nextExecutionVectorIndex = 0;
    [coreState setInstructionCode:code atPositionX:posX andY:posY];
    
    // Act
    BOOL result = [instruction executeForCoreState:coreState];
    
    // Assert
    XCTAssert(result);
    XCTAssertEqual(ev.x, posX + 1);
    XCTAssertEqual(ev.y, posY);
    XCTAssertEqual(ev.direction, CWSDirectionEast);
}

- (void) testRIGHTInstruction {
    // Arrange
    CWSInstructionCode code = kCWSInstructionCodeRIGHT;
    CWSInstruction * instruction = [CWSInstruction instructionForCode:code];
    CWSCoreState * coreState = [CWSCoreState coreStateWithWidth:17 andHeight:10];
    NSInteger posX = 5;
    NSInteger posY = 6;
    CWSExecutionVector * ev = [CWSExecutionVector executionVectorWithX:posX andY:posY andDirection:CWSDirectionSouth andInstructionColorTag:42];
    [coreState.executionVectors addObject:ev];
    coreState.nextExecutionVectorIndex = 0;
    [coreState setInstructionCode:code atPositionX:posX andY:posY];
    
    // Act
    BOOL result = [instruction executeForCoreState:coreState];
    
    // Assert
    XCTAssert(result);
    XCTAssertEqual(ev.x, posX - 1);
    XCTAssertEqual(ev.y, posY);
    XCTAssertEqual(ev.direction, CWSDirectionWest);
}

- (void) testNOPInstruction {
    // Arrange
    CWSInstructionCode code = kCWSInstructionCodeNOP;
    CWSInstruction * instruction = [CWSInstruction instructionForCode:code];
    CWSCoreState * coreState = [CWSCoreState coreStateWithWidth:17 andHeight:10];
    NSInteger posX = 5;
    NSInteger posY = 6;
    CWSExecutionVector * ev = [CWSExecutionVector executionVectorWithX:posX andY:posY andDirection:CWSDirectionSouth andInstructionColorTag:42];
    [coreState.executionVectors addObject:ev];
    coreState.nextExecutionVectorIndex = 0;
    [coreState setInstructionCode:code atPositionX:posX andY:posY];
    
    // Act
    BOOL result = [instruction executeForCoreState:coreState];
    
    // Assert
    XCTAssert(result);
    XCTAssertEqual(ev.x, posX);
    XCTAssertEqual(ev.y, posY+1);
    XCTAssertEqual(ev.direction, CWSDirectionSouth);
}

- (void) testWALLInstruction {
    // Arrange
    CWSInstructionCode code = kCWSInstructionCodeWALL;
    CWSInstruction * instruction = [CWSInstruction instructionForCode:code];
    CWSCoreState * coreState = [CWSCoreState coreStateWithWidth:17 andHeight:10];
    NSInteger posX = 5;
    NSInteger posY = 6;
    CWSExecutionVector * ev = [CWSExecutionVector executionVectorWithX:posX andY:posY andDirection:CWSDirectionSouth andInstructionColorTag:42];
    [coreState.executionVectors addObject:ev];
    coreState.nextExecutionVectorIndex = 0;
    [coreState setInstructionCode:kCWSInstructionCodeNOP atPositionX:posX andY:posY];
    [coreState setInstructionCode:code atPositionX:posX andY:posY+1];
    
    // Act
    [instruction executeForCoreState:coreState];
    BOOL result = [instruction executeForCoreState:coreState];
    
    // Assert
    XCTAssert(result);
    XCTAssertEqual(ev.x, posX);
    XCTAssertEqual(ev.y, posY);
    XCTAssertEqual(ev.direction, CWSDirectionSouth);
}

- (void) testSTOPInstruction {
    // Arrange
    CWSInstructionCode code = kCWSInstructionCodeSTOP;
    CWSInstruction * instruction = [CWSInstruction instructionForCode:code];
    CWSCoreState * coreState = [CWSCoreState coreStateWithWidth:17 andHeight:10];
    NSInteger posX = 5;
    NSInteger posY = 6;
    CWSExecutionVector * ev = [CWSExecutionVector executionVectorWithX:posX andY:posY andDirection:CWSDirectionSouth andInstructionColorTag:42];
    [coreState.executionVectors addObject:ev];
    coreState.nextExecutionVectorIndex = 0;
    [coreState setInstructionCode:code atPositionX:posX andY:posY];
    
    // Act
    BOOL result = [instruction executeForCoreState:coreState];
    
    // Assert
    XCTAssert(result);
    XCTAssertEqual(ev.x, posX);
    XCTAssertEqual(ev.y, posY);
    XCTAssertEqual(ev.direction, CWSDirectionSouth);
}

@end
