//
//  StringWithFormat.h
//  Tachcard
//
//  Created by admin on 21.09.16.
//  Copyright © 2016 Tachcard. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NewString [StringWithFormat sharedInstance]

@interface StringWithFormat : NSObject
+ (StringWithFormat*)sharedInstance;
- (NSString *)stringWithFormat: (NSString *)format withString:(NSString *)string;
- (NSString *)anyStringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement inString:(NSString *)string;
@end
