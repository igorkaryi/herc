//
//  TCCPinViewController.h
//  Tachcard
//
//  Created by Yaroslav Bulda on 18/11/15.
//  Copyright © 2015 Tachcard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCCPinController : NSObject
@property (nonatomic) BOOL isCurrentlyOnScreen;
+ (void)setup;
+ (TCCPinController*)sharedInstanse;
- (BOOL)currentlyOnScreen;
@end
