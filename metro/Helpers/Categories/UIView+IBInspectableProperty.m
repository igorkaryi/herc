//
//  UIView+IBInspectableProperty.m
//  metro
//
//  Created by admin on 4/18/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "UIView+IBInspectableProperty.h"

@implementation UIView (IBInspectableProperty)
@dynamic layerCornerRadius;
@dynamic borderUIColor;
@dynamic borderWidth;


- (void)setLayerCornerRadius:(CGFloat)layerCornerRadius {
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:layerCornerRadius];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    [self.layer setBorderWidth:borderWidth];
}

- (void)setBorderUIColor:(UIColor *)borderUIColor {
    [self.layer setBorderColor:borderUIColor.CGColor];
}



@end
