//
//  TCCAddress.h
//  Tachcard
//
//  Created by admin on 26.04.16.
//  Copyright © 2016 Tachcard. All rights reserved.
//

#import <Realm/Realm.h>

@interface TCCMasterpassAccount : RLMObject

@property NSString *userFlow;

@end

RLM_ARRAY_TYPE(TCCMasterpassAccount)
