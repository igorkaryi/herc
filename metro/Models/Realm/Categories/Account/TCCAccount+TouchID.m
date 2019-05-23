//
//  TCCAccount+TouchID.m
//  Tachcard
//
//  Created by Yaroslav Bulda on 22/10/15.
//  Copyright © 2015 Tachcard. All rights reserved.
//

#import "TCCAccount+TouchID.h"
#import <LocalAuthentication/LocalAuthentication.h>

@implementation TCCAccount (TouchID)

- (LAContext *)_authContext:(BOOL)invalidate {
    static LAContext *_authContext = nil;
    if (invalidate) {
        [_authContext invalidate];
        _authContext = nil;
    }
    
    if (!_authContext) {
        _authContext = [LAContext new];
    }
    
    return _authContext;
}

- (LAContext *)authContext {
    return [self _authContext:NO];
}

- (BOOL)isPassByBiometricsAvailable {
    return [self.authContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                                         error:NULL];
}

- (BOOL)isTouchIDAvailable {
    return iOS8andHi && [self isPassByBiometricsAvailable];
}

- (void)passByBiometricsWithReason:(NSString *)reason
                       succesBlock:(void(^)(void))successBlock
                      failureBlock:(void(^)(NSError *error))failureBlock {
    @weakify(self);
    [self.authContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:reason reply:^(BOOL success, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                @strongify(self);
                [self _authContext:YES];
                successBlock();
            } else {
                failureBlock(error);
            }
        });
    }];
}

@end
