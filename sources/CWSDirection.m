//
//  CWSDirection.m
//  yafacwesConsole
//
//  Created by Matthias Lamoureux on 13/07/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import "CWSDirection.h"

#define DIRECTION_COUNT 4

CWSDirection leftDirection(CWSDirection aDirection) {
    return (CWSDirection)((aDirection + DIRECTION_COUNT - 1) % DIRECTION_COUNT);
}

CWSDirection rightDirection(CWSDirection aDirection) {
    return (CWSDirection)((aDirection + 1) % DIRECTION_COUNT);
}
