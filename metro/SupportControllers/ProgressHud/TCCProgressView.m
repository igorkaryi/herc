//
//  TCCProgressView.m
//  Tachcard
//
//  Created by Yaroslav Bulda on 6/10/15.
//  Copyright (c) 2015 Tachcard. All rights reserved.
//

#import "TCCProgressView.h"

@interface TCCProgressView ()

@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) TCCAngleGradientView *gradientView;
@property (nonatomic, strong) UIView *containerView;

@end

@implementation TCCProgressView

#pragma mark -
#pragma mark Lifecycle methods

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.backgroundColor = UIColor.clearColor;
    self.lineWidth = 2.f;
    self.cornerRadius = 6.f;
    
    CAShapeLayer *shapeLayer = [CAShapeLayer new];
    shapeLayer.borderWidth = 0.f;
    shapeLayer.fillColor = UIColor.clearColor.CGColor;
    shapeLayer.lineWidth = 2.f;
    shapeLayer.strokeColor = [[UIColor whiteColor] CGColor];
    shapeLayer.backgroundColor = UIColor.clearColor.CGColor;
    
    self.shapeLayer = shapeLayer;
    
    self.containerView = [[UIView alloc] initWithFrame:self.bounds];
    self.containerView.layer.mask = shapeLayer;
    
    TCCAngleGradientView *gradientView = [[TCCAngleGradientView alloc] initWithFrame:self.bounds];
    self.gradientView = gradientView;
    [self.containerView addSubview:gradientView];
    self.containerView.backgroundColor = UIColor.clearColor;
    
    [self addSubview:self.containerView];
    
    
    self.clipsToBounds = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat outlineStrokeWidth = self.lineWidth;
    CGFloat outlineCornerRadius = self.cornerRadius;
    CGRect insetRect = CGRectInset(self.bounds, outlineStrokeWidth/2.0f, outlineStrokeWidth/2.0f);
    
    // get our rounded rect as a path
    CGPathRef path = CGPathCreateRoundRect(insetRect, outlineCornerRadius);
    
    self.shapeLayer.frame = self.bounds;
    self.shapeLayer.path = path;
    
    self.containerView.frame = self.bounds;
    
    CGFloat dR = self.bounds.size.width/sqrtf(2.f)/2.f;
    self.gradientView.frame = CGRectMake(-dR, -dR, self.bounds.size.width + 2*dR, self.bounds.size.width + 2*dR);
}

#pragma mark -
#pragma mark Animation

- (void)starAnimating {
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = @(M_PI * 2.0f);
    rotationAnimation.duration = 1.f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = INFINITY;
    rotationAnimation.fillMode = kCAFillModeForwards;
    rotationAnimation.removedOnCompletion = NO;
    
    [self.gradientView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stopAnimating {
    [self.gradientView.layer removeAnimationForKey:@"rotationAnimation"];
}

#pragma mark -
#pragma mark Props 

- (void)setLineWidth:(CGFloat)lineWidth {
    self.shapeLayer.lineWidth = lineWidth;
}

- (CGFloat)lineWidth {
    return self.shapeLayer.lineWidth;
}

#pragma mark -
#pragma mark Private

CGPathRef CGPathCreateRoundRect(const CGRect r, const CGFloat cornerRadius) {
    UIBezierPath *outpath = [UIBezierPath bezierPathWithRoundedRect:r cornerRadius:cornerRadius];
    return outpath.CGPath;
}

@end
