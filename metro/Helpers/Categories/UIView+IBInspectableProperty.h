//
//  UIView+IBInspectableProperty.h
//  metro
//
//  Created by admin on 4/18/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (IBInspectableProperty)

@property(nonatomic, assign) IBInspectable CGFloat layerCornerRadius;
@property(nonatomic, assign) IBInspectable UIColor* borderUIColor;
@property(nonatomic, assign) IBInspectable CGFloat borderWidth;

@end
