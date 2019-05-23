//
//  TCCCarouselItemView.h
//  Tachcard
//
//  Created by admin on 12/18/17.
//  Copyright © 2017 Tachcard. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TCCCarouselItemViewDelegate <NSObject>
- (void)helpQrHandler;
- (void)tryNextHandler;
@end

@interface CarouselItemView : UIView
@property (nonatomic, weak) NSObject <TCCCarouselItemViewDelegate> *delegate;
@property (nonatomic, retain) IBOutlet UIView *cantScanView;
@property (nonatomic, retain) IBOutlet UIView *cantScanButtonView;

@property (nonatomic, retain) IBOutlet UIImageView *qrImageView;
@property (nonatomic, retain) IBOutlet UIImageView *warningImageView;

@property (nonatomic, retain) IBOutlet UILabel *expireLabel;
@property (nonatomic, retain) IBOutlet UILabel *simpleLabel;
@property (nonatomic, retain) IBOutlet UIButton *helpButton;


@property (nonatomic, retain) NSString *receiptIdString;
- (void)succesAnimationCompletion:(void (^)(BOOL succesAnimation))completion;
@end

