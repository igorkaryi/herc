//
//  AnyHelper.m
//  Tachcard
//
//  Created by admin on 14.03.16.
//  Copyright © 2016 Tachcard. All rights reserved.
//

#import "AnyHelper.h"

@implementation AnyHelper
static AnyHelper *instance = nil;

+(AnyHelper*)sharedInstance{
    if (!instance) {
        instance = [AnyHelper new];
    }
    return instance;
}

- (NSString *)formatPhoneNumber:(NSString *)aString {
    aString = [aString stringByReplacingOccurrencesOfString:@"(" withString:@""];
    aString = [aString stringByReplacingOccurrencesOfString:@")" withString:@""];
    aString = [aString stringByReplacingOccurrencesOfString:@" " withString:@""];
    aString = [aString stringByReplacingOccurrencesOfString:@" " withString:@""];
    aString = [aString stringByReplacingOccurrencesOfString:@" " withString:@""];
    aString = [aString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    aString = [aString stringByReplacingOccurrencesOfString:@"+" withString:@""];
    if (aString.length == 10) {
        aString = [NSString stringWithFormat:@"38%@",aString];
    }
    return aString;
}

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

- (BOOL)validateEmail:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}

@end
