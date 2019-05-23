//
//  SecurityHelper.h
//  Tachcard
//
//  Created by admin on 04.03.16.
//  Copyright © 2016 Tachcard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SecurityHelper : NSObject
+ (SecurityHelper*)sharedInstance;
@property NSString *securityKey;

- (NSData*) encryptString:(NSData*)plaintext withKey:(NSString*)key;
- (NSString*) decryptData:(NSData*)ciphertext withKey:(NSString*)key;
- (NSString*)secretKey;

@end
