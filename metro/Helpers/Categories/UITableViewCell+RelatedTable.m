//
//  UITableViewCell+RelatedTable.m
//  metro
//
//  Created by admin on 4/23/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "UITableViewCell+RelatedTable.h"

@implementation UITableViewCell (RelatedTable)

- (UITableView *)relatedTable {
    if ([self.superview isKindOfClass:[UITableView class]])
        return (UITableView *)self.superview;
    else if ([self.superview.superview isKindOfClass:[UITableView class]])
        return (UITableView *)self.superview.superview;
    else {
        NSAssert(NO, @"UITableView shall always be found.");
        return nil;
    }
}

@end
