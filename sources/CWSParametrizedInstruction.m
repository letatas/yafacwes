//
//  CWSParametrizedInstruction.m
//  yafacwesConsole
//
//  Created by Matthias Lamoureux on 02/08/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import "CWSParametrizedInstruction.h"
#import "CWSDescriptableParameter.h"

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

- (NSString *)description {
    NSMutableString * result = [NSMutableString stringWithFormat:@"%ld",(long)self.code];
    
    if (self.parameter != nil) {
        if ([self.parameter conformsToProtocol:@protocol(CWSDescriptableParameter)]) {
            [result appendFormat:@"{%@}",[self.parameter parameterDescription]];
        }
        else {
            [result appendFormat:@"{%@}",[self.parameter description]];
        }
    }

    return result;
}

#pragma mark - Equality

- (BOOL)isEqualToParametrizedInstruction:(CWSParametrizedInstruction *) aParametrizedInstruction {
    if (!aParametrizedInstruction) {
        return NO;
    }
    
    BOOL haveEqualCodes = self.code == aParametrizedInstruction.code;
    BOOL haveEqualParams = (!self.parameter && !aParametrizedInstruction.parameter) || [self.parameter isEqualTo:aParametrizedInstruction.parameter];
    
    return haveEqualCodes && haveEqualParams;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[CWSParametrizedInstruction class]]) {
        return NO;
    }
    
    return [self isEqualToParametrizedInstruction:(CWSParametrizedInstruction *)object];
}

- (NSUInteger)hash {
    return self.code ^ [self.parameter hash];
}


@end
