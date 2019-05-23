//
//  TCCAccount+Manage.h
//  Tachcard
//
//  Created by Yaroslav Bulda on 08/10/15.
//  Copyright © 2015 Tachcard. All rights reserved.
//

#import "TCCAccount.h"

@interface TCCAccount (Manage)

+ (instancetype)object;

- (BOOL)isAuthorized;
- (void)logout;

@end
