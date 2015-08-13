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
    XCTAssertEqualObjects([CWSInstructionPUSH class], [[CWSInstruction instructionForCode:kCWSInstructionCodePUSH] class]);
    XCTAssertEqualObjects([CWSInstructionPOP class], [[CWSInstruction instructionForCode:kCWSInstructionCodePOP] class]);
}

- (void) testNULLInstruction {
    // Arrange
    CWSInstruction * instruction = [CWSInstruction instructionForCode:kCWSInstructionCodeNULL];
    CWSCoreState * coreState = [CWSCoreState coreStateWithWidth:17 andHeight:10];
    CWSExecutionVector * ev = [CWSExecutionVector executionVectorWithPosition:CWSPositionMake(5, 5) andDirection:CWSDirectionSouth andInstructionColorTag:42];
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
    CWSPosition position = CWSPositionMake(5,6);
    CWSExecutionVector * ev = [CWSExecutionVector executionVectorWithPosition:position andDirection:CWSDirectionSouth andInstructionColorTag:42];
    [coreState.executionVectors addObject:ev];
    coreState.nextExecutionVectorIndex = 0;
    [coreState setInstructionCode:code atPosition:position];
    
    // Act
    BOOL result = [instruction executeForCoreState:coreState];
    
    // Assert
    XCTAssert(result);
    XCTAssertEqual(ev.position.x, position.x + 1);
    XCTAssertEqual(ev.position.y, position.y);
    XCTAssertEqual(ev.direction, CWSDirectionEast);
}

- (void) testRIGHTInstruction {
    // Arrange
    CWSInstructionCode code = kCWSInstructionCodeRIGHT;
    CWSInstruction * instruction = [CWSInstruction instructionForCode:code];
    CWSCoreState * coreState = [CWSCoreState coreStateWithWidth:17 andHeight:10];
    CWSPosition position = CWSPositionMake(5,6);
    CWSExecutionVector * ev = [CWSExecutionVector executionVectorWithPosition:position andDirection:CWSDirectionSouth andInstructionColorTag:42];
    [coreState.executionVectors addObject:ev];
    coreState.nextExecutionVectorIndex = 0;
    [coreState setInstructionCode:code atPosition:position];
    
    // Act
    BOOL result = [instruction executeForCoreState:coreState];
    
    // Assert
    XCTAssert(result);
    XCTAssertEqual(ev.position.x, position.x - 1);
    XCTAssertEqual(ev.position.y, position.y);
    XCTAssertEqual(ev.direction, CWSDirectionWest);
}

- (void) testNOPInstruction {
    // Arrange
    CWSInstructionCode code = kCWSInstructionCodeNOP;
    CWSInstruction * instruction = [CWSInstruction instructionForCode:code];
    CWSCoreState * coreState = [CWSCoreState coreStateWithWidth:17 andHeight:10];
    CWSPosition position = CWSPositionMake(5,6);
    CWSExecutionVector * ev = [CWSExecutionVector executionVectorWithPosition:position andDirection:CWSDirectionSouth andInstructionColorTag:42];
    [coreState.executionVectors addObject:ev];
    coreState.nextExecutionVectorIndex = 0;
    [coreState setInstructionCode:code atPosition:position];
    
    // Act
    BOOL result = [instruction executeForCoreState:coreState];
    
    // Assert
    XCTAssert(result);
    XCTAssertEqual(ev.position.x, position.x);
    XCTAssertEqual(ev.position.y, position.y+1);
    XCTAssertEqual(ev.direction, CWSDirectionSouth);
}

- (void) testWALLInstruction {
    // Arrange
    CWSInstructionCode code = kCWSInstructionCodeWALL;
    CWSInstruction * instruction = [CWSInstruction instructionForCode:code];
    CWSCoreState * coreState = [CWSCoreState coreStateWithWidth:17 andHeight:10];
    CWSPosition position = CWSPositionMake(5,6);
    CWSExecutionVector * ev = [CWSExecutionVector executionVectorWithPosition:position andDirection:CWSDirectionSouth andInstructionColorTag:42];
    [coreState.executionVectors addObject:ev];
    coreState.nextExecutionVectorIndex = 0;
    [coreState setInstructionCode:kCWSInstructionCodeNOP atPosition:position];
    [coreState setInstructionCode:code atPosition:CWSPositionMake(position.x, position.y+1)];
    
    // Act
    [instruction executeForCoreState:coreState];
    BOOL result = [instruction executeForCoreState:coreState];
    
    // Assert
    XCTAssert(result);
    XCTAssertEqual(ev.position.x, position.x);
    XCTAssertEqual(ev.position.y, position.y);
    XCTAssertEqual(ev.direction, CWSDirectionSouth);
}

