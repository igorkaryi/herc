//
//  TCCAccount+TouchID.h
//  Tachcard
//
//  Created by Yaroslav Bulda on 22/10/15.
//  Copyright © 2015 Tachcard. All rights reserved.
//

#import "TCCAccount.h"

@interface TCCAccount (TouchID)

@property (nonatomic, readonly) BOOL isTouchIDAvailable;

- (void)passByBiometricsWithReason:(NSString *)reason
                       succesBlock:(void(^)(void))successBlock
                      failureBlock:(void(^)(NSError *error))failureBlock;

@end
