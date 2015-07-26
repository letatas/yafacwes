//
//  CWSConsolePalette.m
//  yafacwesConsole
//
//  Created by Matthias Lamoureux on 26/07/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import "CWSConsolePalette.h"

@implementation CWSConsolePalette

+ (NSString *) consoleColorFromColorTag:(CWSInstructionColorTag) aColorTag {
    switch (aColorTag) {
        case 1: return @"\033[0;31m"; // Red
        case 2: return @"\033[0;32m"; // Green
        case 3: return @"\033[0;33m"; // Brown/Orange
        case 4: return @"\033[0;34m"; // Blue
        case 5: return @"\033[0;35m"; // Purple
        case 6: return @"\033[0;36m"; // Cyan
        case 7: return @"\033[0;37m"; // Light Gray
        case 8: return @"\033[1;31m"; // Light Red
        case 9: return @"\033[1;32m"; // Light Green
        case 10: return @"\033[1;33m"; // Yellow
        case 11: return @"\033[1;34m"; // Light Blue
        case 12: return @"\033[1;35m"; // Light Purple
        case 13: return @"\033[1;36m"; // Light Cyan
        case 14: return @"\033[1;37m"; // White
        case 15: return @"\033[1;30m"; // Dark Gray
        case 16: return @"\033[0;30m"; // Black
        default: return @"\033[0m"; // No color
    }
}


@end
