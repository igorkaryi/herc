//
//  MasterpassRequestModel.m
//  Tachcard
//
//  Created by admin on 6/26/17.
//  Copyright © 2017 Tachcard. All rights reserved.
//

#import "MasterpassRequestModel.h"
#import "GCDSingleton.h"
#import "TCCHTTPSessionManager.h"
#import "TCCAccount+Manage.h"

@interface MasterpassRequestModel ()
@property (nonatomic, copy) requestReturnResponse returnResponse;

@end

@implementation MasterpassRequestModel

#pragma mark -
#pragma mark Singletone

+ (instancetype)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [self new];
    });
}

#pragma mark -
#pragma mark Lifecycle methods

- (instancetype)init {
    self = [super init];
    if (self) {
        if (!self.mfsLib || !self.mfsLib.baseURL) {
            TCCAccount *account = [TCCAccount object];
            self.mfsLib =  [[MfsIOSLibrary alloc] initWithMsisdn:[TCCAccount object].name];

            self.mfsLib.baseURL = account.mfsBaseURL;
            self.mfsLib.clientId = account.mfsClientId;
            self.mfsLib.macroMerchantId = account.mfsMacroMerchantId;
            self.mfsLib.language = account.mfsLanguage;
            self.mfsLib.msisdn = account.mfsMsisdn;

            [self getMasterpassConfigCompletion:^(BOOL comlete) {
            }];
        }
    }
    return self;
}

- (void)getMasterpassConfigCompletion:(void (^)(BOOL comlete))completion {

    TCCAccount *account = [TCCAccount object];

    self.mfsLib =  [[MfsIOSLibrary alloc] initWithMsisdn:account.name];

    @weakify(self);
    [TCCSharedHTTPSessionManager POST:TCCHTTPRequestMasterpassGetConfig parameters:nil completion:^(id responseObject, NSString *errorStr) {
        @strongify(self);
        if (errorStr) {
            completion(FALSE);
            return;
        }

        NSLog(@"%@",responseObject);

        NSDictionary *mpSettings = responseObject[@"config"];

        self.mfsLib.baseURL = mpSettings[@"client_address"];//@"https://test.masterpassturkiye.com/MasterpassJsonServerHandler/v2";//@"https://uatui.masterpassturkiye.com/v2";//
        self.mfsLib.clientId = mpSettings[@"client_id"];
        self.mfsLib.macroMerchantId = mpSettings[@"macro_merchant_id"];
        self.mfsLib.language = @"eng";
        self.mfsLib.msisdn = [TCCAccount object].name;



        [[RLMRealm defaultRealm] transactionWithBlock:^{
            account.mfsBaseURL = mpSettings[@"client_address"];
            account.mfsClientId = mpSettings[@"client_id"];
            account.mfsMacroMerchantId = mpSettings[@"macro_merchant_id"];
            account.mfsLanguage = @"eng";
            account.mfsMsisdn = [TCCAccount object].name;
        }];

        completion(TRUE);
    }];
}

- (void)returnResponse:(MfsResponse*) responseObject {
    if (self.returnResponse) {
        self.returnResponse(responseObject);
    }
}

- (void)getToken:(NSDictionary *)param returnResponse:(requestReturnResponse)returnResponse completion:(void (^)(NSString *token, id responseObject))completion {

    NSDictionary *params = (param)?param:@{@"validation_type":@"01",@"msisdn_validated":@"01"};
    //@weakify(self);
    [TCCSharedHTTPSessionManager POST:TCCHTTPRequestMasterpassToken parameters:params completion:^(id responseObject, NSString *errorStr) {
        //@strongify(self);
        if (errorStr) {
            NSLog(@"GET TOKEN ERROR STRING: %@",errorStr);
            self.returnResponse = returnResponse;
            MfsResponse *newErrorRespons = [MfsResponse new];
            newErrorRespons.errorCode = @"09090909";
            newErrorRespons.errorDescription = errorStr;
            [self returnResponse:newErrorRespons];
            return;
        } else {
            if ([responseObject isKindOfClass:[NSArray class]]) {
//                [TCCAlertView showLikeErrorWithText:@"Masterpass disable on tachcard server" okButtonHandler:^(NSInteger idx) {
//
//                }];
            } else {
                if ([[responseObject allKeys]containsObject:@"token"]) {
                    NSLog(@"GET TOKEN STRING: %@",responseObject[@"token"]);
                    completion(responseObject[@"token"],responseObject);
                } else {
                    completion(@"missingToken",responseObject);
                }
            }
        }
    }];
}

