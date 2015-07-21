//
//  CWSMiscellaneousTests.m
//  yafacwesConsole
//
//  Created by Matthias Lamoureux on 21/07/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>

@interface CWSMiscellaneousTests : XCTestCase

@end

@implementation CWSMiscellaneousTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testEncodeTypeOf {
    // Arrange
    NSUInteger count = 3;
    NSArray * tab = @[@1,@2,@3];
    
    // Act
    char * encodeUInt = @encode(typeof(count));
    char * encodePropertyCall = @encode(typeof(tab.count));
    char * encodeMethodCall = @encode(typeof([tab count]));
    
    BOOL encodeUIntOk = encodeUInt[0] == 'Q';
    BOOL encodePropertyCallOk = encodePropertyCall[0] == 'Q';
    BOOL encodeMethodCallOk = encodeMethodCall[0] == 'Q';
    
    // Assert
    XCTAssert(encodeUIntOk);
    XCTAssert(encodePropertyCallOk);
    XCTAssert(encodeMethodCallOk);
}

@end
