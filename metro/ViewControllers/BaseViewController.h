//
//  BaseViewController.h
//  3mob
//
//  Created by admin on 3/23/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccesoryButtonView.h"
#import "TCCProgressHud.h"

@interface BaseViewController : UIViewController
- (IBAction)popBackButtonHandler:(id)sender;
- (IBAction)closeButtonHandler:(id)sender;

@property (nonatomic, retain) IBOutlet NSLayoutConstraint *bottomViewMarginConstraint;
@property (nonatomic, retain) AccesoryButtonView *accesoryButtonView;

+ (UINavigationController *)viewControllerInNavigation;

- (void)setStatusbarHidden: (BOOL)status;
- (void)setBgImageColours:(UIColor *)firstColour secondColour:(UIColor *)secondColour;

- (void)showHud;
- (void)hideHud;

@property (nonatomic, retain) UIImageView *bgImageView;

- (void)closeButtonSetupRight: (BOOL)right;

- (void)keyBoardDidChange;

- (void)backButtonWithColor: (UIColor *)color;
- (void)closeButtonWithColor: (UIColor *)color;

- (UIViewController*)topViewController;

- (void)configButton:(UIButton*)button;

@end
