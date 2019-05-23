//
//  TCCEnterPINViewController.m
//  Tachcard
//
//  Created by Yaroslav Bulda on 7/4/15.
//  Copyright (c) 2015 Tachcard. All rights reserved.
//

#import "NSObject+RACPropertySubscribing.h"
#import "TCCEnterPINViewController.h"

#import "TCCDotsView.h"

#import <AudioToolbox/AudioToolbox.h>
#import "UIView+ShakeEffect.h"

#import "TCCAccount+Manage.h"
#import "TCCAccount+TouchID.h"
#import "TCCAccount+Keychain.h"
#import "TCCHTTPSessionManager.h"
#import "NSString+MD5.h"
#import "SecurityHelper.h"
#import "TCCProgressHud.h"
#import "UIImage+Additions.h"
#import "AnyHelper.h"

#import "AuthViewController.h"


@interface TCCEnterPINViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *logOutButton;

@property (nonatomic, copy) IBOutletCollection (UIView) NSArray *cornerViewArray;
@property (nonatomic, copy) IBOutletCollection (UIButton) NSArray *buttonsArray;
@property (weak, nonatomic) IBOutlet UIView *cornerViewTmp;
@end

@implementation TCCEnterPINViewController

#pragma mark -
#pragma mark Lifecycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    self.pin = @"";
    NSNotificationCenter *defCenter = [NSNotificationCenter defaultCenter];
    [self.logOutButton setTitleColor:mainColour forState:UIControlStateNormal];

    [defCenter addObserver:self selector:@selector(lockScreen) name:@"lockScreen" object:nil];
    [defCenter addObserver:self selector:@selector(unlockScreen) name:@"unlockScreen" object:nil];
    [defCenter addObserver:self selector:@selector(beconeActiveField:) name:@"quickScanHide" object:nil];

    [defCenter addObserver:self selector:@selector(resignActiveField:) name:@"enterPinHideKeyboard" object:nil];
    [defCenter addObserver:self selector:@selector(beconeActiveField:) name:@"enterPinShowKeyboard" object:nil];

    [defCenter addObserver:self selector:@selector(activeFastScan) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activeFastScan) name:@"checkBecomeActivePinField" object:nil];




    [self enterPinRac];

    [self.view setNeedsUpdateConstraints];
    UIView *alphaView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [alphaView setBackgroundColor:[UIColor whiteColor]];
    [alphaView setAlpha:0.8];
    [self.bgView addSubview:alphaView];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (UIView *cornerView in self.cornerViewArray) {
            [cornerView setLayerCornerRadius:cornerView.bounds.size.height/2];
        }

        float fontSize = 40*((self.cornerViewTmp.bounds.size.width/60));
        for (UIButton *button in self.buttonsArray) {
            [button.titleLabel setFont:[UIFont fontWithName:@"ProbaNav2-ExtraLight" size:fontSize]];
        }
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.pinTextField.text = @"";
    [self.dotsView setActiveDot:0 animated:NO completion:nil];

    [UIApplication sharedApplication].applicationSupportsShakeToEdit = NO;

    [self activeDots];

    [self.bgView setImage:([AnyHelper sharedInstance].screenshotImage)?[AnyHelper sharedInstance].screenshotImage:[UIImage add_resizableImageWithColor:[UIColor whiteColor]]];

    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)enterPinRac {
    @weakify(self);
    [[RACObserve(self, pin) distinctUntilChanged] subscribeNext:^(NSString *pin) {
        @strongify(self);
        [self.dotsView setActiveDot:pin.length animated:YES completion:^{
            self.errorLabel.hidden = YES;
            [self correctPinCheck:NO];
            if (pin.length == 4) {
                [self checkPinRequest:pin];
            }
        }];
    }];
}

- (void)checkPinRequest :(NSString*)pin {
    if ([pin isEqualToString:@"1111"]) { //TCCAccount.object.pin
        [self correctPIN];
    } else {
        [self.dotsView setActiveDot:0 animated:YES completion:^{
        }];
        [self wrongState];
    }

    self.pin = @"";


    //    @weakify(self);
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        @strongify(self);
    //        NSString *paramPin = [[NSString stringWithFormat:@"%@%@",[self.account.pin tcc_md5], pin] tcc_md5];
    //        NSDictionary *params = @{@"pin":paramPin};
    //
    //        [self showHugMy];
    //        [self.pinTextField resignFirstResponder];
    //
    //        [TCCSharedHTTPSessionManager POST:TCCHTTPRequestCheckPinRoute parameters:params completion:^(id responseObject, NSString *errorStr) {
    //            [self hideHudMy];
    //            if (errorStr) {
    //                if ([errorStr isEqualToString:@"ERROR_FORBIDDEN"]) {
    //                    [self.pinTextField becomeFirstResponder];
    //                    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    //                    [self wrongState];
    //                    [self.dotsView setActiveDot:0 animated:YES completion:^{
    //                        self.pinTextField.text = @"";
    //                        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    //                    }];
    //                } else {
    //                    @weakify(self);
    //                    [UIAlertController showAlertInViewController:self withTitle:@"" message:errorStr cancelButtonTitle:@"Ок" destructiveButtonTitle:nil otherButtonTitles:nil textFieldPlaceholders:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
    //                        @strongify(self);
    //                        [self.pinTextField becomeFirstResponder];
    //                        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    //                        [self.dotsView setActiveDot:0 animated:YES completion:^{
    //                            self.pinTextField.text = @"";
    //                            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    //                        }];
    //
    //                    }];
    //                }
    //                return;
    //            } else {
    //                [SecurityHelper sharedInstance].securityKey = responseObject[@"str"];
    //                [self correctPIN];
    //            }
    //        }];
    //    });
}



