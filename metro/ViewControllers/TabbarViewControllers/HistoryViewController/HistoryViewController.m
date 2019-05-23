//
//  HistoryViewController.m
//  metro
//
//  Created by admin on 4/20/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "HistoryViewController.h"

#import "BLKFlexibleHeightBar.h"
#import "SquareCashStyleBehaviorDefiner.h"
#import "BLKDelegateSplitter.h"

#import "HowWorkViewController.h"

#import "HistoryPaymentCell.h"
#import "HistoryTripsCell.h"

#import "CornerCell.h"
#import "TCCHTTPSessionManager.h"

#import "ChartView.h"
#import "HistoryModel.h"

#import "StatsDays.h"
#import "StatsMonths.h"
#import "StatsWeeks.h"
#import "TCCFormatter.h"


typedef NS_ENUM(NSUInteger, tableDataType) {
    tableDataTypeTrips = 0,
    tableDataTypePayments
};

@interface HistoryViewController ()
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) IBOutlet BLKFlexibleHeightBar *myCustomBar;
@property (nonatomic) BLKDelegateSplitter *delegateSplitter;
@property NSIndexPath * selectedCell;

@property (nonatomic, retain) NSArray *paymentsArray;
@property (nonatomic, retain) NSArray *tripsArray;

@property (nonatomic, retain) IBOutlet UIView *statusView;
@property (nonatomic, retain) IBOutlet NSLayoutConstraint *buttonStatusViewConstraint;

@property (nonatomic, retain) IBOutlet UIView *filterView;
@property (nonatomic, retain) IBOutlet NSLayoutConstraint *filterViewConstraint;


@property (nonatomic, retain) IBOutlet UIView *noHistoryView;
@property (nonatomic, retain) IBOutlet UIView *chartParentView;

@property tableDataType currentTableDataType;

//@property (nonatomic, retain) NSDateFormatter *dateFormatter;

@property (nonatomic, retain) ChartView *chart;

@property (nonatomic, retain) IBOutlet UILabel *tripsCountLabel;
@property (nonatomic, retain) IBOutlet UILabel *tripsAmountLabel;

@property (nonatomic, retain) RLMResults *historyTripsResults;
@property (nonatomic, retain) RLMResults *historyPaymentsResults;

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillAppear:) name:@"tabHistoryWillApper" object:nil];

    self.historyTripsResults = HistoryTrips.allObjects;
    self.historyPaymentsResults = HistoryPayments.allObjects;

    self.currentTableDataType = tableDataTypeTrips;

    self.myCustomBar.minimumBarHeight = 70;
    SquareCashStyleBehaviorDefiner *behaviorDefiner = [[SquareCashStyleBehaviorDefiner alloc] init];
    [behaviorDefiner addSnappingPositionProgress:0.0 forProgressRangeStart:0.0 end:0.5];
    [behaviorDefiner addSnappingPositionProgress:1.0 forProgressRangeStart:0.5 end:1.0];
    behaviorDefiner.elasticMaximumHeightAtTop = YES;
    self.myCustomBar.behaviorDefiner = behaviorDefiner;

    self.delegateSplitter = [[BLKDelegateSplitter alloc] initWithFirstDelegate:behaviorDefiner secondDelegate:self];
    self.tableView.delegate = (id<UITableViewDelegate>)self.delegateSplitter;
    [self.tableView registerNib:[UINib nibWithNibName:@"HistoryPaymentCell" bundle:nil] forCellReuseIdentifier:@"HistoryPaymentCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HistoryTripsCell" bundle:nil] forCellReuseIdentifier:@"HistoryTripsCell"];

    self.chart = [[ChartView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.chartParentView.bounds.size.height)];
    self.chart.delgate = (id)self;
    [self addSubView:self.chart toVeiw:self.chartParentView];
    [self.view layoutIfNeeded];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.myCustomBar.translatesAutoresizingMaskIntoConstraints = YES;
        if ([self.historyTripsResults count]>0) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    });

//    self.dateFormatter = [[NSDateFormatter alloc] init];
//    [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
//    NSLocale *locale = [[NSLocale alloc]
//                        initWithLocaleIdentifier:@"uk_UA"];
//    [self.dateFormatter setLocale:locale];
//    [self.dateFormatter setDateFormat:@"d MMMM"];

    UIButton *tmp = [UIButton new];
    [tmp setTag:1];
    [self filterHandler:tmp];

    [self.tableView reloadData];
}



- (void)viewWillAppear:(BOOL)animated {
    if ([[self topViewController] isKindOfClass:[HistoryViewController class]]) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
    self.tableView.contentInset = UIEdgeInsetsMake(self.myCustomBar.maximumBarHeight, 0.0, 0.0, 0.0);
    [self loadData];
}

