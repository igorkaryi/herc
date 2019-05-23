//
//  MfsEditText.h
//  MfsIOSLibrary
//
//  Created by ercu on 09/04/15.
//  Copyright (c) 2015 Phaymobile. All rights reserved.
//

#ifndef MfsIOSLibrary_MfsEditText_h
#define MfsIOSLibrary_MfsEditText_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MfsTextCallback;

@protocol MfsCardTypeCallback <NSObject>

- (void)runCallback:(NSInteger)cardType;

@end

@protocol MfsFirst6CharsCallback <NSObject>

- (void)runFirst6CharsCallback:(NSString*)first6Chars;

@end

@protocol MfsCancelInstallmentCallback <NSObject>

- (void)runCancelInstallmentCallback;

@end

@protocol MfsTextFieldCallback <NSObject>

- (void) mfsTextFieldShouldBeginEditing:(NSInteger*)typeId;

@end

@interface MfsTextField : UITextField
- (void)setSystemId:(NSString*)systemId;
- (void)setCardTypeCallback:(id)callback;
- (void)setFirst6CharsCallback:(id)callback;
- (void)setCancelInstallmentCallback:(id)callback;
- (void)setMfsTextFieldCallback:(id)callback;
- (void)setMaxLength:(NSUInteger)maxLength;
- (void)setType:(NSInteger)typeId;
- (BOOL)isEqualTo:(MfsTextField*)textField2;
- (void)clear;
- (BOOL)validateInput;
- (BOOL)isEmpty;
- (NSString*)getFirst6Chars;
- (void)setSystemIdforGet:(NSString*)system_Id;
- (void)setTextAlignment:(NSTextAlignment)textAlignment;
- (void)setFirst6Digit:(NSString*)first6Digit;

@property (nonatomic, weak) id<MfsCardTypeCallback> delegateCardType;

@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@property (nonatomic, assign) NSDictionary *attrDictionary;

@property (nonatomic)  NSUInteger maxLength;


@end


#endif
