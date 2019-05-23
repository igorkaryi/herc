//
//  HistoryTripsCell.m
//  metro
//
//  Created by admin on 4/20/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "HistoryTripsCell.h"
#import "HistoryTrips.h"
#import "TicketsObject.h"
#import "TCCFormatter.h"

@implementation HistoryTripsCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)configCellWithIndexPath:(NSIndexPath *)indexPath rowsCount:(int)rowsCount {
    [super configCellWithIndexPath:indexPath rowsCount:rowsCount];
    TicketsObject *currentTicket = [HistoryTrips.allObjects[indexPath.section] currentObject][indexPath.row];
    
//    NSLog(@"%@",currentTicket.action_time);
//
    NSLog(@"%@",[TCCSharedFormatter utcStringFromDateWithFormat:@"HH:mm" date:currentTicket.action_time]);
    NSLog(@"%@",[TCCSharedFormatter localStringFromDateWithFormat:@"HH:mm" date:currentTicket.action_time]);
//

    [self.iconImageView setImage:[UIImage imageNamed:[self brachImageName:currentTicket.branch]]];
    [self.stationNameLabe setText:currentTicket.station_name];
    [self.dateLabe setText:[TCCSharedFormatter localStringFromDateWithFormat:@"HH:mm" date:currentTicket.action_time]];
    [self.detailStationNameLabe setText:currentTicket.station_name];
    [self.lobbyLabe setText:currentTicket.station_location];
    [self.detailDateLabe setText:[TCCSharedFormatter localStringFromDateWithFormat:@"HH:mm" date:currentTicket.action_time]];
    [self.codeLabel setText:currentTicket.ticket_name];
}

- (NSString *)brachImageName: (NSString *)branch {

    switch ([self randomValueBetween:0 and:2]) {
        case 0:
            return @"M1";
            break;
        case 1:
            return @"M2";
            break;
        case 2:
            return @"M3";
            break;

        default:
            break;
    }


    if ([branch isEqualToString:@"branch_1"]) {
        return @"M1";
    } else if ([branch isEqualToString:@"branch_2"]) {
        return @"M2";
    } else if ([branch isEqualToString:@"branch_3"]) {
        return @"M3";
    } else {
        return @"M1";
    }
}

- (NSInteger)randomValueBetween:(NSInteger)min and:(NSInteger)max {
    return (NSInteger)(min + arc4random_uniform(max - min + 1));
}

@end

