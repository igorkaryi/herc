//
//  Tickets+HTTPRequests.m
//  metro
//
//  Created by admin on 4/27/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "Tickets+HTTPRequests.h"
#import "TCCHTTPSessionManager.h"
#import "RLMObject+Mapping.h"
#import "TCCAccount+Manage.h"
#import "TCCAccount.h"

@implementation Tickets (HTTPRequests)

- (void)loadTicketsWithCompletion:(void (^)(id responseObject, NSString *errorStr))completion {
    [TCCSharedHTTPSessionManager POST:TCCHTTPRequestTicketsList parameters:nil completion:^(id responseObject, NSString *errorStr) {
        if (errorStr) {
            if (completion) {
                completion(nil,errorStr);
            }
        } else {
            RLMRealm *realm = [RLMRealm defaultRealm];

            if (Tickets.allObjects.count <2 && [responseObject[@"tickets"] count] == 2) {
                [self startLocalNotification];
            } else {
                if ([[[UIApplication sharedApplication] scheduledLocalNotifications]count]>0) {
                    for (UILocalNotification* oneEvent in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
                        if ([[oneEvent.userInfo objectForKey:@"notificationIdent"] isEqualToString:@"lastTicket"]) {
                            [[UIApplication sharedApplication] cancelLocalNotification:oneEvent];
                        }
                    }
                }
            }

            [realm beginWriteTransaction];
            [realm deleteObjects:[Tickets allObjects]];
            [realm commitWriteTransaction];

            for (NSDictionary *ticketsDict in responseObject[@"tickets"]) {
                Tickets *ticket = [Tickets new];

                ticket.add_info = [NSString stringWithFormat:@"%@",ticketsDict[@"add_info"]];
                ticket.amount = [NSString stringWithFormat:@"%@",ticketsDict[@"amount"]];
                ticket.balance = [NSString stringWithFormat:@"%@",ticketsDict[@"balance"]];
                ticket.done_time = [NSString stringWithFormat:@"%@",ticketsDict[@"done_time"]];
                ticket.expire_time = [NSString stringWithFormat:@"%@",ticketsDict[@"expire_time"]];
                ticket.objID = [NSString stringWithFormat:@"%@",ticketsDict[@"objID"]];
                ticket.make_time = [NSString stringWithFormat:@"%@",ticketsDict[@"make_time"]];
                ticket.name = [NSString stringWithFormat:@"%@",ticketsDict[@"name"]];
                ticket.qr_code = [NSString stringWithFormat:@"%@",ticketsDict[@"qr_code"]];
                ticket.receipt_id = [NSString stringWithFormat:@"%@",ticketsDict[@"receipt_id"]];
                ticket.state = [NSString stringWithFormat:@"%@",ticketsDict[@"state"]];
                ticket.ticket_id = [NSString stringWithFormat:@"%@",ticketsDict[@"ticket_id"]];
                ticket.title = [NSString stringWithFormat:@"%@",ticketsDict[@"title"]];
                ticket.work_day = [NSString stringWithFormat:@"%@",ticketsDict[@"work_day"]];

                [realm beginWriteTransaction];
                [realm addObject:ticket];
                [realm commitWriteTransaction];
            }

            if (completion) {
                completion([Tickets allObjects],errorStr);
            }
        }
    }];
}

-(void)startLocalNotification {
    if (TCCAccount.object.settings.pushLastTicket) {
        UILocalNotification *notification = [[UILocalNotification alloc]init];
        [notification setAlertBody:@"Осталось 2 билета"];
        [notification setFireDate:[NSDate dateWithTimeIntervalSinceNow:30]];
        [notification setTimeZone:[NSTimeZone  defaultTimeZone]];
        [notification setUserInfo:@{@"notificationIdent":@"lastTicket"}];
        [[UIApplication sharedApplication] setScheduledLocalNotifications:[NSArray arrayWithObject:notification]];
    }
}

@end
