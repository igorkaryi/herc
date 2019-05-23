//
//  VcodeViewController.m
//  metro
//
//  Created by admin on 4/13/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "VcodeViewController.h"
#import "HowFinedVcodeViewController.h"
#import "TCCMasterpassModel.h"

@interface VcodeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *customTitleLabel;
@property (nonatomic, retain) IBOutlet MfsTextField *vcodeTextField;
@property (weak, nonatomic) IBOutlet SpinnerButton *nextButton;
@end

@implementation VcodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    switch (self.currentType) {
        case VcodeTypeLinkAccount: {
            [self.customTitleLabel setText:@"Підтвердження \nгаманця"];
        }
            break;
        case VcodeTypeLinkCard: {
            [self.customTitleLabel setText:@"Підтвердження \nкартки"];
        }
            break;

        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark - IBActions

- (IBAction)howHandler:(id)sender {
    HowFinedVcodeViewController *vc = [HowFinedVcodeViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)confirmHandler:(id)sender {
    [self.nextButton startAnim];
    @weakify(self);
    [TCCSharedMasterpassModel validateTransaction:self.tokenString textField:self.vcodeTextField completion:^(MfsResponse *responseObject, NSString *errorStr) {
        @strongify(self);
        [self.nextButton stopAnim];
        if([responseObject result]){
            [self succesAction];
        } else if ([[responseObject errorCode] isEqualToString:@"5001"]){
            VcodeViewController *vc = [VcodeViewController new];
            vc.tokenString = responseObject.token;
            vc.currentType = self.currentType;
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([[responseObject errorCode] isEqualToString:@"5007"]){
            VcodeViewController *vc = [VcodeViewController new];
            vc.tokenString = responseObject.token;
            vc.currentType = self.currentType;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            if (responseObject) {
                [UIAlertController showAlertInViewController:self withTitle:[responseObject errorDescription] message:[NSString stringWithFormat:@"unknown error scheme: %@",[responseObject errorCode]] cancelButtonTitle:@"Ок" destructiveButtonTitle:nil otherButtonTitles:nil textFieldPlaceholders:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                }];
            } else {
                [UIAlertController showAlertInViewController:self withTitle:nil message:errorStr cancelButtonTitle:@"Ок" destructiveButtonTitle:nil otherButtonTitles:nil textFieldPlaceholders:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                }];
            }
        }
    }];
}

- (void)succesAction {
    SuccesViewController *vc = [SuccesViewController new];
    switch (self.currentType) {
        case VcodeTypeLinkAccount: {
            vc.currentType = StatusViewTypeAddCardRegister;
            vc.succesActionType = (self.succesActionType)?self.succesActionType:StatusViewSuccesActionRootTabBar;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case VcodeTypeLinkCard: {
            vc.currentType = StatusViewTypeAddCard;
            vc.succesActionType = (self.succesActionType)?self.succesActionType:StatusViewSuccesActionRootTabBar;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
