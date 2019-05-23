//
//  RLMRealm+Migration.m
//  Tachcard
//
//  Created by Yaroslav Bulda on 28/10/15.
//  Copyright © 2015 Tachcard. All rights reserved.
//

#import "RLMRealm+Migration.h"
#import "TCCAccount.h"

@implementation RLMRealm (Migration)

+ (RLMMigrationBlock)tcc_migrationBlock {
    return ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
        [migration enumerateObjects:TCCAccount.className
                              block:^(RLMObject *oldObject, RLMObject *newObject) {
                                  
                              }];
    };
}

@end