- (void) testSTOPInstruction {
    // Arrange
    CWSInstructionCode code = kCWSInstructionCodeSTOP;
    CWSInstruction * instruction = [CWSInstruction instructionForCode:code];
    CWSCoreState * coreState = [CWSCoreState coreStateWithWidth:17 andHeight:10];
    CWSPosition position = CWSPositionMake(5,6);
    CWSExecutionVector * ev = [CWSExecutionVector executionVectorWithPosition:position andDirection:CWSDirectionSouth andInstructionColorTag:42];
    [coreState.executionVectors addObject:ev];
    coreState.nextExecutionVectorIndex = 0;
    [coreState setInstructionCode:code atPosition:position];
    
    // Act
    BOOL result = [instruction executeForCoreState:coreState];
    
    // Assert
    XCTAssert(result);
    XCTAssertEqual(ev.position.x, position.x);
    XCTAssertEqual(ev.position.y, position.y);
    XCTAssertEqual(ev.direction, CWSDirectionSouth);
}

- (void) testPUSHInstructionWithoutParam {
    // Arrange
    CWSInstructionCode code = kCWSInstructionCodePUSH;
    CWSInstruction * instruction = [CWSInstruction instructionForCode:code];
    CWSCoreState * coreState = [CWSCoreState coreStateWithWidth:17 andHeight:10];
    CWSPosition position = CWSPositionMake(5,6);
    NSValue * param = [NSValue valueWithPosition:CWSPositionMake(-2, 1)];
    CWSExecutionVector * ev = [CWSExecutionVector executionVectorWithPosition:position andDirection:CWSDirectionSouth andInstructionColorTag:42];
    [coreState.executionVectors addObject:ev];
    coreState.nextExecutionVectorIndex = 0;
    [coreState setInstructionCode:code atPosition:position];
    [coreState setInstructionParameter:param atPosition:position];
    
    CWSInstructionCode destinationCode = kCWSInstructionCodeNOP;
    CWSPosition destinationPosition = CWSPositionMake(3, 7);
    [coreState setInstructionCode:destinationCode atPosition:destinationPosition];
    
    // Act
    BOOL result = [instruction executeForCoreState:coreState];
    CWSParametrizedInstruction * stackedInstruction = [ev peekOnStack];
    
    // Assert
    XCTAssert(result);
    XCTAssertEqual(ev.position.x, position.x);
    XCTAssertEqual(ev.position.y, position.y + 1);
    XCTAssertEqual(ev.direction, CWSDirectionSouth);
    
    XCTAssertEqual((NSUInteger) 1, ev.stackSize);
    XCTAssertEqual(destinationCode, stackedInstruction.code);
    XCTAssertNil(stackedInstruction.parameter);
}

