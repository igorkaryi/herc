//
//  GestureTachcardImageView.m
//  metro
//
//  Created by admin on 7/19/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "GestureTachcardImageView.h"

@implementation GestureTachcardImageView

- (void)setTachcardTapGesture:(BOOL)tachcardTapGesture {
    if (tachcardTapGesture == YES) {
        [self setUserInteractionEnabled:YES];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)]];
    }
}

- (void)tapAction {
    NSLog(@"TAP");
}
@end
