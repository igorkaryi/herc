//
//  TurnOffPinViewController.m
//  metro
//
//  Created by admin on 4/24/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "TurnOffPinViewController.h"
#import "TCCAccount+Keychain.h"

@interface TurnOffPinViewController ()

@end

@implementation TurnOffPinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Вимкнути пін-код";
    [self.nextButton setTitle:@"Вимкнути пін-код" forState:UIControlStateNormal];
    [self.textLabel setText:@"Введіть пін-код:"];
    [self.pinTextField1 becomeFirstResponder];
}

- (IBAction)buttonHandler:(id)sender {
    if ([TCCAccount.object.pin isEqualToString:[NSString stringWithFormat:@"%@%@%@%@",self.pinTextField1.text,self.pinTextField2.text,self.pinTextField3.text,self.pinTextField4.text]]) {
        [[RLMRealm defaultRealm] transactionWithBlock:^{
            TCCAccount.object.settings.pinEnabled = FALSE;
        }];

        SuccesViewController *vc = [SuccesViewController new];
        vc.currentType = StatusViewTypePinOff;
        vc.succesActionType = StatusViewSuccesActionPopRoot;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [UIAlertController showAlertInViewController:self withTitle:@"" message:@"Невірний пароль" cancelButtonTitle:@"Ок" destructiveButtonTitle:nil otherButtonTitles:nil textFieldPlaceholders:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            [self.pinTextField1 becomeFirstResponder];
        }];
    }
}



@end
