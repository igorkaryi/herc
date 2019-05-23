//
//  AccesoryButtonView.m
//  3mob
//
//  Created by admin on 4/6/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "AccesoryButtonView.h"
#import "UIView+LoadNib.h"

@implementation AccesoryButtonView

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
    [self setBackgroundColor:mainColour];
    self.frameHeight = 50.f;
    [self setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|
                               UIViewAutoresizingFlexibleTopMargin|
                               UIViewAutoresizingFlexibleLeftMargin|
                               UIViewAutoresizingFlexibleRightMargin|
                               UIViewAutoresizingFlexibleBottomMargin)];

    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:self.button];
    self.button.frame = self.bounds;

    [self.button setTitle:@"Далее" forState:UIControlStateNormal];
    [self.button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor.whiteColor colorWithAlphaComponent:0.2f] forState:UIControlStateDisabled];
    [self.button setTitleColor:UIColor.blackColor forState:UIControlStateHighlighted];

    self.button.titleLabel.font = [UIFont fontWithName:@"SFUIText-Regular" size:16.f];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (!CGRectEqualToRect(self.bounds, self.button.frame)) {
        self.button.frame = self.bounds;
    }
}



@end
