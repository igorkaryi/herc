//
//  SecurityHelper.m
//  Tachcard
//
//  Created by admin on 04.03.16.
//  Copyright © 2016 Tachcard. All rights reserved.
//

#import "SecurityHelper.h"
#import <CommonCrypto/CommonCryptor.h>
#import "NSData+Encryption.h"
#import "TCCAccount+Keychain.h"
#import "TCCAccount+Manage.h"
#import "NSString+MD5.h"
#import "AnyHelper.h"

@implementation SecurityHelper
static SecurityHelper *instance = nil;

+(SecurityHelper*)sharedInstance{
    if (!instance) {
        instance = [SecurityHelper new];
    }
    return instance;
}

- (NSData*) encryptString:(NSData*)plaintext withKey:(NSString*)key {
    NSData *data;
    if ([plaintext isKindOfClass:[NSString class]]) {
        data = [[(NSString*)plaintext dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptWithKey:key];
    } else {
        data = [plaintext AES256EncryptWithKey:key];
    }

    return data;
}

- (NSString*) decryptData:(NSData*)ciphertext withKey:(NSString*)key {
    if ([ciphertext isKindOfClass:[NSString class]] || !ciphertext) {
        return (NSString *)ciphertext;
    } else {
        NSString *dataString = [[NSString alloc] initWithData:[ciphertext AES256DecryptWithKey:key]
                                                     encoding:NSUTF8StringEncoding];
        return dataString;
    }
}

- (NSString*)secretKey {
    NSString *str = [[NSString stringWithFormat:@"%@%@",[NSString stringWithFormat:@"tachcard%@", [[AnyHelper sharedInstance] digitOnlyString:TCCAccount.object.name ]],self.securityKey] tcc_md5];
    return str;
}

@end
