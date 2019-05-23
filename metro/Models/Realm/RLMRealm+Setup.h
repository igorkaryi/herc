//
//  RLMRealm+Setup.h
//  Tachcard
//
//  Created by Yaroslav Bulda on 28/10/15.
//  Copyright © 2015 Tachcard. All rights reserved.
//

#import <Realm/Realm.h>

FOUNDATION_EXPORT NSInteger const RLMRealmSchemaVersion;

@interface RLMRealm (Setup)

+ (void)tcc_setupDefaultRealm;

@end
