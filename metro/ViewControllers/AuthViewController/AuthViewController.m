//
//  AuthViewController.m
//  metro
//
//  Created by admin on 4/12/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "AuthViewController.h"
#import "FinalAuthViewController.h"
#import "AgreementViewController.h"
#import "TCCEnterPINViewController.h"
#import "TCCHTTPSessionManager.h"

@interface AuthViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet SHSAnyTextField *textField;
@property (retain, nonatomic) IBOutlet SpinnerButton *nextButton;

@end

@implementation AuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.textField.formatter addOutputPattern:@"# ## ### ## ##" forRegExp:@"^\\d*$"];
    [self.textField setFormattedText:@"0675855576"];
}

- (void)viewWillAppear:(BOOL)animated {
    [self setNeedsStatusBarAppearanceUpdate];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)keyBoardDidChange {
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat newContentOffsetY = (self.scrollView.contentSize.height/2) - (self.scrollView.bounds.size.height/2);
        self.scrollView.contentOffset = CGPointMake(0, newContentOffsetY);
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - IBAction

- (IBAction)nextButtonHandler:(id)sender {
    [self.nextButton startAnim];
    NSDictionary *params = @{@"phone":[NSString stringWithFormat:@"38%@",self.textField.stringWithoutPrefix]};
    @weakify(self);
    [TCCSharedHTTPSessionManager POST:TCCHTTPRequestRegisterRoute parameters:params completion:^(id responseObject, NSString *errorStr) {
        @strongify(self);
        [self.nextButton stopAnim];
        if (errorStr) {
            [UIAlertController showAlertInViewController:self withTitle:@"" message:errorStr cancelButtonTitle:@"Ок" destructiveButtonTitle:nil otherButtonTitles:nil textFieldPlaceholders:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {

            }];
        } else {
            
            if ([responseObject[@"need_pin"]intValue] == 1) {
                
                TCCEnterPINViewController *vc = [TCCEnterPINViewController new];
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                FinalAuthViewController *vc = [FinalAuthViewController new];
                vc.tokenString = responseObject[@"token"];
                vc.userPhoneString = params[@"phone"];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }];
}

- (IBAction)agreementHandler:(id)sender {
    AgreementViewController *vc = [AgreementViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
