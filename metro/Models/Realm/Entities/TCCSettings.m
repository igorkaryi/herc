//
//  TCCSettings.m
//  Tachcard
//
//  Created by Yaroslav Bulda on 08/10/15.
//  Copyright © 2015 Tachcard. All rights reserved.
//

#import "TCCSettings.h"

@implementation TCCSettings

// Specify default values for properties

+ (NSDictionary *)defaultPropertyValues {
    return @{@"useTouchID":@NO,@"pushLastTicket":@YES,@"pushDateTicket":@YES};
}

// Specify properties to ignore (Realm won't persist these)

//+ (NSArray *)ignoredProperties
//{
//    return @[];
//}

@end
