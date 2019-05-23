//
//  AboutUsViewController.m
//  metro
//
//  Created by admin on 4/25/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (IBAction)openTachcardUrl:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://tachcard.com/ua"]];
}

@end
