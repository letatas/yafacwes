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
    XCTAssertEqualObjects([CWSInstructionNULL class], [[CWSInstruction instructionForCode:0] class]);
    XCTAssertEqualObjects([CWSInstructionLEFT class], [[CWSInstruction instructionForCode:1] class]);
    XCTAssertEqualObjects([CWSInstructionRIGHT class], [[CWSInstruction instructionForCode:2] class]);
}

- (void) testNULLInstruction {
    // Arrange
    CWSInstruction * instruction = [CWSInstruction instructionForCode:0];
    CWSCoreState * coreState = [CWSCoreState coreStateWithWidth:17 andHeight:10];
    CWSExecutionVector * ev = [CWSExecutionVector executionVectorWithX:5 andY:5 andDirection:CWSDirectionSouth];
    [coreState.executionVectors addObject:ev];
    coreState.nextExecutionVectorIndex = 0;
    
    // Act
    BOOL result = [instruction executeForCoreState:coreState];
    
    // Assert
    XCTAssertFalse(result);
}

- (void) testLEFTInstruction {
    // Arrange
    CWSInstructionCode code = 1;
    CWSInstruction * instruction = [CWSInstruction instructionForCode:code];
    CWSCoreState * coreState = [CWSCoreState coreStateWithWidth:17 andHeight:10];
    NSInteger posX = 5;
    NSInteger posY = 6;
    CWSExecutionVector * ev = [CWSExecutionVector executionVectorWithX:posX andY:posY andDirection:CWSDirectionSouth];
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
    CWSInstructionCode code = 2;
    CWSInstruction * instruction = [CWSInstruction instructionForCode:code];
    CWSCoreState * coreState = [CWSCoreState coreStateWithWidth:17 andHeight:10];
    NSInteger posX = 5;
    NSInteger posY = 6;
    CWSExecutionVector * ev = [CWSExecutionVector executionVectorWithX:posX andY:posY andDirection:CWSDirectionSouth];
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

@end
