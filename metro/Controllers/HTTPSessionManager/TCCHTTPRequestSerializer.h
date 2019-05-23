//
//  TCCHTTPRequestSerializer.h
//  Tachcard
//
//  Created by admin on 30.08.16.
//  Copyright © 2016 Tachcard. All rights reserved.
//

#import <AFNetworking/AFURLRequestSerialization.h>
//#import "AFNetworking.h"

@interface TCCHTTPRequestSerializer : AFHTTPRequestSerializer


@end

#pragma mark -

/**
 `AFJSONRequestSerializer` is a subclass of `AFHTTPRequestSerializer` that encodes parameters as JSON using `NSJSONSerialization`, setting the `Content-Type` of the encoded request to `application/json`.
 */
@interface TCCJSONRequestSerializer : TCCHTTPRequestSerializer

/**
 Options for writing the request JSON data from Foundation objects. For possible values, see the `NSJSONSerialization` documentation section "NSJSONWritingOptions". `0` by default.
 */
@property (nonatomic, assign) NSJSONWritingOptions writingOptions;

/**
 Creates and returns a JSON serializer with specified reading and writing options.

 @param writingOptions The specified JSON writing options.
 */
+ (instancetype)serializerWithWritingOptions:(NSJSONWritingOptions)writingOptions;

@end

#pragma mark -
