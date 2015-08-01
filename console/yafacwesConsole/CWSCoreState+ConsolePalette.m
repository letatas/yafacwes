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
  
        // Clear screen
//        [result appendString:@"\x1B[2J\x1B[1;1H"];
        
        [self.executionVectors enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [result appendFormat:@"%@\n",[obj description:YES]];
        }];
        
        [result appendFormat:@"NEXT:%ld\n-\n",self.nextExecutionVectorIndex];
        
        NSString * color = @"";
        NSString * noColor = [CWSConsolePalette consoleColorFromColorTag:kPALETTE_COLOR_TAG_NO_COLOR];
        CWSPosition position = CWSPositionZero;
        for (position.y = 0; position.y < self.height; position.y++) {
            for (position.x = 0; position.x < self.width; position.x++) {
                if (position.x > 0) {
                    [result appendString:@" "];
                }
                color = [CWSConsolePalette consoleColorFromColorTag:[self instructionColorTagAtPosition:position]];

                [result appendFormat:@"%@%ld%@",color,[self instructionCodeAtPosition:position],noColor];
            }
            [result appendString:@"\n"];
        }
        
        return result;
    }
    else {
        return self.description;
    }
}


@end
