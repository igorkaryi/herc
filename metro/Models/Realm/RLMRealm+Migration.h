//
//  RLMRealm+Migration.h
//  Tachcard
//
//  Created by Yaroslav Bulda on 28/10/15.
//  Copyright © 2015 Tachcard. All rights reserved.
//

#import <Realm/Realm.h>

@interface RLMRealm (Migration)

+ (RLMMigrationBlock)tcc_migrationBlock;

@end
