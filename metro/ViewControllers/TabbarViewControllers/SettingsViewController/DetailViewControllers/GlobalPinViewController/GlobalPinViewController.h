//
//  GlobalPinViewController.h
//  metro
//
//  Created by admin on 4/24/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCCAccount+Manage.h"
#import "TCCAccount.h"
#import "SuccesViewController.h"

@interface GlobalPinViewController : BaseViewController
@property (nonatomic, retain) IBOutlet UITextField *pinTextField1;
@property (nonatomic, retain) IBOutlet UITextField *pinTextField2;
@property (nonatomic, retain) IBOutlet UITextField *pinTextField3;
@property (nonatomic, retain) IBOutlet UITextField *pinTextField4;
@property (nonatomic, retain) IBOutlet UIButton *nextButton;
@property (nonatomic, retain) IBOutlet UILabel *textLabel;
@end
