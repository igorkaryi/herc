//
//  QuantityViewController.m
//  metro
//
//  Created by admin on 4/23/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "QuantityViewController.h"
#import "CardsListPopupView.h"
#import "CardDataMpViewController.h"
#import "TCCMasterpassModel.h"
#import "HelpListViewController.h"
#import "TCCHTTPSessionManager.h"
#import "PayCheckWebViewController.h"
#import "SuccesViewController.h"

@interface QuantityViewController ()
@property (nonatomic, retain) IBOutlet UIPickerView *firstPicker;
@property (nonatomic, retain) IBOutlet UIPickerView *secondPicker;

@property (nonatomic, retain) IBOutlet UILabel *amountLabel;
@property (nonatomic, retain) IBOutlet UIButton *buyButton;

@property (nonatomic, retain) IBOutlet UILabel *cardNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *cardPanLabel;
@property (nonatomic, retain) IBOutlet UIImageView *cardImageView;

@property (nonatomic, retain) TCCMasterpassCard *cardForPay;


@end

@implementation QuantityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.secondPicker selectRow:1 inComponent:0 animated:YES];
    [self getCardForPay];
}

- (void)viewWillAppear:(BOOL)animated {
    [self setNeedsStatusBarAppearanceUpdate];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)getCardForPay {
    //[self showHud];
    [self.view setUserInteractionEnabled:NO];
    @weakify(self);
    [TCCSharedMasterpassModel getWallets:^(id responseObject, NSString *errorStr) {
        @strongify(self);
        [self.view setUserInteractionEnabled:YES];
        //[self hideHud];
        if (errorStr) {
            [UIAlertController showAlertInViewController:[[UIApplication sharedApplication] keyWindow].rootViewController withTitle:@"" message:errorStr cancelButtonTitle:@"Ок" destructiveButtonTitle:nil otherButtonTitles:nil textFieldPlaceholders:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }];
        } else {
            if ([responseObject count] != 0) {
                self.cardForPay = responseObject[[responseObject count]-1];
                for (TCCMasterpassCard *card in responseObject) {
                    if ([card.cardName isEqualToString:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"isFavorite"]]]) {
                        self.cardForPay = card;
                    }
                }
                [self configView];
            }
        }
    }];
}

- (void)configView {
    self.cardNameLabel.text = self.cardForPay.cardName;
    self.cardPanLabel.text = [NSString stringWithFormat:@"**** **%@",[self.cardForPay.cardNo substringFromIndex:14]];
    [self.cardImageView setImage:[UIImage imageNamed:([[self.cardForPay.cardNo substringToIndex:1] isEqualToString:@"5"])?@"mc card":@"visa card"]];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Picker Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    [thePickerView.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        subview.hidden = (CGRectGetHeight(subview.frame) < 1.0);
    }];
    return 1;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return ((100.0/568.0)*[UIScreen mainScreen].bounds.size.height);
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    return (thePickerView == self.firstPicker)?3:10;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    [pickerView setShowsSelectionIndicator:NO];
    UILabel* tView = (UILabel*)view;
    if (!tView) {
        tView = [[UILabel alloc] init];
        tView.textColor = (pickerView == self.firstPicker)?(row == 0)?UIColorFromRGB(0x000000):[UIColor whiteColor]:[UIColor whiteColor];
        tView.alpha = (pickerView == self.firstPicker)?(row == 0)?0.2:1:1;
        tView.textAlignment = (pickerView == self.firstPicker)?NSTextAlignmentRight:NSTextAlignmentLeft;
        [tView setFont:[UIFont fontWithName:@"ProbaNav2-ExtraLight" size:((100.0/568.0)*[UIScreen mainScreen].bounds.size.height)]];
    }
    tView.text = [NSString stringWithFormat:@"%ld",(long)row];
    return tView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(pickerView == self.firstPicker) {
        if (row == 2) {
            if (row != 0) {
                [self.secondPicker selectRow:0 inComponent:0 animated:YES];
                //[self setAmount:20];
                //return;
            } 
        } else {
            if (row == 0) {
                if ([self.secondPicker selectedRowInComponent:0] == 0) {
                    [self.secondPicker selectRow:1 inComponent:0 animated:YES];
                    //[self setAmount:1];
                    //return;
                }
            }
        }
    } else {
        if (row == 0) {
            if ([self.firstPicker selectedRowInComponent:0] == 0) {
                [self.secondPicker selectRow:1 inComponent:0 animated:YES];
                //[self setAmount:1];
                //return;
            }
        } else {
            if ([self.firstPicker selectedRowInComponent:0] == 2) {
                [self.secondPicker selectRow:0 inComponent:0 animated:YES];
                //[self setAmount:20];
                //return;
            }
        }
    }
    NSString *amountString = [NSString stringWithFormat:@"%ld%ld",(long)[self.firstPicker selectedRowInComponent:0],(long)[self.secondPicker selectedRowInComponent:0]];
    [self setAmount:amountString.intValue];

    if (amountString.intValue != 1) {
        [UIAlertController showAlertInViewController:self withTitle:@"" message:@"На даний момент доступна покупка тільки 1 квитка за 1 покупку. Для покупки декількох квитків виконайте кілька покупок" cancelButtonTitle:@"Ок" destructiveButtonTitle:nil otherButtonTitles:nil textFieldPlaceholders:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            [self.firstPicker selectRow:0 inComponent:0 animated:YES];
            [self.secondPicker selectRow:1 inComponent:0 animated:YES];
            [self setAmount:1];
        }];
    }
}

