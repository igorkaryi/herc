//
//  UIImage+ImageWithColor.m
//  TachPay
//
//  Created by Yaroslav Bulda on 3/31/15.
//  Copyright (c) 2015 tachcard. All rights reserved.
//

#import "UIImage+Additions.h"
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>

@implementation UIImage (Additions)

+ (UIImage *)add_resizableImageWithColor:(UIColor *)color {
    
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = CGRectMake(0.f, 0.f, 2.f, 2.f);
    imageLayer.backgroundColor = color.CGColor;
    
    UIGraphicsBeginImageContext(imageLayer.frame.size);
    [imageLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = [UIGraphicsGetImageFromCurrentImageContext() resizableImageWithCapInsets:UIEdgeInsetsMake(1.f, 1.f, 1.f, 1.f)];
    UIGraphicsEndImageContext();
    
    return img;
}

+ (UIImage *)add_imageWithGradient:(NSArray *)colors size:(CGSize)size direction:(ADDImageGradientDirection)direction {
    
    UIImage *image = nil;
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Create Gradient
    NSMutableArray *cgColors = [NSMutableArray arrayWithCapacity:colors.count];
    for (UIColor *color in colors)
        [cgColors addObject:(id)color.CGColor];
    
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(space, (__bridge CFArrayRef)cgColors, NULL);
    
    // Apply gradient
    CGPoint startPoint = CGPointZero;
    CGPoint endPoint = CGPointZero;
    
    if (direction == ADDImageGradientDirectionVertical) {
        endPoint = CGPointMake(0, rect.size.height);
    } else if (direction == ADDImageGradientDirectionHorizontal) {
        endPoint = CGPointMake(rect.size.width, 0);
    } else if (direction == ADDImageGradientDirectionLeftSlanted) {
        endPoint = CGPointMake(rect.size.width, rect.size.height);
    } else if (direction == ADDImageGradientDirectionRightSlanted) {
        startPoint = CGPointMake(rect.size.width, 0);
        endPoint = CGPointMake(0, rect.size.height);
    } else if (direction == ADDImageGradientDirectionFromLeftToRightCorner) {
        startPoint = CGPointMake(0, 0);
        endPoint = CGPointMake(rect.size.width, rect.size.height);
    }
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Clean memory & End context
    UIGraphicsEndImageContext();
    CGGradientRelease(gradient);
    CGColorSpaceRelease(space);
    
    return image;
}
@end
