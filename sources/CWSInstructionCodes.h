//
//  CWSInstructionCodes.h
//  yafacwesConsole
//
//  Created by Matthias Lamoureux on 19/07/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import "CWSCompat.h"

typedef NS_ENUM(NSInteger, CWSInstructionCode) {
    kCWSInstructionCodeNULL = 0,
    kCWSInstructionCodeLEFT,
    kCWSInstructionCodeRIGHT,
    kCWSInstructionCodeNOP,
    kCWSInstructionCodeWALL
};