- (void)lockScreen {
    [self.pinTextField resignFirstResponder];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.pinTextField resignFirstResponder];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.pinTextField resignFirstResponder];
    });
}

- (void)unlockScreen {

}

- (void)showHugMy {
    if (_hud) {
        return;
    }

    _hud = [[TCCProgressHud alloc] init];
    _hud.delegate = (id)self;
    [self.view addSubview:_hud];

    [_hud show];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)hideHudMy {
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [_hud hide];
    [_hud removeFromSuperview];
    _hud  = nil;
}

- (void)activeDots {
    [self setNeedsStatusBarAppearanceUpdate];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.51 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            self.account = TCCAccount.object;
            if (self.account.settings.useTouchID && self.account.isTouchIDAvailable) {
                [self.account passByBiometricsWithReason:@"Use touch id \n or hit \"Cancel\" to enter passcode" succesBlock:^{
                    [self.dotsView setActiveDot:6 animated:YES completion:^{
                    }];
                    [self checkPinRequest:TCCAccount.object.pin];
                } failureBlock:^(NSError *error) {
                }];
            } else {
            }
        });
}

- (void)activeFastScan {
    if ([self.delegate currentlyOnScreen] == YES) {
        [self activeDots];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
    [self.pinTextField resignFirstResponder];
    self.account = nil;
}

- (void)wrongState {
    self.errorLabel.hidden = NO;
    [self correctPinCheck:YES];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self.dotsViewContainer shakeXWithOffset:25.0f breakFactor:0.85f duration:0.75f maxShakes:6];
}

- (void)correctPIN {
    [self.delegate enterPINViewControllerDidEnterPIN:self];
    [AnyHelper sharedInstance].screenshotImage = nil;
    [NSNotificationCenter.defaultCenter postNotificationName:@"successEnterPin" object:nil];
    [self pinSucces];
}

- (void)pinSucces {
    TCCTabbarViewController *rootViewController = [TCCTabbarViewController new];
    [[UIApplication sharedApplication].keyWindow setRootViewController:rootViewController animated:YES];
}
#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug – see note вbelow.
    if (range.length + range.location > textField.text.length) {
        return NO;
    }
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 4;
}

#pragma mark -
#pragma mark Manage

- (void)show {
    UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
    self.view.frame = mainWindow.bounds;
    self.view.alpha = 1;
    [mainWindow addSubview:self.view];
}

- (void)hide {
    [self.pinTextField resignFirstResponder];
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    
    [UIView animateWithDuration:0.35f animations:^{
        //self.view.frameY = self.view.frameHeight;
        [self.view setAlpha:0];
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

- (IBAction)resignActiveField:(id)sender {
    //[self.pinTextField resignFirstResponder];
}

- (IBAction)beconeActiveField:(id)sender {
    //[self.pinTextField becomeFirstResponder];
}

- (void)correctPinCheck: (BOOL)error {
    [self.titleLabel setText:(error)?@"НЕВЕРНЫЙ PIN":@"ВВЕДИТЕ ВАШ PIN"];
    [self.titleLabel setTextColor:(error)?UIColorFromRGB(0xFC3942):UIColorFromRGB(0x000000)];
}

- (IBAction)popBackHandler:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)logoutHandler:(id)sender {
    [TCCAccount.object logout];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:[AuthViewController new]];
    [[UIApplication sharedApplication].keyWindow setRootViewController:nc animated:YES];
}

- (IBAction)numberHandler:(id)sender {
    self.pin = [NSString stringWithFormat:@"%@%ld",self.pin,(long)[(UIButton *)sender tag]];
}

- (IBAction)backspaceHandler:(id)sender {
    if (self.pin.length>0) {
        self.pin = [self.pin substringToIndex:self.pin.length-1];
    }
}
@end