- (void) testPUSHInstructionWithParam {
    // Arrange
    CWSInstructionCode code = kCWSInstructionCodePUSH;
    CWSInstruction * instruction = [CWSInstruction instructionForCode:code];
    CWSCoreState * coreState = [CWSCoreState coreStateWithWidth:17 andHeight:10];
    CWSPosition position = CWSPositionMake(5,6);
    NSValue * param = [NSValue valueWithPosition:CWSPositionMake(2, -1)];
    CWSExecutionVector * ev = [CWSExecutionVector executionVectorWithPosition:position andDirection:CWSDirectionSouth andInstructionColorTag:42];
    [coreState.executionVectors addObject:ev];
    coreState.nextExecutionVectorIndex = 0;
    [coreState setInstructionCode:code atPosition:position];
    [coreState setInstructionParameter:param atPosition:position];
    
    CWSInstructionCode destinationCode = kCWSInstructionCodeNOP;
    CWSPosition destinationPosition = CWSPositionMake(7, 5);
    NSValue * destinationParam = [NSValue valueWithPosition:CWSPositionMake(7, 8)];
    [coreState setInstructionCode:destinationCode atPosition:destinationPosition];
    [coreState setInstructionParameter:destinationParam atPosition:destinationPosition];
    
    // Act
    BOOL result = [instruction executeForCoreState:coreState];
    CWSParametrizedInstruction * stackedInstruction = [ev peekOnStack];
    
    // Assert
    XCTAssert(result);
    XCTAssertEqual(ev.position.x, position.x);
    XCTAssertEqual(ev.position.y, position.y + 1);
    XCTAssertEqual(ev.direction, CWSDirectionSouth);
    
    XCTAssertEqual((NSUInteger) 1, ev.stackSize);
    XCTAssertEqual(destinationCode, stackedInstruction.code);
    XCTAssertEqual(destinationParam, stackedInstruction.parameter);
}

- (void) testPUSHInstructionWithArrayParam {
   // Arrange
    CWSInstructionCode code = kCWSInstructionCodePUSH;
    CWSInstruction * instruction = [CWSInstruction instructionForCode:code];
    CWSCoreState * coreState = [CWSCoreState coreStateWithWidth:17 andHeight:10];
    CWSPosition position = CWSPositionMake(5,6);
    NSMutableArray * param = [NSMutableArray array];
    [param addObject:[NSValue valueWithPosition:CWSPositionMake(2, -1)]];
    [param addObject:[NSValue valueWithPosition:CWSPositionMake(2, -2)]];
    CWSExecutionVector * ev = [CWSExecutionVector executionVectorWithPosition:position andDirection:CWSDirectionSouth andInstructionColorTag:42];
    [coreState.executionVectors addObject:ev];
    coreState.nextExecutionVectorIndex = 0;
    [coreState setInstructionCode:code atPosition:position];
    [coreState setInstructionParameter:param atPosition:position];
    
    CWSInstructionCode destinationCode1 = kCWSInstructionCodeNOP;
    CWSPosition destinationPosition1 = CWSPositionMake(7, 5);
    NSValue * destinationParam1 = [NSValue valueWithPosition:CWSPositionMake(7, 8)];
    [coreState setInstructionCode:destinationCode1 atPosition:destinationPosition1];
    [coreState setInstructionParameter:destinationParam1 atPosition:destinationPosition1];
    
    CWSInstructionCode destinationCode2 = kCWSInstructionCodeLEFT;
    CWSPosition destinationPosition2 = CWSPositionMake(7, 4);
    NSMutableArray * destinationParam2 = [NSMutableArray array];
    NSValue * destinationParam2_1 = [NSValue valueWithPosition:CWSPositionMake(12, 12)];
    [destinationParam2 addObject:destinationParam2_1];
    NSValue * destinationParam2_2 = [NSValue valueWithPosition:CWSPositionMake(42, 42)];
    [destinationParam2 addObject:destinationParam2_2];
    [coreState setInstructionCode:destinationCode2 atPosition:destinationPosition2];
    [coreState setInstructionParameter:destinationParam2 atPosition:destinationPosition2];
    
    // Act
    BOOL result = [instruction executeForCoreState:coreState];
    CWSParametrizedInstruction * stackedInstruction = [ev peekOnStack];
    
    // Assert
    XCTAssert(result);
    XCTAssertEqual(ev.position.x, position.x);
    XCTAssertEqual(ev.position.y, position.y + 1);
    XCTAssertEqual(ev.direction, CWSDirectionSouth);   
    XCTAssertEqual((NSUInteger) 2, ev.stackSize);

    XCTAssertEqual(destinationCode2, stackedInstruction.code);
    XCTAssertEqual(destinationParam2_1, [stackedInstruction.parameter objectAtIndex:0]);
    XCTAssertEqual(destinationParam2_2, [stackedInstruction.parameter objectAtIndex:1]);
        
    [ev popOnStack];
    stackedInstruction = [ev peekOnStack];
    XCTAssertEqual(destinationCode1, stackedInstruction.code);
    XCTAssertEqual(destinationParam1, stackedInstruction.parameter);
}

