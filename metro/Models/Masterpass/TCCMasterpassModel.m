//
//  TCCMasterpassModel.m
//  Tachcard
//
//  Created by admin on 6/26/17.
//  Copyright © 2017 Tachcard. All rights reserved.
//

#import "TCCMasterpassModel.h"
#import "GCDSingleton.h"
#import "TCCHTTPSessionManager.h"
#import "MasterpassRequestModel.h"

//#import "TCCMasterpassAddWalletNameViewController.h"
//#import "TCCMasterpassWebViewController.h"

//#import "TCCCheckMarkModDodeViewController.h"

#import "TCCAccount+Manage.h"
//#import "TCCMasterpassVcodeViewController.h"

#import "TCCMasterpassAccount.h"
#import "TCCMasterpassAccount+Manage.h"
#import "MasterpassRequestModel.h"

@interface TCCMasterpassModel ()
@property int payTryCount;
@end


@implementation TCCMasterpassModel

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
        TCCSharedMasterpassRequestModel;
    }
    return self;
}

- (void)reloadMpDataWithCompletion:(void (^)(id responseObject, NSString *errorStr))completion {
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [TCCSharedMasterpassRequestModel checkMasterPassEndUser:^(MfsResponse *responseObject) {
        if(responseObject.result){
            NSString *userFlouString = [[responseObject.cardStatus substringFromIndex:1]substringToIndex:4];
            if (userFlouString) {
                TCCMasterpassAccount *account = TCCMasterpassAccount.object;
                [realm beginWriteTransaction];
                account.userFlow = userFlouString;
                [realm commitWriteTransaction];
            }
        }

        [self getWallets:^(id responseObject, NSString *errorStr) {
            if (errorStr) {
                if (completion) {
                    completion(nil, errorStr);
                }
            } else {
                if (completion) {
                    completion(responseObject, nil);
                }
            }
        }];
    }];
}

- (void)checkEndUserFlow:(void (^)(MPEndUserFlow endUserFlow))completion {
    NSString *statusString = TCCMasterpassAccount.object.userFlow;
    if ([statusString isEqualToString:@"0000"]) {
        completion(MPEndUserDontHave);
    } else if ([statusString isEqualToString:@"1100"]) {
        completion(MPEndUserNotLink);
    } else if ([statusString isEqualToString:@"1110"]) {
        completion(MPEndUserLink);
    } else {
        completion(MPEndUserUnknown);
    }
}

#pragma mark -
#pragma mark Lifecycle methods

- (void)registerClientWithName: (NSString *)name month:(NSString *)month year:(NSString *)year cardNumberField:(MfsTextField *)cardNumberField cvvField:(MfsTextField *)cvvField param:(NSDictionary *)param completion:(MasterpassCompletionBlock)completion {
    MfsCard *card = [[MfsCard alloc] init];
    card.cardName = name;
    card.expireMonth = month;
    card.expireYear = year;

    [TCCSharedMasterpassRequestModel registerClientWithName:card cardNumberField:cardNumberField cvvField:cvvField param:param returnResponse:^(MfsResponse *responseObject) {
        if(responseObject.result){
            [self reloadMpDataWithCompletion:^(id responseObject, NSString *errorStr) {
                completion(@"succes",nil);
            }];
        } else if([responseObject.errorCode isEqualToString:@"5001"]) {
            completion(responseObject,responseObject.errorDescription);
        } else if([responseObject.errorCode isEqualToString:@"5002"]) {
            NSDictionary *parsmsDict = @{@"validation_type":@"01",@"msisdn_validated":@"01"};
            [self registerClientWithName:name month:month year:year cardNumberField:cardNumberField cvvField:cvvField param:parsmsDict completion:^(id responseObject, NSString *errorStr) {
                if (errorStr) {
                    completion(responseObject,errorStr);
                } else {
                    completion(responseObject,errorStr);
                }
            }];
        } else if([responseObject.errorCode isEqualToString:@"5007"]) {
            completion(responseObject,responseObject.errorDescription);
        } else if([responseObject.errorCode isEqualToString:@"5008"]) {
            completion(responseObject,responseObject.errorDescription);
        } else if([responseObject.errorCode isEqualToString:@"5010"]) {
            completion(responseObject,responseObject.errorDescription);
        } else if([responseObject.errorCode isEqualToString:@"5015"]) {
            completion(responseObject,responseObject.errorDescription);
        } else {
            if ([responseObject.errorCode isEqualToString:@"T_B0002"]) {
                NSLog(@"Your card is not 3DS enrolled");
                NSDictionary *parsmsDict = @{@"validation_type":@"01",@"msisdn_validated":@"01"};
                [self registerClientWithName:name month:month year:year cardNumberField:cardNumberField cvvField:cvvField param:parsmsDict completion:^(id responseObject, NSString *errorStr) {
                    if (errorStr) {
                        completion(responseObject,errorStr);
                    } else {
                        completion(responseObject,errorStr);
                    }
                }];
            } else {
                completion(responseObject,responseObject.errorDescription);
                NSLog(@"Error");
                NSLog(@"%@",responseObject.errorCode);
                NSLog(@"%@",responseObject.errorDescription);
            }
            return;
        }
    }];
}



