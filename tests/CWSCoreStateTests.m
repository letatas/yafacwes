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
    
    // Act
    CWSCoreState * coreState = [CWSCoreState coreStateWithWidth:width andHeight:height];
    
    // Assert
    for (int x = 0; x < width; x++) {
        for (int y = 0; y < height; y++) {
            XCTAssertEqual(0, [coreState instructionCodeAtPositionX:x andY:y]);
        }
    }
    
    XCTAssertEqual(CWSNoExecutionVector, coreState.nextExecutionVectorIndex);
    
    XCTAssertEqual(0, coreState.executionVectors.count);
}

- (void) testSettingInstructionCode {
    // Arrange
    NSInteger width = 17;
    NSInteger height = 10;
    NSInteger x1 = 0;
    NSInteger y1 = 0;
    NSInteger i1 = 1;
    NSInteger x2 = 4;
    NSInteger y2 = 9;
    NSInteger i2 = 2;
    NSInteger x3 = width - 1;
    NSInteger y3 = height - 1;
    NSInteger i3 = 3;
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

- (void) testCoreStateFromString {
    // Arrange
    NSString * coreStateData = 
      @"EV:5,6,S\n"
       "EV:7,3,E\n"
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
       "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0";
    
    NSInteger width = 17;
    NSInteger height = 10;
    NSInteger x1 = 5;
    NSInteger y1 = 6;
    NSInteger i1 = 3;

    // Act
    CWSCoreState * coreState = [CWSCoreState coreStateWithString: coreStateData];
        
    // Assert
    XCTAssertEqual(i1, [coreState instructionCodeAtPositionX:x1 andY:y1]);
    XCTAssertEqual(0, coreState.nextExecutionVectorIndex);
    XCTAssertEqual(2, coreState.executionVectors.count);
}

- (void) testOneStep {
    // Arrange
    CWSCoreState * coreState = [CWSCoreState coreStateWithWidth:17 andHeight:10];
    NSInteger posX1 = 5;
    NSInteger posY1 = 6;
    CWSExecutionVector * ev1 = [CWSExecutionVector executionVectorWithX:posX1 andY:posY1 andDirection:CWSDirectionSouth];
    [coreState.executionVectors addObject:ev1];
    NSInteger posX2 = 7;
    NSInteger posY2 = 3;
    CWSExecutionVector * ev2 = [CWSExecutionVector executionVectorWithX:posX2 andY:posY2 andDirection:CWSDirectionEast];
    [coreState.executionVectors addObject:ev2];
    coreState.nextExecutionVectorIndex = 0;
    [coreState setInstructionCode:3 atPositionX:posX1 andY:posY1];
    
    // Act
    [coreState oneStep];
    
    // Assert
    XCTAssertEqual(ev1.x, posX1);
    XCTAssertEqual(ev1.y, posY1+1);
    XCTAssertEqual(ev1.direction, CWSDirectionSouth);
    XCTAssertEqual(1, coreState.nextExecutionVectorIndex);
    XCTAssertEqual(2, coreState.executionVectors.count);

    // Act
    [coreState oneStep];
    
    // Assert
    XCTAssertEqual(ev1.x, posX1);
    XCTAssertEqual(ev1.y, posY1+1);
    XCTAssertEqual(ev1.direction, CWSDirectionSouth);
    XCTAssertEqual(0, coreState.nextExecutionVectorIndex);
    XCTAssertEqual(1, coreState.executionVectors.count);
    XCTAssertEqual(NSNotFound, [coreState.executionVectors indexOfObject:ev2]);
}

- (void) testToString {
    // Arrange
    CWSCoreState * coreState = [CWSCoreState coreStateWithWidth:17 andHeight:10];
    NSInteger posX1 = 5;
    NSInteger posY1 = 6;
    CWSExecutionVector * ev1 = [CWSExecutionVector executionVectorWithX:posX1 andY:posY1 andDirection:CWSDirectionSouth];
    [coreState.executionVectors addObject:ev1];
    NSInteger posX2 = 7;
    NSInteger posY2 = 3;
    CWSExecutionVector * ev2 = [CWSExecutionVector executionVectorWithX:posX2 andY:posY2 andDirection:CWSDirectionEast];
    [coreState.executionVectors addObject:ev2];
    coreState.nextExecutionVectorIndex = 0;
    [coreState setInstructionCode:3 atPositionX:posX1 andY:posY1];

    // Act
    NSString * string = coreState.description;
    NSString * expected = @"EV:5,6,S\n"
    "EV:7,3,E\n"
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
    "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0";
    
    // Assert
    XCTAssertEqualObjects(expected, string);
}

@end
