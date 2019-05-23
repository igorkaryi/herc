//
//  FeedbackViewController.m
//  metro
//
//  Created by admin on 4/26/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "FeedbackViewController.h"
#import "SAMTextView.h"
#import "TCCHTTPSessionManager.h"
#import "SuccesViewController.h"

@interface FeedbackViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet SAMTextView *textView;
@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Залишити відгук";

    self.textView.layer.borderColor = UIColorFromRGB(0xD1D5DC).CGColor;
    self.textView.layer.borderWidth = 0.5f;
    self.textView.layer.cornerRadius = 4.f;

    self.textView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Відгук..."
                                                                          attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0xD1D5DC), NSFontAttributeName:self.textView.font}];
    self.textView.layoutManager.allowsNonContiguousLayout = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.textView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.textView resignFirstResponder];
}

- (IBAction)feedbackHandler:(id)sender {
    [self showHud];
    NSDictionary *params = @{ @"comment":self.textView.text};
    @weakify(self);
    [TCCSharedHTTPSessionManager POST:TCCHTTPRequestUserLeaveComment parameters:params completion:^(id responseObject, NSString *errorStr) {
        @strongify(self);
        [self hideHud];
        if (errorStr) {
            [UIAlertController showAlertInViewController:self withTitle:@"" message:errorStr cancelButtonTitle:@"Ок" destructiveButtonTitle:nil otherButtonTitles:nil textFieldPlaceholders:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            }];
        } else {
            SuccesViewController *vc = [SuccesViewController new];
            vc.succesActionType = StatusViewSuccesActionPopRoot;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}
@end
