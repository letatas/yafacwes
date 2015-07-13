//
//  main.m
//  yafacwesConsole
//
//  Created by Matthias Lamoureux on 13/07/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWSCategories.h"
#import "CWSCore.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        [@"****************************************************" stdoutPrintln];
        [@"*    __  _____   _______  ______      __________   *" stdoutPrintln];
        [@"*    \\ \\/ / _ | / __/ _ |/ ___/ | /| / / __/ __/   *" stdoutPrintln];
        [@"*     \\  / __ |/ _// __ / /__ | |/ |/ / _/_\\ \\     *" stdoutPrintln];
        [@"*     /_/_/ |_/_/ /_/ |_\\___/ |__/|__/___/___/     *" stdoutPrintln];
        [@"*                                                  *" stdoutPrintln];
        [@"****************************************************" stdoutPrintln];
        [@"" stdoutPrintln];
        
        CWSCore * core = [[CWSCore alloc] init];
        core.name = @"MIW Core";
        
        [core.name stdoutPrintln];
    }
    return 0;
}
