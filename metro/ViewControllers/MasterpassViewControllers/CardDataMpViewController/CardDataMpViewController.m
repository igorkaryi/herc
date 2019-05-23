//
//  CardDataMpViewController.m
//  metro
//
//  Created by admin on 4/16/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "CardDataMpViewController.h"
#import "VcodeViewController.h"
#import "HowFindCvvViewController.h"
#import "AgreementViewController.h"

#import "MfsIOSLibrary.h"
#import "TCCMasterpassModel.h"


@interface CardDataMpViewController ()
@property (nonatomic, retain) IBOutlet MfsTextField *cardPanTextField;
@property (nonatomic, retain) IBOutlet MfsTextField *cvvTextField;

@property (nonatomic, retain) IBOutlet UITextField *dateTextField;
@property (nonatomic, retain) IBOutlet UITextField *cardNameTextField;

@property (weak, nonatomic) IBOutlet UILabel *lunErrorLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomPanFieldBorder;

@property (weak, nonatomic) IBOutlet SpinnerButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *offerButton;

@property BOOL isApproveOffer;
@end

@implementation CardDataMpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Дані картки";

    [self.cardPanTextField setType:1];
    [self.cardPanTextField setMaxLength:20];
    [self.cardPanTextField setKeyboardType:UIKeyboardTypeNumberPad];

    [self.cvvTextField setMaxLength:3];
    [self.cvvTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [self.cvvTextField setSecureTextEntry:YES];

    self.cardPanTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Номер картки"
                                                                           attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0x343534)}];

    self.dateTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"MM/YY"
                                                                                  attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0x343534)}];

    self.cvvTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"CVV"
                                                                                  attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0x343534)}];

    self.cardNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Назвіть картку"
                                                                              attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0x343534)}];

    self.isApproveOffer = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma - mark IBActions

- (IBAction)addHandler:(id)sender {
    [self.lunErrorLabel setAlpha:0];
    [self.bottomPanFieldBorder setBackgroundColor:UIColorFromRGB(0x000000)];

    NSArray *dateArray = [self.dateTextField.text componentsSeparatedByString:@"/"];
    NSString *monthStr;
    NSString *yearStr;

    if ([dateArray count]>=2) {
        monthStr = dateArray[0];
        yearStr = dateArray[1];
    }

    [self.nextButton startAnim];
    @weakify(self);
    [TCCSharedMasterpassModel registerClientWithName:self.cardNameTextField.text month:monthStr year:yearStr cardNumberField:self.cardPanTextField cvvField:self.cvvTextField param:nil completion:^(id responseObject, NSString *errorStr) {
        @strongify(self);
        [self.nextButton stopAnim];
        if (errorStr) {
            MfsResponse *mpResponseObject = responseObject;
            if([mpResponseObject.errorCode isEqualToString:@"5001"]) {
                VcodeViewController *vc = [VcodeViewController new];
                vc.tokenString = mpResponseObject.token;
                vc.currentType = VcodeTypeLinkCard;
                if (self.succesActionType) {
                    vc.succesActionType = self.succesActionType;
                }
                [self.navigationController pushViewController:vc animated:YES];
            } else if([mpResponseObject.errorCode isEqualToString:@"5007"]) {
                VcodeViewController *vc = [VcodeViewController new];
                vc.tokenString = mpResponseObject.token;
                vc.currentType = VcodeTypeLinkCard;
                if (self.succesActionType) {
                    vc.succesActionType = self.succesActionType;
                }
                [self.navigationController pushViewController:vc animated:YES];
            } else if([mpResponseObject.errorCode isEqualToString:@"5008"]) {
                VcodeViewController *vc = [VcodeViewController new];
                vc.tokenString = mpResponseObject.token;
                vc.currentType = VcodeTypeLinkCard;
                if (self.succesActionType) {
                    vc.succesActionType = self.succesActionType;
                }
                [self.navigationController pushViewController:vc animated:YES];
            } else if([mpResponseObject.errorCode isEqualToString:@"5015"]) {
                VcodeViewController *vc = [VcodeViewController new];
                vc.tokenString = mpResponseObject.token;
                vc.currentType = VcodeTypeLinkCard;
                if (self.succesActionType) {
                    vc.succesActionType = self.succesActionType;
                }
                [self.navigationController pushViewController:vc animated:YES];
            } else if([mpResponseObject.errorCode isEqualToString:@"E004"]) {
                [self.cardPanTextField becomeFirstResponder];
                [UIView animateWithDuration:0.3 animations:^{
                    [self.bottomPanFieldBorder setBackgroundColor:UIColorFromRGB(0xFF0000)];
                    [self.lunErrorLabel setAlpha:1];
                }];
            } else {
                [UIAlertController showAlertInViewController:self withTitle:@"" message:mpResponseObject.errorDescription cancelButtonTitle:@"Ок" destructiveButtonTitle:nil otherButtonTitles:nil textFieldPlaceholders:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                }];
            }
        } else {
            if ([[NSString stringWithFormat:@"%@",responseObject] isEqualToString:@"succes"]) {
                SuccesViewController *vc = [SuccesViewController new];
                vc.currentType = StatusViewTypeAddCardRegister;
                vc.succesActionType = (self.succesActionType)?self.succesActionType:StatusViewSuccesActionRootTabBar;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                [UIAlertController showAlertInViewController:self withTitle:@"" message:@"unknown error" cancelButtonTitle:@"Ок" destructiveButtonTitle:nil otherButtonTitles:nil textFieldPlaceholders:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                }];
            }
        }
    }];
}

- (IBAction)findCvvHandler:(id)sender {
    UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:[HowFindCvvViewController new]];
    [self.navigationController presentViewController:nc animated:YES completion:nil];
}

- (IBAction)termsHandler:(id)sender {
    AgreementViewController *vc = [AgreementViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)offerApproveHandler:(id)sender {
    self.isApproveOffer = !self.isApproveOffer;
    [self.offerButton setImage:[UIImage imageNamed:(self.isApproveOffer == YES)?@"checkbox":@"checkboxDisable"] forState:UIControlStateNormal];
    [self.nextButton setEnabled:self.isApproveOffer];
}

#pragma - mark UITextField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.dateTextField == textField) {
        NSString *filter = @"##/##";

        if(!filter) return YES; // No filter provided, allow anything

        NSString *changedString = [textField.text stringByReplacingCharactersInRange:range withString:string];

        if(range.length == 1 && // Only do for single deletes
           string.length < range.length &&
           [[textField.text substringWithRange:range] rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]].location == NSNotFound)
        {
            // Something was deleted.  Delete past the previous number
            NSInteger location = changedString.length-1;
            if(location > 0)
            {
                for(; location > 0; location--)
                {
                    if(isdigit([changedString characterAtIndex:location]))
                    {
                        break;
                    }
                }
                changedString = [changedString substringToIndex:location];
            }
        }

        textField.text = [changedString stringByFormat:filter];

        return NO;
    } else {
        return YES;
    }
}



@end
