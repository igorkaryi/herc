//
//  TCCAccount+Keychain.m
//  Tachcard
//
//  Created by Yaroslav Bulda on 08/10/15.
//  Copyright © 2015 Tachcard. All rights reserved.
//

#import "TCCAccount+Keychain.h"
#import "SSKeychain.h"
#import "SecurityHelper.h"
#import "NSData+Encryption.h"


@implementation TCCAccount (Keychain)

#pragma mark -
#pragma mark Constant defination

static NSString *const TCCKeychainServiceName = @"com.tachcard.request.sign.service";

#pragma mark -
#pragma mark Class

+ (void)clenUpKeyChain {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pin"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"requestSalt"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -
#pragma mark Props

- (NSData *)salt {
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"requestSalt"]) {
        return nil;
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"requestSalt"];
}

- (BOOL)setSalt:(NSData *)salt {
    if (![SecurityHelper sharedInstance].securityKey) {
        [[NSUserDefaults standardUserDefaults] setObject:salt forKey:@"requestSalt"];
        return [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:[[SecurityHelper sharedInstance]encryptString:salt withKey:[[SecurityHelper sharedInstance]secretKey]] forKey:@"requestSalt"];
        return [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (NSString *)idTouch {
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"idTouch"]) {
        return nil;
    }
    NSString *idTouchString = [[NSString alloc] initWithData:[[[NSUserDefaults standardUserDefaults] objectForKey:@"idTouch"] AES256DecryptWithKey:@"8ns*85?6nvgm*vkHmc-Gmj_c8935873642tyuhs@d"]
                                                encoding:NSUTF8StringEncoding];
    return idTouchString;
}

- (BOOL)setIdTouch:(NSString *)touch {
    NSData *criptTouch = [[touch dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptWithKey:@"8ns*85?6nvgm*vkHmc-Gmj_c8935873642tyuhs@d"];
    [[NSUserDefaults standardUserDefaults] setObject:criptTouch forKey:@"idTouch"];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)pin {
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"pin"]) {
        return nil;
    }
    NSString *pinString = [[NSString alloc] initWithData:[[[NSUserDefaults standardUserDefaults] objectForKey:@"pin"] AES256DecryptWithKey:@"8ns*85?6nvgm*vkHmc-Gmj_c8935873642tyuhs@d"]
                                                encoding:NSUTF8StringEncoding];
    return pinString;
}

- (BOOL)setPin:(NSString *)pin {
    NSData *criptPin = [[pin dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptWithKey:@"8ns*85?6nvgm*vkHmc-Gmj_c8935873642tyuhs@d"];
    [[NSUserDefaults standardUserDefaults] setObject:criptPin forKey:@"pin"];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
