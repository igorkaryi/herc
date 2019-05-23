//
//  TCCErrorModel.h
//  Tachcard
//
//  Created by admin on 21.07.16.
//  Copyright © 2016 Tachcard. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TCCSharedErrorModel [TCCErrorModel sharedInstance]

@interface TCCErrorModel : NSObject

+ (instancetype)sharedInstance;

- (NSString *)returnErrorText :(NSDictionary *)dict withUrl :(NSString *)url;
@end
