//
//  TCCTabbar.h
//  Tachcard
//
//  Created by Yaroslav Bulda on 6/12/15.
//  Copyright (c) 2015 Tachcard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCCTabbarItem.h"

@class TCCTabbar, TCCTabbarItem;

@protocol TCCTabBarDelegate <NSObject>

/**
 * Asks the delegate if the specified tab bar item should be selected.
 */
- (BOOL)tabBar:(TCCTabbar *)tabBar shouldSelectItemAtIndex:(NSInteger)index;

/**
 * Tells the delegate that the specified tab bar item is now selected.
 */
- (void)tabBar:(TCCTabbar *)tabBar didSelectItemAtIndex:(NSInteger)index;

@end

@interface TCCTabbar : UIView

@property (nonatomic, weak) id <TCCTabBarDelegate> delegate;
@property (nonatomic, copy) NSArray *items;

@property (nonatomic, weak) TCCTabbarItem *selectedItem;

- (void)setIndicatorAtIndex:(NSInteger)idx hidden:(BOOL)hidden;
- (void)highlightTabAtIndex:(NSInteger)idx;

@property (nonatomic, retain) UIView *separatoView;

@end
