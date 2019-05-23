//
//  LinkVcodeViewController.h
//  metro
//
//  Created by admin on 4/13/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuccesViewController.h"

typedef NS_ENUM(NSUInteger, VcodeType) {
    VcodeTypeLinkAccount = 1,
    VcodeTypeLinkCard
};



@interface VcodeViewController : BaseViewController
@property (nonatomic, assign) VcodeType currentType;
@property (nonatomic, retain) NSString *tokenString;
@property (nonatomic, assign) StatusViewSuccesAction succesActionType;
@end
