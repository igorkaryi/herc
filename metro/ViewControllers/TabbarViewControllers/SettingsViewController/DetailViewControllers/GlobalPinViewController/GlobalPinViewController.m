//
//  GlobalPinViewController.m
//  metro
//
//  Created by admin on 4/24/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "GlobalPinViewController.h"

@interface GlobalPinViewController ()

@end

@implementation GlobalPinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.pinTextField1 becomeFirstResponder];

    RAC(self.nextButton, enabled) = [RACSignal combineLatest:@[self.pinTextField1.rac_textSignal, self.pinTextField2.rac_textSignal, self.pinTextField3.rac_textSignal, self.pinTextField4.rac_textSignal] reduce:^id(NSString *pin1, NSString *pin2, NSString *pin3, NSString *pin4){
        return @(pin1.length == 1 && pin2.length == 1 && pin3.length == 1 && pin4.length == 1);
    }];
}

- (IBAction)buttonHandler:(id)sender {

}

#pragma mark - textField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
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

@end
