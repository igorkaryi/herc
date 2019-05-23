//
//  UIImageView+IBInspectableProperty.m
//  metro
//
//  Created by admin on 7/19/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "UIImageView+IBInspectableProperty.h"

@implementation UIImageView (IBInspectableProperty)
@dynamic tachcardTapGesture;

- (void)setTachcardTapGesture:(BOOL)tachcardTapGesture {
    if (tachcardTapGesture == YES) {
        [self setUserInteractionEnabled:YES];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)]];
    }
}

- (void)tapAction {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://tachcard.com/ua"]];
}



@end



