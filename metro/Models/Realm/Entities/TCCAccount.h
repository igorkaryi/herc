//
//  TCCAccount.h
//  Tachcard
//
//  Created by Yaroslav Bulda on 08/10/15.
//  Copyright © 2015 Tachcard. All rights reserved.
//

#import <Realm/Realm.h>
#import "TCCSettings.h"

typedef NS_OPTIONS(NSInteger, opScope) {
    opScopeNone         = 0,
    opScopeReceipt      = 1 << 0,
    opScopePay          = 1 << 1,
    opScopeTransfer     = 1 << 2,
    opScopeExchange     = 1 << 3,
    opScopeC2C          = 1 << 4
};

@interface TCCAccount : RLMObject

@property NSString *name;
@property NSString *token;
@property NSString *secret;
@property NSString *pushToken;

@property NSString *pinString;

@property TCCSettings *settings;

@property NSString *mfsBaseURL;
@property NSString *mfsClientId;
@property NSString *mfsMacroMerchantId;
@property NSString *mfsLanguage;
@property NSString *mfsMsisdn;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<TCCAccount>
RLM_ARRAY_TYPE(TCCAccount)
