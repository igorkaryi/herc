//
//  TCCTabbarViewController.h
//  Tachcard
//
//  Created by Yaroslav Bulda on 6/12/15.
//  Copyright (c) 2015 Tachcard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCCTabbar.h"

@interface TCCTabbarViewController : UIViewController

@property (nonatomic, copy) IBOutletCollection(UIViewController) NSArray *viewControllers;

@property (nonatomic, weak) UIViewController *selectedViewController;
@property (nonatomic) NSUInteger selectedIndex;

@property (nonatomic, strong, readonly) TCCTabbar *tabBar;

@property (nonatomic, getter=isTabBarHidden) BOOL tabBarHidden;

- (void)setIndicatorAtIndex:(NSInteger)idx hidden:(BOOL)hidden;
- (void)highlightTabAtIndex:(NSInteger)idx;

- (void)showTopViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion;
- (void)dismissTopViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion;

@end
