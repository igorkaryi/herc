//
//  Tickets+HTTPRequests.h
//  metro
//
//  Created by admin on 4/27/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tickets.h"

@interface Tickets (HTTPRequests)
- (void)loadTicketsWithCompletion:(void (^)(id responseObject, NSString *errorStr))completion;
@end
