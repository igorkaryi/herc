//
//  ChangePinCreateViewController.m
//  metro
//
//  Created by admin on 4/24/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "ChangePinCreateViewController.h"
#import "TCCAccount+Keychain.h"

@interface ChangePinCreateViewController ()

@end

@implementation ChangePinCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Зміна пін-коду";
    [self.nextButton setTitle:@"Змінити" forState:UIControlStateNormal];
    [self.textLabel setText:@"Введіть новий пін-код:"];
    [self.pinTextField1 becomeFirstResponder];
}

- (IBAction)buttonHandler:(id)sender {
    TCCAccount.object.pin = [NSString stringWithFormat:@"%@%@%@%@",self.pinTextField1.text,self.pinTextField2.text,self.pinTextField3.text,self.pinTextField4.text];
    SuccesViewController *vc = [SuccesViewController new];
    vc.currentType = StatusViewTypePinOff;
    vc.succesActionType = StatusViewSuccesActionPopRoot;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
