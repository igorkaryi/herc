//
//  StatsDays.h
//  metro
//
//  Created by admin on 5/7/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import <Realm/Realm.h>

@interface StatsDays : RLMObject
@property NSInteger count;
@property NSInteger total;
@property NSString *day;
@end

RLM_ARRAY_TYPE(StatsDays)
