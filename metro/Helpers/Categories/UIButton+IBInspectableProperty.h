//
//  UIButton+IBInspectable.h
//  metro
//
//  Created by admin on 4/12/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (IBInspectableProperty)
@property(nonatomic, assign) IBInspectable BOOL mainTitleButtonColor;
@property(nonatomic, assign) IBInspectable BOOL mainBgButtonColor;
@property(nonatomic, assign) IBInspectable UIColor* custonButtonImageUIColor;
@property(nonatomic, assign) IBInspectable CGFloat layerCornerRadius;

@property(nonatomic, assign) IBInspectable UIColor* bgUIColor;
@property(nonatomic, assign) IBInspectable UIColor* borderUIColor;
@property(nonatomic, assign) IBInspectable CGFloat borderWidth;

@property(nonatomic, assign) IBInspectable UIColor* imageColourCustom;

@end
