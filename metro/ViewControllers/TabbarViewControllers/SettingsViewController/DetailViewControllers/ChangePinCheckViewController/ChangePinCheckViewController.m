//
//  ChangePinCheckViewController.m
//  metro
//
//  Created by admin on 4/24/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "ChangePinCheckViewController.h"
#import "ChangePinCreateViewController.h"
#import "TCCAccount+Keychain.h"

@interface ChangePinCheckViewController ()
@end

@implementation ChangePinCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Зміна пін-коду";
    [self.nextButton setTitle:@"Далі" forState:UIControlStateNormal];
    [self.textLabel setText:@"Введіть наявний пін-код:"];
    [self.pinTextField1 becomeFirstResponder];
}

- (IBAction)buttonHandler:(id)sender {
    if ([TCCAccount.object.pin isEqualToString:[NSString stringWithFormat:@"%@%@%@%@",self.pinTextField1.text,self.pinTextField2.text,self.pinTextField3.text,self.pinTextField4.text]]) {
        ChangePinCreateViewController *vc = [[ChangePinCreateViewController alloc]initWithNibName:@"GlobalPinViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [UIAlertController showAlertInViewController:self withTitle:@"" message:@"Невірний пароль" cancelButtonTitle:@"Ок" destructiveButtonTitle:nil otherButtonTitles:nil textFieldPlaceholders:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            [self.pinTextField1 becomeFirstResponder];
        }];
    }
}

@end
