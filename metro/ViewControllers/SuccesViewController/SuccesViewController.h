//
//  SuccesViewController.h
//  metro
//
//  Created by admin on 4/16/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, StatusViewType) {
    StatusViewTypeAddCardRegister = 1,
    StatusViewTypeAddCard,
    StatusViewTypePinOff
};

typedef NS_ENUM(NSUInteger, StatusViewSuccesAction) {
    StatusViewSuccesActionDismiss = 1,
    StatusViewSuccesActionPopBack,
    StatusViewSuccesActionPopRoot,
    StatusViewSuccesActionRootTabBar
};


@interface SuccesViewController : BaseViewController

@property (nonatomic, assign) StatusViewType currentType;
@property (nonatomic, assign) StatusViewSuccesAction succesActionType;

@end

