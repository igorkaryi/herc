//
//  CardsViewController.m
//  metro
//
//  Created by admin on 4/18/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "CardsViewController.h"
#import "MasterpassRequestModel.h"
#import "TCCMasterpassModel.h"

#import "HowWorkViewController.h"

#import "VcodeViewController.h"
#import "CardDataMpViewController.h"

#import "SuccesViewController.h"

#import "AboutMpWalletViewController.h"

#import "CardsViewCell.h"
#import "AddCardCell.h"

@interface CardsViewController ()
@property (retain, nonatomic) IBOutlet UIView *contentView;

@property (retain, nonatomic) IBOutlet UIView *linkMasterpassView;
@property (retain, nonatomic) IBOutlet UIView *createMasterpassView;
@property (retain, nonatomic) IBOutlet UIView *walletsMasterpassView;

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@property (nonatomic, retain) NSArray *cardsArray;
@end

@implementation CardsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillAppear:) name:@"tabCardWillApper" object:nil];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CardsViewCell" bundle:nil] forCellReuseIdentifier:@"CardsViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddCardCell" bundle:nil] forCellReuseIdentifier:@"AddCardCell"];
    self.cardsArray = @[];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    if ([[self topViewController] isKindOfClass:[CardsViewController class]]) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
    [self setMainView];
}

- (void)setMainView {
    [TCCSharedMasterpassModel checkEndUserFlow:^(MPEndUserFlow endUserFlow) {
        switch (endUserFlow) {
            case MPEndUserDontHave: {
                [self addSubView:self.createMasterpassView];
            }
                break;
            case MPEndUserNotLink: {
                [self addSubView:self.linkMasterpassView];
            }
                break;
            case MPEndUserLink: {
                [self addSubView:self.walletsMasterpassView];

                self.cardsArray = (NSArray *)[TCCMasterpassCard allObjects];;
                [self.tableView reloadData];

                @weakify(self);
                [TCCSharedMasterpassModel getWallets:^(id responseObject, NSString *errorStr) {
                    @strongify(self);
                    //[self hideHud];
                    if (errorStr) {
//                        [UIAlertController showAlertInViewController:self withTitle:@"" message:errorStr cancelButtonTitle:@"Ок" destructiveButtonTitle:nil otherButtonTitles:nil textFieldPlaceholders:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
//                        }];
                    } else {
                        self.cardsArray = responseObject;
                        [self.tableView reloadData];
                    }
                }];
            }
                break;
            default:
                break;
        }
    }];
}

- (void)addSubView: (UIView *)subView {
    [[self.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.contentView addSubview:subView];
    subView.translatesAutoresizingMaskIntoConstraints = NO;
    [subView setBackgroundColor:[UIColor clearColor]];

    NSLayoutConstraint *trailing =[NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.f];

    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.f];

    NSLayoutConstraint *bottom =[NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.f];

    NSLayoutConstraint *top =[NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.f];

    [self.contentView addConstraint:trailing];
    [self.contentView addConstraint:bottom];
    [self.contentView addConstraint:leading];
    [self.contentView addConstraint:top];
}

#pragma - mark IBActions

- (IBAction)linkMpHandler:(id)sender {
    [self showHud];
    @weakify(self);
    [TCCSharedMasterpassRequestModel linkCardToClient:^(MfsResponse *responseObject) {
        if(responseObject.result){
            [TCCSharedMasterpassModel reloadMpDataWithCompletion:^(id responseObject, NSString *errorStr) {
                @strongify(self);
                [self hideHud];
                SuccesViewController *vc = [SuccesViewController new];
                vc.currentType = StatusViewTypeAddCardRegister;
                vc.succesActionType = StatusViewSuccesActionRootTabBar;
                [self.navigationController pushViewController:vc animated:YES];
            }];
        } else {
            @strongify(self);
            [self hideHud];
            if([[(MfsResponse *)responseObject errorCode] isEqualToString:@"5001"] || [[(MfsResponse *)responseObject errorCode] isEqualToString:@"5007"]){
                VcodeViewController *vc = [VcodeViewController new];
                vc.tokenString = [(MfsResponse *)responseObject token];
                vc.currentType = VcodeTypeLinkAccount;
                [vc closeButtonSetupRight:NO];
                UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:vc];
                [self.tccTabbarViewController presentViewController:nc animated:YES completion:nil];
            } else {
                [UIAlertController showAlertInViewController:self withTitle:@"" message:[(MfsResponse *)responseObject errorDescription] cancelButtonTitle:@"Ок" destructiveButtonTitle:nil otherButtonTitles:nil textFieldPlaceholders:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                }];
            }
        }
    }];
}

