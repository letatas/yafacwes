//
//  CWSConsoleTool.h
//  yafacwesConsole
//
//  Created by Matthias Lamoureux on 14/07/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CWSConsoleTool : NSObject

+ (NSString *) niceTitle;
+ (NSDictionary *) parseParamsCount:(int) argc andValues:(const char **) argv;
+ (NSString *) usageOfExecutable:(NSString *) aExecutableName;

@end
