//
//  CardsListPopupCell.h
//  metro
//
//  Created by admin on 4/24/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCCMasterpassCard.h"

@interface CardsListPopupCell : UITableViewCell
@property (nonatomic, retain) IBOutlet UIImageView *cardImageView;
@property (nonatomic, retain) IBOutlet UILabel *cardNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *cardPanLabel;

- (void)configCellWithCard: (TCCMasterpassCard *)card;
@end
