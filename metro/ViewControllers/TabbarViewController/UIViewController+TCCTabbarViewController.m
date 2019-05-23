//
//  UIViewController+TCCTabbarViewController.m
//  Tachcard
//
//  Created by Yaroslav Bulda on 6/17/15.
//  Copyright (c) 2015 Tachcard. All rights reserved.
//

#import "UIViewController+TCCTabbarViewController.h"
#import "AppDelegate.h"

@implementation UIViewController (TCCTabbarViewController)

- (TCCTabbarViewController *)tccTabbarViewController {
    return (TCCTabbarViewController *)[((AppDelegate *)[[UIApplication sharedApplication] delegate]).window rootViewController];
}

@end
