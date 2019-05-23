//
//  HistoryPayments.h
//  metro
//
//  Created by admin on 5/4/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import <Realm/Realm.h>
#import "PaymentsObject.h"

@interface HistoryPayments : RLMObject

@property NSDate *groupDate;
@property RLMArray <PaymentsObject> *currentObject;

@end

RLM_ARRAY_TYPE(HistoryPayments)
