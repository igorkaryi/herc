//
//  AuthLinkMpViewController.m
//  metro
//
//  Created by admin on 4/13/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "AuthLinkMpViewController.h"
#import "VcodeViewController.h"
#import "TCCAccount+Manage.h"
#import "TCCTabbarViewController.h"
#import "TCCMasterpassModel.h"
#import "MasterpassRequestModel.h"
#import "VcodeViewController.h"
#import "SuccesViewController.h"

@interface AuthLinkMpViewController ()
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@end

@implementation AuthLinkMpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.textLabel setText:[NSString stringWithFormat:@"Схоже, для вашого номера \n+%@ вже створено Mastepass-гаманець. Підключіть його, щоб продовжити роботу.",[TCCAccount.object.name stringByFormat:@"### ## ### ## ##"]]];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

#pragma mark - IBActions

- (IBAction)linkHandler:(id)sender {
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
                NSLog(@"OTP asked");
                VcodeViewController *vc = [VcodeViewController new];
                vc.tokenString = [(MfsResponse *)responseObject token];
                vc.currentType = VcodeTypeLinkAccount;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                [UIAlertController showAlertInViewController:self withTitle:@"" message:[(MfsResponse *)responseObject errorDescription] cancelButtonTitle:@"Ок" destructiveButtonTitle:nil otherButtonTitles:nil textFieldPlaceholders:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                }];
            }
        }
    }];
}

- (IBAction)logInHandler:(id)sender {
    TCCTabbarViewController *rootViewController = [TCCTabbarViewController new];
    [[UIApplication sharedApplication].keyWindow setRootViewController:rootViewController animated:YES];
}

@end
