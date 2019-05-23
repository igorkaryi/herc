//
//  Tickets.h
//  metro
//
//  Created by admin on 4/27/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import <Realm/Realm.h>

@interface Tickets : RLMObject

@property (nonatomic, copy) NSString *add_info;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *balance;
@property (nonatomic, copy) NSString *done_time;
@property (nonatomic, copy) NSString *expire_time;
@property (nonatomic, copy) NSString *objID;
@property (nonatomic, copy) NSString *make_time;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *qr_code;
@property (nonatomic, copy) NSString *receipt_id;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *ticket_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *work_day;

@end

RLM_ARRAY_TYPE(Tickets)
