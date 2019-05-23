//
//  LoaderViewController.m
//  metro
//
//  Created by admin on 4/12/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "LoaderViewController.h"
#import "ManualViewController.h"
#import "TCCTabbarViewController.h"

#import "TCCAccount+Manage.h"
#import "TCCAccount+Keychain.h"
#import "TCCAccount+HTTPRequests.h"

#import "TCCPinController.h"
#import <Lottie/Lottie.h>

@interface LoaderViewController ()
@property (nonatomic, retain) IBOutlet NSLayoutConstraint *metroLogoHeight;
@property (nonatomic, retain) IBOutlet NSLayoutConstraint *metroTitleHeadPadding;
@property (weak, nonatomic) IBOutlet UILabel *KMPLabel;

@property (nonatomic, retain) IBOutlet UIView *animationView;
@property (nonatomic, retain) LOTAnimationView *lAnimation;
@end

@implementation LoaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view layoutIfNeeded];
}

- (void)viewWillAppear:(BOOL)animated {
    [self setStatusbarHidden:YES];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self playAnimation];
}

- (void)playAnimation {
    if (!TCCAccount.object.isAuthorized) {
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:[ManualViewController new]];
        [[UIApplication sharedApplication].keyWindow setRootViewController:nc animated:YES];
    } else {
        TCCTabbarViewController *rootViewController = [TCCTabbarViewController new];
        [[UIApplication sharedApplication].keyWindow setRootViewController:rootViewController animated:YES];
        [TCCPinController setup];
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


@end
