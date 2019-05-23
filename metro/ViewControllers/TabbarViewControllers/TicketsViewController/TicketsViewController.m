//
//  TicketsViewController.m
//  metro
//
//  Created by admin on 4/18/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "TicketsViewController.h"
#import "TCCAccount+Manage.h"
#import "TCCMasterpassModel.h"
#import "MasterpassRequestModel.h"
#import "SuccesViewController.h"

#import "VcodeViewController.h"
#import "CardDataMpViewController.h"
#import "QuantityViewController.h"

#import "HowWorkViewController.h"
#import "iCarousel.h"
#import "CarouselItemView.h"

#import "HelpListViewController.h"
#import "Reachability.h"
#import "UIImage+MDQRCode.h"

#import "Tickets+HTTPRequests.h"
#import "NSTimer+BlocksKit.h"
#import "UIScreen+Brightness.h"

@interface TicketsViewController () <iCarouselDataSource, iCarouselDelegate>
@property (retain, nonatomic) IBOutlet UIView *contentView;

@property (retain, nonatomic) IBOutlet UIView *existTicketsView;
@property (retain, nonatomic) IBOutlet UIView *noTicketsView;
@property (retain, nonatomic) IBOutlet UIView *linkMasterpassView;
@property (retain, nonatomic) IBOutlet UIView *createMasterpassView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControll;

@property (retain, nonatomic) IBOutlet NSLayoutConstraint *noConnectionHeightConstraint;
@property (retain, nonatomic) IBOutlet UILabel *ticketsCountLabel;
@property (retain, nonatomic) IBOutlet UIButton *buyButton;

@property (nonatomic, strong) IBOutlet iCarousel *carousel;
@property float icarouselItemWidth;
@property float icarouselItemHeight;

@property (retain, nonatomic) RLMResults *ticketsArray;
@property (retain, nonatomic) RLMResults *tmpTicketsArray;

@property (retain, nonatomic) NSDateFormatter *expireDateFormatter;
@property (retain, nonatomic) NSDateFormatter *expireFinalDateFormatter;

@end

@implementation TicketsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.segmentedControll.layer.cornerRadius = 14.0;
    self.segmentedControll.layer.borderColor = [UIColor colorWithRed:0.00 green:0.27 blue:0.48 alpha:1.0].CGColor;
    self.segmentedControll.layer.borderWidth = 1.0f;
    self.segmentedControll.layer.masksToBounds = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillAppear:) name:@"tabTicketWillApper" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityDidChange:) name:kReachabilityChangedNotification object:nil];
    [self configDateFormatters];

    self.ticketsArray = Tickets.allObjects;
    self.tmpTicketsArray = self.ticketsArray;
    
    [self addSubView:self.noTicketsView];

    [self configCarousel];
    [self loadTickets];

//    [NSTimer bk_scheduledTimerWithTimeInterval:5.0 block:^(NSTimer *time) {
//         if (TCCAccount.object.isAuthorized) {
//             [self loadTickets];
//         }
//    } repeats:YES];
}

