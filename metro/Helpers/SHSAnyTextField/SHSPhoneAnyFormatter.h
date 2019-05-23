//
//  SHSPhoneAnyFormatter.h
//  Tachcard
//
//  Created by admin on 19.02.16.
//  Copyright © 2016 Tachcard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHSPhoneNumberFormatter.h"

@interface SHSPhoneAnyFormatter : SHSPhoneNumberFormatter
- (NSString *)deleteFormat: (NSString *)string;
@end
