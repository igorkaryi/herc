//
//  StatsMonths.h
//  metro
//
//  Created by admin on 5/7/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import <Realm/Realm.h>

@interface StatsMonths : RLMObject
@property NSInteger count;
@property NSInteger total;
@property NSString *month;
@end

RLM_ARRAY_TYPE(StatsMonths)
