//
//  TCCDateFormatter.m
//  Tachcard
//
//  Created by Yaroslav Bulda on 8/6/15.
//  Copyright (c) 2015 Tachcard. All rights reserved.
//

#import "TCCFormatter.h"
#import "GCDSingleton.h"

@interface TCCFormatter ()

@property (nonatomic, strong) NSDateFormatter *netDateFormatter;
@property (nonatomic, strong) NSDateFormatter *fullDateFormatter;
@property (nonatomic, strong) NSDateFormatter *relativeDateFormatter;
@property (nonatomic, strong) NSDateFormatter *appleDateFormatter;

@property (nonatomic, strong) NSCalendar *currentCalendar;

@property (nonatomic, strong) NSNumberFormatter *currencyFormatter;

@property (nonatomic, strong) NSDateFormatter *utcDateFormatter;



@end

@implementation TCCFormatter

#pragma mark -
#pragma mark Singletone

+ (instancetype)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [self new];
    });
}

#pragma mark -
#pragma mark Lifecycle methods

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUpNetFormatter];
        [self setUpFullFormatter];
        [self setUpRelativeFormatter];
        [self setUpCurrencyFormatter];
        [self setUpAppleFormatter];
        [self setUpLocalFormatter];
        [self setUpTimeFormatter];
        [self setUpUtcFormatter];
        
        self.currentCalendar = [NSCalendar currentCalendar];
    }
    return self;
}

- (void)setUpUtcFormatter {
    self.utcDateFormatter = [NSDateFormatter new];
    [self.utcDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [self.utcDateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"uk_UA"]];
}

- (void)setUpLocalFormatter {
    self.localDateFormatter = [NSDateFormatter new];
    [self.localDateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [self.localDateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"uk_UA"]];
}






- (void)setUpNetFormatter {
    self.netDateFormatter = [NSDateFormatter new];
    //[self.netDateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
    [self.netDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [self.netDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];//[NSTimeZone timeZoneWithName:@"UTC"] //[NSTimeZone timeZoneForSecondsFromGMT:0]
}

- (void)setUpFullFormatter {
    self.fullDateFormatter = [NSDateFormatter new];
    [self.fullDateFormatter setDateFormat:@"dd MMM yyyy HH:mm"];
}

- (void)setUpAppleFormatter {
    self.appleDateFormatter = [NSDateFormatter new];
    [self.appleDateFormatter setDateFormat:@"dd.MM.yyyy"];
}

- (void)setUpTimeFormatter {
    self.timeFormatter = [NSDateFormatter new];
    [self.timeFormatter setDateFormat:@"HH:mm"];
    [self.timeFormatter setTimeZone:[NSTimeZone systemTimeZone]];
}

- (void)setUpRelativeFormatter {
    self.relativeDateFormatter = [[NSDateFormatter alloc] init];
    [self.relativeDateFormatter setDateStyle:NSDateFormatterNoStyle];
    [self.relativeDateFormatter setTimeStyle:NSDateFormatterShortStyle];
    self.relativeDateFormatter.doesRelativeDateFormatting = YES;
}

- (void)setUpCurrencyFormatter {
    self.currencyFormatter = [[NSNumberFormatter alloc] init];
    self.currencyFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    self.currencyFormatter.locale = [NSLocale currentLocale];
    self.currencyFormatter.maximumFractionDigits = 2;
    self.currencyFormatter.currencySymbol = @"";
    self.currencyFormatter.currencyGroupingSeparator = @"";
    self.currencyFormatter.usesGroupingSeparator = NO;
}

- (NSDate*)dateUTCToLocal:(NSDate*)utc_date {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"LLL d, yyyy - HH:mm:ss zzz";
    NSDate *utc = utc_date;
    fmt.timeZone = [NSTimeZone systemTimeZone];
    NSString *local = [fmt stringFromDate:utc];
    return [fmt dateFromString:local];
}

#pragma mark -
#pragma mark DateFormating

- (NSDate *)utcDateFromStringWithFormat: (NSString *)format dateString:(NSString *)dateString {
    [self.utcDateFormatter setDateFormat:format];
    return [self.utcDateFormatter dateFromString:dateString];
}

- (NSString *)utcStringFromDateWithFormat: (NSString *)format date:(NSDate *)date {
    [self.utcDateFormatter setDateFormat:format];
    return [self.utcDateFormatter stringFromDate:date];
}

- (NSDate *)localDateFromStringWithFormat: (NSString *)format dateString:(NSString *)dateString {
    [self.localDateFormatter setDateFormat:format];
    return [self.localDateFormatter dateFromString:dateString];
}

- (NSString *)localStringFromDateWithFormat: (NSString *)format date:(NSDate *)date {
    [self.localDateFormatter setDateFormat:format];
    return [self.localDateFormatter stringFromDate:date];
}



- (NSString *)stringFromLocalDate: (NSDate *)date {
    return [self.localDateFormatter stringFromDate:date];
}

- (NSDate *)dateFromNetString:(NSString *)string {
    return [self.netDateFormatter dateFromString:string];
}

- (NSString *)stringFromNetDate: (NSDate *)date {
    return [self.netDateFormatter stringFromDate:date];
}

- (NSString *)fullDateStringFromDate:(NSDate *)date {
    return [self.fullDateFormatter stringFromDate:date];
}

- (NSString *)relativeStringFromDate:(NSDate *)date {
    if (!date) {
        return @"";
    }

    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitWeekday;
    //unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSWeekdayCalendarUnit;
    
    NSDateComponents *comps = [self.currentCalendar components:unitFlags fromDate:date];
    [comps setHour:0];
    [comps setMinute:0];
    [comps setSecond:0];
    NSDate *suppliedDate = [self.currentCalendar dateFromComponents:comps];
    
    NSDate *currentDate = [NSDate date];
    
    for (int i = -1; i < 7; i++) {
        comps = [self.currentCalendar components:unitFlags fromDate:currentDate];
        [comps setHour:0];
        [comps setMinute:0];
        [comps setSecond:0];
        [comps setDay:[comps day] - i];
        NSDate *referenceDate = [self.currentCalendar dateFromComponents:comps];
        
        long weekday = [[self.currentCalendar components:unitFlags fromDate:referenceDate] weekday] - 1;
        
        if ([suppliedDate compare:referenceDate] == NSOrderedSame && i == 0) {
            [self.relativeDateFormatter setDateStyle:NSDateFormatterNoStyle];
            [self.relativeDateFormatter setTimeStyle:NSDateFormatterShortStyle];
            return [self.relativeDateFormatter stringFromDate:[self dateUTCToLocal:date]];
        } else if ([suppliedDate compare:referenceDate] == NSOrderedSame && i == 1) {
            return @"Вчера";
        } else if ([suppliedDate compare:referenceDate] == NSOrderedSame) {
            NSString *day = [[self.relativeDateFormatter weekdaySymbols] objectAtIndex:weekday];
            return day;
        }
    }
    
    NSString *defaultDate = [self.appleDateFormatter stringFromDate:date];
    return defaultDate;
}

#pragma mark -
#pragma mark CurrencyFormating

- (NSString *)formattedCurency:(NSNumber *)amount {
    NSString *amountStr = [[self.currencyFormatter stringFromNumber:amount] stringByReplacingOccurrencesOfString:self.currencyFormatter.groupingSeparator withString:@""];
    return [amountStr stringByReplacingOccurrencesOfString:@"." withString:@","];
}


@end
