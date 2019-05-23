//
//  HistoryPaymentCell.h
//  metro
//
//  Created by admin on 4/20/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "CornerCell.h"
#import <UIKit/UIKit.h>
#import "UITableViewCell+RelatedTable.h"

@interface HistoryPaymentCell : CornerCell


@property (weak, nonatomic) IBOutlet UILabel *ticketCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardLabel;

@end