- (void)getTlvToken:(NSDictionary *)param returnResponse:(requestReturnResponse)returnResponse completion:(void (^)(NSString *token))completion {
    NSDictionary *params = (param)?param:@{@"validation_type":@"01",@"msisdn_validated":@"01"};
    //@weakify(self);
    [TCCSharedHTTPSessionManager GET:TCCHTTPRequestMasterpassGetTlvToken parameters:params completion:^(id responseObject, NSString *errorStr) {


        //@strongify(self);
        if (errorStr) {
            NSLog(@"GET TOKEN ERROR STRING: %@",errorStr);
            self.returnResponse = returnResponse;
            MfsResponse *newErrorRespons = [MfsResponse new];
            newErrorRespons.errorCode = @"09090909";
            newErrorRespons.errorDescription = errorStr;
            [self returnResponse:newErrorRespons];
            return;
        } else {
            if ([responseObject isKindOfClass:[NSArray class]]) {
//                [TCCAlertView showLikeErrorWithText:@"Masterpass disable on tachcard server" okButtonHandler:^(NSInteger idx) {
//
//                }];
            } else {
                if ([[responseObject allKeys]containsObject:@"token"]) {
                    NSLog(@"GET TOKEN STRING: %@",responseObject[@"token"]);
                    completion(responseObject[@"token"]);
                } else {
                    completion(@"missingToken");
                }
            }
        }
    }];
}

#pragma mark -
#pragma mark MP methods

- (void)checkMasterPassEndUser: (requestReturnResponse)returnResponse {
    @weakify(self);
    [self getToken:nil returnResponse:returnResponse completion:^(NSString *token, id responseObject) {
        @strongify(self);
        self.returnResponse = returnResponse;
        [self.mfsLib checkMasterPassEndUser:[TCCAccount object].name token:token checkCallback:@selector(returnResponse:) checkTarget:self];
    }];
}

- (void)getCardsList: (requestReturnResponse)returnResponse {
    @weakify(self);
    [self getToken:nil returnResponse:returnResponse completion:^(NSString *token, id responseObject) {
        @strongify(self);
        NSLog(@"token %@",token);
        NSLog(@"cardsListReferenceNo %@",responseObject[@"reference_no"]);

        [[NSUserDefaults standardUserDefaults]setObject:token forKey:@"cardsListToken"];
        [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"reference_no"] forKey:@"cardsListReferenceNo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.returnResponse = returnResponse;
        [self.mfsLib getCards:@selector(returnResponse:) token:token getCardsTarget:self];
    }];
}

- (void)deleteCardWithName: (NSString *)name returnResponse:(requestReturnResponse)returnResponse {
    @weakify(self);
    [self getToken:nil returnResponse:returnResponse completion:^(NSString *token, id responseObject) {
        @strongify(self);
        self.returnResponse = returnResponse;
        [self.mfsLib deleteCard:name token:token deleteCallback:@selector(returnResponse:) deleteTarget:self];
    }];
}

- (void)registerClientWithName: (MfsCard *)card cardNumberField:(MfsTextField *)cardNumberField cvvField:(MfsTextField *)cvvField param:(NSDictionary *)param returnResponse:(requestReturnResponse)returnResponse {

    @weakify(self);
    [self getToken:param returnResponse:returnResponse completion:^(NSString *token, id responseObject) {
        @strongify(self);
        self.returnResponse = returnResponse;
        [self.mfsLib registerClient:card token:token textField:cardNumberField cvv:cvvField registerCallback:@selector(returnResponse:) registerTarget:self];
    }];
}

