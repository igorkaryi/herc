//
//  HelpListViewController.m
//  metro
//
//  Created by admin on 4/25/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "HelpListViewController.h"
#import "SettingsCell.h"
#import "HowWorkViewController.h"
#import "HowScanTicketsViewController.h"
#import "TariffsAndPaymentViewController.h"
#import "SecurityViewController.h"

@interface HelpListViewController ()
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSArray *tableViewArray;
@end

@implementation HelpListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Допомога";

    [self.tableView setTableFooterView:[UIView new]];
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingsCell" bundle:nil] forCellReuseIdentifier:@"SettingsCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    self.tableViewArray = @[@"Як працює додаток?",@"Як сканувати квитки?",@"Тарифи і оплата",@"Безпека"];
    [self.tableView reloadData];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark -
#pragma mark UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableViewArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CornerCell *cell = nil;

    cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsCell"];

    if (!cell) {
        cell = [[SettingsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingsCell"];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(SettingsCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell.titleTextLabel setText:self.tableViewArray[indexPath.row]];
    [cell.accesoryImageView setHidden:NO];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0: {
            HowWorkViewController *vc = [HowWorkViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1: {
            HowScanTicketsViewController *vc = [HowScanTicketsViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2: {
            TariffsAndPaymentViewController *vc = [TariffsAndPaymentViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3: {
            SecurityViewController *vc = [SecurityViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;

        default:
            break;
    }
}


@end
