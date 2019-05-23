//
//  TCCHTTPSessionManager.m
//  Tachcard
//
//  Created by Yaroslav Bulda on 7/1/15.
//  Copyright (c) 2015 Tachcard. All rights reserved.
//

#import "TCCHTTPSessionManager.h"

#import "GCDSingleton.h"

//#import "AFNetworkActivityIndicatorManager.h"

#import "TCCErrorModel.h"

#import "TCCHTTPRequestSerializer.h"
#import "AFHTTPSessionManager.h"

@interface TCCHTTPSessionManager ()

@end

@implementation TCCHTTPSessionManager

#pragma mark -
#pragma mark Constant defination

#warning check server before submit

//static NSString *const TCCHTTPBaseURL = @"https://test-api.tachcard.com";

//static NSString *const TCCHTTPBaseURL = @"https://ios-api.tachcard.com";
static NSString *const TCCHTTPBaseURL = @"https://api.tachcard.com";

//static NSString *const TCCHTTPBaseURL = @"https://sandbox.tachcard.com";

//static NSString *const TCCHTTPBaseURL = @"https://android-api.tachcard.com";


static NSTimeInterval const TCCHTTPRequestTimeOutInterval = 60.f;

#pragma mark -
#pragma mark Session config

+ (NSURLSessionConfiguration *)sessionConfig {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = TCCHTTPRequestTimeOutInterval;
    config.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
    config.allowsCellularAccess = YES;
    return config;
}

#pragma mark -
#pragma mark Singletone

+ (instancetype)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [self manager];
    });
}

+ (instancetype)manager {
    return [[self alloc] initWithBaseURL:[NSURL URLWithString:TCCHTTPBaseURL] sessionConfiguration:[self sessionConfig]];
}

#pragma mark -
#pragma mark Lifecycle methods

- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration {
    self = [super initWithBaseURL:url sessionConfiguration:configuration];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.requestSerializer = [TCCJSONRequestSerializer serializer];// [TCCHTTPRequestSerializer serializer];
    
    self.operationQueue.maxConcurrentOperationCount = 1;
    
    //[[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
}

#pragma mark -
#pragma mark Requests reload

- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:&serializationError];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:self.authToken forHTTPHeaderField:@"X-Auth-Token"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
//    [request setValue:@"3" forHTTPHeaderField:@"X-API-Version"];
//    [request setValue:([TCCHTTPBaseURL isEqualToString:@"https://api.tachcard.com"] || [TCCHTTPBaseURL isEqualToString:@"https://api.tachcard.com"])?@"5b9d17c8d547bdf90a7d04dba7606160":@"5b9d17c8d547bdf90a7d04dba7606160" forHTTPHeaderField:@"X-Auth-App-Key"];
    
    
    
    if (self.signBlock) {
        
        NSString *sign = nil;
        NSNumber *timestamp = nil;
        
        TCCHTTPSignStatus signStatus = self.signBlock(&sign, &timestamp);
        
        if (signStatus == TCCHTTPSignStatusOK) {
            [request setValue:timestamp.stringValue forHTTPHeaderField:@"X-Auth-Reqn"];
            [request setValue:sign forHTTPHeaderField:@"X-Auth-Sign"];
        }
    }
    
    
    
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
#pragma clang diagnostic pop
        }
        
        return nil;
    }
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTaslReturnCount = 3;
    
    /*
     dataTask = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
     if (error) {
     if (failure) {
     failure(dataTask, error);
     }
     } else {
     if (success) {
     success(dataTask, responseObject);
     }
     }
     }];
     [dataTask resume];
     */
    
    dataTask = [self dataTaslReturn:dataTask request:request success:success failure:failure];
    
    return dataTask;
}

int dataTaslReturnCount;

- (NSURLSessionDataTask *)dataTaslReturn: (NSURLSessionDataTask *)dataTask request:(NSMutableURLRequest *)request success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    dataTask = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (error) {
            if (failure) {
                failure(dataTask, error);
            }
            //            NSLog(@"COUNT %d",dataTaslReturnCount);
            //            NSLog(@"ERROR CODE: %ld",(long)error.code);
            //            if ((error.code == -1009 || error.code == -1005) && dataTaslReturnCount>0) {
            //                dataTaslReturnCount --;
            //                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //                    [self dataTaslReturn:dataTask request:request success:success failure:failure];
            //                });
            //            } else {
            //                if (failure) {
            //                    failure(dataTask, error);
            //                }
            //            }
        } else {
            if (success) {
                success(dataTask, responseObject);
            }
        }
    }];
    [dataTask resume];
    return dataTask;
}

#pragma mark -
#pragma mark Helpers

- (NSString *)errorStringFromError:(NSError *)error andUrl:(NSString *)url {
    NSString *errstr = nil;
    
    NSData *afError = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    if (!afError) {
        
        return [error localizedDescription];
    }
    NSDictionary *errorObj = [NSJSONSerialization JSONObjectWithData:afError options:kNilOptions error:nil];
    
    [[TCCErrorModel sharedInstance] returnErrorText:errorObj withUrl:url];
    
    if (!errorObj) {
        errstr = [error localizedDescription];
    } else {
        errstr = [[TCCErrorModel sharedInstance] returnErrorText:errorObj withUrl:url];
    }
    
    return errstr;
}

#pragma mark -
#pragma mark Requests

- (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters completion:(TCCHTTPCompletionBlock)completion {
    return [self dataTaskWithHTTPMethod:@"POST" URLString:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if (completion) {
            completion(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (completion) {
            completion(nil, [self errorStringFromError:error andUrl:URLString]);
        }
    }];
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters completion:(TCCHTTPCompletionBlock)completion {
    return [self dataTaskWithHTTPMethod:@"GET" URLString:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if (completion) {
            completion(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (completion) {
            completion(nil, [self errorStringFromError:error andUrl:URLString]);
        }
    }];
}

- (NSURLSessionDataTask *)DELETE:(NSString *)URLString parameters:(id)parameters completion:(TCCHTTPCompletionBlock)completion {
    return [self dataTaskWithHTTPMethod:@"DELETE" URLString:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if (completion) {
            completion(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (completion) {
            completion(nil, [self errorStringFromError:error andUrl:URLString]);
        }
    }];
}

@end
