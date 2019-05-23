//
//  HistoryModel.m
//  metro
//
//  Created by admin on 5/4/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "HistoryModel.h"

#import "TCCHTTPSessionManager.h"
#import "GCDSingleton.h"

#import "TCCAccount+Manage.h"

#import "TCCFormatter.h"
#import "HistoryWeekTrips.h"

#import "HistoryStats.h"


#import "StatsDays.h"
#import "StatsMonths.h"
#import "StatsWeeks.h"

@implementation HistoryModel

#pragma mark -
#pragma mark Singletone

+ (instancetype)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [self new];
    });
}


- (void)loadHistoryWithCompletion:(void (^)(id responseObject, NSString *errorStr))completion {
    NSString *updateDateString = [[TCCSharedFormatter localDateFormatter] stringFromDate:[NSDate date]];

    NSDictionary *params;
    if (TCCAccount.object.settings.historyUpdateDate) {
        params = @{@"datetime":[[TCCSharedFormatter localDateFormatter] stringFromDate:TCCAccount.object.settings.historyUpdateDate],@"group_by_days":@"1"};
    } else {
        params = @{@"group_by_days":@"1"};
    }

    [TCCSharedHTTPSessionManager POST:TCCHTTPRequestTicketsHistory parameters:params completion:^(id responseObject, NSString *errorStr) {
        if (errorStr) {
            if (completion) {
                completion(nil,errorStr);
            }
        } else {
//            [[RLMRealm defaultRealm] transactionWithBlock:^{
//                TCCAccount.object.settings.historyUpdateDate = [[TCCSharedFormatter localDateFormatter] dateFromString:updateDateString];
//            }];

            __block int fnish = 0;

            [self getHistoryStatsWithCompletion:^(BOOL status) {
                fnish = fnish+1;
                if (fnish == 3) {
                    if (completion) {
                        completion(responseObject,errorStr);
                    }
                }
            }];

            [self getGroupedTrips:responseObject[@"data"][@"tickets"] completion:^(BOOL status) {
                fnish = fnish+1;
                if (fnish == 3) {
                    if (completion) {
                        completion(responseObject,errorStr);
                    }
                }
            }];

            [self getGroupedPayments:responseObject[@"data"][@"payments"] completion:^(BOOL status) {
                fnish = fnish+1;
                if (fnish == 3) {
                    if (completion) {
                        completion(responseObject,errorStr);
                    }
                }
            }];
        }
    }];
}

- (void)getHistoryStatsWithCompletion:(void (^)(BOOL status))completion {
    [TCCSharedHTTPSessionManager POST:TCCHTTPRequestTicketsStats parameters:nil completion:^(id responseObject, NSString *errorStr) {
        if (errorStr) {
            if (completion) {
                completion(NO);
            }
        } else {
            if ([[responseObject allKeys]containsObject:@"stats"]) {

                RLMRealm *realm = [RLMRealm defaultRealm];

                [realm beginWriteTransaction];
                [realm deleteObjects:[StatsDays allObjects]];
                [realm deleteObjects:[StatsMonths allObjects]];
                [realm deleteObjects:[StatsWeeks allObjects]];
                [realm commitWriteTransaction];

                if ([[responseObject[@"stats"] allKeys]containsObject:@"days"]) {
                    for (NSDictionary *days in responseObject[@"stats"][@"days"]) {
                        StatsDays *daysObj = [StatsDays new];
                        daysObj.count = [days[@"count"]integerValue];
                        daysObj.total = [days[@"total"]integerValue];
                        daysObj.day = days[@"day"];

                        [realm beginWriteTransaction];
                        [realm addObject:daysObj];
                        [realm commitWriteTransaction];
                    }
                }

                if ([[responseObject[@"stats"] allKeys]containsObject:@"months"]) {
                    for (NSDictionary *months in responseObject[@"stats"][@"months"]) {
                        StatsMonths *monthsObj = [StatsMonths new];
                        monthsObj.count = [months[@"count"]integerValue];
                        monthsObj.total = [months[@"total"]integerValue];
                        monthsObj.month = months[@"month"];

                        [realm beginWriteTransaction];
                        [realm addObject:monthsObj];
                        [realm commitWriteTransaction];
                    }
                }

                if ([[responseObject[@"stats"] allKeys]containsObject:@"weeks"]) {
                    for (NSDictionary *weeks in responseObject[@"stats"][@"weeks"]) {
                        StatsWeeks *weeksObj = [StatsWeeks new];
                        weeksObj.count = [weeks[@"count"]integerValue];
                        weeksObj.total = [weeks[@"total"]integerValue];
                        weeksObj.week_end = weeks[@"week_end"];
                        weeksObj.week_start = weeks[@"week_start"];

                        [realm beginWriteTransaction];
                        [realm addObject:weeksObj];
                        [realm commitWriteTransaction];
                    }
                }

                if (completion) {
                    completion(YES);
                }
            }
        }
    }];
}

