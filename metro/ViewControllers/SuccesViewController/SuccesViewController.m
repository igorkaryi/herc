//
//  SuccesViewController.m
//  metro
//
//  Created by admin on 4/16/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "SuccesViewController.h"
#import "TCCTabbarViewController.h"

@interface SuccesViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageStatusView;
@property (nonatomic, retain) IBOutlet NSLayoutConstraint *labelTopConstarint;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@end

@implementation SuccesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    switch (self.currentType) {
        case StatusViewTypeAddCardRegister: {
            [self.statusLabel setText:@"Гаманець \nпідключено"];
        }
            break;
        case StatusViewTypeAddCard: {
            [self.statusLabel setText:@"Картку \nдодано"];
        }
            break;
        case StatusViewTypePinOff: {
            [self.statusLabel setText:@"Пін-код \nвимкнено"];
        }
            break;
        default: {
             [self.statusLabel setText:@""];
        }
            break;
    }

    [self drawSuccesIcon];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)drawSuccesIcon {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1 animations:^{
            self.labelTopConstarint.constant = 20;
            [self.statusLabel setAlpha:1];
            [self.view layoutIfNeeded];
        }];
    });


    UIColor *iconColour = mainColour;
    int radius = 45;
    CAShapeLayer *circle = [CAShapeLayer layer];
    circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius)
                                             cornerRadius:radius].CGPath;
    circle.fillColor = [UIColor clearColor].CGColor;
    circle.strokeColor = iconColour.CGColor;
    circle.lineWidth = 2.5;

    [self.imageStatusView.layer addSublayer:circle];

    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation.duration            = 0.6; // "animate over 10 seconds or so.."
    drawAnimation.repeatCount         = 1.0;  // Animate only once..
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    drawAnimation.toValue   = [NSNumber numberWithFloat:1.0f];
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];

    [circle addAnimation:drawAnimation forKey:@"drawCircleAnimation"];


    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.6 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        CAShapeLayer *line = [CAShapeLayer layer];

        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path,NULL,radius/3,radius);
        CGPathAddLineToPoint(path, NULL, radius/1.2, radius*1.5);
        CGPathAddLineToPoint(path, NULL, radius+radius/1.9, radius/1.3);


        line.path = path;
        line.fillColor = [UIColor clearColor].CGColor;
        line.strokeColor = iconColour.CGColor;
        line.lineWidth = 2.5;

        [self.imageStatusView.layer addSublayer:line];

        CABasicAnimation *drawAnimationLine = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        drawAnimationLine.duration            = 0.4; // "animate over 10 seconds or so.."
        drawAnimationLine.repeatCount         = 1.0;  // Animate only once..
        drawAnimationLine.fromValue = [NSNumber numberWithFloat:0.0f];
        drawAnimationLine.toValue   = [NSNumber numberWithFloat:1.0f];
        drawAnimationLine.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];

        line.contentsScale = 2;

        [line addAnimation:drawAnimationLine forKey:@"drawCircleAnimation"];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self completionAfterAnimation];
        });
    });
}



- (void)completionAfterAnimation {
    switch (self.succesActionType) {
        case StatusViewSuccesActionRootTabBar: {
            TCCTabbarViewController *rootViewController = [TCCTabbarViewController new];
            [[UIApplication sharedApplication].keyWindow setRootViewController:rootViewController animated:YES];
        }
            break;
        case StatusViewSuccesActionPopBack: {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case StatusViewSuccesActionDismiss: {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        case StatusViewSuccesActionPopRoot: {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
        default: {
            TCCTabbarViewController *rootViewController = [TCCTabbarViewController new];
            [[UIApplication sharedApplication].keyWindow setRootViewController:rootViewController animated:YES];
        }
            break;
    }
}

@end
