//
//  SHSPhoneAnyFormatter.m
//  Tachcard
//
//  Created by admin on 19.02.16.
//  Copyright © 2016 Tachcard. All rights reserved.
//

#import "SHSPhoneAnyFormatter.h"

@implementation SHSPhoneAnyFormatter

- (NSString *)digitOnlyString:(NSString *)aString {
    aString = [aString stringByReplacingOccurrencesOfString:@"(" withString:@""];
    aString = [aString stringByReplacingOccurrencesOfString:@")" withString:@""];
    aString = [aString stringByReplacingOccurrencesOfString:@" " withString:@""];
    aString = [aString stringByReplacingOccurrencesOfString:@" " withString:@""];
    aString = [aString stringByReplacingOccurrencesOfString:@" " withString:@""];
    aString = [aString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    aString = [aString stringByReplacingOccurrencesOfString:@"+" withString:@""];
    return aString;
}

- (NSString *)deleteFormat: (NSString *)string {
    if ([[self->config allKeys]containsObject:@".*"]) {
        if ([[self->config[@".*"] allKeys]containsObject:@"format"]) {

            NSMutableString *str = [NSMutableString stringWithString:string];
            NSString *formatString = self->config[@".*"][@"format"];
            
            for (int i = 0; i<string.length; i++) {
                NSRange range = NSMakeRange(i, 1);

                if (![[formatString substringWithRange:range] isEqualToString:@"#"]) {
                    [str replaceCharactersInRange:range withString:@"☼"];
                }
            }
            return [str stringByReplacingOccurrencesOfString:@"☼" withString:@""];
        }
    }
    return string;
}

@end
