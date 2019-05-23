//
//  TCCHTTPSessionManager.h
//  Tachcard
//
//  Created by Yaroslav Bulda on 7/1/15.
//  Copyright (c) 2015 Tachcard. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "TCCHTTPRoutes.h"

#define TCCSharedHTTPSessionManager [TCCHTTPSessionManager sharedInstance]

typedef NS_ENUM(NSUInteger, TCCHTTPSignStatus) {
    TCCHTTPSignStatusOK = 0,
    TCCHTTPSignStatusFail,
    TCCHTTPSignStatusNotNecessary
};

typedef void(^TCCHTTPCompletionBlock)(id responseObject, NSString *errorStr);
typedef TCCHTTPSignStatus(^TCCHTTPSignBlock)(NSString **sign, NSNumber **timestamp);

@interface TCCHTTPSessionManager : AFHTTPSessionManager

@property (nonatomic, copy) NSString *authToken;
@property (nonatomic, copy) TCCHTTPSignBlock signBlock;

+ (instancetype)sharedInstance;

- (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters completion:(TCCHTTPCompletionBlock)completion;
- (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters completion:(TCCHTTPCompletionBlock)completion;
- (NSURLSessionDataTask *)DELETE:(NSString *)URLString parameters:(id)parameters completion:(TCCHTTPCompletionBlock)completion;

@end
