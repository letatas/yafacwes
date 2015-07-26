//
//  CWSConsoleTool.m
//  yafacwesConsole
//
//  Created by Matthias Lamoureux on 14/07/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import "CWSConsoleTool.h"
#import "CWSConsolePalette.h"

@implementation CWSConsoleTool

+ (NSString *) niceTitle:(BOOL) aColored {
    NSString * color = aColored?[CWSConsolePalette consoleColorFromColorTag:kPALETTE_COLOR_TAG_GREEN]:@"";
    NSString * noColor = aColored?[CWSConsolePalette consoleColorFromColorTag:kPALETTE_COLOR_TAG_NO_COLOR]:@"";
    
    NSMutableString * result = [NSMutableString string];
    
    [result appendString:@"****************************************************\n"];
    [result appendFormat:@"*    %@__  _____   _______  ______      __________   %@*\n", color, noColor];
    [result appendFormat:@"*    %@\\ \\/ / _ | / __/ _ |/ ___/ | /| / / __/ __/   %@*\n", color, noColor];
    [result appendFormat:@"*    %@ \\  / __ |/ _// __ / /__ | |/ |/ / _/_\\ \\     %@*\n", color, noColor];
    [result appendFormat:@"*    %@ /_/_/ |_/_/ /_/ |_\\___/ |__/|__/___/___/     %@*\n", color, noColor];
    [result appendString:@"*                                                  *\n"];
    [result appendString:@"****************************************************\n"];

    return result;
}

+ (NSDictionary *) parseParamsCount:(int) argc andValues:(const char **) argv {
    NSMutableDictionary * result = [NSMutableDictionary dictionaryWithCapacity:argc / 2];
    
    NSString * key = @"EXEC";
    
    for (int i = 0; i < argc; i++) {
        NSString * argument = [NSString stringWithCString:argv[i] encoding:NSUTF8StringEncoding];
        
        if (i%2 == 0) {
            result[key] = argument;
        }
        else {
            key = argument;
        }
    }
    
    return result;
}

+ (NSString *) usageOfExecutable:(NSString *) aExecutableName {
    NSMutableString * result = [NSMutableString string];
    
    [result appendString:@"Usage:\n"];
    [result appendFormat:@"    %@ --state <state_filename> [--steps <count>]\n", aExecutableName.lastPathComponent];
    [result appendString:@"<state_filename>: file containing a core state\n"];
    [result appendString:@"<count>         : the step counts the core state will execute\n"];
    
    return result;
}

@end
