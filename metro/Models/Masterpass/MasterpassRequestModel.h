//
//  MasterpassRequestModel.h
//  Tachcard
//
//  Created by admin on 6/26/17.
//  Copyright © 2017 Tachcard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MfsIOSLibrary.h"

#define TCCSharedMasterpassRequestModel [MasterpassRequestModel sharedInstance]

@interface MasterpassRequestModel : NSObject
+ (MasterpassRequestModel*)sharedInstance;
@property (strong, nonatomic) MfsIOSLibrary *mfsLib;

typedef void(^requestReturnResponse)(MfsResponse *responseObject);

- (void)getMasterpassConfigCompletion:(void (^)(BOOL comlete))completion;
- (void)checkMasterPassEndUser: (requestReturnResponse) returnResponse;
- (void)getCardsList: (requestReturnResponse)returnResponse;
- (void)deleteCardWithName: (NSString *)name returnResponse:(requestReturnResponse)returnResponse;
- (void)registerClientWithName: (MfsCard *)card cardNumberField:(MfsTextField *)cardNumberField cvvField:(MfsTextField *)cvvField param:(NSDictionary *)param returnResponse:(requestReturnResponse)returnResponse;
- (void)validateTransaction:(NSString*)token textField:(MfsTextField*)textField  returnResponse:(requestReturnResponse)returnResponse;
- (void)validateTransaction3D:(MfsWebView*)webView response:(MfsResponse*)response returnResponse:(requestReturnResponse)returnResponse;
- (void)pay:(NSString*)cardName amount:(NSString*)amount orderId:(NSString*)orderId paramsDict:(NSDictionary *)paramsDict qrData:(NSString *)qrData returnResponse:(requestReturnResponse)returnResponse;
- (void)verifyPin: (requestReturnResponse)returnResponse;
- (void)forgotPassword:(NSString*)cardNo returnResponse:(requestReturnResponse)returnResponse;
- (void)resendOtp:(NSString*)token returnResponse:(requestReturnResponse)returnResponse;
- (void)linkCardToClient:(requestReturnResponse)returnResponse;

@end
