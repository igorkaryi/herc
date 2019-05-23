//
//  TCCAccount.m
//  Tachcard
//
//  Created by Yaroslav Bulda on 08/10/15.
//  Copyright © 2015 Tachcard. All rights reserved.
//

#import <Realm/Realm.h>

@protocol RLMObjectJSONSerializing <NSObject>
@required
+ (NSDictionary *)JSONKeyPathsByPropertyKey;

//@optional
//+ (NSDictionary *)JSONRelationsKeyPaths;

@end

FOUNDATION_EXPORT NSString *const RLMObjectJSONSerializingRelationKey;

@interface RLMObject (Mapping)

+ (instancetype)objectFromJSONDictionary:(NSDictionary *)jsonDictionary;
+ (NSArray *)objectsFromJSONArray:(NSArray *)jsonArray;

+ (instancetype)createOrUpdateFromJSONDictionary:(NSDictionary *)jsonDictionary;
+ (NSArray *)createOrUpdateFromJSONArray:(NSArray *)jsonArray;

- (void)mapValuesFromJSONDictionary:(NSDictionary *)jsonDictionary;

@end
