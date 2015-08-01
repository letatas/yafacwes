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
#import "CWSCoreState+ConsolePalette.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSDictionary * params = [CWSConsoleTool parseParamsCount:argc andValues:argv];
        NSString * stateFileName = params[@"--state"];

        BOOL colored = [params[@"--colored"] isEqualToString:@"YES"];
        [[CWSConsoleTool niceTitle:colored] stdoutPrintln];

        if (stateFileName == nil) {
            [[CWSConsoleTool usageOfExecutable:params[@"EXEC"]] stdoutPrintln];
        }
        else {
            CWSCoreState * coreState = [CWSCoreState coreStateWithContentsOfFile:stateFileName];
            
            [@"Initial State:" stdoutPrintln];
            [[coreState description:colored] stdoutPrintln];
            
            NSString * stepsParam = params[@"--steps"];
            NSInteger steps = (stepsParam == nil)?1:stepsParam.integerValue;
            
            for (NSInteger i = 0; i < steps; i++) {
                [[NSString stringWithFormat:@"\nStep %ld:",(long)(i+1)] stdoutPrintln];
                [coreState oneStep];
                [[coreState description:colored] stdoutPrintln];
            }
        }
    }
    return 0;
}
