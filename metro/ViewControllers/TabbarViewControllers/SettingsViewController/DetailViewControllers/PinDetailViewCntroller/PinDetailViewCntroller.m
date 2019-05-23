//
//  PinDetailViewCntroller.m
//  metro
//
//  Created by admin on 4/24/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "PinDetailViewCntroller.h"
#import "SettingsCell.h"
#import "TCCAccount+Manage.h"
#import "TCCAccount.h"
#import "TurnOffPinViewController.h"
#import "ChangePinCheckViewController.h"

@interface PinDetailViewCntroller ()
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSArray *tableViewArray;
@end

@implementation PinDetailViewCntroller
static dispatch_once_t pinDetailOnceToken;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Вхід з пін-кодом";
    pinDetailOnceToken = 0;

    [self.tableView setTableFooterView:[UIView new]];
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingsCell" bundle:nil] forCellReuseIdentifier:@"SettingsCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    self.tableViewArray = @[@"Входити з пін-кодом",@"Змінити пін-код"];
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

    [cell.accesoryImageView setHidden:YES];
    [cell.switchView setHidden:YES];

    switch (indexPath.row) {
        case 0: {
            [cell.switchView setHidden:NO];
            cell.switchView.on = TCCAccount.object.settings.pinEnabled;

            dispatch_once(&pinDetailOnceToken, ^{
                [[cell.switchView rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISwitch *x) {
                    if (x.isOn) {
                        [[RLMRealm defaultRealm] transactionWithBlock:^{
                            TCCAccount.object.settings.pinEnabled = x.isOn;
                        }];
                    } else {
                        TurnOffPinViewController *vc = [[TurnOffPinViewController alloc]initWithNibName:@"GlobalPinViewController" bundle:nil];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                }];
            });
        }
            break;
        case 1: {
            [cell.accesoryImageView setHidden:NO];
        }
            break;

        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 1: {
            ChangePinCheckViewController *vc = [[ChangePinCheckViewController alloc]initWithNibName:@"GlobalPinViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;

        default:
            break;
    }
}
@end