- (void)validateTransaction:(NSString*)token textField:(MfsTextField*)textField completion:(MasterpassCompletionBlock)completion {
    [TCCSharedMasterpassRequestModel validateTransaction:token textField:textField returnResponse:^(MfsResponse *responseObject) {
        if(responseObject.result) {
            MfsResponse *tmpresponse = responseObject;
            [self reloadMpDataWithCompletion:^(id responseObject, NSString *errorStr) {
                 completion(tmpresponse, nil);
            }];
        } else if([responseObject.errorCode isEqualToString:@"5001"]){
            NSLog(@"OTP asked");
            completion(responseObject, nil);
        } else if([responseObject.errorCode isEqualToString:@"5002"]){
            NSLog(@"MPIN asked");
            completion(responseObject, nil);
        } else if([responseObject.errorCode isEqualToString:@"5007"]){
            NSLog(@"OTP MasterPass is asked");
            completion(responseObject, nil);
        } else if([responseObject.errorCode isEqualToString:@"5015"]){
            NSLog(@"PIN Define asked");
            completion(responseObject, nil);
        } else {
            completion(nil, responseObject.errorDescription);
            return;
        }
    }];
}

-(void)validateTransaction3D:(MfsWebView*)webView response:(MfsResponse*)response completion:(MasterpassCompletionBlock)completion {
    [TCCSharedMasterpassRequestModel validateTransaction3D:webView response:response returnResponse:^(MfsResponse *responseObject) {
        if(responseObject.result){
            MfsResponse *tmpresponse = responseObject;
            [self reloadMpDataWithCompletion:^(id responseObject, NSString *errorStr) {
                completion(tmpresponse, nil);
            }];
        } else {
            completion(nil, responseObject.errorDescription);
        }
    }];
}