- (IBAction)createMpHandler:(id)sender {
    CardDataMpViewController *vc = [CardDataMpViewController new];
    [vc closeButtonSetupRight:NO];
    UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:vc];
    [self.tccTabbarViewController presentViewController:nc animated:YES completion:nil];
}

- (IBAction)howWorkHandler:(id)sender {
    HowWorkViewController *vc = [HowWorkViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)aboutHandler:(id)sender {
    AboutMpWalletViewController *vc = [AboutMpWalletViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cardsArray count]+1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.cardsArray.count) {
        AddCardCell *cell = nil;

        cell = [tableView dequeueReusableCellWithIdentifier:@"AddCardCell"];

        if (!cell) {
            cell = [[AddCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddCardCell"];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }

        cell.selectionStyle = UITableViewCellSelectionStyleDefault;

        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = _RGBA(255, 255, 255, 0.0);
        [cell setSelectedBackgroundView:bgColorView];

        return cell;
    } else {
        CardsViewCell *cell = nil;

        cell = [tableView dequeueReusableCellWithIdentifier:@"CardsViewCell"];

        if (!cell) {
            cell = [[CardsViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CardsViewCell"];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = (id)self;
        [cell configCellWithCard:self.cardsArray[indexPath.row]];

        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == self.cardsArray.count) {
        [self createMpHandler:self];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.cardsArray.count) {
        return NO;
    } else {
        return YES;
    }
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Видалити" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        if ([self.cardsArray count]==1) {
            [UIAlertController showAlertInViewController:self withTitle:@"Ви видаляєте гаманець Masterpass" message:@"Ви видаляєте останню картку в гаманці. Гаманець Masterpass буде також  видалено." cancelButtonTitle:@"Відмінити" destructiveButtonTitle:@"Видалити" otherButtonTitles:nil textFieldPlaceholders:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [self deleteCardAtIndexPath:indexPath];
                }
            }];
        } else {
            [self deleteCardAtIndexPath:indexPath];
        }
    }];

    delete.backgroundColor = UIColorFromRGB(0xF3F3F3);
    return @[delete];
}

- (void)deleteCardAtIndexPath: (NSIndexPath *)indexPath {
    [self showHud];
    @weakify(self);
    [TCCSharedMasterpassModel deleteCard:self.cardsArray[indexPath.row] completion:^(id responseObject, NSString *errorStr) {
        @strongify(self);
        if (errorStr) {
            [self hideHud];
            [UIAlertController showAlertInViewController:self withTitle:@"" message:errorStr cancelButtonTitle:@"Ок" destructiveButtonTitle:nil otherButtonTitles:nil textFieldPlaceholders:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            }];
        } else {
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            [realm deleteObject:self.cardsArray[indexPath.row]];
            [realm commitWriteTransaction];

            [TCCSharedMasterpassModel reloadMpDataWithCompletion:^(id responseObject, NSString *errorStr) {
                @strongify(self);
                [self hideHud];
                [self setMainView];
            }];
        }
    }];
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    for (UIView *subview in tableView.subviews) {
        if ([NSStringFromClass([subview class]) isEqualToString:@"UISwipeActionPullView"]) {
            if ([NSStringFromClass([subview.subviews[0] class]) isEqualToString:@"UISwipeActionStandardButton"]) {
                CGRect newFrame = subview.subviews[0].frame;
                newFrame.size.height = 70;
                newFrame.origin.y = 5;
                subview.subviews[0].frame = newFrame;
                subview.subviews[0].backgroundColor = [UIColor redColor];
            }
        }
    }
}


- (void)setFavoriteCard: (TCCMasterpassCard *)wallet {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isFavorite"]) {
        if ([wallet.cardName isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"isFavorite"]]) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isFavorite"];
        } else {
            [[NSUserDefaults standardUserDefaults]setObject:wallet.cardName forKey:@"isFavorite"];
        }
    } else {
        [[NSUserDefaults standardUserDefaults]setObject:wallet.cardName forKey:@"isFavorite"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self setMainView];
}

@end
