//
//  GlobalPopupView.m
//  metro
//
//  Created by admin on 4/24/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "GlobalPopupView.h"

@implementation GlobalPopupView

- (void)showView {
    UIWindow *mainWindow = [[UIApplication sharedApplication] keyWindow];
    [mainWindow addSubview:self];

    self.frame = [[UIScreen mainScreen] bounds];
    [self layoutIfNeeded];

    self.alpha = 0.f;

    [UIView animateWithDuration:0.2f animations:^{
        self.alpha = 1.f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3f delay:0.f options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self layoutIfNeeded];
        } completion:nil];
    }];
}

- (void)hideView {
    [UIView animateWithDuration:0.3f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.alpha = 0.f;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
