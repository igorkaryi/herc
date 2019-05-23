//
//  UIButton+IBInspectable.m
//  metro
//
//  Created by admin on 4/12/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "UIButton+IBInspectableProperty.h"

@implementation UIButton (IBInspectableProperty)

@dynamic mainTitleButtonColor;
@dynamic mainBgButtonColor;
@dynamic custonButtonImageUIColor;
@dynamic layerCornerRadius;
@dynamic bgUIColor;
@dynamic borderUIColor;
@dynamic borderWidth;
@dynamic imageColourCustom;

- (void)setMainTitleButtonColor:(BOOL)mainTitleButtonColor {
    if (mainTitleButtonColor) {
        [self setTitleColor:mainColour forState:UIControlStateNormal];
        [self setTitleColor:[mainColour colorWithAlphaComponent:0.5] forState:UIControlStateDisabled];
    }
}

- (void)setMainBgButtonColor:(BOOL)mainBgButtonColor {
    if (mainBgButtonColor) {
        [self setBackgroundColor:mainColour];
    }
}

- (void)setCustonButtonImageUIColor:(UIColor *)custonButtonImageUIColor {
    self.imageView.image = [self.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self setTintColor:custonButtonImageUIColor];
}

- (void)setLayerCornerRadius:(CGFloat)layerCornerRadius {
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:layerCornerRadius];
}

- (void)setBgUIColor:(UIColor *)bgUIColor {
    [self setBackgroundColor:bgUIColor];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    [self.layer setBorderWidth:borderWidth];
}

- (void)setBorderUIColor:(UIColor *)borderUIColor {
    [self.layer setBorderColor:borderUIColor.CGColor];
}

- (void)setImageColourCustom:(UIColor *)imageColourCustom {
    self.imageView.image = [self.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self setTintColor:imageColourCustom];
}

@end
