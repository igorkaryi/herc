//
//  CardsListPopupView.m
//  metro
//
//  Created by admin on 4/24/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "CardsListPopupView.h"
#import "CardsListPopupCell.h"
#import "MasterpassRequestModel.h"
#import "TCCMasterpassModel.h"
#import "UIView+LoadNib.h"

@interface CardsListPopupView ()
@property (nonatomic, retain) NSArray *cardsArray;
@property (nonatomic, retain) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;
@end

@implementation CardsListPopupView

+ (void)showCardsListInViewController: (UIViewController *)vc {
    CardsListPopupView *popup = [[CardsListPopupView alloc]initWith];
    popup.delgate = vc;
    [popup showView];
}

#pragma mark -
#pragma mark Lifecycle methods

- (instancetype)initWith {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self loadNib];
        [self.tableView setTableFooterView:[UIView new]];
        [self.tableView registerNib:[UINib nibWithNibName:@"CardsListPopupCell" bundle:nil] forCellReuseIdentifier:@"CardsListPopupCell"];
        [self loadCards];
    }
    return self;
}

- (IBAction)closeHandler:(id)sender {
    [self hideView];
}

- (void)loadCards {
    self.cardsArray = (NSArray *)[TCCMasterpassCard allObjects];
    [self.tableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tableViewHeightConstraint.constant = self.tableView.contentSize.height;
        [UIView animateWithDuration:0.3 animations:^{
            [self layoutIfNeeded];
        }];
    });

/*
    [self setUserInteractionEnabled:NO];
    @weakify(self);
    [TCCSharedMasterpassModel getWallets:^(id responseObject, NSString *errorStr) {
        @strongify(self);
        [self setUserInteractionEnabled:YES];
        if (errorStr) {
            [UIAlertController showAlertInViewController:[[UIApplication sharedApplication] keyWindow].rootViewController withTitle:@"" message:errorStr cancelButtonTitle:@"Ок" destructiveButtonTitle:nil otherButtonTitles:nil textFieldPlaceholders:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            }];
        } else {
            self.cardsArray = responseObject;
            [self.tableView reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.tableViewHeightConstraint.constant = self.tableView.contentSize.height;
                [UIView animateWithDuration:0.3 animations:^{
                    [self layoutIfNeeded];
                }];
            });
        }
    }];
 */
}

#pragma mark -
#pragma mark UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cardsArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CardsListPopupCell *cell = nil;

    cell = [tableView dequeueReusableCellWithIdentifier:@"CardsListPopupCell"];

    if (!cell) {
        cell = [[CardsListPopupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CardsListPopupCell"];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    cell.selectionStyle = UITableViewCellSelectionStyleDefault;

    [cell configCellWithCard:self.cardsArray[indexPath.row]];

    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = _RGBA(255, 255, 255, 0.2);
    [cell setSelectedBackgroundView:bgColorView];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delgate respondsToSelector:@selector(selectCard:)]) {
        [self.delgate selectCard:self.cardsArray[indexPath.row]];
        [self hideView];
    }
}

- (IBAction)addCardHandler:(id)sender {
    if ([self.delgate respondsToSelector:@selector(addCardHandler:)]) {
        [self.delgate addCardHandler:sender];
        [self hideView];
    }
}

@end
