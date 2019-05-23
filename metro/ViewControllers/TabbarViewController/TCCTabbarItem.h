//
//  TCCTabBarItem.h
//  Tachcard
//
//  Created by Yaroslav Bulda on 6/12/15.
//  Copyright (c) 2015 Tachcard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCCTabbarItem : UIControl

@property (nonatomic) UIOffset imagePositionAdjustment;

- (void)setSelectedImageName:(NSString *)selImageName andUnSelectedImageName:(NSString *)unSelImageName;
- (void)setTitle:(NSString *)title selectedColor:(UIColor *)selcolor andUnSelectedColor:(UIColor *)unselcolor;

- (void)setIndicatorHidden:(BOOL)hidden;
- (void)highlight;

@end
