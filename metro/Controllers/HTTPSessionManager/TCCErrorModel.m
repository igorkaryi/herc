//
//  TCCErrorModel.m
//  Tachcard
//
//  Created by admin on 21.07.16.
//  Copyright © 2016 Tachcard. All rights reserved.
//

#import "TCCErrorModel.h"
#import "GCDSingleton.h"

@interface TCCErrorModel ()

@end

@implementation TCCErrorModel

#pragma mark -
#pragma mark Singletone

+ (instancetype)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [self new];
    });
}

#pragma mark -
#pragma mark Lifecycle methods

- (instancetype)init {
    self = [super init];
    if (self) {

    }
    return self;
}

- (NSString *)returnErrorText :(NSDictionary *)dict withUrl :(NSString *)url {

    if ([[dict allKeys] containsObject:@"error"]) {
        @try {
            if ([self errorWithUrl:url andError:dict[@"error"]] == YES) {
                return @"ERROR_FORBIDDEN";
            }
            if ([[dict allKeys] containsObject:@"reason"]) {
                if (![dict[@"reason"]isKindOfClass:[NSNull class]]) {
                    return dict[@"reason"];
                } else {
                    return dict[@"error"];
                }
            } else if ([[dict allKeys] containsObject:@"params"]) {
                if (![dict[@"params"]isKindOfClass:[NSNull class]]) {
                    if ([[[dict[@"params"] allKeys] firstObject] isEqualToString:@"pan"]) {
                        return @"ERROR_PARAMS_PAN";
                    } else {
                        NSString *errorString = @"";
                        for (int i = 0; i<[[dict[@"params"] allKeys] count]; i++) {
                            if ([dict[@"params"][[dict[@"params"] allKeys][i]]isKindOfClass:[NSArray class]]) {
                                NSString *subStr = @"";
                                for (int z = 0; z<[dict[@"params"][[dict[@"params"] allKeys][i]]count]; z++) {
                                    subStr = [NSString stringWithFormat:@"%@ %@",subStr,dict[@"params"][[dict[@"params"] allKeys][i]][z]];
                                }
                                errorString = [NSString stringWithFormat:@"%@%@\n",errorString,subStr];
                            } else {
                                errorString = [NSString stringWithFormat:@"%@%@\n",errorString,[NSString stringWithFormat:@"%@",dict[@"params"][[dict[@"params"] allKeys][i]]]];
                            }
                        }
                        return errorString;
                    }
                } else {
                    return dict[@"error"];
                }
            } else if ([[dict allKeys] containsObject:@"param"]) {
                return dict[@"error"];
            } else {
                return dict[@"error"];
            }
        }
        @catch (NSException *exception) {
            return @"ERROR_UNKNOWN";
        }
        @finally {
            
        }
    } else {
        return @"";
    }
}

- (BOOL)errorWithUrl :(NSString *)url andError:(NSString *)error {

    if ([url isEqualToString:@"/register"]) {
    } else if ([url isEqualToString:@"/register/confirm"]) {
    } else if ([url isEqualToString:@"/register/renewpushtoken"]) {
    } else if ([url isEqualToString:@"/register/userinfo"]) {
    } else if ([url isEqualToString:@"/register/checkemail"]) {
    } else if ([url isEqualToString:@"/addopinion"]) {
    } else if ([url isEqualToString:@"/transactions"]) {
    } else if ([url isEqualToString:@"transactions/cancel"]) {
    } else if ([url isEqualToString:@"transactions/switch"]) {
    } else if ([url isEqualToString:@"/account"]) {
    } else if ([url isEqualToString:@"/receipt/create"]) {
    } else if ([url isEqualToString:@"receipt/cancel"]) {
    } else if ([url isEqualToString:@"/receipt/send"]) {
    } else if ([url isEqualToString:@"receipt/send/confirm"]) {
    } else if ([url isEqualToString:@"/receipt/view"]) {
    } else if ([url isEqualToString:@"/pay"]) {
    } else if ([url isEqualToString:@"/pay/confirm"]) {
    } else if ([url isEqualToString:@"/lp"]) {
    } else if ([url isEqualToString:@"/taslink/bind"]) {
    } else if ([url isEqualToString:@"/taslink/view"]) {
    } else if ([url isEqualToString:@"/webmoney/bind"]) {
    } else if ([url isEqualToString:@"webmoney/bind/confirm"]) {
    } else if ([url isEqualToString:@"/transfer"]) {
    } else if ([url isEqualToString:@"/transfer/calc"]) {
    } else if ([url isEqualToString:@"/transfer/confirm"]) {
    } else if ([url isEqualToString:@"/exchange"]) {
    } else if ([url isEqualToString:@"/exchange/confirm"]) {
    } else if ([url isEqualToString:@"/auth/savepin"]) {
    } else if ([url isEqualToString:@"/auth/checkpin"]) {
    } else if ([url isEqualToString:@"/changes"]) {
    } else if ([url isEqualToString:@"/auth/restore"]) {
    } else if ([url isEqualToString:@"/auth/restore/confirm"]) {
    } else if ([url isEqualToString:@"/auth/restore/complete"]) {
    } else if ([url isEqualToString:@"/address"]) {
    } else if ([url isEqualToString:@"/contacts"]) {
    } else if ([url isEqualToString:@"/c2ctransfer/calc"]) {
    } else if ([url isEqualToString:@"c2ctransfer"]) {
    } else if ([url isEqualToString:@"/c2ctransfer/confirm"]) {
    } else {
    }

    if ([error isEqualToString:@"ERROR_INCORRECT_VERSION"]) {
        return YES;
    }

    return NO;
}

@end
