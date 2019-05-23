//
//  TCCCarouselItemView.m
//  Tachcard
//
//  Created by admin on 12/18/17.
//  Copyright © 2017 Tachcard. All rights reserved.
//

#import "CarouselItemView.h"
#import "UIView+loadNib.h"
#import "Reachability.h"
#import "TCCHTTPSessionManager.h"

@implementation CarouselItemView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadNib];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityDidChange:) name:kReachabilityChangedNotification object:nil];
    }
    return self;
}

- (IBAction)helpHandler:(id)sender {
    if ([self.delegate respondsToSelector:@selector(helpQrHandler)]) {
        [self.delegate helpQrHandler];
    }
}

- (IBAction)scanNextHandler:(id)sender {
    if ([self.delegate respondsToSelector:@selector(tryNextHandler)]) {
        [self.delegate tryNextHandler];
    }
}

- (IBAction)tryAgainHandler:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        [self.cantScanView setAlpha:0];
    }];
}

- (IBAction)cantScanHandler:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        [self.cantScanView setAlpha:1];
    }];
}

- (IBAction)deleteTicket {
    NSDictionary *params = @{@"receipt_id":self.receiptIdString};
    [TCCSharedHTTPSessionManager POST:TCCHTTPRequestTicketsService parameters:params completion:^(id responseObject, NSString *errorStr) {
        if (errorStr) {

        } else {

        }
    }];
}

- (void)reachabilityDidChange:(NSNotification *)notification {
    [self isInternetConnection:[(Reachability *)[notification object] isReachable]];
}

- (void)isInternetConnection: (BOOL) isConnect {
    [self.cantScanButtonView setAlpha:(isConnect)?0:1];
}

- (void)succesAnimationCompletion:(void (^)(BOOL succesAnimation))completion {
    [self drawSuccesIcon];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (completion) {
            completion(YES);
        }
    });
}

- (void)drawSuccesIcon {
    UIView *bgView = [[UIView alloc]initWithFrame:self.qrImageView.bounds];
    [bgView setBackgroundColor:[UIColor whiteColor]];

    UIColor *iconColour = mainColour;
    int radius = self.qrImageView.bounds.size.height/2;
    CAShapeLayer *circle = [CAShapeLayer layer];
    circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius)
                                             cornerRadius:radius].CGPath;
    circle.fillColor = [UIColor clearColor].CGColor;
    circle.strokeColor = iconColour.CGColor;
    circle.lineWidth = 2.5;

    [bgView.layer addSublayer:circle];

    [self.qrImageView addSubview:bgView];

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

        [self.qrImageView.layer addSublayer:line];

        CABasicAnimation *drawAnimationLine = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        drawAnimationLine.duration            = 0.4; // "animate over 10 seconds or so.."
        drawAnimationLine.repeatCount         = 1.0;  // Animate only once..
        drawAnimationLine.fromValue = [NSNumber numberWithFloat:0.0f];
        drawAnimationLine.toValue   = [NSNumber numberWithFloat:1.0f];
        drawAnimationLine.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];

        line.contentsScale = 2;

        [line addAnimation:drawAnimationLine forKey:@"drawCircleAnimation"];
    });
}

@end