- (void)setAmount: (int)amount {
    int price = 5;
    [self.amountLabel setText:[NSString stringWithFormat:@"%d ₴",amount*price]];
    [self.buyButton setTitle:[NSString stringWithFormat:@"Придбати %d %@",amount,[self ticketsString:amount]] forState:UIControlStateNormal];
}

- (NSString*)ticketsString:(int)number{
    if (number < 0) {
        number = number*-1;
    }
    NSArray *data = @[@"квиток",@"квитка",@"квитків"];
    NSArray *_case = @[@2, @0, @1, @1, @1, @2];
    return data[(number%100 > 4 && number%100 < 20)?2:[_case[((number%10 < 5)?number%10:5)] intValue]];
}

#pragma mark - Picker Delegate

- (IBAction)cardsHandler:(id)sender {
    [CardsListPopupView showCardsListInViewController:self];
}

- (IBAction)buyHandler:(id)sender {
    [self showHud];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def synchronize];

    NSString *amountString = [NSString stringWithFormat:@"%ld%ld",(long)[self.firstPicker selectedRowInComponent:0],(long)[self.secondPicker selectedRowInComponent:0]];

    NSDictionary *params = @{
                             @"token":[def objectForKey:@"cardsListToken"],
                             @"retrieval_reference_no":[def objectForKey:@"cardsListRefNo"],
                             @"list_account_name":self.cardForPay.cardName,
                             @"reference_no":[def objectForKey:@"cardsListReferenceNo"],
                             @"amount":[NSString stringWithFormat:@"%d",amountString.intValue*5]};
    @weakify(self);
    [TCCSharedHTTPSessionManager POST:TCCHTTPRequestTransactionsInit parameters:params completion:^(id responseObject, NSString *errorStr) {
        @strongify(self);
        [self hideHud];
        if (errorStr) {
            [UIAlertController showAlertInViewController:self withTitle:@"" message:errorStr cancelButtonTitle:@"Ок" destructiveButtonTitle:nil otherButtonTitles:nil textFieldPlaceholders:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            }];
        } else {
            if ([[responseObject allKeys]containsObject:@"is_redirect"]) {
                if ([responseObject[@"is_redirect"]boolValue] == TRUE) {
                    PayCheckWebViewController *vc = [[PayCheckWebViewController alloc]initWithNibName:@"GlobalWebViewController" bundle:nil];
                    vc.url = responseObject[@"url"];
                    vc.method = @"POST";
                    vc.paymentToken = responseObject[@"payment_token"];
                    vc.arguments = responseObject[@"fields"];
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    if ([responseObject[@"status"]boolValue] == TRUE) {
                        [self confirmPayWithToken:responseObject[@"payment_token"]];
                    } else {
                        [UIAlertController showAlertInViewController:self withTitle:@"" message:@"Помилка серверу" cancelButtonTitle:@"Ок" destructiveButtonTitle:nil otherButtonTitles:nil textFieldPlaceholders:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                        }];
                    }
                }
            } else {
                if ([responseObject[@"status"]boolValue] == TRUE) {
                    [self confirmPayWithToken:responseObject[@"payment_token"]];
                } else {
                    [UIAlertController showAlertInViewController:self withTitle:@"" message:@"Помилка серверу" cancelButtonTitle:@"Ок" destructiveButtonTitle:nil otherButtonTitles:nil textFieldPlaceholders:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                    }];
                }
            }
        }
    }];
}

- (void)confirmPayWithToken: (NSString *)paymentToken {
    NSDictionary *params = @{@"payment_token":paymentToken};
    [self showHud];
    @weakify(self);
    [TCCSharedHTTPSessionManager POST:TCCHTTPRequestTransactionsConfirm parameters:params completion:^(id responseObject, NSString *errorStr) {
        @strongify(self);
        [self hideHud];
        if (errorStr) {
            [UIAlertController showAlertInViewController:self withTitle:@"" message:errorStr cancelButtonTitle:@"Ок" destructiveButtonTitle:nil otherButtonTitles:nil textFieldPlaceholders:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            }];
        } else {
            if ([responseObject[@"status"]boolValue] == YES) {
                SuccesViewController *vc = [SuccesViewController new];
                vc.succesActionType = StatusViewSuccesActionRootTabBar;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                [UIAlertController showAlertInViewController:self withTitle:@"" message:responseObject[@"error"] cancelButtonTitle:@"Ок" destructiveButtonTitle:nil otherButtonTitles:nil textFieldPlaceholders:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                }];
            }
        }
    }];
}

- (IBAction)helpHandler:(id)sender {
    HelpListViewController *vc = [HelpListViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)selectCard:(TCCMasterpassCard *)card {
    self.cardForPay = card;
    [self configView];
}

- (IBAction)addCardHandler:(id)sender {
    CardDataMpViewController *vc = [CardDataMpViewController new];
    vc.succesActionType = StatusViewSuccesActionDismiss;
    [vc closeButtonSetupRight:NO];
    UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:vc];
    [self.navigationController presentViewController:nc animated:YES completion:nil];
}


@end
