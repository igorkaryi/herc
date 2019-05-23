//
//  SpinnerButton.m
//  metro
//
//  Created by admin on 7/18/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "SpinnerButton.h"
#import <Lottie/Lottie.h>

@interface SpinnerButton ()
@property (nonatomic, retain) LOTAnimationView *lAnimation;
@property (nonatomic, retain) NSString *titleString;
@end


@implementation SpinnerButton

#pragma mark -
#pragma mark Lifecycle methods

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.lAnimation = [LOTAnimationView animationNamed:@"spinner1"];
    self.lAnimation.loopAnimation = YES;
    self.lAnimation.contentMode = UIViewContentModeScaleAspectFit;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.lAnimation setFrame:CGRectMake(self.bounds.size.width/2-15, (self.bounds.size.height-30)/2, 30, 30)];
        [self.lAnimation setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.lAnimation];
    });

    [self.lAnimation setHidden:YES];
}

- (void)startAnim {
    [[[UIApplication sharedApplication] keyWindow].rootViewController.view setUserInteractionEnabled:NO];
    [self.lAnimation setHidden:NO];
    self.titleString = self.titleLabel.text;
    [self setTitle:@"" forState:UIControlStateNormal];
    [self.lAnimation playWithCompletion:^(BOOL animationFinished) {

    }];
}

- (void)stopAnim {
    [[[UIApplication sharedApplication] keyWindow].rootViewController.view setUserInteractionEnabled:YES];
    [self.lAnimation setHidden:YES];
    [self setTitle:self.titleString forState:UIControlStateNormal];
    [self.lAnimation stop];
}

@end
