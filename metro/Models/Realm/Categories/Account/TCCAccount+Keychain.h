//
//  TCCAccount+Keychain.h
//  Tachcard
//
//  Created by Yaroslav Bulda on 08/10/15.
//  Copyright © 2015 Tachcard. All rights reserved.
//

#import "TCCAccount.h"

@interface TCCAccount (Keychain)

+ (void)clenUpKeyChain;

- (NSString *)salt;
- (BOOL)setSalt:(NSData *)salt;

- (NSString *)pin;
- (BOOL)setPin:(NSString *)pin;



- (NSString *)idTouch;
- (BOOL)setIdTouch:(NSString *)touch;

@end
