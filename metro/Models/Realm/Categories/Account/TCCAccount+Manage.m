//
//  TCCAccount+Manage.m
//  Tachcard
//
//  Created by Yaroslav Bulda on 08/10/15.
//  Copyright © 2015 Tachcard. All rights reserved.
//

#import "TCCAccount+Manage.h"

#import "TCCAccount+HTTPRequests.h"
#import "TCCAccount+Keychain.h"

#import "TCCHTTPSessionManager.h"

@implementation TCCAccount (Manage)

#pragma mark -
#pragma mark Class

+ (instancetype)object {
    static TCCAccount *account = nil;
    
    if (!account || account.isInvalidated) {
        account = TCCAccount.allObjects.firstObject;
        
        if (!account.isAuthorized) {
            [RLMRealm.defaultRealm transactionWithBlock:^{
                [RLMRealm.defaultRealm deleteAllObjects];
            }];
            account = nil;
        }
        
        if (!account) {
            account = [TCCAccount new];
            
            TCCSettings *settingsObj = [TCCSettings new];
            account.settings = settingsObj;
            
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            [realm addObject:account];
            [realm commitWriteTransaction];
            
            [TCCAccount clenUpKeyChain];
        } else {
            [account setUpRequestsSign];
        }
    }
    
    return account;
}

#pragma mark -
#pragma mark Props

- (BOOL)isAuthorized {
    return self.token.length != 0 && self.pin.length != 0;
}

#pragma mark -
#pragma mark Manage

- (void)logout {
    [self clearRequestSign];
    [RLMRealm.defaultRealm transactionWithBlock:^{
        [RLMRealm.defaultRealm deleteAllObjects];
    }];
}

@end
