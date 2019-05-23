//
//  TCCAccount.m
//  Tachcard
//
//  Created by Yaroslav Bulda on 08/10/15.
//  Copyright © 2015 Tachcard. All rights reserved.
//

#import "RLMObject+Mapping.h"

@implementation RLMObject (Mapping)

NSString *const RLMObjectJSONSerializingRelationKey = @"RLMObjectJSONSerializingRelationKey";

+ (instancetype)objectFromJSONDictionary:(NSDictionary *)jsonDictionary {
    RLMObject *object = [self new];
    [object mapValuesFromJSONDictionary:jsonDictionary];
    
    return object;
}

+ (NSArray *)objectsFromJSONArray:(NSArray *)jsonArray {
    NSMutableArray *temp = [NSMutableArray  arrayWithCapacity:jsonArray.count];
    [jsonArray enumerateObjectsUsingBlock:^(NSDictionary *item, NSUInteger idx, BOOL * _Nonnull stop) {
        RLMObject *object = [self new];
        [object mapValuesFromJSONDictionary:item];
        [temp addObject:object];
    }];
    return temp.copy;
}

- (void)mapValuesFromJSONDictionary:(NSDictionary *)jsonDictionary {
    NSAssert([self conformsToProtocol:@protocol(RLMObjectJSONSerializing)], @"Must conforms to RLMObjectJSONSerializing");
    NSParameterAssert(jsonDictionary);
    
    NSDictionary *paths = [self.class JSONKeyPathsByPropertyKey];
    
    NSAssert(paths.allKeys.count != 0, @"No props to map");
    
    @weakify(self);
    [jsonDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *propertyKey, id value, BOOL *stop) {
        @strongify(self);
        
        id JSONKeyPath = paths[propertyKey];
        
        if (JSONKeyPath == nil || [value isEqual:NSNull.null]) {
            return;
        }
        
        NSString *firstChar = [[JSONKeyPath substringToIndex:1] capitalizedString];
        NSString *capStr = [firstChar stringByAppendingString:[JSONKeyPath substringFromIndex:1]];
        
        NSString *selectorString = [NSString stringWithFormat:@"map%@Key:", capStr];
        SEL selector = NSSelectorFromString(selectorString);

        if ([[self class] respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            id mapValue = [[self class] performSelector:selector withObject:value];
#pragma clang diagnostic pop
            
            [self setValue:mapValue forKeyPath:JSONKeyPath];
        } else {
            [self setValue:value forKey:JSONKeyPath];
        }
    }];
}

- (NSString *)capitalizedFirstCharacterString:(NSString *)toCap {
    if ([toCap length] > 0) {
        NSString *firstChar = [[toCap substringToIndex:1] capitalizedString];
        return [firstChar stringByAppendingString:[toCap substringFromIndex:1]];
    }
    return toCap;
}

#pragma mark -
#pragma mark Create or Update

+ (instancetype)createOrUpdateFromJSONDictionary:(NSDictionary *)jsonDictionary {
    NSAssert([self conformsToProtocol:@protocol(RLMObjectJSONSerializing)], @"Must conforms to RLMObjectJSONSerializing");
    NSParameterAssert(jsonDictionary);
    
    NSDictionary *paths = [self.class JSONKeyPathsByPropertyKey];
    
    NSAssert(paths.allKeys.count != 0, @"No props to map");
    
    NSMutableDictionary *transformedJsonDic = [NSMutableDictionary new];
    
    [jsonDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *propertyKey, id value, BOOL *stop) {
        
        id JSONKeyPath = paths[propertyKey];
        
        if (JSONKeyPath == nil || [value isEqual:NSNull.null]) {
            return;
        }
        
        NSString *firstChar = [[JSONKeyPath substringToIndex:1] capitalizedString];
        NSString *capStr = [firstChar stringByAppendingString:[JSONKeyPath substringFromIndex:1]];
        
        NSString *selectorString = [NSString stringWithFormat:@"map%@Key:", capStr];
        SEL selector = NSSelectorFromString(selectorString);
        
        if ([self respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            id mapValue = [self performSelector:selector withObject:value];
#pragma clang diagnostic pop
            
            [transformedJsonDic setValue:mapValue forKeyPath:JSONKeyPath];
        } else {
            [transformedJsonDic setValue:value forKey:JSONKeyPath];
        }
    }];
    
    return [self createOrUpdateInDefaultRealmWithValue:transformedJsonDic.copy];
}

+ (NSArray *)createOrUpdateFromJSONArray:(NSArray *)jsonArray {
    NSMutableArray *temp = [NSMutableArray  arrayWithCapacity:jsonArray.count];
    [jsonArray enumerateObjectsUsingBlock:^(NSDictionary *item, NSUInteger idx, BOOL * _Nonnull stop) {
        RLMObject *object = [self createOrUpdateFromJSONDictionary:item];
        [temp addObject:object];
    }];
    return temp.copy;
}

@end
