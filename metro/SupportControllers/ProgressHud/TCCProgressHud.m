//
//  TCCProgressHud.m
//  Tachcard
//
//  Created by Yaroslav Bulda on 7/5/15.
//  Copyright (c) 2015 Tachcard. All rights reserved.
//

#import "TCCProgressHud.h"
#import "TCCProgressView.h"
#import <Lottie/Lottie.h>

@interface TCCProgressHud ()

@property (nonatomic, strong) TCCProgressView *progressView;
@property (nonatomic, strong) UIView *progressBGView;
@property (nonatomic, retain) LOTAnimationView *lAnimation;

@end

@implementation TCCProgressHud

#pragma mark -
#pragma mark Lifecycle methods

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        self.progressBGView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 75.f, 65.f)];
        self.progressBGView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
        self.progressBGView.layer.cornerRadius = 9.f;
        [self addSubview:self.progressBGView];

        self.lAnimation = [LOTAnimationView animationNamed:@"loader"];
        self.lAnimation.contentMode = UIViewContentModeScaleAspectFit;
        [self.lAnimation setFrame:CGRectMake(-5, 7, 75, 75)];
        [self.lAnimation setBackgroundColor:[UIColor clearColor]];
        self.lAnimation.loopAnimation = YES;
        self.lAnimation.autoReverseAnimation = NO;
        [self.progressBGView addSubview:self.lAnimation];
        [self.lAnimation play];

//        [self.lAnimation playWithCompletion:^(BOOL animationFinished) {
//            // Do Something
//        }];

        self.progressView = [[TCCProgressView alloc] initWithFrame:CGRectMake(0.f, 0.f, 30.f, 30.f)];
        self.progressView.cornerRadius = 5.f;
        self.progressView.gradientView.colors = @[
                                                  (id)[UIColor whiteColor].CGColor,
                                                  (id)[UIColor clearColor].CGColor,
                                                  (id)[UIColor clearColor].CGColor
                                                  ];
        //[self addSubview:self.progressView];
        
        self.alpha = 0.f;
    }
    return self;
}

- (void)layoutIfNeeded {
    [super layoutIfNeeded];
    
    self.frame = self.superview.bounds;
    
    self.progressBGView.center = self.center;
    self.progressView.center = self.center;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    if (self.superview) {
        [self layoutIfNeeded];
    }
}

#pragma mark -
#pragma mark Apperance

- (void)show {
    [self.progressView starAnimating];
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 1.f;
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self.progressView stopAnimating];
        [self removeFromSuperview];
        [self.delegate hudWasHidden:self];
    }];
}

@end