- (void)loadTickets {
    [[Tickets new] loadTicketsWithCompletion:^(id responseObject, NSString *errorStr) {
        if (self.carousel.numberOfItems > self.ticketsArray.count) {
            [(CarouselItemView *)[self.carousel itemViewAtIndex:self.carousel.currentItemIndex] succesAnimationCompletion:^(BOOL succesAnimation) {
                self.ticketsArray = Tickets.allObjects;
                [self configCarousel];
                [self setMainView];
            }];
        } else {
            self.ticketsArray = Tickets.allObjects;
            [self configCarousel];
            [self setMainView];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    if ([[self topViewController] isKindOfClass:[TicketsViewController class]]) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
    [self setMainView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [UIScreen mainScreen].animatedBrightness = [[NewString anyStringByReplacingOccurrencesOfString:@"," withString:@"." inString:[[NSUserDefaults standardUserDefaults]objectForKey:@"screenBrightness"]]floatValue];
}

- (void)setMainView {
    if (self.ticketsArray.count != 0) {
        [self addSubView:self.existTicketsView];
    } else {
        [TCCSharedMasterpassModel checkEndUserFlow:^(MPEndUserFlow endUserFlow) {
            switch (endUserFlow) {
                case MPEndUserDontHave: {
                    [self addSubView:self.createMasterpassView];
                }
                    break;
                case MPEndUserNotLink: {
                    [self addSubView:self.linkMasterpassView];
                }
                    break;
                case MPEndUserLink: {
                    [self addSubView:self.noTicketsView];
                }
                    break;
                default:
                    break;
            }
        }];
    }
}

- (void)addSubView: (UIView *)subView {
    if (!subView) {
        return;
    }
    [[self.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.contentView addSubview:subView];
    subView.translatesAutoresizingMaskIntoConstraints = NO;
    [subView setBackgroundColor:[UIColor clearColor]];

    NSLayoutConstraint *trailing =[NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.f];

    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.f];

    NSLayoutConstraint *bottom =[NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.f];

    NSLayoutConstraint *top =[NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.f];

    [self.contentView addConstraint:trailing];
    [self.contentView addConstraint:bottom];
    [self.contentView addConstraint:leading];
    [self.contentView addConstraint:top];
}

#pragma - mark IBActions

- (IBAction)linkMpHandler:(id)sender {
    [self showHud];
    @weakify(self);
    [TCCSharedMasterpassRequestModel linkCardToClient:^(MfsResponse *responseObject) {
        if(responseObject.result){
            [TCCSharedMasterpassModel reloadMpDataWithCompletion:^(id responseObject, NSString *errorStr) {
                @strongify(self);
                [self hideHud];
                SuccesViewController *vc = [SuccesViewController new];
                vc.currentType = StatusViewTypeAddCardRegister;
                vc.succesActionType = StatusViewSuccesActionRootTabBar;
                [self.navigationController pushViewController:vc animated:YES];
            }];
        } else {
            @strongify(self);
            [self hideHud];
            if([[(MfsResponse *)responseObject errorCode] isEqualToString:@"5001"] || [[(MfsResponse *)responseObject errorCode] isEqualToString:@"5007"]){
                VcodeViewController *vc = [VcodeViewController new];
                vc.tokenString = [(MfsResponse *)responseObject token];
                vc.currentType = VcodeTypeLinkAccount;
                [vc closeButtonSetupRight:NO];

                UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:vc];
                [self.tccTabbarViewController presentViewController:nc animated:YES completion:nil];
            } else {
                [UIAlertController showAlertInViewController:self withTitle:@"" message:[(MfsResponse *)responseObject errorDescription] cancelButtonTitle:@"Ок" destructiveButtonTitle:nil otherButtonTitles:nil textFieldPlaceholders:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                }];
            }
        }
    }];
}

- (IBAction)createMpHandler:(id)sender {
    CardDataMpViewController *vc = [CardDataMpViewController new];
    [vc closeButtonSetupRight:NO];
    UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:vc];
    [self.tccTabbarViewController presentViewController:nc animated:YES completion:nil];
}

- (IBAction)howWorkHandler:(id)sender {
    HowWorkViewController *vc = [HowWorkViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)buyTicketHandler:(id)sender {
    QuantityViewController *vc = [QuantityViewController new];
    UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:vc];
    [self.tccTabbarViewController presentViewController:nc animated:YES completion:nil];
}

- (void)isInternetConnection: (BOOL) isConnect {
    [self.ticketsCountLabel setAlpha:(isConnect)?1:0.5];
    [self.buyButton setEnabled:(isConnect)?YES:NO];

    self.noConnectionHeightConstraint.priority = (isConnect)?900:1;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)helpQrHandler {
    HelpListViewController *vc = [HelpListViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark iCarousel methods

- (void)tryNextHandler {
    if (self.carousel.currentItemIndex+1 >= self.carousel.numberOfItems) {
        [self.carousel scrollToItemAtIndex:0 duration:0.3];
    } else {
        [self.carousel scrollToItemAtIndex:self.carousel.currentItemIndex+1 duration:0.3];
    }
}

- (void)configCarousel {
    self.carousel.type = iCarouselTypeLinear;
    self.carousel.pagingEnabled = YES;

    self.icarouselItemWidth = [UIScreen mainScreen].bounds.size.width * 0.8;
    self.icarouselItemHeight = self.icarouselItemWidth*1.05;

    [self.ticketsCountLabel setText:[NSString stringWithFormat:@"%lu %@",(unsigned long)self.ticketsArray.count, [self ticketsString:(int)self.ticketsArray.count]]];

    [self.carousel reloadData];
    [self.view layoutIfNeeded];
}

- (NSString*)ticketsString:(int)number{
    if (number < 0) {
        number = number*-1;
    }
    NSArray *data = @[@"квиток",@"квитка",@"квитків"];
    NSArray *_case = @[@2, @0, @1, @1, @1, @2];
    return data[(number%100 > 4 && number%100 < 20)?2:[_case[((number%10 < 5)?number%10:5)] intValue]];
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return self.ticketsArray.count;
}

- (void)configDateFormatters {
    self.expireDateFormatter = [[NSDateFormatter alloc] init];
    [self.expireDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    NSLocale *locale = [[NSLocale alloc]
                        initWithLocaleIdentifier:@"uk_UA"];
    [self.expireDateFormatter setLocale:locale];
    [self.expireDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    self.expireFinalDateFormatter = [[NSDateFormatter alloc] init];
    [self.expireFinalDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [self.expireFinalDateFormatter setLocale:locale];
    [self.expireFinalDateFormatter setDateFormat:@"d MMMM"];
}

- (NSString *)checkExpireDate: (NSString *)expireDateString {
    NSDate *expireDate = [self.expireDateFormatter dateFromString:expireDateString];

//    NSLog(@"%@",expireDate);
//    NSLog(@"%@",[[NSDate date] dateByAddingTimeInterval:60*60*24*30*2]);
//    NSLog(@"%@",[[NSDate date] dateByAddingTimeInterval:60*60*24*1]);

    if([expireDate compare: [[NSDate date] dateByAddingTimeInterval:60*60*24*30*2]] == NSOrderedAscending)  {
        NSString *expireString = [NSString stringWithFormat:@"Термін дії квитка закінчиться %@",[self.expireFinalDateFormatter stringFromDate:expireDate]];
        if([expireDate compare: [[NSDate date] dateByAddingTimeInterval:60*60*24*30*2]] == NSOrderedAscending)  {
            expireString = [NSString stringWithFormat:@"Термін дії квитка закінчиться %@. Залишилось менше 2 місяців.",[self.expireFinalDateFormatter stringFromDate:expireDate]];
        }

        if([expireDate compare: [[NSDate date] dateByAddingTimeInterval:60*60*24*30*1]] == NSOrderedAscending)  {
            expireString = [NSString stringWithFormat:@"Термін дії квитка закінчиться %@. Залишилось менше 1 місяця.",[self.expireFinalDateFormatter stringFromDate:expireDate]];
        }

        if ([expireDate compare: [[NSDate date] dateByAddingTimeInterval:60*60*24*5]] == NSOrderedAscending) {
            expireString = [NSString stringWithFormat:@"Термін дії квитка закінчиться %@. Залишилось менше 5 днів.",[self.expireFinalDateFormatter stringFromDate:expireDate]];
        }

        if ([expireDate compare: [[NSDate date] dateByAddingTimeInterval:60*60*24*1]] == NSOrderedAscending) {
            expireString = [NSString stringWithFormat:@"Термін дії квитка закінчиться %@. Залишилось менше 1 дня.",[self.expireFinalDateFormatter stringFromDate:expireDate]];
        }
        return expireString;
    } else {
        return nil;
    }
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    CarouselItemView *carouselView = (CarouselItemView *)view;

    if (view == nil) {
        carouselView = [[CarouselItemView alloc]initWithFrame:CGRectMake(0, 0, self.icarouselItemWidth,self.icarouselItemHeight)];
        [carouselView setFrame:CGRectMake(0, 0, self.icarouselItemWidth, self.icarouselItemHeight)];
        view = carouselView;
        carouselView.delegate = (id)self;
    }

    if (self.ticketsArray.count > 0) {
        Tickets *currentTicket = self.ticketsArray[index];

        NSString *expireString = [self checkExpireDate:currentTicket.expire_time];

        if (expireString) {
            [carouselView.expireLabel setText:expireString];
            [carouselView.expireLabel setTextAlignment:NSTextAlignmentLeft];
            [carouselView.expireLabel setFont:[UIFont fontWithName:@"ProbaNav2-Regular" size:11]];

            [carouselView.helpButton setHidden:YES];
            [carouselView.simpleLabel setHidden:YES];
            [carouselView.warningImageView setHidden:NO];
            [carouselView.expireLabel setHidden:NO];
        } else {
            [carouselView.helpButton setHidden:NO];
            [carouselView.simpleLabel setHidden:NO];
            [carouselView.warningImageView setHidden:YES];
            [carouselView.expireLabel setHidden:YES];
        }

        UIImage *qrImage = [UIImage mdQRCodeForString:currentTicket.qr_code size:carouselView.qrImageView.bounds.size.height];
        [carouselView.qrImageView setImage:qrImage];
        carouselView.receiptIdString = currentTicket.receipt_id;
    }



    return view;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    switch (option) {
        case iCarouselOptionWrap: {
            return NO;
        }
        case iCarouselOptionSpacing: {
            return 1.05;
        }
        case iCarouselOptionTilt: {
            return 0;
        }

        default: {
            return value;
        }
            break;
    }
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {

}

- (void)reachabilityDidChange:(NSNotification *)notification {
    [self isInternetConnection:[(Reachability *)[notification object] isReachable]];
}


@end
