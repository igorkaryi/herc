//
//  AnyHelper.h
//  Tachcard
//
//  Created by admin on 14.03.16.
//  Copyright © 2016 Tachcard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnyHelper : NSObject
+ (AnyHelper*)sharedInstance;
- (NSString *)formatPhoneNumber:(NSString *)aString;
- (NSString *)digitOnlyString:(NSString *)aString;
- (BOOL)validateEmail:(NSString *)emailStr;
@property (nonatomic, retain) UIImage *screenshotImage;

@end
