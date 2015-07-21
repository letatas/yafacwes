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

NSString * directionToString(CWSDirection aDirection) {
    switch (aDirection) {
        case CWSDirectionNorth: return @"N";
        case CWSDirectionEast: return @"E";
        case CWSDirectionSouth: return @"S";
        case CWSDirectionWest: return @"W";
    }
}

CWSDirection directionFromString(NSString * aDirection) {
  if (aDirection != nil) {
      if ([aDirection isEqual:@"N"]) {
	return CWSDirectionNorth;
      } else if ([aDirection isEqual:@"E"]) {
	return CWSDirectionEast;
      } else if ([aDirection isEqual:@"S"]) {
	return CWSDirectionSouth;
      } else if ([aDirection isEqual:@"W"]) {
	return CWSDirectionWest;
      }
  }
  NSException * badParam = [NSException exceptionWithName:@"BadDirectionException" reason:[NSString stringWithFormat:@"Invalid direction : %@",aDirection] userInfo:nil];
  [badParam raise];
  // never reached
  return CWSDirectionNorth;
}