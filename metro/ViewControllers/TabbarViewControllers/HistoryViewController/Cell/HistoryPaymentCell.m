//
//  HistoryPaymentCell.m
//  metro
//
//  Created by admin on 4/20/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "HistoryPaymentCell.h"
#import "HistoryPayments.h"
#import "PaymentsObject.h"
#import "TCCFormatter.h"

@implementation HistoryPaymentCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)configCellWithIndexPath:(NSIndexPath *)indexPath rowsCount:(int)rowsCount {
    [super configCellWithIndexPath:indexPath rowsCount:rowsCount];
    PaymentsObject *currentPayment = [HistoryPayments.allObjects[indexPath.section] currentObject][indexPath.row];
    
    [self.ticketCountLabel setText:[NSString stringWithFormat:@"%@ %@",currentPayment.tickets_count,[self ticketsString:currentPayment.tickets_count.intValue]]];
    [self.amountLabel setText:[NSString stringWithFormat:@"%0.f ₴",currentPayment.amount.floatValue]];
    [self.dateLabel setText:[TCCSharedFormatter localStringFromDateWithFormat:@"HH:mm" date:currentPayment.updated_at]];
    [self.detailAmountLabel setText:[NSString stringWithFormat:@"%0.f ₴",currentPayment.amount.floatValue]];
    [self.detailDateLabel setText:[TCCSharedFormatter localStringFromDateWithFormat:@"HH:mm" date:currentPayment.updated_at]];
    [self.cardLabel setText:[NSString stringWithFormat:@"%@ ****%@",currentPayment.list_account_name,currentPayment.card_last_digits]];

}

- (NSString*)ticketsString:(int)number{
    if (number < 0) {
        number = number*-1;
    }
    NSArray *data = @[@"квиток",@"квитка",@"квитків"];
    NSArray *_case = @[@2, @0, @1, @1, @1, @2];
    return data[(number%100 > 4 && number%100 < 20)?2:[_case[((number%10 < 5)?number%10:5)] intValue]];
}
@end
