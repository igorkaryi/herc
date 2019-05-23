//
//  TCCProgressHud.h
//  Tachcard
//
//  Created by Yaroslav Bulda on 7/5/15.
//  Copyright (c) 2015 Tachcard. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TCCProgressHud;

@protocol TCCProgressHudDelegate <NSObject>

- (void)hudWasHidden:(TCCProgressHud *)hud;

@end

@interface TCCProgressHud : UIView

@property (weak, nonatomic) id<TCCProgressHudDelegate> delegate;

- (void)show;
- (void)hide;

@end