- (void)getWallets: (MasterpassCompletionBlock)completion {
    [TCCSharedMasterpassRequestModel getCardsList:^(MfsResponse *responseObject) {
        if(responseObject.result){
            NSLog(@"MPRefNo %@",responseObject.refNo);
            [[NSUserDefaults standardUserDefaults]setObject:responseObject.refNo forKey:@"cardsListRefNo"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            RLMRealm *realm = [RLMRealm defaultRealm];

            [realm beginWriteTransaction];
            [realm deleteObjects:[TCCMasterpassCard allObjects]];
            [realm commitWriteTransaction];
            
            for (MfsCard *card in responseObject.cardList) {
                TCCMasterpassCard *newCard = [TCCMasterpassCard new];

                newCard.cardName = card.cardName;
                newCard.cardNo = card.cardNo;
                newCard.expireMonth = card.expireMonth;
                newCard.cardStatus = card.cardStatus;
                newCard.expireYear = card.expireYear;
                newCard.cardHolderName = card.cardHolderName;
                newCard.cvv = card.cvv;
                newCard.bankIca = card.bankIca;
                newCard.loyaltyCode = card.loyaltyCode;
                newCard.productName = card.productName;
                newCard.cardId = card.cardId;
                newCard.eftCode = card.eftCode;

                [realm beginWriteTransaction];
                [realm addObject:newCard];
                [realm commitWriteTransaction];

            }
            completion([TCCMasterpassCard allObjects], nil);
        } else {
            completion(nil, responseObject.errorDescription);
        }
    }];
}

//- (void)getWallets: (MasterpassCompletionBlock)completion {
//
//    NSMutableArray *tmpArray = [NSMutableArray new];
//
//    for (TCCMasterpassCard *card in [TCCMasterpassCard allObjects]) {
//
//        TCCMasterpassCard *newCard = [TCCMasterpassCard new];
//        newCard.cardName = card.cardName;
//        newCard.cardNo = card.cardNo;
//        newCard.expireMonth = card.expireMonth;
//        newCard.cardStatus = card.cardStatus;
//        newCard.expireYear = card.expireYear;
//        newCard.cardHolderName = card.cardHolderName;
//        newCard.cvv = card.cvv;
//
//        newCard.bankIca = card.bankIca;
//        newCard.loyaltyCode = card.loyaltyCode;
//        newCard.productName = card.productName;
//        newCard.cardId = card.cardId;
//        newCard.eftCode = card.eftCode;
//
//        [tmpArray addObject:newCard];
//    }
//
//    if ([[TCCMasterpassCard allObjects] count]>0) {
//        completion([TCCMasterpassCard allObjects], nil);
//    } else {
//        [TCCSharedMasterpassRequestModel getCardsList:^(MfsResponse *responseObject) {
//            if(responseObject.result){
//
//                RLMRealm *realm = [RLMRealm defaultRealm];
//
//                for (MfsCard *card in responseObject.cardList) {
//                    if ([[TCCMasterpassCard objectsWhere:@"cardId == %@",card.cardId]count]==0) {
//
//                        TCCMasterpassCard *newCard = [TCCMasterpassCard new];
//
//                        newCard.cardName = card.cardName;
//                        newCard.cardNo = card.cardNo;
//                        newCard.expireMonth = card.expireMonth;
//                        newCard.cardStatus = card.cardStatus;
//                        newCard.expireYear = card.expireYear;
//                        newCard.cardHolderName = card.cardHolderName;
//                        newCard.cvv = card.cvv;
//                        newCard.bankIca = card.bankIca;
//                        newCard.loyaltyCode = card.loyaltyCode;
//                        newCard.productName = card.productName;
//                        newCard.cardId = card.cardId;
//                        newCard.eftCode = card.eftCode;
//
//                        [realm beginWriteTransaction];
//                        [realm addObject:newCard];
//                        [realm commitWriteTransaction];
//                    }
//                }
//                completion([TCCMasterpassCard allObjects], nil);
//            } else {
//                completion(nil, responseObject.errorDescription);
//            }
//        }];
//    }
//}



- (void)deleteCard: (TCCMasterpassCard *)card completion:(MasterpassCompletionBlock)completion {
    @weakify(self);
    [TCCSharedMasterpassRequestModel deleteCardWithName:card.cardName returnResponse:^(MfsResponse *responseObject) {
        @strongify(self);
        if(responseObject.result){
            [self reloadMpDataWithCompletion:^(id responseObject, NSString *errorStr) {
                completion(nil, nil);
            }];
        } else {
            completion(nil, responseObject.errorDescription);
        }

    }];
}

- (void)payWithCardName: (NSString *)cardName amount:(NSString *)amount paramsDict:(NSDictionary *)paramsDict paymentToken:(NSString *)paymentToken qrData:(NSString *)qrData completion:(MasterpassCompletionBlock)completion {
    if (self.payTryCount >= 5) {
        self.payTryCount = 0;
        completion(nil, @"Ошибка платежной карты. Невозможно провести платеж");
        return;
    }
    self.payTryCount ++;
    NSLog(@"PAY COUNT: ==== %d",self.payTryCount);
    NSDictionary *params = @{@"payment_token":paymentToken};
    [TCCSharedHTTPSessionManager POST:TCCHTTPRequestMasterpassInit parameters:params completion:^(id responseObject, NSString *errorStr) {
        if (errorStr) {
            completion(nil, errorStr);
            return;
        }

        self.mpToken = responseObject[@"mp_token"];
        NSString *orderNo = responseObject[@"order_no"];
        [TCCSharedMasterpassRequestModel pay:cardName amount:amount orderId:orderNo paramsDict:paramsDict qrData:qrData returnResponse:^(MfsResponse *responseObject) {
            if(responseObject.result){
                self.payTryCount = 0;
                completion(@{@"mp_response":responseObject,@"pay_data":@{@"amount":amount,@"order_no":orderNo}}, nil);
                NSLog(@"Purchase Successfully completed");
            }else if ([responseObject.errorCode isEqualToString:@"5001"]){
                NSLog(@"OTP asked");
                completion(@{@"mp_response":responseObject,@"pay_data":@{@"amount":amount,@"order_no":orderNo}}, responseObject.errorCode);
            } else if([responseObject.errorCode isEqualToString:@"5002"]){
                NSLog(@"MPIN asked");
                [self payWithCardName:cardName amount:amount paramsDict:@{@"validation_type":@"04",@"msisdn_validated":@"01"} paymentToken:paymentToken qrData:qrData completion:^(id responseObject, NSString *errorStr) {
                    if (errorStr) {
                        completion(responseObject, errorStr);
                    } else {
                        completion(responseObject, nil);
                    }
                }];
            }else if([responseObject.errorCode isEqualToString:@"5010"]){
                NSLog(@"3D OTP asked");
                completion(@{@"mp_response":responseObject,@"pay_data":@{@"amount":amount,@"order_no":orderNo}}, responseObject.errorCode);
            }  else {
                if ([responseObject.errorCode isEqualToString:@"T_B0002"]) {
                    [self payWithCardName:cardName amount:amount paramsDict:@{@"validation_type":@"01",@"msisdn_validated":@"01"} paymentToken:paymentToken qrData:qrData completion:^(id responseObject, NSString *errorStr) {
                        if (errorStr) {
                            self.payTryCount = 0;
                            completion(responseObject, errorStr);
                        } else {
                            completion(responseObject, nil);
                        }
                    }];
                } else {
                    self.payTryCount = 0;
                    completion(nil, responseObject.errorDescription);
                }
            };
        }];
    }];
}

- (void)verifyPin {
    [TCCSharedMasterpassRequestModel verifyPin:^(MfsResponse *responseObject) {

    }];
}

- (void)forgotPassword:(NSString *)cardNo completion:(MasterpassCompletionBlock)completion {
    [TCCSharedMasterpassRequestModel forgotPassword:cardNo returnResponse:^(MfsResponse *responseObject) {
        if(responseObject.result){
            completion(responseObject, nil);
        } else if([[(MfsResponse *)responseObject errorCode] isEqualToString:@"5001"]){
            NSLog(@"OTP required");
            completion(responseObject, nil);
        } else if([[(MfsResponse *)responseObject errorCode] isEqualToString:@"5007"]){
            NSLog(@"OTP for MasterPass Device verification required ");
            completion(responseObject, nil);
        } else if([[(MfsResponse *)responseObject errorCode] isEqualToString:@"5015"]){
            NSLog(@"PIN define required");
            completion(responseObject, nil);
        } else {
            completion(nil, responseObject.errorDescription);
        }
    }];
}

- (void)resendOtp:(NSString*)token completion:(MasterpassCompletionBlock)completion {
    [TCCSharedMasterpassRequestModel resendOtp:token returnResponse:^(MfsResponse *responseObject) {
        if(responseObject.result){
            completion(responseObject, nil);
        } else {
            completion(nil, responseObject.errorDescription);
        }
    }];
}




@end












