//
//  ChartView.h
//  metro
//
//  Created by admin on 4/26/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryModel.h"
@import Charts;

@protocol ChartViewCustomDelegate <NSObject>
- (void)chartDataSelect: (NSString *_Nullable)data;
@end

@interface ChartView : UIView

- (instancetype _Nonnull )initWithFrame:(CGRect)frame;

@property (nonatomic, strong) IBOutlet BarLineChartViewBase * _Nonnull chartView;
@property (nonatomic, strong) IBOutlet UISlider * _Nullable sliderX;
@property (nonatomic, strong) IBOutlet UISlider * _Nullable sliderY;
@property (nonatomic, strong) IBOutlet UITextField * _Nullable sliderTextX;
@property (nonatomic, strong) IBOutlet UITextField * _Nullable sliderTextY;
@property (nonatomic, assign) BOOL shouldHideData;

- (void)updateChartWithData: (NSArray *)dataArray andType:(HistoryPeriod) type emptyCount: (int)emptyCount;

@property (weak, nonatomic) NSObject <ChartViewCustomDelegate> * _Nullable delgate;

@end
