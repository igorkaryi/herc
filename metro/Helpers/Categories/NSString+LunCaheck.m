//
//  NSString+MD5.m
//  Tachcard
//
//  Created by Yaroslav Bulda on 7/13/15.
//  Copyright (c) 2015 Tachcard. All rights reserved.
//

#import "NSString+LunCaheck.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (LunCaheck)

- (NSMutableArray *) toCharArray {

    NSMutableArray *characters = [[NSMutableArray alloc] initWithCapacity:[self length]];
    for (int i=0; i < [self length]; i++) {
        NSString *ichar  = [NSString stringWithFormat:@"%c", [self characterAtIndex:i]];
        [characters addObject:ichar];
    }

    return characters;
}

- (BOOL) luhnCheck {

    NSMutableArray *stringAsChars = [self toCharArray];

    BOOL isOdd = YES;
    int oddSum = 0;
    int evenSum = 0;

    for (int i = (int)([self length] - 1); i >= 0; i--) {

        int digit = [(NSString *)[stringAsChars objectAtIndex:i] intValue];

        if (isOdd)
            oddSum += digit;
        else
            evenSum += digit/5 + (2*digit) % 10;

        isOdd = !isOdd;
    }

    return ((oddSum + evenSum) % 10 == 0);
}

@end
