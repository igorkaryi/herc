//
//  HistoryTickets.h
//  metro
//
//  Created by admin on 5/4/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import <Realm/Realm.h>
#import "TicketsObject.h"

@interface HistoryTrips : RLMObject

@property NSDate *groupDate;
@property RLMArray <TicketsObject> *currentObject;

@end

RLM_ARRAY_TYPE(HistoryTrips)
