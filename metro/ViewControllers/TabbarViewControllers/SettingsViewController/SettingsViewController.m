//
//  SettingsViewController.m
//  metro
//
//  Created by admin on 4/23/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsCell.h"
#import "TCCAccount+Manage.h"
#import "TCCAccount.h"
#import "PinDetailViewCntroller.h"
#import "GCDSingleton.h"
#import "AboutUsViewController.h"
#import "HelpListViewController.h"
#import "AuthViewController.h"
#import "FeedbackViewController.h"

@interface SettingsViewController ()
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSArray *tableViewArray;
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingsCell" bundle:nil] forCellReuseIdentifier:@"SettingsCell"];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    if ([[self topViewController] isKindOfClass:[SettingsViewController class]]) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }

    self.tableViewArray = @[
                            @{
                                @"title":@"Налаштування",
                                @"data":@[
                                        @{@"type":@(SettingsCellPhone),@"title":@"Телефон",@"decription":[NSString stringWithFormat:@"+%@",[TCCAccount.object.name stringByFormat:@"### ## ### ## ##"]]},
                                        @{@"type":@(SettingsCellPin),@"title":@"Пін-код",@"decription":(TCCAccount.object.settings.pinEnabled == YES)?@"Увімкнено":@"Вимкнено"},
                                        @{@"type":@(SettingsCellTouch),@"title":@"Touch ID для входу",@"decription":@""},
                                        @{@"type":@(SettingsCellLang),@"title":@"Мова",@"decription":@"Українська"}]},

                            @{
                                @"title":@"Сповіщення",
                                @"data":@[
                                        @{@"type":@(SettingsCellTicketsLast),@"title":@"Залишилось 2 квитки",@"decription":@""},
                                        @{@"type":@(SettingsCellTicketsDate),@"title":@"Закінчується термін дії квитків",@"decription":@""}]},

                            @{
                                @"title":@"Про додаток",
                                @"data":@[
                                        @{@"type":@(SettingsCellAboutUs),@"title":@"Про розробників",@"decription":@""},
                                        @{@"type":@(SettingsCellHelp),@"title":@"Допомога",@"decription":@""},
                                        @{@"type":@(SettingsCellResponse),@"title":@"Залишити відгук",@"decription":@""}]},

                            @{
                                @"title":@"",
                                @"data":@[
                                        @{@"type":@(SettingsCellLogout),@"title":@"Вийти з профілю",@"decription":@""} ]}];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark -
#pragma mark UITableView delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.frameWidth-25.f, 20.f)];
    [title setFont:[UIFont fontWithName:@"ProbaNav2-Regular" size:14.f]];
    [title setTextColor:UIColorFromRGB(0xA5A8AC)];

    UIView *header = [UIView new];

    [title setText:self.tableViewArray[section][@"title"]];
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
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableViewArray[section][@"data"]count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.tableViewArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CornerCell *cell = nil;

    cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsCell"];

    if (!cell) {
        cell = [[SettingsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingsCell"];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    [cell configCellWithIndexPath:indexPath rowsCount:(int)[tableView numberOfRowsInSection:indexPath.section]];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(SettingsCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell.titleTextLabel setText:self.tableViewArray[indexPath.section][@"data"][indexPath.row][@"title"]];
    [cell.descTextLabel setText:self.tableViewArray[indexPath.section][@"data"][indexPath.row][@"decription"]];

    [cell.accesoryImageView setHidden:YES];
    [cell.switchView setHidden:YES];
    [cell.imageView setHidden:YES];
    [cell.titleTextLabel setTextColor:UIColorFromRGB(0x000000)];

    switch ([self.tableViewArray[indexPath.section][@"data"][indexPath.row][@"type"]intValue]) {
        case SettingsCellPhone: {

        }
            break;

        case SettingsCellPin: {
            [cell.accesoryImageView setHidden:NO];
        }
            break;

        case SettingsCellTouch: {
            [cell.switchView setHidden:NO];
            cell.switchView.on = TCCAccount.object.settings.useTouchID;

            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                [[cell.switchView rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISwitch *x) {
                    [[RLMRealm defaultRealm] transactionWithBlock:^{
                        TCCAccount.object.settings.useTouchID = x.isOn;
                    }];
                }];
            });
        }
            break;

        case SettingsCellLang: {
            //[cell.accesoryImageView setHidden:NO];
        }
            break;

        case SettingsCellTicketsLast: {
            [cell.switchView setHidden:NO];
            static dispatch_once_t onceToken;
            cell.switchView.on = TCCAccount.object.settings.pushLastTicket;
            dispatch_once(&onceToken, ^{
                [[cell.switchView rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISwitch *x) {
                    [[RLMRealm defaultRealm] transactionWithBlock:^{
                        TCCAccount.object.settings.pushLastTicket = x.isOn;
                    }];
                }];
            });

        }
            break;

        case SettingsCellTicketsDate: {
            [cell.switchView setHidden:NO];
            cell.switchView.on = TCCAccount.object.settings.pushDateTicket;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                [[cell.switchView rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISwitch *x) {
                    [[RLMRealm defaultRealm] transactionWithBlock:^{
                        TCCAccount.object.settings.pushDateTicket = x.isOn;
                    }];
                }];
            });
        }
            break;

        case SettingsCellAboutUs: {
            [cell.accesoryImageView setHidden:NO];
        }
            break;

        case SettingsCellHelp: {
            [cell.accesoryImageView setHidden:NO];
        }
            break;

        case SettingsCellResponse: {
            [cell.accesoryImageView setHidden:NO];
        }
            break;

        case SettingsCellLogout: {
            [cell.imageView setHidden:NO];
            [cell.titleTextLabel setText:[NSString stringWithFormat:@"         %@",self.tableViewArray[indexPath.section][@"data"][indexPath.row][@"title"]]];
            [cell.titleTextLabel setTextColor:UIColorFromRGB(0x24AC66)];
            cell.imageView.frameX = 20;
            [cell.imageView setImage:[UIImage imageNamed:@"exit"]];
        }
            break;

        default:
            break;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    switch ([self.tableViewArray[indexPath.section][@"data"][indexPath.row][@"type"]intValue]) {
        case SettingsCellPhone: {

        }
            break;

        case SettingsCellPin: {
            PinDetailViewCntroller *vc = [PinDetailViewCntroller new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;

        case SettingsCellTouch: {

        }
            break;

        case SettingsCellLang: {

        }
            break;

        case SettingsCellTicketsLast: {

        }
            break;

        case SettingsCellTicketsDate: {

        }
            break;

        case SettingsCellAboutUs: {
            AboutUsViewController *vc = [AboutUsViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;

        case SettingsCellHelp: {
            HelpListViewController *vc = [HelpListViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;

        case SettingsCellResponse: {
            FeedbackViewController *vc = [FeedbackViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;

        case SettingsCellLogout: {
            [TCCAccount.object logout];
            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:[AuthViewController new]];
            [[UIApplication sharedApplication].keyWindow setRootViewController:nc animated:YES];
        }
            break;

        default:
            break;
    }
}




@end
