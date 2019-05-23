//
//  UIView+ShakeEffect.h
//  iGlobe
//
//  Created by Yaroslav Bulda on 2/6/15.
//  Copyright (c) 2015 iGlobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ShakeEffect)

- (void)shakeX;
- (void)shakeXWithOffset:(CGFloat)aOffset breakFactor:(CGFloat)aBreakFactor duration:(CGFloat)aDuration maxShakes:(NSInteger)maxShakes;

@end
