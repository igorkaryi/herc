//
//  UIImage+ImageWithColor.h
//  TachPay
//
//  Created by Yaroslav Bulda on 3/31/15.
//  Copyright (c) 2015 tachcard. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum __ADDImageGradientDirection {
    /**
     * Vertical direction.
     **/
    ADDImageGradientDirectionVertical,
    
    /**
     * Horizontal direction.
     **/
    ADDImageGradientDirectionHorizontal,
    
    /**
     * Left slanted direction.
     **/
    ADDImageGradientDirectionLeftSlanted,
    
    /**
     * Right slanted direction.
     **/
    ADDImageGradientDirectionRightSlanted ,
    ADDImageGradientDirectionFromLeftToRightCorner
} ADDImageGradientDirection;

@interface UIImage (Additions)

+ (UIImage *)add_resizableImageWithColor:(UIColor *)color;
+ (UIImage *)add_imageWithGradient:(NSArray *)colors size:(CGSize)size direction:(ADDImageGradientDirection)direction;

@end

