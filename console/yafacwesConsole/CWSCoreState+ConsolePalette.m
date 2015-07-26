//
//  CWSCoreState+ConsolePalette.m
//  yafacwesConsole
//
//  Created by Matthias Lamoureux on 26/07/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import "CWSCoreState+ConsolePalette.h"
#import "CWSCoreState_Private.h"
#import "CWSConsolePalette.h"

@implementation CWSCoreState (ConsolePalette)

- (NSString *) description:(BOOL) aColored {
    if (aColored) {
        NSMutableString * result = [NSMutableString string];
        
        [self.executionVectors enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [result appendFormat:@"%@\n",[obj description:YES]];
        }];
        
        [result appendFormat:@"NEXT:%ld\n-\n",self.nextExecutionVectorIndex];
        
        NSString * color = @"";
        NSString * noColor = [CWSConsolePalette consoleColorFromColorTag:kPALETTE_COLOR_TAG_NO_COLOR];
        for (int y = 0; y < self.height; y++) {
            for (int x = 0; x < self.width; x++) {
                if (x > 0) {
                    [result appendString:@" "];
                }
                color = [CWSConsolePalette consoleColorFromColorTag:[self instructionColorTagAtPositionX:x andY:y]];

                [result appendFormat:@"%@%ld%@",color,[self instructionCodeAtPositionX:x andY:y],noColor];
            }
            [result appendString:@"\n"];
        }
        
        [result appendString:@"-\n"];
        
        for (int y = 0; y < self.height; y++) {
            if (y > 0) {
                [result appendString:@"\n"];
            }
            for (int x = 0; x < self.width; x++) {
                if (x > 0) {
                    [result appendString:@" "];
                }
                color = [CWSConsolePalette consoleColorFromColorTag:[self instructionColorTagAtPositionX:x andY:y]];
                [result appendFormat:@"%@%ld%@",color, [self instructionColorTagAtPositionX:x andY:y], noColor];
            }
        }
        
        return result;
    }
    else {
        return self.description;
    }
}


@end
