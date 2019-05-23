//
//  HistoryStats.h
//  metro
//
//  Created by admin on 5/7/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import <Realm/Realm.h>
#import "StatsDays.h"
#import "StatsMonths.h"
#import "StatsWeeks.h"

@interface HistoryStats : RLMObject
@property RLMArray <StatsDays> *days;
@property RLMArray <StatsMonths> *months;
@property RLMArray <StatsWeeks> *weeks;
@end
