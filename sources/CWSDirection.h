//
//  CWSDirection.h
//  yafacwesConsole
//
//  Created by Matthias Lamoureux on 13/07/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWSCompat.h"

typedef NS_ENUM(NSInteger, CWSDirection) {
    CWSDirectionNorth = 0,
    CWSDirectionEast,
    CWSDirectionSouth,
    CWSDirectionWest
};

CWSDirection leftDirection(CWSDirection aDirection);
CWSDirection rightDirection(CWSDirection aDirection);

NSString * directionToString(CWSDirection aDirection);
CWSDirection directionFromString(NSString * aDirection);
