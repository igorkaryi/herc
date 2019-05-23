//
//  TCCAccount+Manage.m
//  Tachcard
//
//  Created by Yaroslav Bulda on 08/10/15.
//  Copyright © 2015 Tachcard. All rights reserved.
//

#import "TCCMasterpassAccount+Manage.h"

@implementation TCCMasterpassAccount (Manage)

#pragma mark -
#pragma mark Class

+ (instancetype)object {
    static TCCMasterpassAccount *account = nil;
    
    if (!account || account.isInvalidated) {
        account = TCCMasterpassAccount.allObjects.firstObject;
        
        if (!account) {
            account = [TCCMasterpassAccount new];
            
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            [realm addObject:account];
            [realm commitWriteTransaction];
        }
    }
    
    return account;
}


@end
