//
//  CWSDirection.m
//  yafacwesConsole
//
//  Created by Matthias Lamoureux on 13/07/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import "CWSDirection.h"

CWSDirection leftDirection(CWSDirection aDirection) {
    return (CWSDirection)((aDirection + 3) % 4);
}

CWSDirection rightDirection(CWSDirection aDirection) {
    return (CWSDirection)((aDirection + 1) % 4);
}
