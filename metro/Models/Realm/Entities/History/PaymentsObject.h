//
//  PaymentsObject.h
//  metro
//
//  Created by admin on 5/4/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import <Realm/Realm.h>

@interface PaymentsObject : RLMObject

@property NSString *amount;
@property NSString *card_last_digits;
@property NSString *list_account_name;
@property NSString *receipt_id;
@property NSDate *updated_at;
@property NSString *tickets_count;

@end

RLM_ARRAY_TYPE(PaymentsObject)
