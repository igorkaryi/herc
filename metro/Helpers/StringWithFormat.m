//
//  StringWithFormat.m
//  Tachcard
//
//  Created by admin on 21.09.16.
//  Copyright © 2016 Tachcard. All rights reserved.
//

#import "StringWithFormat.h"
#import "SHSPhoneLibrary.h"

@implementation StringWithFormat
static StringWithFormat *instance = nil;
SHSPhoneTextField *phoneTextField;

+(StringWithFormat*)sharedInstance{
    if (!instance) {
        instance = [StringWithFormat new];
    }
    return instance;
}

- (BOOL)isStringNumeric:(NSString *)text
{
    NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:text];
    return [alphaNums isSupersetOfSet:inStringSet];
}

- (BOOL)isPhoneString: (NSString *)string {
    if ([[string substringToIndex:1] isEqualToString:@"+"]) {
        if ([self isStringNumeric:[string substringFromIndex:1]]) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return [self isStringNumeric:string];
    }
}

- (NSString *)stringWithFormat: (NSString *)format withString:(NSString *)string {
    if (!phoneTextField) {
        phoneTextField = [SHSPhoneTextField new];
    }
    if (string.length >= 10 && [self isPhoneString:string] && ([string rangeOfString:@"*"].location == NSNotFound)) {
        [phoneTextField.formatter addOutputPattern:@"### ## ### ## ##" forRegExp:@"^380\\d*$"];
        [phoneTextField.formatter addOutputPattern:format forRegExp:@"^\\d*$"];
        [phoneTextField.formatter addOutputPattern:format forRegExp:@"^0\\d*$"];

        [phoneTextField setFormattedText:string];
        if (phoneTextField.text.length == 16 && [[phoneTextField.text substringToIndex:1] isEqualToString:@"3"]) {
            return [NSString stringWithFormat:@"+%@",phoneTextField.text];
        } else {
            return phoneTextField.text;
        }
    } else {
        return string;
    }
}


- (NSString *)anyStringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement inString:(NSString *)string {
    NSString *tmpStr = [NSString stringWithFormat:@"%@",string];
    return [tmpStr stringByReplacingOccurrencesOfString:target withString:replacement];
}

@end
