//
//  TCCDateFormatter.h
//  Tachcard
//
//  Created by Yaroslav Bulda on 8/6/15.
//  Copyright (c) 2015 Tachcard. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TCCSharedFormatter [TCCFormatter sharedInstance]



@interface TCCFormatter : NSObject

+ (instancetype)sharedInstance;

- (NSDate *)dateFromNetString:(NSString *)string;

- (NSString *)fullDateStringFromDate:(NSDate *)date;
- (NSString *)relativeStringFromDate:(NSDate *)date;
- (NSString *)stringFromNetDate: (NSDate *)date;

- (NSString *)formattedCurency:(NSNumber *)amount;
- (NSDate*)dateUTCToLocal:(NSDate*)utc_date;
- (NSString *)stringFromLocalDate: (NSDate *)date;

- (NSDate *)utcDateFromStringWithFormat: (NSString *)format dateString:(NSString *)dateString;
- (NSString *)utcStringFromDateWithFormat: (NSString *)format date:(NSDate *)date;

- (NSDate *)localDateFromStringWithFormat: (NSString *)format dateString:(NSString *)dateString;
- (NSString *)localStringFromDateWithFormat: (NSString *)format date:(NSDate *)date;



@property (nonatomic, strong) NSDateFormatter *localDateFormatter;
@property (nonatomic, strong) NSDateFormatter *timeFormatter;
@end
