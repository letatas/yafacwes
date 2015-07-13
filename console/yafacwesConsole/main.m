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
        [@"******************************" stdoutPrintln];
        [@"*   Y  A  F  A  C  W  E  S   *" stdoutPrintln];
        [@"******************************" stdoutPrintln];
        
        CWSCore * core = [[CWSCore alloc] init];
        core.name = @"MIW Core";
        
        [core.name stdoutPrintln];        
    }
    return 0;
}
