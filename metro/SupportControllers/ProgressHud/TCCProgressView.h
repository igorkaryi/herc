//
//  TCCProgressView.h
//  Tachcard
//
//  Created by Yaroslav Bulda on 6/10/15.
//  Copyright (c) 2015 Tachcard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCCAngleGradientView.h"

@interface TCCProgressView : UIView

@property (nonatomic, strong, readonly) TCCAngleGradientView *gradientView;

@property (nonatomic) CGFloat lineWidth;
@property (nonatomic) CGFloat cornerRadius;

- (void)starAnimating;
- (void)stopAnimating;

@end
