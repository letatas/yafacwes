//
//  NSString+StdOut.m
//  yafacwesConsole
//
//  Created by Matthias Lamoureux on 13/07/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#import "NSString+StdOut.h"

@implementation NSString (StdOut)

- (void) stdoutPrint {
    [self writeToFile:@"/dev/stdout" atomically:NO encoding:NSUTF8StringEncoding error:NULL];
}

- (void) stdoutPrintln {
    [[self stringByAppendingString:@"\n"] stdoutPrint];
}

@end
