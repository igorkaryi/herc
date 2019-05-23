//
//  CardsViewCell.m
//  metro
//
//  Created by admin on 4/18/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "CardsViewCell.h"


@implementation CardsViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)configCellWithCard: (TCCMasterpassCard *)card {
    self.mpCard = card;
    [self.cardNameLabel setText:card.cardName];
    [self.cardPanLabel setText:card.cardNo];
    [self.cardSmallPanLabel setText:[NSString stringWithFormat:@"**** **%@",[card.cardNo substringFromIndex:14]]];
    [self.cardImageView setImage:[UIImage imageNamed:([[card.cardNo substringToIndex:1] isEqualToString:@"5"])?@"mcCell":@"visaCell"]];


    if ([card.cardName isEqualToString:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"isFavorite"]]]) {
        [self.favoriteButton setImage:[UIImage imageNamed:@"selectedStar"] forState:UIControlStateNormal];
    } else {
        [self.favoriteButton setImage:[UIImage imageNamed:@"emptyStar"] forState:UIControlStateNormal];
    }
}

- (IBAction)favoriteHandler:(id)sender {
    if ([self.delegate respondsToSelector:@selector(setFavoriteCard:)]) {
        [self.delegate setFavoriteCard:self.mpCard];
    }
}
@end
