//
//  TicketsObject.h
//  metro
//
//  Created by admin on 5/4/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import <Realm/Realm.h>

@interface TicketsObject : RLMObject

@property NSDate *action_time;
@property NSString *branch;
@property NSString *station_location;
@property NSString *station_name;
@property NSString *ticket_id;
@property NSString *ticket_name;

@end

 RLM_ARRAY_TYPE(TicketsObject)
