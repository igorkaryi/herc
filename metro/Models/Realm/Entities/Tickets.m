//
//  Tickets.m
//  metro
//
//  Created by admin on 4/27/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "Tickets.h"

@implementation Tickets

//+ (NSString *)primaryKey {
//    return @"objID";
//}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"add_info":@"add_info",
             @"amount":@"amount",
             @"balance":@"balance",
             @"done_time":@"done_time",
             @"expire_time":@"expire_time",
             @"id":@"objID",
             @"location":@"location",
             @"make_time":@"make_time",
             @"name":@"name",
             @"qr_code":@"qr_code",
             @"receipt_id":@"receipt_id",
             @"state":@"state",
             @"ticket_id":@"ticket_id",
             @"title":@"title",
             @"work_day":@"work_day"
             };
}

@end

