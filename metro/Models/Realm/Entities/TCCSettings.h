//
//  TCCSettings.h
//  Tachcard
//
//  Created by Yaroslav Bulda on 08/10/15.
//  Copyright © 2015 Tachcard. All rights reserved.
//

#import <Realm/Realm.h>

@interface TCCSettings : RLMObject

@property BOOL useTouchID;
@property BOOL pinEnabled;

@property BOOL pushLastTicket;
@property BOOL pushDateTicket;

@property NSDate *historyUpdateDate;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<TCCSettings>
RLM_ARRAY_TYPE(TCCSettings)
