//
//  UIWindow+Additions.m
//  metro
//
//  Created by admin on 4/17/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "UIWindow+Additions.h"

@implementation UIWindow (Additions)

- (void)setRootViewController: (UIViewController *)rootViewController animated: (BOOL)animated
{
    UIView *snapShotView;

    if (animated)
    {
        snapShotView = [self snapshotViewAfterScreenUpdates: YES];
        [rootViewController.view addSubview: snapShotView];
    }

    [self setRootViewController: rootViewController];

    if (animated)
    {
        [UIView animateWithDuration: 0.3 animations:^{

            snapShotView.layer.opacity = 0;
            snapShotView.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5);

        } completion:^(BOOL finished) {

            [snapShotView removeFromSuperview];

        }];
    }
}

@end
