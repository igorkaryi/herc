//
//  UIView+ShakeEffect.m
//  iGlobe
//
//  Created by Yaroslav Bulda on 2/6/15.
//  Copyright (c) 2015 iGlobe. All rights reserved.
//

#import "UIView+ShakeEffect.h"

@implementation UIView (ShakeEffect)

- (void)shakeX {
    [self shakeXWithOffset:40.0 breakFactor:0.85 duration:1.5 maxShakes:30];
}

- (void)shakeXWithOffset:(CGFloat)aOffset breakFactor:(CGFloat)aBreakFactor duration:(CGFloat)aDuration maxShakes:(NSInteger)maxShakes {
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [animation setDuration:aDuration];
    
    
    NSMutableArray *keys = [NSMutableArray arrayWithCapacity:20];
    NSInteger infinitySec = maxShakes;
    while(aOffset > 0.01) {
        [keys addObject:[NSValue valueWithCGPoint:CGPointMake(self.center.x - aOffset, self.center.y)]];
        aOffset *= aBreakFactor;
        [keys addObject:[NSValue valueWithCGPoint:CGPointMake(self.center.x + aOffset, self.center.y)]];
        aOffset *= aBreakFactor;
        infinitySec--;
        if(infinitySec <= 0) {
            break;
        }
    }
    
    animation.values = keys;
    
    
    [self.layer addAnimation:animation forKey:@"position"];
}

@end
