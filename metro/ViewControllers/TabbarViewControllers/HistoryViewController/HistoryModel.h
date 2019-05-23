//
//  HistoryModel.h
//  metro
//
//  Created by admin on 5/4/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HistoryPayments.h"
#import "HistoryTrips.h"

#define SharedHistoryModel [HistoryModel sharedInstance]

typedef NS_ENUM(NSUInteger, HistoryPeriod) {
    dayPeriod = 0,
    weekPeriod,
    monthPeriod
};

@interface HistoryModel : NSObject
+ (HistoryModel*)sharedInstance;
- (void)loadHistoryWithCompletion:(void (^)(id responseObject, NSString *errorStr))completion;
@end
