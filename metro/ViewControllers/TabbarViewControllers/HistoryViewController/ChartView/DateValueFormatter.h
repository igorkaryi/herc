//
//  DateValueFormatter.h
//  ChartsDemo
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

#import <UIKit/UIKit.h>
#import "ChartView.h"
#import "HistoryModel.h"

@interface DateValueFormatter : NSObject <IChartAxisValueFormatter>
- (void)setupFormatterWithType: (HistoryPeriod) type data:(NSArray *)data;
@end
