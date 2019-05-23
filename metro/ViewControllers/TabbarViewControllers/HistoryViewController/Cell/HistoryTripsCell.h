//
//  HistoryTripsCell.h
//  metro
//
//  Created by admin on 4/20/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "CornerCell.h"
#import <UIKit/UIKit.h>
#import "UITableViewCell+RelatedTable.h"

@interface HistoryTripsCell : CornerCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *stationNameLabe;
@property (weak, nonatomic) IBOutlet UILabel *dateLabe;


@property (weak, nonatomic) IBOutlet UILabel *detailStationNameLabe;
@property (weak, nonatomic) IBOutlet UILabel *lobbyLabe;
@property (weak, nonatomic) IBOutlet UILabel *detailDateLabe;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@end