- (void)addSubView: (UIView *)subView toVeiw: (UIView *)parentView {
    if (!subView) {
        return;
    }
    [[parentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [parentView addSubview:subView];
    subView.translatesAutoresizingMaskIntoConstraints = NO;
    [subView setBackgroundColor:[UIColor clearColor]];

    //NSLayoutConstraint *trailing =[NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.f];

    //NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.f];

    NSLayoutConstraint *right =[NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.f];

    NSLayoutConstraint *left =[NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.f];

    NSLayoutConstraint *bottom =[NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.f];

    NSLayoutConstraint *top =[NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.f];

    //[parentView addConstraint:trailing];
    //[parentView addConstraint:leading];

    [parentView addConstraint:right];
    [parentView addConstraint:left];
    [parentView addConstraint:bottom];
    [parentView addConstraint:top];
}

- (void)loadData {
    if ([self.historyPaymentsResults count] == 0 && [self.historyTripsResults count] == 0) {
        //[self showHud];
        [self.view setUserInteractionEnabled:NO];
    }
    @weakify(self);
    [SharedHistoryModel loadHistoryWithCompletion:^(id responseObject, NSString *errorStr) {
        @strongify(self);
        [self.view setUserInteractionEnabled:YES];
       // [self hideHud];
        if (errorStr) {
            [UIAlertController showAlertInViewController:self withTitle:@"" message:errorStr cancelButtonTitle:@"Ок" destructiveButtonTitle:nil otherButtonTitles:nil textFieldPlaceholders:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            }];
        } else {
            self.historyTripsResults = HistoryTrips.allObjects;
            self.historyPaymentsResults = HistoryPayments.allObjects;

            //NSLog(@"%@",self.historyTripsResults);
            //NSLog(@"%@",self.historyPaymentsResults);

            UIButton *tmp = [UIButton new];
            [tmp setTag:1];
            [self filterHandler:tmp];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark -
#pragma mark UITableView delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.frameWidth-25.f, 20.f)];
    [title setFont:[UIFont fontWithName:@"ProbaNav2-Regular" size:14.f]];
    [title setTextColor:UIColorFromRGB(0xA5A8AC)];

    UIView *header = [UIView new];

    switch (self.currentTableDataType) {
        case tableDataTypeTrips:
            [title setText:[TCCSharedFormatter localStringFromDateWithFormat:@"d MMMM" date:[self.historyTripsResults[section] groupDate]]];
            break;
        case tableDataTypePayments: {
            [title setText:[TCCSharedFormatter localStringFromDateWithFormat:@"d MMMM" date:[self.historyTripsResults[section] groupDate]]];
        }
            break;
        default: {
        }
            break;
    }

    [header addSubview:title];
    [header setBackgroundColor:UIColorFromRGB(0xF3F3F3)];

    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *header = [UIView new];
    [header setBackgroundColor:UIColorFromRGB(0xF3F3F3)];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 33;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedCell == indexPath) {
        switch (self.currentTableDataType) {
            case tableDataTypeTrips:
                return 239;
                break;
            case tableDataTypePayments: {
                return 202;
            }
                break;
            default: {
                return 50;
            }
                break;
        }
    } else {
        return 50;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.historyPaymentsResults count] == 0 && [self.historyTripsResults count] == 0) {
        [self.noHistoryView setHidden:NO];
    } else {
        [self.noHistoryView setHidden:YES];
    }

    switch (self.currentTableDataType) {
        case tableDataTypeTrips:
            return [[self.historyTripsResults[section] currentObject]count];
            break;
        case tableDataTypePayments: {
            return [[self.historyPaymentsResults[section] currentObject]count];
        }
            break;
        default: {
            return 0;
        }
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    switch (self.currentTableDataType) {
        case tableDataTypeTrips:
            return [self.historyTripsResults count];
            break;
        case tableDataTypePayments: {
            return [self.historyPaymentsResults count];
        }
            break;
        default: {
            return 0;
        }
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CornerCell *cell = nil;

    switch (self.currentTableDataType) {
        case tableDataTypeTrips:
            cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryTripsCell"];

            if (!cell) {
                cell = [[HistoryTripsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HistoryTripsCell"];
                cell.accessoryType = UITableViewCellAccessoryNone;
            }

            [cell configCellWithIndexPath:indexPath rowsCount:(int)[tableView numberOfRowsInSection:indexPath.section]];

            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        case tableDataTypePayments: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryPaymentCell"];

            if (!cell) {
                cell = [[HistoryPaymentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HistoryPaymentCell"];
                cell.accessoryType = UITableViewCellAccessoryNone;
            }

            [cell configCellWithIndexPath:indexPath rowsCount:(int)[tableView numberOfRowsInSection:indexPath.section]];

            cell.selectionStyle = UITableViewCellSelectionStyleNone;

        }
            break;
        default: {
            NSLog(@"DEFAULT");
        }
            break;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (self.selectedCell == indexPath) {
        self.selectedCell = [NSIndexPath indexPathForRow:0 inSection:-1];
    } else {
        self.selectedCell = indexPath;
    }

    [tableView beginUpdates];
    [tableView endUpdates];

    CGFloat relativeY = [tableView cellForRowAtIndexPath:indexPath].frame.origin.y - tableView.contentOffset.y + [tableView cellForRowAtIndexPath:indexPath].frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat maxYView = CGRectGetMaxY(self.view.frame);

    if (maxYView<relativeY) {
        [tableView scrollRectToVisible:[tableView cellForRowAtIndexPath:indexPath].frame animated:YES];
    }
}


- (IBAction)tripsHandler:(id)sender {
    self.currentTableDataType = tableDataTypeTrips;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    self.buttonStatusViewConstraint.constant = 0;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.tableView reloadData];
    }];
}

- (IBAction)paymentsHandler:(id)sender {
    self.currentTableDataType = tableDataTypePayments;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    self.buttonStatusViewConstraint.constant = self.statusView.bounds.size.width;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.tableView reloadData];
    }];
}

- (IBAction)howWorkHandler:(id)sender {
    HowWorkViewController *vc = [HowWorkViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)filterHandler:(id)sender {
    UIButton *btn = (UIButton *)sender;
    self.filterViewConstraint.constant = btn.frame.origin.x;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {

    }];

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    NSLocale *locale = [[NSLocale alloc]
                        initWithLocaleIdentifier:@"uk_UA"];
    [df setLocale:locale];

    switch (btn.tag) {
        case 1: {
            NSMutableArray *tmpArr = [NSMutableArray new];
            for (StatsDays *data in [StatsDays.allObjects sortedResultsUsingKeyPath:@"day" ascending:YES]) {

                df.dateFormat = @"yyyy-MM-dd";
                NSDate *tmpDate = [df dateFromString:data.day];
                df.dateFormat = @"d MMM";

                [tmpArr addObject:@{@"y":@(data.count),@"x":[df stringFromDate:tmpDate]}];
            }

            int emptyCount = (int)(5 - [tmpArr count]);

            if (emptyCount>0) {
                for (int i = 0; i<emptyCount; i++) {
                    [tmpArr addObject:@{@"y":@(0),@"x":@""}];
                }
            }
            [self.chart updateChartWithData:tmpArr andType:dayPeriod emptyCount:emptyCount];
        }
            break;
        case 2: {
            NSMutableArray *tmpArr = [NSMutableArray new];
            for (StatsWeeks *data in [StatsWeeks.allObjects sortedResultsUsingKeyPath:@"week_end" ascending:YES]) {

                df.dateFormat = @"yyyy-MM-dd";
                NSDate *week_start = [df dateFromString:data.week_start];
                NSDate *week_end = [df dateFromString:data.week_end];

                df.dateFormat = @"MMM";
                NSString *monthString = [df stringFromDate:week_start];

                df.dateFormat = @"d";

                [tmpArr addObject:@{@"y":@(data.count),@"x":[NSString stringWithFormat:@"%@-%@ %@",[df stringFromDate:week_start],[df stringFromDate:week_end],monthString]}];
            }

            int emptyCount = (int)(5 - [tmpArr count]);

            if (emptyCount>0) {
                for (int i = 0; i<emptyCount; i++) {
                    [tmpArr addObject:@{@"y":@(0),@"x":@""}];
                }
            }
            [self.chart updateChartWithData:tmpArr andType:dayPeriod emptyCount:emptyCount];
        }
            break;
        case 3: {
            NSMutableArray *tmpArr = [NSMutableArray new];
            for (StatsMonths *data in [StatsMonths.allObjects sortedResultsUsingKeyPath:@"month" ascending:YES]) {

                df.dateFormat = @"yyyy-MM-dd";
                NSDate *tmpDate = [df dateFromString:data.month];
                df.dateFormat = @"MMM";

                [tmpArr addObject:@{@"y":@(data.count),@"x":[df stringFromDate:tmpDate]}];
            }

            int emptyCount = (int)(5 - [tmpArr count]);

            if (emptyCount>0) {
                for (int i = 0; i<emptyCount; i++) {
                    [tmpArr addObject:@{@"y":@(0),@"x":@""}];
                }
            }
            [self.chart updateChartWithData:tmpArr andType:dayPeriod emptyCount:emptyCount];
        }
            break;
        default:
            break;
    }
}

- (void)chartDataSelect: (NSString *_Nullable)data {
    [self.tripsCountLabel setText:[NSString stringWithFormat:@"%0.f",[data floatValue]]];
    [self.tripsAmountLabel setText:[NSString stringWithFormat:@"%0.f ₴",[data floatValue]*5.0]];
}

@end
