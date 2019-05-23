//
//  HistoryWeekPayments.h
//  metro
//
//  Created by admin on 5/7/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import <Realm/Realm.h>
#import "HistoryTrips.h"

@interface HistoryWeekTrips : RLMObject

@property NSDate *firstDate;
@property NSDate *lastDate;

@property NSString *weekYear;
@property RLMArray <HistoryTrips> *currentObject;


@end
