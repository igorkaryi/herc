//
//  UIScreen+Brightness.m
//  metro
//
//  Created by admin on 7/20/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "UIScreen+Brightness.h"
#import "NSTimer+BlocksKit.h"

@implementation UIScreen (Brightness)
@dynamic animatedBrightness;

- (void)setAnimatedBrightness:(float)endValue {

    CGFloat startValue = [[UIScreen mainScreen] brightness];

    if (endValue == startValue) {
        return;
    }

    CGFloat fadeInterval = 0.05;
    if (endValue < startValue)
        fadeInterval = -fadeInterval;

    __block CGFloat brightness = startValue;

    [NSTimer bk_scheduledTimerWithTimeInterval:0.01 block:^(NSTimer *time) {
        if (fabs(brightness-endValue)<0 || fabs(brightness-endValue)>1) {
            [time invalidate];
            return;
        } else {
            if (brightness<0 || brightness>1) {
                return;
            }
            NSLog(@"brightness : %f",brightness);

            brightness += fadeInterval;

            if (fabs(brightness-endValue) < fabs(fadeInterval)) {
                brightness = endValue;
                [[UIScreen mainScreen] setBrightness:brightness];
                [time invalidate];
                 return;
            }


            [[UIScreen mainScreen] setBrightness:brightness];
        }
    } repeats:YES];

    /*
    if  (animatedBrightness == [UIScreen mainScreen].brightness) {
        return;
    }

    __block float startBrightness = [UIScreen mainScreen].brightness;
    __block float finishBrightness = animatedBrightness;
    __block float diffBrightness = finishBrightness - startBrightness;

    __block float currentBrightness;

    [NSTimer bk_scheduledTimerWithTimeInterval:0.1 block:^(NSTimer *time) {



        NSLog(@"currentBrightness : %f",currentBrightness);

        if (startBrightness > finishBrightness) {
            currentBrightness = currentBrightness - startBrightness + diffBrightness/100;
            [[UIScreen mainScreen] setBrightness:currentBrightness];
            if (currentBrightness <= finishBrightness || currentBrightness<=0 || currentBrightness>=1) {
                //[[UIScreen mainScreen] setBrightness:animatedBrightness];
                [time invalidate];
                return;
            }
        } else {
            currentBrightness = currentBrightness + startBrightness + diffBrightness/100;
            [[UIScreen mainScreen] setBrightness:currentBrightness];
            if (currentBrightness >= finishBrightness || currentBrightness<=0 || currentBrightness>=1) {
                //[[UIScreen mainScreen] setBrightness:animatedBrightness];
                [time invalidate];
                return;
            }
        }


    } repeats:YES];


    NSLog(@"%f",animatedBrightness);
    NSLog(@"%f",[UIScreen mainScreen].brightness);
     */
}

@end
