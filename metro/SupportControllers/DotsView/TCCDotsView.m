//
//  TCCDotsView.m
//  Tachcard
//
//  Created by Yaroslav Bulda on 15/10/15.
//  Copyright © 2015 Tachcard. All rights reserved.
//

#import "TCCDotsView.h"

@interface TCCDotView : UIView

@property (nonatomic) CGFloat borderWidth;
@property (nonatomic, strong) UIView *innerView;

@property (nonatomic, strong) NSArray *activeColor;
@property (nonatomic, strong) NSArray *inactiveColor;

@property (nonatomic, strong) CAGradientLayer *gradient;

@end

@implementation TCCDotView

#pragma mark -
#pragma mark Lifecycle methods

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        self.borderWidth = 1.5f;
        self.activeColor = @[(id)UIColorFromRGB(0x242021).CGColor, (id)UIColorFromRGB(0x242021).CGColor];
        self.inactiveColor = @[(id)UIColorFromRGB(0xAEBBC1).CGColor, (id)UIColorFromRGB(0xAEBBC1).CGColor];

        self.clipsToBounds = YES;

        self.innerView = [UIView new];
        self.innerView.backgroundColor = UIColor.whiteColor;
        [self addSubview:self.innerView];

        self.innerView.frame = CGRectInset(self.bounds, self.borderWidth, self.borderWidth);
        self.innerView.layer.cornerRadius = self.frameWidth/2.f - self.borderWidth;
        self.layer.cornerRadius = self.frameWidth/2.f;

        self.gradient = [CAGradientLayer layer];
        self.gradient.frame = self.bounds;
        self.gradient.colors = @[(id)UIColorFromRGB(0xAEBBC1).CGColor, (id)UIColorFromRGB(0xAEBBC1).CGColor];

        self.gradient.startPoint = CGPointMake(0.0, 0.0);
        self.gradient.endPoint = CGPointMake(1.0, 1.0);

        [self.layer insertSublayer:self.gradient atIndex:0];
    }
    return self;
}

@end

@interface TCCDotsView ()

@property (nonatomic, strong) NSMutableArray *dots;

@end

@implementation TCCDotsView

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
    self.dots = [NSMutableArray arrayWithCapacity:4];

    CGFloat dotSize = 1+8*1.5;
    CGFloat offset = 29;
    CGFloat xPos = -5.f;

    for (NSInteger idx = 0; idx < 4; idx++) {
        TCCDotView *dot = [[TCCDotView alloc] initWithFrame:CGRectMake(xPos, 0.f, dotSize, dotSize)];

        [self addSubview:dot];
        [self.dots addObject:dot];

        xPos += offset + dotSize;
    }

    self.activeDot = 0;
}

#pragma mark -
#pragma mark Manage

- (void)setActiveDot:(NSInteger)activeDot {
    [self setActiveDot:activeDot animated:NO completion:nil];
}

- (void)setActiveDot:(NSInteger)activeDot animated:(BOOL)animated  completion:(void (^)(void))completion {
    NSTimeInterval duration = animated ? 0.25f : 0.f;

    [self.layer removeAllAnimations];

    if (activeDot >= self.dots.count) {
        [UIView animateWithDuration:duration animations:^{
            for (NSInteger idx = 0; idx < self.dots.count; idx++) {
                TCCDotView *dot = self.dots[idx];
                dot.gradient.colors = dot.activeColor;
                dot.innerView.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
            }
        } completion:^(BOOL finished) {
            if (completion) {
                completion();
            }
        }];

        _activeDot = self.dots.count-1;
        return;
    }

    NSInteger moves = labs(self.activeDot - activeDot);
    NSInteger mpler = self.activeDot > activeDot ? -1 : 1;

    for (NSInteger move = 0; move < moves; move++) {
        TCCDotView *dot = self.dots[self.activeDot + (mpler * move)];
        [dot.innerView.layer removeAllAnimations];
    }

    [UIView animateWithDuration:duration animations:^{
        for (NSInteger move = 0; move < moves; move++) {
            TCCDotView *dot = self.dots[self.activeDot + (mpler * move)];
            if (mpler > 0) {
                dot.gradient.colors = dot.activeColor;
                dot.innerView.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
            } else {
                dot.gradient.colors = dot.inactiveColor;
                dot.innerView.transform = CGAffineTransformMakeScale(1.f, 1.f);
            }
        }

        TCCDotView *dot = self.dots[activeDot];
        dot.gradient.colors = dot.activeColor;
        dot.innerView.transform = CGAffineTransformMakeScale(1.f, 1.f);
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];

    _activeDot = activeDot;
}

@end