- (void)pay:(NSString*)cardName amount:(NSString*)amount orderId:(NSString*)orderId paramsDict:(NSDictionary *)paramsDict qrData:(NSString *)qrData returnResponse:(requestReturnResponse)returnResponse {

    NSDictionary *params = @{@"validation_type":@"04",@"msisdn_validated":@"01"};

    if (amount.floatValue >0 && amount.floatValue<=100) {
        params = @{@"validation_type":@"00",@"msisdn_validated":@"01"};
    } else if (amount.floatValue >=101 && amount.floatValue<=200) {
        params = @{@"validation_type":@"01",@"msisdn_validated":@"01"};
    } else if (amount.floatValue >=201 ) {
        params = @{@"validation_type":@"04",@"msisdn_validated":@"01"};
    }

    if (paramsDict) {
        params = paramsDict;
    }

    if (qrData) {
        NSMutableDictionary *tmpMutableDict = [[NSMutableDictionary alloc]initWithDictionary:params];
        [tmpMutableDict setObject:qrData forKey:@"qr_data"];
        @weakify(self);
        [self getTlvToken:tmpMutableDict returnResponse:returnResponse completion:^(NSString *token) {
            @strongify(self);
            self.returnResponse = returnResponse;

            NSString* encodedCardName = [cardName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

            int amoutnInt = amount.floatValue * 100;
            NSString *tokenStr = [NSString stringWithFormat:@"%@",token];
            NSString *encodedCardNameStr = [NSString stringWithFormat:@"%@",encodedCardName];
            NSString *amountStr = [NSString stringWithFormat:@"%d",amoutnInt];
            NSString *orderIdStr = [NSString stringWithFormat:@"%@",orderId];

            [self.mfsLib pay:encodedCardNameStr token:tokenStr amount:amountStr cvv:nil orderId:orderIdStr payCallback:@selector(returnResponse:) payTarget:self];
        }];
    } else {
        @weakify(self);
        [self getToken:params returnResponse:returnResponse completion:^(NSString *token, id responseObject) {
            @strongify(self);
            self.returnResponse = returnResponse;

            NSString* encodedCardName = [cardName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

            int amoutnInt = amount.floatValue * 100;
            NSString *tokenStr = [NSString stringWithFormat:@"%@",token];
            NSString *encodedCardNameStr = [NSString stringWithFormat:@"%@",encodedCardName];
            NSString *amountStr = [NSString stringWithFormat:@"%d",amoutnInt];
            NSString *orderIdStr = [NSString stringWithFormat:@"%@",orderId];

            [self.mfsLib pay:encodedCardNameStr token:tokenStr amount:amountStr cvv:nil orderId:orderIdStr payCallback:@selector(returnResponse:) payTarget:self];
        }];
    }
}

- (void)validateTransaction:(NSString*)token textField:(MfsTextField*)textField  returnResponse:(requestReturnResponse)returnResponse {
    self.returnResponse = returnResponse;
    [self.mfsLib validateTransaction:token textField:textField validateTransactionCallback:@selector(returnResponse:) validateTransactionTarget:self];
}

- (void)validateTransaction3D: (MfsWebView*)webView response:(MfsResponse*)response returnResponse:(requestReturnResponse)returnResponse {
    self.returnResponse = returnResponse;
    [self.mfsLib validateTransaction3D:webView response:response validateCallback:@selector(returnResponse:) validateTarget:self];
}

- (void)verifyPin: (requestReturnResponse)returnResponse {
    @weakify(self);
    [self getToken:nil returnResponse:returnResponse completion:^(NSString *token, id responseObject) {
        @strongify(self);
        self.returnResponse = returnResponse;
        [self.mfsLib verifyPin:[TCCAccount object].name token:token verifyPinCallback:@selector(returnResponse:) verifyPinTarget:self];
    }];
}

- (void)forgotPassword:(NSString*)cardNo returnResponse:(requestReturnResponse)returnResponse {

    @weakify(self);
    [self getToken:nil returnResponse:returnResponse completion:^(NSString *token, id responseObject) {
        @strongify(self);
        self.returnResponse = returnResponse;
        [self.mfsLib forgotPassword:[TCCAccount object].name token:token cardNo:cardNo forgotPasswordCallback:@selector(returnResponse:) forgotPasswordTarget:self];
    }];
}

- (void)resendOtp:(NSString*)token returnResponse:(requestReturnResponse)returnResponse {
    self.returnResponse = returnResponse;
    [self.mfsLib resendOtp:(NSString*)token resendOtpCallback:@selector(returnResponse:) resendOtpTarget:self];
}

- (void)linkCardToClient:(requestReturnResponse)returnResponse {
    @weakify(self);
    [self getToken:nil returnResponse:returnResponse completion:^(NSString *token, id responseObject) {
        @strongify(self);
        self.returnResponse = returnResponse;
        [self.mfsLib linkCardToClient:[TCCAccount object].name token:token cardName:nil linkCallback:@selector(returnResponse:) linkTarget:self];
    }];
}

@end





















