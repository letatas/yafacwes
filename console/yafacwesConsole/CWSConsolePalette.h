//
//  CWSConsolePalette.h
//  yafacwesConsole
//
//  Created by Matthias Lamoureux on 26/07/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWSInstructionColorTag.h"

#define kPALETTE_COLOR_TAG_RED 1
#define kPALETTE_COLOR_TAG_GREEN 2
#define kPALETTE_COLOR_TAG_BROWN_ORANGE 3
#define kPALETTE_COLOR_TAG_BLUE 4
#define kPALETTE_COLOR_TAG_PURPLE 5
#define kPALETTE_COLOR_TAG_CYAN 6
#define kPALETTE_COLOR_TAG_LIGHT_GRAY 7
#define kPALETTE_COLOR_TAG_LIGHT_RED 8
#define kPALETTE_COLOR_TAG_LIGHT_GREEN 9
#define kPALETTE_COLOR_TAG_YELLOW 10
#define kPALETTE_COLOR_TAG_LIGHT_BLUE 11
#define kPALETTE_COLOR_TAG_LIGHT_PURPLE 12
#define kPALETTE_COLOR_TAG_LIGHT_CYAN 13
#define kPALETTE_COLOR_TAG_WHITE 14
#define kPALETTE_COLOR_TAG_DARK_GRAY 15
#define kPALETTE_COLOR_TAG_BLACK 16
#define kPALETTE_COLOR_TAG_NO_COLOR 0

@interface CWSConsolePalette : NSObject

+ (NSString *) consoleColorFromColorTag:(CWSInstructionColorTag) aColorTag;

@end
