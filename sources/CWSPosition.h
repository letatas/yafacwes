//
//  CWSPosition.h
//  yafacwesConsole
//
//  Created by Matthias Lamoureux on 01/08/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWSDescriptableParameter.h"

struct CWSPosition {
    NSInteger x;
    NSInteger y;
};
typedef struct CWSPosition CWSPosition;


extern CWSPosition CWSPositionMake(NSInteger x, NSInteger y);
extern NSString * NSStringFromPosition(CWSPosition aPosition);
extern const CWSPosition CWSPositionZero;
extern CWSPosition CWSPositionAdd(CWSPosition a, CWSPosition b);

@interface NSValue (CWSPosition) <CWSDescriptableParameter>

+ (NSValue *)valueWithPosition:(CWSPosition)position;

@property (readonly) CWSPosition positionValue;

@end

@interface NSScanner (CWSPosition)

- (BOOL) scanPosition: (CWSPosition *) position;
- (BOOL) scanPositions: (NSMutableArray *) positions;

@end
