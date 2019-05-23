//
//  PayCheckWebViewController.m
//  metro
//
//  Created by admin on 5/1/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "PayCheckWebViewController.h"
#import "TCCHTTPSessionManager.h"
#import "SuccesViewController.h"

@interface PayCheckWebViewController ()

@end

@implementation PayCheckWebViewController

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}


- (void)absWebViewDidFinishLoad:(UIWebView *)webView {
    NSString *innerHTML = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];

    if ([innerHTML rangeOfString:@"success3ds"].location != NSNotFound || [innerHTML rangeOfString:@"{\"status\":true}"].location != NSNotFound) {
        [webView setHidden:YES];
        [self checkTransaction];
    }
}

- (void)checkTransaction {
    [self confirmPayWithToken:self.paymentToken];
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

@end
