//
//  TCCEnterPINViewController.h
//  Tachcard
//
//  Created by Yaroslav Bulda on 7/4/15.
//  Copyright (c) 2015 Tachcard. All rights reserved.
//

#import "BaseViewController.h"
#import "TCCDotsView.h"
#import "TCCAccount+Manage.h"
#import "TCCAccount+TouchID.h"
#import "TCCAccount+Keychain.h"
#import "TCCProgressHud.h"

@class TCCEnterPINViewController;

@protocol TCCEnterPINViewControllerDelegete <NSObject>
- (void)enterPINViewControllerDidEnterPIN:(TCCEnterPINViewController *)pinVC;
- (void)logOut;
- (BOOL)currentlyOnScreen;
@end

@interface TCCEnterPINViewController : BaseViewController

@property (weak, nonatomic) id<TCCEnterPINViewControllerDelegete> delegate;

- (void)show;
- (void)hide;

@property (strong, nonatomic) UITextField *pinTextField;

@property (weak, nonatomic) IBOutlet UIView *dotsViewContainer;
@property (weak, nonatomic) IBOutlet TCCDotsView *dotsView;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) TCCAccount *account;

@property (nonatomic, strong) NSString *pin;
@property TCCProgressHud *hud;

- (void)showHugMy;
- (void)hideHudMy;
- (void)wrongState;

- (void)correctPinCheck: (BOOL)error;
- (void)pinSucces;
@end
