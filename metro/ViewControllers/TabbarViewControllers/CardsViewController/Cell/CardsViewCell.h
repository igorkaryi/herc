//
//  CardsViewCell.h
//  metro
//
//  Created by admin on 4/18/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCCMasterpassCard.h"

@protocol CardsViewCellDelegate <NSObject>
- (void)setFavoriteCard: (TCCMasterpassCard *)wallet;
@end

@interface CardsViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cardNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardPanLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardSmallPanLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cardImageView;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@property (retain, nonatomic) TCCMasterpassCard *mpCard;


@property (weak, nonatomic) IBOutlet NSObject <CardsViewCellDelegate> *delegate;

- (void)configCellWithCard: (TCCMasterpassCard *)card;
@end
