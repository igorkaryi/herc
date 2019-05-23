//
//  SHSPhoneTextField.m
//  PhoneComponentExample
//
//  Created by Willy on 18.04.13.
//  Copyright (c) 2013 SHS. All rights reserved.
//

#import "SHSAnyTextField.h"
#import "SHSPhoneNumberFormatter+UserConfig.h"

@implementation SHSAnyTextField

-(void)logicInitialization
{
    _formatter = [[SHSPhoneAnyFormatter alloc] init];
    _formatter.textField = (id)self;
    
    logicDelegateInherit = [[SHSPhoneLogic alloc] init];
    
    [super setDelegate:logicDelegateInherit];
    self.keyboardType = UIKeyboardTypeNumberPad;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self logicInitialization];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self logicInitialization];
    }
    return self;
}

#pragma mark -
#pragma mark Delegates

-(void) setDelegate:(id<UITextFieldDelegate>)delegate
{
    logicDelegateInherit.delegate = delegate;
}

-(id<UITextFieldDelegate>) delegate
{
    return logicDelegateInherit.delegate;
}

#pragma mark -
#pragma mark Additional Text Setter

-(void) setFormattedText:(NSString *)text
{
    [SHSPhoneLogic applyFormat:(id)self forText:text];
}

-(NSString *) phoneNumber
{
    return [self.formatter digitOnlyString:self.text];
}

-(NSString *)stringWithoutPrefix
{
    return [self.formatter digitOnlyString:[self.text stringByReplacingOccurrencesOfString:self.formatter.prefix withString:@""]];
}




@end


