//
//  CardsListPopupCell.m
//  metro
//
//  Created by admin on 4/24/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "CardsListPopupCell.h"

@implementation CardsListPopupCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configCellWithCard: (TCCMasterpassCard *)card {
    [self.cardNameLabel setText:card.cardName];
    [self.cardPanLabel setText:[NSString stringWithFormat:@"**** **%@",[card.cardNo substringFromIndex:14]]];
    [self.cardImageView setImage:[UIImage imageNamed:([[card.cardNo substringToIndex:1] isEqualToString:@"5"])?@"mc card":@"visa card"]];
}

@end
