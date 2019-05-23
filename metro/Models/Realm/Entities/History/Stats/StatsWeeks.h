//
//  StatsWeeks.h
//  metro
//
//  Created by admin on 5/7/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import <Realm/Realm.h>

@interface StatsWeeks : RLMObject
@property NSInteger count;
@property NSInteger total;
@property NSString *week_end;
@property NSString *week_start;
@end

RLM_ARRAY_TYPE(StatsWeeks)
