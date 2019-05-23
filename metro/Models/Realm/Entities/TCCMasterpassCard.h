//
//  TCCAddress.h
//  Tachcard
//
//  Created by admin on 26.04.16.
//  Copyright © 2016 Tachcard. All rights reserved.
//

#import <Realm/Realm.h>

@interface TCCMasterpassCard : RLMObject

@property (nonatomic, copy) NSString *cardName;
@property (nonatomic, copy) NSString *cardNo;
@property (nonatomic, copy) NSString *expireMonth;
@property (nonatomic, copy) NSString *cardStatus;
@property (nonatomic, copy) NSString *expireYear;
@property (nonatomic, copy) NSString *cardHolderName;
@property (nonatomic, copy) NSString *cvv;

@property (nonatomic) BOOL isMasterPass;
@property (strong, nonatomic)  NSString *bankIca;
@property (strong, nonatomic)  NSString *loyaltyCode;
@property (strong, nonatomic)  NSString *productName;
@property (strong, nonatomic)  NSString *cardId;
@property (strong, nonatomic)  NSString *eftCode;
@end

RLM_ARRAY_TYPE(TCCMasterpassCard)
