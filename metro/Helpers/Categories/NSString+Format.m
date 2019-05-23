//
//  NSString+Format.m
//  metro
//
//  Created by admin on 4/18/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "NSString+Format.h"

@implementation NSString (Format)

- (NSString *)stringByFormat: (NSString *)format {

    NSUInteger onOriginal = 0, onFilter = 0, onOutput = 0;
    char outputString[([format length])];
    BOOL done = NO;

    while(onFilter < [format length] && !done)
    {
        char filterChar = [format characterAtIndex:onFilter];
        char originalChar = onOriginal >= self.length ? '\0' : [self characterAtIndex:onOriginal];
        switch (filterChar) {
            case '#':
                if(originalChar=='\0')
                {
                    // We have no more input numbers for the filter.  We're done.
                    done = YES;
                    break;
                }
                if(isdigit(originalChar))
                {
                    outputString[onOutput] = originalChar;
                    onOriginal++;
                    onFilter++;
                    onOutput++;
                }
                else
                {
                    onOriginal++;
                }
                break;
            default:
                // Any other character will automatically be inserted for the user as they type (spaces, - etc..) or deleted as they delete if there are more numbers to come.
                outputString[onOutput] = filterChar;
                onOutput++;
                onFilter++;
                if(originalChar == filterChar)
                    onOriginal++;
                break;
        }
    }
    outputString[onOutput] = '\0'; // Cap the output string
    return [NSString stringWithUTF8String:outputString];
}

@end
