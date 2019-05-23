//
//  AboutMpWalletViewController.m
//  metro
//
//  Created by admin on 4/16/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "AboutMpWalletViewController.h"
#import "CardDataMpViewController.h"

@interface AboutMpWalletViewController ()

@end

@implementation AboutMpWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (IBAction)addCardHandler:(id)sender {
    CardDataMpViewController *vc = [CardDataMpViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