- (void) testPUSHInstructionIncomplete {
    // Arrange
    CWSInstructionCode code = kCWSInstructionCodePUSH;
    CWSInstruction * instruction = [CWSInstruction instructionForCode:code];
    CWSCoreState * coreState = [CWSCoreState coreStateWithWidth:17 andHeight:10];
    CWSPosition position = CWSPositionMake(5,6);
    CWSExecutionVector * ev = [CWSExecutionVector executionVectorWithPosition:position andDirection:CWSDirectionSouth andInstructionColorTag:42];
    [coreState.executionVectors addObject:ev];
    coreState.nextExecutionVectorIndex = 0;
    [coreState setInstructionCode:code atPosition:position];
    
    // Act
    BOOL result = [instruction executeForCoreState:coreState];
    CWSParametrizedInstruction * stackedInstruction = [ev peekOnStack];
    
    // Assert
    XCTAssertFalse(result);
    XCTAssertEqual(ev.position.x, position.x);
    XCTAssertEqual(ev.position.y, position.y);
    XCTAssertEqual(ev.direction, CWSDirectionSouth);
    
    XCTAssertEqual((NSUInteger) 0, ev.stackSize);
    XCTAssertNil(stackedInstruction);
}

- (void) testPOPInstructionWithoutParam {
    // Arrange
    CWSInstructionCode code = kCWSInstructionCodePOP;
    CWSInstruction * instruction = [CWSInstruction instructionForCode:code];
    CWSCoreState * coreState = [CWSCoreState coreStateWithWidth:17 andHeight:10];
    CWSPosition position = CWSPositionMake(5,6);
    NSValue * param = [NSValue valueWithPosition:CWSPositionMake(-2, 1)];
    CWSExecutionVector * ev = [CWSExecutionVector executionVectorWithPosition:position andDirection:CWSDirectionSouth andInstructionColorTag:42];
    [coreState.executionVectors addObject:ev];
    coreState.nextExecutionVectorIndex = 0;
    [coreState setInstructionCode:code atPosition:position];
    [coreState setInstructionParameter:param atPosition:position];
    
    CWSInstructionCode destinationCode = kCWSInstructionCodeNOP;
    CWSParametrizedInstruction * destinationInstruction = [CWSParametrizedInstruction parametrizedInstructionWithCode:destinationCode andParameter:nil];
    [ev pushOnStack:destinationInstruction];
    CWSPosition destinationPosition = CWSPositionMake(3, 7);
    
    // Act
    BOOL result = [instruction executeForCoreState:coreState];
    CWSInstructionCode poppedInstructionCode = [coreState instructionCodeAtPosition:destinationPosition];
    id poppedParam = [coreState instructionParameterAtPosition:destinationPosition];
    
    // Assert
    XCTAssert(result);
    XCTAssertEqual(ev.position.x, position.x);
    XCTAssertEqual(ev.position.y, position.y + 1);
    XCTAssertEqual(ev.direction, CWSDirectionSouth);
    
    XCTAssertEqual((NSUInteger) 0, ev.stackSize);
    XCTAssertEqual(destinationCode, poppedInstructionCode);
    XCTAssertNil(poppedParam);
}

