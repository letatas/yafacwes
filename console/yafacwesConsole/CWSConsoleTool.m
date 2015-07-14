//
//  CWSConsoleTool.m
//  yafacwesConsole
//
//  Created by Matthias Lamoureux on 14/07/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import "CWSConsoleTool.h"

@implementation CWSConsoleTool

+ (NSString *) niceTitle {
    NSMutableString * result = [NSMutableString string];
    
    [result appendString:@"****************************************************\n"];
    [result appendString:@"*    __  _____   _______  ______      __________   *\n"];
    [result appendString:@"*    \\ \\/ / _ | / __/ _ |/ ___/ | /| / / __/ __/   *\n"];
    [result appendString:@"*     \\  / __ |/ _// __ / /__ | |/ |/ / _/_\\ \\     *\n"];
    [result appendString:@"*     /_/_/ |_/_/ /_/ |_\\___/ |__/|__/___/___/     *\n"];
    [result appendString:@"*                                                  *\n"];
    [result appendString:@"****************************************************\n"];

    return result;
}

@end
