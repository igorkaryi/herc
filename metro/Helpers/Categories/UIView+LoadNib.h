//
//  UIView+loadNib.h
//
//  Created by Yaroslav Bulda on 12/25/13.
//  Copyright (c) 2013 All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIViewLoadNib <NSObject>
@optional

- (void)commonInit;

@end

@interface UIView (LoadNib) <UIViewLoadNib>

- (void)loadNib;

@end
