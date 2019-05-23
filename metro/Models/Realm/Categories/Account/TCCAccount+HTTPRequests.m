//
//  TCCAccount+HTTPRequestsSign.m
//  Tachcard
//
//  Created by Yaroslav Bulda on 08/10/15.
//  Copyright © 2015 Tachcard. All rights reserved.
//

#import "TCCAccount+HTTPRequests.h"

#import "TCCAccount+Manage.h"
#import "TCCAccount+Keychain.h"
#import "TCCHTTPSessionManager.h"

#import "NSDate+TCCExtensions.h"
#import "NSString+MD5.h"
#import "SecurityHelper.h"

#import "MasterpassRequestModel.h"

@implementation TCCAccount (HTTPRequests)

#pragma mark -
#pragma mark Sign

- (void)setUpRequestsSign {
    TCCSharedHTTPSessionManager.authToken = self.token;
    [self setSalt:(NSData *)self.secret];
    
    @weakify(self);
    TCCSharedHTTPSessionManager.signBlock = ^TCCHTTPSignStatus(NSString **sign, NSNumber **timestamp) {
        @strongify(self);
        if (self.token.length == 0) {
            return TCCHTTPSignStatusNotNecessary;
        }

        NSString *salt;
        if ([SecurityHelper sharedInstance].securityKey) {
            TCCAccount *acc = [TCCAccount object];
            salt = [[SecurityHelper sharedInstance] decryptData:(NSData *)[acc salt] withKey:[[SecurityHelper sharedInstance]secretKey]];
        } else {
            salt = self.salt;
        }

        if (!salt) {
            return TCCHTTPSignStatusFail;
        }
        
        *timestamp = @([NSDate unixTimestampInMilliseconds]);
        NSString *toSign = [NSString stringWithFormat:@"%@%@%@", self.token, *timestamp, salt];
        *sign = [toSign tcc_md5];
        
        return TCCHTTPSignStatusOK;
    };
}

- (void)clearRequestSign {
    [TCCAccount clenUpKeyChain];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"sendContactsPeriod"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"lastTransactionDate"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"lastChangesDate"];

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"receiversCardsArray"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"checkSecretQuestionCount"];

    [[NSUserDefaults standardUserDefaults] synchronize];

    [SecurityHelper sharedInstance].securityKey = nil;
    TCCSharedHTTPSessionManager.authToken = nil;
    TCCSharedHTTPSessionManager.signBlock = nil;
}


@end
