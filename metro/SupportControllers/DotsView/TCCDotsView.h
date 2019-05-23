//
//  TCCDotsView.h
//  Tachcard
//
//  Created by Yaroslav Bulda on 15/10/15.
//  Copyright © 2015 Tachcard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCCDotsView : UIView

@property (nonatomic) NSInteger activeDot;
- (void)setActiveDot:(NSInteger)activeDot animated:(BOOL)animated completion:(void(^)(void))completion;

@end
