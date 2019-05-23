//
//  ManualViewController.m
//  metro
//
//  Created by admin on 4/12/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "ManualViewController.h"
#import "AuthViewController.h"
#import "SMPageControl.h"

@interface ManualViewController ()

@property (nonatomic, retain) IBOutlet UIView *animationView;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (nonatomic, weak) IBOutlet UIButton *nextButton;
@property (nonatomic, weak) IBOutlet UIButton *ignoreButton;

@property (retain, nonatomic) IBOutlet SMPageControl *pageControl;
@end

@implementation ManualViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configPageControl];
    [self configButton:self.nextButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self playAnimationWithIndex:0];
    });
}

- (IBAction)nextButtonHandler:(id)sender {
    if (self.pageControl.currentPage >= self.pageControl.numberOfPages-1) {
        [self ignoreButtonHandler:sender];
    } else {
        self.pageControl.currentPage += 1;
        [self playAnimationWithIndex:self.pageControl.currentPage];
    }
}

- (void)playAnimationWithIndex:(NSInteger)animation {
    NSString *animationName;
    NSString *descriptionText;
    switch (animation) {
        case 0: {
            animationName = @"a1";
            descriptionText = @"Купуйте квитки у два дотики";
            self.imageView.image = [UIImage imageNamed:@"guide_1"];
        }
            break;
        case 1: {
            animationName = @"a2";
            descriptionText = @"Піднесіть телефон до верхньої панелі турнікета кодом униз та проходьте";
            self.imageView.image = [UIImage imageNamed:@"guide_2"];
        }
            break;
        case 2: {
            self.imageView.image = [UIImage imageNamed:@"guide_3"];
            [self.nextButton setTitle:@"Почати" forState:UIControlStateNormal];
            [self.ignoreButton setHidden:YES];
            animationName = @"a3";
            descriptionText = @"Додаток працює з системою Masterpass — це захищений гаманець для оплати банківськими картками";
        }
            break;
        default: {
            return;
        }
            break;
    }

    [self.descriptionLabel setText:descriptionText];
}

- (IBAction)ignoreButtonHandler:(id)sender {
    AuthViewController *vc = [AuthViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark iCarousel methods

- (void)configPageControl {
    self.pageControl.numberOfPages = 3;
    self.pageControl.alignment = SMPageControlAlignmentCenter;
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.00 green:0.49 blue:0.65 alpha:1.0];
    self.pageControl.indicatorMargin = 15.0f;

    self.pageControl.tapBehavior = SMPageControlTapBehaviorJump;
}


@end
