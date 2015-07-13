//
//  CWSDirection.m
//  yafacwesConsole
//
//  Created by Matthias Lamoureux on 13/07/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import "CWSDirection.h"

#define kDIRECTION_COUNT 4

CWSDirection leftDirection(CWSDirection aDirection) {
    return (CWSDirection)((aDirection + kDIRECTION_COUNT - 1) % kDIRECTION_COUNT);
}

CWSDirection rightDirection(CWSDirection aDirection) {
    return (CWSDirection)((aDirection + 1) % kDIRECTION_COUNT);
}
