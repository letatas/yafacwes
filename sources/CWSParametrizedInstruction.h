//
//  CWSParametrizedInstruction.h
//  yafacwesConsole
//
//  Created by Matthias Lamoureux on 02/08/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWSInstructionCodes.h"

@interface CWSParametrizedInstruction : NSObject

@property (nonatomic, assign) CWSInstructionCode code;
@property (nonatomic, strong) id parameter;

+ (instancetype) parametrizedInstructionWithCode:(CWSInstructionCode) aCode andParameter:(id) aParameter;

@end
