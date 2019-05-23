//
//  FinalAuthViewController.m
//  metro
//
//  Created by admin on 4/13/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "FinalAuthViewController.h"

#import "AuthLinkMpViewController.h"
#import "AddCardMpInfoViewController.h"

#import "TCCHTTPSessionManager.h"

#import "TCCAccount+Manage.h"
#import "TCCAccount+Keychain.h"
#import "TCCAccount+HTTPRequests.h"
#import "TCCMasterpassModel.h"

#import "MasterpassRequestModel.h"
#import "TCCTabbarViewController.h"

@import BlocksKit;

@interface FinalAuthViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *paralaxImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *frameView;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property BOOL canScrollToSecondPage;

@property (nonatomic, retain) IBOutlet UITextField *codeTextField;
@property (nonatomic, retain) IBOutlet UITextField *pinTextField1;
@property (nonatomic, retain) IBOutlet UITextField *pinTextField2;
@property (nonatomic, retain) IBOutlet UITextField *pinTextField3;
@property (nonatomic, retain) IBOutlet UITextField *pinTextField4;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *paralaxViewXConstraint;

@property (retain, nonatomic) IBOutlet UIView *errorView;
@property (retain, nonatomic) IBOutlet UIView *resendView;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (nonatomic, retain) IBOutlet SpinnerButton *checkSmsButton;
@property (nonatomic, retain) IBOutlet SpinnerButton *createPinButton;

@end

@implementation FinalAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.frameView.constant = [[[UIApplication sharedApplication] delegate] window].bounds.size.width;
    [self.view layoutIfNeeded];
    [self backButtonWithColor:[UIColor whiteColor]];
    [self.scrollView setDirectionalLockEnabled:YES];

    [self.codeTextField setText:@"123123"];
//    [self.pinTextField1 setText:@"1"];
//    [self.pinTextField2 setText:@"1"];
//    [self.pinTextField3 setText:@"1"];
//    [self.pinTextField4 setText:@"1"];
    
    self.canScrollToSecondPage = YES;

    [self.phoneLabel setText:[NSString stringWithFormat:@"Ми надіслали на ваш номер \n+%@ СМС з кодом.",[self.userPhoneString stringByFormat:@"### ## ### ## ##"]]];

    [self hideResendView];

    RAC(self.checkSmsButton, enabled) = [self.codeTextField.rac_textSignal map:^id(NSString *text) {
        return @(text.length == 6);
    }];

    RAC(self.createPinButton, enabled) = [RACSignal combineLatest:@[self.pinTextField1.rac_textSignal, self.pinTextField2.rac_textSignal, self.pinTextField3.rac_textSignal, self.pinTextField4.rac_textSignal] reduce:^id(NSString *pin1, NSString *pin2, NSString *pin3, NSString *pin4){
        return @(pin1.length == 1 && pin2.length == 1 && pin3.length == 1 && pin4.length == 1);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [self setNeedsStatusBarAppearanceUpdate];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self.codeTextField becomeFirstResponder];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark -IBActions

- (IBAction)checkSmsHandler:(id)sender {
    [self.checkSmsButton startAnim];
    NSDictionary *params = @{@"token":self.tokenString,@"code":self.codeTextField.text};
    @weakify(self);
    [TCCSharedHTTPSessionManager POST:TCCHTTPRequestRegisterCheckCode parameters:params completion:^(id responseObject, NSString *errorStr) {
        @strongify(self);
        if (errorStr) {
            [self.checkSmsButton stopAnim];
            [UIAlertController showAlertInViewController:self withTitle:@"" message:errorStr cancelButtonTitle:@"Ок" destructiveButtonTitle:nil otherButtonTitles:nil textFieldPlaceholders:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            }];
        } else {
            if ([responseObject[@"status"]boolValue] == FALSE) {
                [self.checkSmsButton stopAnim];
                [self.codeTextField becomeFirstResponder];
                [UIView animateWithDuration:0.3 animations:^{
                    [self.errorView setAlpha:1];
                }];
            } else {
                TCCAccount *account = TCCAccount.object;

                [[RLMRealm defaultRealm] transactionWithBlock:^{
                    account.name = self.userPhoneString;
                    account.token = responseObject[@"token"];
                    account.secret = responseObject[@"secret"];
                    [account setUpRequestsSign];
                }];

                [TCCSharedMasterpassRequestModel getMasterpassConfigCompletion:^(BOOL comlete) {
                    [self.checkSmsButton stopAnim];
                    self.canScrollToSecondPage = YES;
                    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width*1, 0) animated:YES];
                    [self.view endEditing:YES];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.pinTextField1 becomeFirstResponder];
                    });
                    self.paralaxViewXConstraint.constant = -[[[UIApplication sharedApplication] delegate] window].bounds.size.width/2;
                    [UIView animateWithDuration:0.5 animations:^{
                        [self.view layoutIfNeeded];
                    }];
                }];
            }
        }
    }];
}

