//
//  NSData+ Encryption.h
//  Tachcard
//
//  Created by admin on 04.03.16.
//  Copyright © 2016 Tachcard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Encryption)
- (NSData *)AES256EncryptWithKey:(NSString *)key;
- (NSData *)AES256DecryptWithKey:(NSString *)key;
@end
