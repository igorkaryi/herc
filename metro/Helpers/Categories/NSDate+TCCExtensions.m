//
//  NSDate+TCCExtensions.m
//  Tachcard
//
//  Created by Yaroslav Bulda on 08/10/15.
//  Copyright © 2015 Tachcard. All rights reserved.
//

#import "NSDate+TCCExtensions.h"

@implementation NSDate (TCCExtensions)

+ (long long)unixTimestampInMilliseconds {
    return (long long)floor([[NSDate date] timeIntervalSince1970] * 1000);
}

@end
