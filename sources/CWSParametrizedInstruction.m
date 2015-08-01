//
//  CWSParametrizedInstruction.m
//  yafacwesConsole
//
//  Created by Matthias Lamoureux on 02/08/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import "CWSParametrizedInstruction.h"

@implementation CWSParametrizedInstruction

- (instancetype) initWithCode:(CWSInstructionCode) aCode andParameter:(id) aParameter {
    self = [super init];
    
    if (self) {
        self.code = aCode;
        self.parameter = aParameter;
    }
    
    return self;

}

+ (instancetype) parametrizedInstructionWithCode:(CWSInstructionCode) aCode andParameter:(id) aParameter {
    return [[self alloc] initWithCode:aCode andParameter:aParameter];
}

@end