- (void) testPOPInstructionWithParam {
    // Arrange
    CWSInstructionCode code = kCWSInstructionCodePOP;
    CWSInstruction * instruction = [CWSInstruction instructionForCode:code];
    CWSCoreState * coreState = [CWSCoreState coreStateWithWidth:17 andHeight:10];
    CWSPosition position = CWSPositionMake(5,6);
    NSValue * param = [NSValue valueWithPosition:CWSPositionMake(2, -1)];
    CWSExecutionVector * ev = [CWSExecutionVector executionVectorWithPosition:position andDirection:CWSDirectionSouth andInstructionColorTag:42];
    [coreState.executionVectors addObject:ev];
    coreState.nextExecutionVectorIndex = 0;
    [coreState setInstructionCode:code atPosition:position];
    [coreState setInstructionParameter:param atPosition:position];
    
    CWSInstructionCode destinationCode = kCWSInstructionCodeNOP;
    NSValue * destinationParam = [NSValue valueWithPosition:CWSPositionMake(7, 8)];
    CWSParametrizedInstruction * destinationInstruction = [CWSParametrizedInstruction parametrizedInstructionWithCode:destinationCode andParameter:destinationParam];
    [ev pushOnStack:destinationInstruction];
    CWSPosition destinationPosition = CWSPositionMake(7, 5);
    
    // Act
    BOOL result = [instruction executeForCoreState:coreState];
    CWSInstructionCode poppedInstructionCode = [coreState instructionCodeAtPosition:destinationPosition];
    id poppedParam = [coreState instructionParameterAtPosition:destinationPosition];
    
    // Assert
    XCTAssert(result);
    XCTAssertEqual(ev.position.x, position.x);
    XCTAssertEqual(ev.position.y, position.y + 1);
    XCTAssertEqual(ev.direction, CWSDirectionSouth);
    
    XCTAssertEqual((NSUInteger) 0, ev.stackSize);
    XCTAssertEqual(destinationCode, poppedInstructionCode);
    XCTAssertEqual(destinationParam, poppedParam);
}

- (void) testPOPInstructionIncomplete {
    // Arrange
    CWSInstructionCode code = kCWSInstructionCodePOP;
    CWSInstruction * instruction = [CWSInstruction instructionForCode:code];
    CWSCoreState * coreState = [CWSCoreState coreStateWithWidth:17 andHeight:10];
    CWSPosition position = CWSPositionMake(5,6);
    CWSExecutionVector * ev = [CWSExecutionVector executionVectorWithPosition:position andDirection:CWSDirectionSouth andInstructionColorTag:42];
    [coreState.executionVectors addObject:ev];
    coreState.nextExecutionVectorIndex = 0;
    [coreState setInstructionCode:code atPosition:position];
    
    CWSInstructionCode destinationCode = kCWSInstructionCodeNOP;
    NSValue * destinationParam = [NSValue valueWithPosition:CWSPositionMake(7, 8)];
    CWSParametrizedInstruction * destinationInstruction = [CWSParametrizedInstruction parametrizedInstructionWithCode:destinationCode andParameter:destinationParam];
    [ev pushOnStack:destinationInstruction];

    // Act
    BOOL result = [instruction executeForCoreState:coreState];
    CWSParametrizedInstruction * stackedInstruction = [ev peekOnStack];
    
    // Assert
    XCTAssertFalse(result);
    XCTAssertEqual(ev.position.x, position.x);
    XCTAssertEqual(ev.position.y, position.y);
    XCTAssertEqual(ev.direction, CWSDirectionSouth);
    
    XCTAssertEqual((NSUInteger) 1, ev.stackSize);
    XCTAssertEqual(stackedInstruction.code, destinationCode);
    XCTAssertEqualObjects(stackedInstruction.parameter, destinationParam);
}

- (void) testPOPInstructionEmptyStack {
    // Arrange
    CWSInstructionCode code = kCWSInstructionCodePOP;
    CWSInstruction * instruction = [CWSInstruction instructionForCode:code];
    CWSCoreState * coreState = [CWSCoreState coreStateWithWidth:17 andHeight:10];
    CWSPosition position = CWSPositionMake(5,6);
    NSValue * param = [NSValue valueWithPosition:CWSPositionMake(-2, 1)];
    CWSExecutionVector * ev = [CWSExecutionVector executionVectorWithPosition:position andDirection:CWSDirectionSouth andInstructionColorTag:42];
    [coreState.executionVectors addObject:ev];
    coreState.nextExecutionVectorIndex = 0;
    [coreState setInstructionCode:code atPosition:position];
    [coreState setInstructionParameter:param atPosition:position];
    
    // Act
    BOOL result = [instruction executeForCoreState:coreState];
    
    // Assert
    XCTAssertFalse(result);
    XCTAssertEqual(ev.position.x, position.x);
    XCTAssertEqual(ev.position.y, position.y);
    XCTAssertEqual(ev.direction, CWSDirectionSouth);
}

@end
