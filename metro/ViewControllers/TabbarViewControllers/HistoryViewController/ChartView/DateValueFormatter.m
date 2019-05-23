//
//  DateValueFormatter.m
//  ChartsDemo
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//


#import "DateValueFormatter.h"


@interface DateValueFormatter () {
    NSDateFormatter *_dateFormatter;
    NSArray *xDataArray;
}
@end

@implementation DateValueFormatter

- (id)init {
    self = [super init];
    if (self) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *locale = [[NSLocale alloc]
                            initWithLocaleIdentifier:@"uk_UA"];
        [_dateFormatter setLocale:locale];
    }
    return self;
}

- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis {
    return xDataArray[(int)value][@"x"];
}

- (void)setupFormatterWithType: (HistoryPeriod) type data:(NSArray *)data {
    xDataArray = data;
    switch (type) {
        case dayPeriod: {
            _dateFormatter.dateFormat = @"d MMM";
        }
            break;
        case weekPeriod: {
            _dateFormatter.dateFormat = @"MMM";
        }
            break;
        case monthPeriod: {
            _dateFormatter.dateFormat = @"MMM";
        }
            break;

        default:
            break;
    }
}

@end
