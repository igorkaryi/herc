//
//  HistoryCell.h
//  metro
//
//  Created by admin on 4/23/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CornerCell : UITableViewCell
@property (nonatomic, retain) IBOutlet UIView *cornerView;
- (void)configCellWithIndexPath:(NSIndexPath *)indexPath rowsCount:(int)rowsCount;
@end
