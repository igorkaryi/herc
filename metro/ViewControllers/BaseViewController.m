//
//  BaseViewController.m
//  3mob
//
//  Created by admin on 3/23/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "BaseViewController.h"
#import "DAKeyboardControl.h"

@interface BaseViewController () <TCCProgressHudDelegate> {
    TCCProgressHud *_hud;
}
@property BOOL statusbarStatus;
@end

@implementation BaseViewController

#pragma mark -
#pragma mark Class methods

+ (UINavigationController *)viewControllerInNavigation {
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[self new]];
    navigationController.navigationBar.translucent = NO;
    return navigationController;
}

- (void)configButton:(UIButton*)button {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = button.layer.bounds;
    
    gradientLayer.colors = [NSArray arrayWithObjects:
                            (id)[UIColor colorWithRed:0.01 green:0.19 blue:0.40 alpha:1.0].CGColor,
                            (id)[UIColor colorWithRed:0.00 green:0.62 blue:0.75 alpha:1.0].CGColor,
                            nil];
    
    gradientLayer.startPoint = CGPointMake(0.0, 0.5);
    gradientLayer.endPoint = CGPointMake(1.0, 0.5);
    
    gradientLayer.cornerRadius = button.layer.cornerRadius;
    [button.layer addSublayer:gradientLayer];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    @weakify(self);
    [self.view addKeyboardNonpanningWithFrameBasedActionHandler:nil constraintBasedActionHandler:^(CGRect keyboardFrameInView, BOOL opening, BOOL closing) {
        @strongify(self);
        self.bottomViewMarginConstraint.constant = self.view.frameHeight - keyboardFrameInView.origin.y;
        [self keyBoardDidChange];
    }];

    self.bgImageView = [UIImageView new];
    [self setBgImageColours:[UIColor whiteColor] secondColour:[UIColor whiteColor]];
    [self.bgImageView setFrame:self.view.bounds];
    [self.view insertSubview:self.bgImageView atIndex:0];

    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@""
                                             style:UIBarButtonItemStylePlain
                                             target:nil
                                             action:nil];


    self.navigationItem.backBarButtonItem.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)keyBoardDidChange {

}

- (void)setBgImageColours:(UIColor *)firstColour secondColour:(UIColor *)secondColour {
    [self.bgImageView setImage:[UIImage add_imageWithGradient:@[firstColour, secondColour] size:[UIScreen mainScreen].bounds.size direction:ADDImageGradientDirectionRightSlanted]];
}

- (void)setStatusbarHidden: (BOOL)status {
    self.statusbarStatus = status;
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
}

#pragma mark -
#pragma mark Customization helpers

- (void)setTitle:(NSString *)title {
    UILabel *titleLabel = (UILabel *) self.navigationItem.titleView;
    NSAttributedString *attrTitleStr = [[NSAttributedString alloc] initWithString:title
                                                                       attributes:@{NSFontAttributeName:[UIFont fontWithName:@"ProbaNav2-Regular" size:17.f],
                                                                                    NSForegroundColorAttributeName:UIColorFromRGB(0x2C2C2C),
                                                                                    NSKernAttributeName:@(0.5f)}];
    if (titleLabel == nil) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.shadowColor = [UIColor clearColor];

        titleLabel.attributedText = attrTitleStr;

        [titleLabel sizeToFit];

        self.navigationItem.titleView = titleLabel;
        [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:-0.5 forBarMetrics:UIBarMetricsDefault];
        return;
    }

    [titleLabel setAttributedText:attrTitleStr];
    [titleLabel sizeToFit];
}


- (IBAction)popBackButtonHandler:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)closeButtonHandler:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)closeButtonSetupRight: (BOOL)right {
    UIBarButtonItem *closeBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"closeIconNL"] style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonHandler:)];
    if (right == YES) {
        self.navigationItem.rightBarButtonItem = closeBtn;
    } else {
        self.navigationItem.leftBarButtonItem = closeBtn;
    }
}

#pragma mark -
#pragma mark MBProgressHud methods

- (void)showHudWithMessage:(NSString *)message inView:(UIView *)view {
    if (_hud) {
        return;
    }

    _hud = [[TCCProgressHud alloc] init];
    _hud.delegate = self;
    [view addSubview:_hud];

    [_hud show];
}

- (void)showHud {
    [self.view endEditing:YES];
    [self showHudWithMessage:nil inView:self.navigationController.view];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)hideHud {
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [_hud hide];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate Methods

- (void)hudWasHidden:(TCCProgressHud *)hud {
    _hud = nil;
}

- (BOOL)prefersStatusBarHidden {
    return self.statusbarStatus;
}

- (void)backButtonWithColor: (UIColor *)color {
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, 40, 40)];
    [btn addTarget:self action:@selector(popBackButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[[UIImage imageNamed:@"backBtnIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [btn setTintColor:color];
    [self.view addSubview:btn];
}

- (void)closeButtonWithColor: (UIColor *)color {

}

- (UIViewController*)topViewController {
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[TCCTabbarViewController class]]) {
        TCCTabbarViewController* tabBarController = (TCCTabbarViewController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}
@end