- (IBAction)createPinHandler:(id)sender {
    TCCAccount.object.pin = [NSString stringWithFormat:@"%@%@%@%@",self.pinTextField1.text,self.pinTextField2.text,self.pinTextField3.text,self.pinTextField4.text];
    [[RLMRealm defaultRealm] transactionWithBlock:^{
        TCCAccount.object.settings.pinEnabled = YES;
    }];

    
    [self.createPinButton startAnim];
    [TCCSharedMasterpassModel reloadMpDataWithCompletion:^(id responseObject, NSString *errorStr) {
        @weakify(self);
        [TCCSharedMasterpassModel checkEndUserFlow:^(MPEndUserFlow endUserFlow) {
            @strongify(self);
            [self.createPinButton stopAnim];
            switch (endUserFlow) {
                case MPEndUserLink: {
                    TCCTabbarViewController *rootViewController = [TCCTabbarViewController new];
                    [[UIApplication sharedApplication].keyWindow setRootViewController:rootViewController animated:YES];
                }
                    break;
                case MPEndUserNotLink: {
                    AuthLinkMpViewController *vc = [AuthLinkMpViewController new];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case MPEndUserDontHave: {
                    AddCardMpInfoViewController *vc = [AddCardMpInfoViewController new];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;

                default:
                    break;
            }
        }];
    }];
}

- (IBAction)resendButtonHandler:(id)sender {
    [self hideResendView];

    [self showHud];
    NSDictionary *params = @{@"token":self.tokenString};
    @weakify(self);
    [TCCSharedHTTPSessionManager POST:TCCHTTPRequestRegisterResendCode parameters:params completion:^(id responseObject, NSString *errorStr) {
        @strongify(self);
        [self hideHud];
        if (errorStr) {
            [UIAlertController showAlertInViewController:self withTitle:@"" message:errorStr cancelButtonTitle:@"Ок" destructiveButtonTitle:nil otherButtonTitles:nil textFieldPlaceholders:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            }];
        } else {
            self.tokenString = responseObject[@"token"];
        }
    }];
}

- (IBAction)popBackButtonHandler:(id)sender {
    if (self.scrollView.contentOffset.x == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.pinTextField1 setText:@""];
        [self.pinTextField2 setText:@""];
        [self.pinTextField3 setText:@""];
        [self.pinTextField4 setText:@""];
        [self.view endEditing:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.codeTextField becomeFirstResponder];
        });
        self.canScrollToSecondPage = YES;
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];

        self.paralaxViewXConstraint.constant = 0;
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.canScrollToSecondPage == YES) {
        if (scrollView.contentOffset.x == 0) {
            self.canScrollToSecondPage = NO;
        } else if (scrollView.contentOffset.x == self.scrollView.frame.size.width*1) {
            self.canScrollToSecondPage = NO;
        }
    } else {
        if (scrollView.contentOffset.x != 0 || scrollView.contentOffset.x != self.scrollView.frame.size.width*1) {
            if (scrollView.contentOffset.x >= self.scrollView.frame.size.width/2) {
                scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, scrollView.contentOffset.y);
            } else {
                scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
            }
        } else {
            self.canScrollToSecondPage = NO;
        }
    }
}

#pragma mark - textField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.codeTextField) {
        if (self.errorView.alpha>0) {
            [UIView animateWithDuration:0.3 animations:^{
                [self.errorView setAlpha:0];
            }];
        }
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= 6;
    } else {
        if ([string length] == 0 && range.length > 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSInteger nextTag = textField.tag - 1;
                UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
                if (! nextResponder)
                    nextResponder = [textField.superview viewWithTag:1];
                if (nextResponder)
                    [nextResponder becomeFirstResponder];

            });
            return YES;
        }
        if (textField.text.length >=1) {
            textField.text = string;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSInteger nextTag = textField.tag + 1;
                UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
                if (! nextResponder)
                    nextResponder = [textField.superview viewWithTag:1];
                if (nextResponder)
                    [nextResponder becomeFirstResponder];

            });
            return NO;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSInteger nextTag = textField.tag + 1;
            UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
            if (! nextResponder)
                nextResponder = [textField.superview viewWithTag:1];
            if (nextResponder)
                [nextResponder becomeFirstResponder];

        });
        return YES;
    }
}


- (void)hideResendView {
    int timeRepeat = 60;
    [self.timerLabel setText:[NSString stringWithFormat:@"Надіслати ще раз через %d сек",timeRepeat]];
    __block int timerLoop = timeRepeat;
   [NSTimer bk_scheduledTimerWithTimeInterval:1.0 block:^(NSTimer *time) {
        timerLoop--;
        [self.timerLabel setText:[NSString stringWithFormat:@"Надіслати ще раз через %d сек",timerLoop]];
        if (timerLoop <=0) {
            [time invalidate];
            time = nil;
            timerLoop = timeRepeat;
        }
    } repeats:YES];

    [self.timerLabel setAlpha:1];
    [self.resendView setAlpha:0];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeRepeat * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.timerLabel setAlpha:0];
        [UIView animateWithDuration:0.3 animations:^{
            [self.resendView setAlpha:1];
        }];
    });
}


@end
