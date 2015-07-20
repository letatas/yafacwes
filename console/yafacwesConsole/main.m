//
//  main.m
//  yafacwesConsole
//
//  Created by Matthias Lamoureux on 13/07/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWSCategories.h"
#import "CWSCoreState.h"
#import "CWSConsoleTool.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        [[CWSConsoleTool niceTitle] stdoutPrintln];
        
        NSDictionary * params = [CWSConsoleTool parseParamsCount:argc andValues:argv];
        NSString * stateFileName = params[@"--state"];
        
        if (stateFileName == nil) {
            [[CWSConsoleTool usageOfExecutable:params[@"EXEC"]] stdoutPrintln];
        }
        else {
            CWSCoreState * coreState = [CWSCoreState coreStateWithContentsOfFile:stateFileName];
            
            [@"Initial State:" stdoutPrintln];
            [coreState.description stdoutPrintln];
            
            [@"\nStep 1:" stdoutPrintln];
            [coreState oneStep];
            [coreState.description stdoutPrintln];
        }
    }
    return 0;
}
