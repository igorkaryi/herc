//
//  AddCardMpInfoViewController.m
//  metro
//
//  Created by admin on 4/16/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "AddCardMpInfoViewController.h"
#import "AboutMpWalletViewController.h"
#import "CardDataMpViewController.h"

#import "TCCTabbarViewController.h"

@interface AddCardMpInfoViewController ()

@end

@implementation AddCardMpInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

#pragma mark - IBActions

- (IBAction)aboutHandler:(id)sender {
    AboutMpWalletViewController *vc = [AboutMpWalletViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)addCardHandler:(id)sender {
    CardDataMpViewController *vc = [CardDataMpViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)laterHandler:(id)sender {
    TCCTabbarViewController *rootViewController = [TCCTabbarViewController new];
    [[UIApplication sharedApplication].keyWindow setRootViewController:rootViewController animated:YES];
}



@end
