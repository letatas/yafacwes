//
//  CWSExecutionVector+ConsolePalette.m
//  yafacwesConsole
//
//  Created by Matthias Lamoureux on 26/07/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import "CWSExecutionVector+ConsolePalette.h"
#import "CWSConsolePalette.h"

@implementation CWSExecutionVector (ConsolePalette)

- (NSString *) description:(BOOL) aColored {
    if (aColored) {
        NSString * color = [CWSConsolePalette consoleColorFromColorTag:self.colorTag];
        NSString * noColor = [CWSConsolePalette consoleColorFromColorTag:kPALETTE_COLOR_TAG_NO_COLOR];

        return [NSString stringWithFormat:@"%@%@%@",color,self.description,noColor];
    }
    else {
        return self.description;
    }
}

@end