- (void)getGroupedTrips: (NSArray *)trips completion:(void (^)(BOOL status))completion {

    RLMRealm *realm = [RLMRealm defaultRealm];

    [realm beginWriteTransaction];
    [realm deleteObjects:[HistoryTrips allObjects]];
    [realm commitWriteTransaction];

    for (NSDictionary *dict in trips) {
        HistoryTrips *ticket = [HistoryTrips new];

        NSLog(@"%@",dict[@"date"]);
        NSLog(@"%@",[TCCSharedFormatter localDateFromStringWithFormat:@"yyyy-MM-dd" dateString:dict[@"date"]]);
        NSLog(@"%@",[TCCSharedFormatter utcDateFromStringWithFormat:@"yyyy-MM-dd" dateString:dict[@"date"]]);

        ticket.groupDate = [TCCSharedFormatter localDateFromStringWithFormat:@"yyyy-MM-dd" dateString:dict[@"date"]];

        for (NSDictionary *objects in dict[@"data"]) {

            TicketsObject *ticketsObject = [TicketsObject new];

            NSLog(@"%@",objects[@"action_time"]);
            NSLog(@"%@",[TCCSharedFormatter localDateFromStringWithFormat:@"yyyy-MM-dd HH:mm:ss" dateString:objects[@"action_time"]]);
            NSLog(@"%@",[TCCSharedFormatter utcDateFromStringWithFormat:@"yyyy-MM-dd HH:mm:ss" dateString:objects[@"action_time"]]);

            ticketsObject.action_time = [TCCSharedFormatter utcDateFromStringWithFormat:@"yyyy-MM-dd HH:mm:ss" dateString:objects[@"action_time"]];
            ticketsObject.branch = [NSString stringWithFormat:@"%@",objects[@"branch"]];
            ticketsObject.station_location = [NSString stringWithFormat:@"%@",objects[@"station_location"]];
            ticketsObject.station_name = [NSString stringWithFormat:@"%@",objects[@"station_name"]];
            ticketsObject.ticket_id = [NSString stringWithFormat:@"%@",objects[@"ticket_id"]];
            ticketsObject.ticket_name = [NSString stringWithFormat:@"%@",objects[@"ticket_name"]];

            [ticket.currentObject addObject:ticketsObject];
        }

        [realm beginWriteTransaction];
        [realm addObject:ticket];
        [realm commitWriteTransaction];
    }

    if (completion) {
        completion(YES);
    }
}

- (void)getGroupedPayments: (NSArray *)payments completion:(void (^)(BOOL status))completion {

    RLMRealm *realm = [RLMRealm defaultRealm];

    [realm beginWriteTransaction];
    [realm deleteObjects:[HistoryPayments allObjects]];
    [realm commitWriteTransaction];

    for (NSDictionary *dict in payments) {
        HistoryPayments *payment = [HistoryPayments new];

        payment.groupDate = [TCCSharedFormatter localDateFromStringWithFormat:@"yyyy-MM-dd" dateString:dict[@"date"]];

        for (NSDictionary *objects in dict[@"data"]) {
            PaymentsObject *paymentObject = [PaymentsObject new];

            paymentObject.amount = [NSString stringWithFormat:@"%@",objects[@"amount"]];
            paymentObject.card_last_digits = [NSString stringWithFormat:@"%@",objects[@"card_last_digits"]];
            paymentObject.list_account_name = [NSString stringWithFormat:@"%@",objects[@"list_account_name"]];
            paymentObject.receipt_id = [NSString stringWithFormat:@"%@",objects[@"receipt_id"]];
            paymentObject.updated_at = [TCCSharedFormatter utcDateFromStringWithFormat:@"yyyy-MM-dd HH:mm:ss" dateString:objects[@"updated_at"]];
            paymentObject.tickets_count = [NSString stringWithFormat:@"%@",objects[@"tickets_count"]];

            [payment.currentObject addObject:paymentObject];
        }

        [realm beginWriteTransaction];
        [realm addObject:payment];
        [realm commitWriteTransaction];
    }

    if (completion) {
        completion(YES);
    }
}

#pragma - Helpers

- (void)getTransactionsByPeriod: (HistoryPeriod)period {
    switch (period) {
        case dayPeriod: {

        }
            break;
        case weekPeriod: {

        }
            break;
        case monthPeriod: {

        }
            break;

        default:
            break;
    }
}

@end
