//
//  HowFindCvvViewController.m
//  metro
//
//  Created by admin on 4/16/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "HowFindCvvViewController.h"

@interface HowFindCvvViewController ()

@end

@implementation HowFindCvvViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self closeButtonSetupRight:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

@end
