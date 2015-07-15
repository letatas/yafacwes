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

@end
