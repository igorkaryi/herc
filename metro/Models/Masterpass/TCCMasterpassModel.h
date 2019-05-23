//
//  TCCMasterpassModel.h
//  Tachcard
//
//  Created by admin on 6/26/17.
//  Copyright © 2017 Tachcard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MfsIOSLibrary.h"
//#import "TCCMasterpassWalletsListViewController.h"
#import "TCCMasterpassCard.h"

#define TCCSharedMasterpassModel [TCCMasterpassModel sharedInstance]

typedef NS_ENUM(NSUInteger, MPEndUserFlow) {
    MPEndUserUnknown = 0,
    MPEndUserDontHave,
    MPEndUserNotLink,
    MPEndUserLink
};

typedef NS_ENUM(NSUInteger, registerClientStatus) {
    registerClientStatusSucces = 0,
    registerClientStatusOTP,
    registerClientStatusMPIN,
    registerClientStatusOTPMasterPassDevice,
    registerClientStatusOTPMasterPassPhone,
    registerClientStatus3D,
    registerClientStatusPIN,
    registerClientStatusError
};

@interface TCCMasterpassModel : NSObject

@property (nonatomic, retain) NSString *mpToken;

typedef void(^MasterpassCompletionBlock)(id responseObject, NSString *errorStr);

+ (instancetype)sharedInstance;
//- (void)massterpassAddAccount;


//- (void)massterpassCellHandler:(id)viewController type:(MasterpassWalletsListType)type completion:(void (^)(BOOL comlete))completion;
- (void)registerClientWithName: (NSString *)name month:(NSString *)month year:(NSString *)year cardNumberField:(MfsTextField *)cardNumberField cvvField:(MfsTextField *)cvvField param:(NSDictionary *)param completion:(MasterpassCompletionBlock)completion;
- (void)validateTransaction:(NSString*)token textField:(MfsTextField*)textField completion:(MasterpassCompletionBlock)completion;
- (void)validateTransaction3D:(MfsWebView*)webView response:(MfsResponse*)response completion:(MasterpassCompletionBlock)completion;
- (void)getWallets: (MasterpassCompletionBlock)completion;
- (void)deleteCard: (TCCMasterpassCard *)card completion:(MasterpassCompletionBlock)completion;
- (void)payWithCardName: (NSString *)cardName amount:(NSString *)amount paramsDict:(NSDictionary *)paramsDict paymentToken:(NSString *)paymentToken qrData:(NSString *)qrData completion:(MasterpassCompletionBlock)completion;
- (void)verifyPin;
- (void)forgotPassword:(NSString *)cardNo completion:(MasterpassCompletionBlock)completion;
- (void)resendOtp:(NSString*)token completion:(MasterpassCompletionBlock)completion;

- (void)reloadMpDataWithCompletion:(void (^)(id responseObject, NSString *errorStr))completion;

//- (void)linkCardToClient: (MasterpassCompletionBlock)completion;

- (void)checkEndUserFlow:(void (^)(MPEndUserFlow endUserFlow))completion;
@end
