//
//  ChartView.m
//  metro
//
//  Created by admin on 4/26/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "ChartView.h"
#import "UIView+LoadNib.h"
#import "DateValueFormatter.h"

@interface ChartView ()
@property ChartHighlight *selectedhlight;
@end

@implementation ChartView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self loadNib];
    [self setFrame:frame];
    [self initView];
    return self;
}

- (void)initView {
    [self setupBarLineChartView:_chartView];
}

- (void)setupBarLineChartView:(BarLineChartViewBase *)chartView {

    chartView.delegate = (id)self;
    chartView.backgroundColor = [UIColor clearColor];

    chartView.noDataText = @"";

    chartView.minOffset = 0;
    chartView.chartDescription.enabled = NO;
    chartView.pinchZoomEnabled = NO;
    chartView.doubleTapToZoomEnabled = NO;
    chartView.dragEnabled = YES;
    [chartView setScaleEnabled:YES];
    chartView.rightAxis.minWidth = 0;
    chartView.leftAxis.minWidth = 0;
    chartView.rightAxis.enabled = NO;
    chartView.leftAxis.enabled = YES;
    chartView.legend.form = ChartLegendFormNone;
    chartView.chartDescription.enabled = NO;
    chartView.legend.enabled = NO;

    ChartYAxis *leftAxis = chartView.leftAxis;
    [leftAxis removeAllLimitLines];
    leftAxis.drawLabelsEnabled = NO;
    leftAxis.drawZeroLineEnabled = NO;
    leftAxis.drawLimitLinesBehindDataEnabled = NO;
    leftAxis.gridColor = _RGBA(255, 255, 255, 0.1);
    leftAxis.drawAxisLineEnabled = NO;
    leftAxis.axisMinimum = 0.0;
    leftAxis.spaceTop = 0.15;


    ChartXAxis *xAxis = chartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.labelFont = [UIFont fontWithName:@"ProbaNav2-Regular" size:12];
    xAxis.drawGridLinesEnabled = NO;
    xAxis.labelTextColor = [UIColor whiteColor];
    xAxis.drawAxisLineEnabled = YES;
    xAxis.axisLineColor = UIColorFromRGB(0x2D9462);
    xAxis.granularity = 1.0;

    xAxis.valueFormatter = [[DateValueFormatter alloc] init];

    chartView.scaleXEnabled = YES;
    chartView.scaleYEnabled = NO;
}

- (void)updateChartWithData: (NSArray *)dataArray andType:(HistoryPeriod) type emptyCount: (int)emptyCount {
    if (self.shouldHideData) {
        _chartView.data = nil;
        return;
    }

    float scaleValue = dataArray.count/5.0;
    [_chartView zoomWithScaleX:0 scaleY:1 x:0 y:0];
    [_chartView zoomWithScaleX:scaleValue scaleY:1 x:0 y:0];

    [(DateValueFormatter *)_chartView.xAxis.valueFormatter setupFormatterWithType:type data:dataArray];

    NSMutableArray *values = [[NSMutableArray alloc] init];
    for (int i = 0; i < [dataArray count]; i++) {
        double val = [dataArray[i][@"y"]doubleValue];
        [values addObject:[[BarChartDataEntry alloc] initWithX:i y:val icon: [UIImage imageNamed:@"icon"]]];
    }

//    BarChartDataSet *set1 = nil;
//    set1 = [[BarChartDataSet alloc] initWithValues:values label:nil];
//    [set1 setColors:@[UIColorFromRGB(0x2D9462)]];
//    set1.highlightColor = UIColorFromRGB(0x50F299);
//    set1.highlightAlpha = 1;
//    set1.drawValuesEnabled = NO;

    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    //[dataSets addObject:set1];

    BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
    data.barWidth = 0.98;

    _chartView.data = data;

    int hightliteCount = 0;

//    if (emptyCount > 0) {
//        hightliteCount = (int)set1.entryCount - emptyCount;
//        [_chartView highlightValueWithX:hightliteCount-1 dataSetIndex:0 callDelegate:YES];
//    } else {
//        hightliteCount = (int)set1.entryCount;
//        [_chartView highlightValueWithX:hightliteCount dataSetIndex:0 callDelegate:YES];
//    }

//    if ([self.delgate respondsToSelector:@selector(chartDataSelect:)]) {
//        [self.delgate chartDataSelect:[NSString stringWithFormat:@"%f",[set1 entryForIndex:hightliteCount-1].y]];
//    }
}


#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight {
    self.selectedhlight = highlight;
    if (entry.y>0) {

        if ([self.delgate respondsToSelector:@selector(chartDataSelect:)]) {
            [self.delgate chartDataSelect:[NSString stringWithFormat:@"%f",entry.y]];
        }
    }
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView {
    NSLog(@"chartValueNothingSelected");
    [_chartView highlightValue:self.selectedhlight];
}

- (void)updateChartData {

}
@end

