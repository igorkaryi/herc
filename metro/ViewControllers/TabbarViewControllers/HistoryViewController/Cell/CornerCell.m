//
//  HistoryCell.m
//  metro
//
//  Created by admin on 4/23/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "CornerCell.h"

@implementation CornerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setBackgroundColor:[UIColor clearColor]];
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    [self layoutIfNeeded];
}

- (void)configCellWithIndexPath:(NSIndexPath *)indexPath rowsCount:(int)rowsCount {
    if (rowsCount>1) {
        if (indexPath.row == 0) {
            UIBezierPath *maskPath = [UIBezierPath
                                      bezierPathWithRoundedRect:self.cornerView.bounds
                                      byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                      cornerRadii:CGSizeMake(3, 3)
                                      ];

            CAShapeLayer *maskLayer = [CAShapeLayer layer];

            maskLayer.frame = self.cornerView.bounds;
            maskLayer.path = maskPath.CGPath;

            [self addSeparator];

            //[self.cornerView setBackgroundColor:[UIColor redColor]];

            self.cornerView.layer.mask = maskLayer;
        } else if (indexPath.row == rowsCount-1) {
            UIBezierPath *maskPath = [UIBezierPath
                                      bezierPathWithRoundedRect:self.cornerView.bounds
                                      byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                      cornerRadii:CGSizeMake(3, 3)
                                      ];

            CAShapeLayer *maskLayer = [CAShapeLayer layer];

            maskLayer.frame = self.cornerView.bounds;
            maskLayer.path = maskPath.CGPath;

            //[self.cornerView setBackgroundColor:[UIColor yellowColor]];

            self.cornerView.layer.mask = maskLayer;
        } else {

            //[self.cornerView setBackgroundColor:[UIColor greenColor]];
            [self addSeparator];
            [self.cornerView.layer setCornerRadius:0];
        }
    } else {

        //[self.cornerView setBackgroundColor:[UIColor blueColor]];

        [self.cornerView.layer setCornerRadius:3];
    }
    [self layoutIfNeeded];
}

- (void)addSeparator {
    UIView *separatorView = [[UIView alloc]initWithFrame:CGRectMake(0, self.cornerView.bounds.size.height-0.5, self.cornerView.bounds.size.width, 0.5)];
    [separatorView setBackgroundColor:UIColorFromRGB(0xE7E8E8)];
    [self.cornerView addSubview:separatorView];
}

@end
