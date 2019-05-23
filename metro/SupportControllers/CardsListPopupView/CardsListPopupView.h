//
//  CardsListPopupView.h
//  metro
//
//  Created by admin on 4/24/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "GlobalPopupView.h"
#import "TCCMasterpassCard.h"

@protocol CardsListPopupDelegate <NSObject>
- (IBAction)addCardHandler:(id)sender;
- (void)selectCard:(TCCMasterpassCard *)card;
@end


@interface CardsListPopupView : GlobalPopupView
@property (nonatomic, retain) IBOutlet UITableView *tableView;
+ (void)showCardsListInViewController: (UIViewController *)vc;
@property (weak, nonatomic) NSObject <CardsListPopupDelegate> *delgate;
@end
