    //
//  TCCTabbarViewController.m
//  Tachcard
//
//  Created by Yaroslav Bulda on 6/12/15.
//  Copyright (c) 2015 Tachcard. All rights reserved.
//

#import "TCCTabbarViewController.h"

#import "UIImage+Additions.h"

#import "TicketsViewController.h"
#import "CardsViewController.h"
#import "HistoryViewController.h"
#import "SettingsViewController.h"
#import "UIScreen+Brightness.h"

@interface TCCTabbarViewController () <TCCTabBarDelegate>

@property (nonatomic, strong) TCCTabbar *tabBar;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIViewController *modalController;

@property (nonatomic) BOOL appered;
@property (nonatomic, retain) UIView *badgeView;
@end

@implementation TCCTabbarViewController

#pragma mark -
#pragma mark Lifecycle methods

- (void)viewDidLoad {
    [super viewDidLoad];

    UINavigationController *ticketsNc = [TicketsViewController viewControllerInNavigation];
    UINavigationController *cardsNc = [CardsViewController viewControllerInNavigation];
    UINavigationController *historyNc = [HistoryViewController viewControllerInNavigation];
    UINavigationController *profileNc = [SettingsViewController viewControllerInNavigation];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(succesPin) name:@"successEnterPin" object:nil];

    self.viewControllers = @[ticketsNc, cardsNc, profileNc]; //historyNc, 
    
    NSArray *tabBarItemImages = @[@"tabTicket", @"tabCard", @"tabProfile"]; //@"tabHistory",
    NSArray *tabBarItemTitles = @[@"Квитки", @"Картки", @"Профіль"]; //@"Історія",
    
    UIColor *selectedColor = mainColour;
    UIColor *unSelectedColor = UIColorFromRGB(0x686D77);

    self.badgeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 14, 14)];
    [self.badgeView setBackgroundColor:UIColorFromRGB(0xFFF)];
    [self.badgeView.layer setCornerRadius:7];

    UILabel *badgeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 14, 14)];
    [badgeLabel setTextColor:[UIColor whiteColor]];
    [badgeLabel setText:[NSString stringWithFormat:@"%ld",(long)[UIApplication sharedApplication].applicationIconBadgeNumber]];
    [badgeLabel setTextAlignment:NSTextAlignmentCenter];
    [badgeLabel setFont:[UIFont fontWithName:@"ProbaNav2-Regular" size:10]];
    [self.badgeView addSubview:badgeLabel];

    NSInteger index = 0;
    for (TCCTabbarItem *item in [self.tabBar items]) {
        NSString *slImgName = [NSString stringWithFormat:@"%@Sel", [tabBarItemImages objectAtIndex:index]];
        NSString *unSlImgName = [NSString stringWithFormat:@"%@", [tabBarItemImages objectAtIndex:index]];
        [item setTitle:tabBarItemTitles[index] selectedColor:selectedColor andUnSelectedColor:unSelectedColor];
        [item setSelectedImageName:slImgName andUnSelectedImageName:unSlImgName];


        if ([slImgName isEqualToString:@"historySLTabIcon"]) {
            [self.badgeView removeFromSuperview];
            if ([UIApplication sharedApplication].applicationIconBadgeNumber >0) {
                [self.badgeView setFrame:CGRectMake((([UIScreen mainScreen].bounds.size.width/3)/2)+4, item.frame.size.height/2+4, 14, 14)];
                [item addSubview:self.badgeView];
            }
        }

        index++;
    }

    [self.contentView setBackgroundColor:[UIColor redColor]];
    [self.view setBackgroundColor:[UIColor yellowColor]];

    [self.view addSubview:self.contentView];
    [self.view addSubview:self.tabBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setSelectedIndex:[self selectedIndex]];
    [self setTabBarHidden:self.isTabBarHidden animated:NO];
    
    self.appered = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    //[self preferredStatusBarStyle];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //[self preferredStatusBarStyle];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    switch ([self selectedIndex]) {
        case 2: {
            
            return UIStatusBarStyleLightContent;
        }
            break;
        default:
            return UIStatusBarStyleDefault;
            break;
    }
}

- (void)succesPin {
    switch ([self selectedIndex]) {
        case 0:
            break;
        case 1:
            break;
        case 2:
            break;
        case 3:
            break;

        default:
            break;
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    UIInterfaceOrientationMask orientationMask = UIInterfaceOrientationMaskAll;
    for (UIViewController *viewController in [self viewControllers]) {
        if (![viewController respondsToSelector:@selector(supportedInterfaceOrientations)]) {
            return UIInterfaceOrientationMaskPortrait;
        }
        
        UIInterfaceOrientationMask supportedOrientations = [viewController supportedInterfaceOrientations];
        
        if (orientationMask > supportedOrientations) {
            orientationMask = supportedOrientations;
        }
    }
    
    return orientationMask;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    for (UIViewController *viewCotroller in [self viewControllers]) {
        if (![viewCotroller respondsToSelector:@selector(shouldAutorotateToInterfaceOrientation:)] ||
            ![viewCotroller shouldAutorotateToInterfaceOrientation:toInterfaceOrientation]) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - Methods

- (UIViewController *)selectedViewController {
    return [[self viewControllers] objectAtIndex:[self selectedIndex]];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    if (selectedIndex >= self.viewControllers.count) {
        return;
    }

    [self setNeedsStatusBarAppearanceUpdate];

    switch (selectedIndex) {
        case 0: {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"tabTicketWillApper" object:self];
        }

            break;
        case 1: {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"tabCardWillApper" object:self];
        }

            break;
        case 2: {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"tabHistoryWillApper" object:self];
        }
            break;
        case 3: {

        }

            break;

        default:
            break;
    }


    if ([self selectedViewController]) {
        //[[self selectedViewController] willMoveToParentViewController:nil];
        //[[[self selectedViewController] view] removeFromSuperview];
        //[[self selectedViewController] removeFromParentViewController];
    }

    if (selectedIndex == 0) {
        [UIScreen mainScreen].animatedBrightness = 1;
    } else {
        [UIScreen mainScreen].animatedBrightness = [[NewString anyStringByReplacingOccurrencesOfString:@"," withString:@"." inString:[[NSUserDefaults standardUserDefaults]objectForKey:@"screenBrightness"]]floatValue];
    }
    
    _selectedIndex = selectedIndex;
    [[self tabBar] setSelectedItem:[[self tabBar] items][selectedIndex]];
    
    [self setSelectedViewController:[[self viewControllers] objectAtIndex:selectedIndex]];
    [self addChildViewController:[self selectedViewController]];
    [[[self selectedViewController] view] setFrame:[[self contentView] bounds]];
    [[self contentView] addSubview:[[self selectedViewController] view]];
    [[self selectedViewController] didMoveToParentViewController:self];

    if (selectedIndex == 1) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"historyWillApper" object:self];
        });

        [self.badgeView removeFromSuperview];
    }

    [self setNeedsStatusBarAppearanceUpdate];
}


- (void)setViewControllers:(NSArray *)viewControllers {
    if (_viewControllers && _viewControllers.count) {
        for (UIViewController *viewController in _viewControllers) {
            [viewController willMoveToParentViewController:nil];
            [viewController.view removeFromSuperview];
            [viewController removeFromParentViewController];
        }
    }
    
    if (viewControllers && [viewControllers isKindOfClass:[NSArray class]]) {
        _viewControllers = [viewControllers copy];
        
        NSMutableArray *tabBarItems = [[NSMutableArray alloc] init];
        
        for (NSInteger idx = 0; idx < viewControllers.count; idx++) {
            TCCTabbarItem *tabBarItem = [[TCCTabbarItem alloc] init];
            [tabBarItems addObject:tabBarItem];
        }
        
        [[self tabBar] setItems:tabBarItems];
    } else {
        _viewControllers = nil;
    }
}

- (NSInteger)indexForViewController:(UIViewController *)viewController {
    UIViewController *searchedController = viewController;
    if ([searchedController navigationController]) {
        searchedController = [searchedController navigationController];
    }
    return [[self viewControllers] indexOfObject:searchedController];
}

- (TCCTabbar *)tabBar {
    if (!_tabBar) {
        _tabBar = [[TCCTabbar alloc] init];
        [_tabBar setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|
                                      UIViewAutoresizingFlexibleTopMargin|
                                      UIViewAutoresizingFlexibleLeftMargin|
                                      UIViewAutoresizingFlexibleRightMargin|
                                      UIViewAutoresizingFlexibleBottomMargin)];
        [_tabBar setDelegate:self];
    }
    return _tabBar;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        [_contentView setBackgroundColor:[UIColor redColor]];
        [_contentView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|
                                           UIViewAutoresizingFlexibleHeight)];
    }
    return _contentView;
}

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated {
    _tabBarHidden = hidden;
    
    __weak TCCTabbarViewController *weakSelf = self;
    
    void (^block)(void) = ^{
        CGSize viewSize = weakSelf.view.bounds.size;
        CGFloat tabBarStartingY = viewSize.height;
        CGFloat contentViewHeight = viewSize.height;
        CGFloat tabBarHeight = (52+(([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone && [[UIScreen mainScreen] nativeBounds].size.height == 2436)?34:0));
        
        if (!hidden) {
            tabBarStartingY = viewSize.height - tabBarHeight;
            [[weakSelf tabBar] setHidden:NO];
        }
        
        [[weakSelf tabBar] setFrame:CGRectMake(0, tabBarStartingY, viewSize.width, tabBarHeight)];
        [[weakSelf contentView] setFrame:CGRectMake(0, 0, viewSize.width, contentViewHeight-tabBarHeight)];
    };
    
    void (^completion)(BOOL) = ^(BOOL finished) {
        if (hidden) {
            [[weakSelf tabBar] setHidden:YES];
        }
    };
    
    if (animated) {
        [UIView animateWithDuration:0.25f animations:block completion:completion];
    } else {
        block();
        completion(YES);
    }
}

- (void)setTabBarHidden:(BOOL)hidden {
    [self setTabBarHidden:hidden animated:NO];
}

- (void)setIndicatorAtIndex:(NSInteger)idx hidden:(BOOL)hidden {
    [self.tabBar setIndicatorAtIndex:idx hidden:hidden];
}

- (void)highlightTabAtIndex:(NSInteger)idx {
    [self.tabBar highlightTabAtIndex:idx];
}

#pragma mark -
#pragma mark Modal

- (void)showTopViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    [self addChildViewController:viewControllerToPresent];
    
    [viewControllerToPresent beginAppearanceTransition:YES animated:flag];
    
    [self.view addSubview:viewControllerToPresent.view];
    viewControllerToPresent.view.frame = self.view.bounds;
    viewControllerToPresent.view.autoresizingMask = UIViewAutoresizingMaskAll;
    
    self.modalController = viewControllerToPresent;
    
    if (flag) {
        viewControllerToPresent.view.frameY = self.view.frameHeight;
        
        [UIView animateWithDuration:0.35f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            viewControllerToPresent.view.frameY = 0.f;
        } completion:^(BOOL finished) {
            if (completion) {
                completion();
            }
            [viewControllerToPresent endAppearanceTransition];
            [viewControllerToPresent didMoveToParentViewController:self];
        }];
    } else {
        if (completion) {
            completion();
        }
        [viewControllerToPresent endAppearanceTransition];
        [viewControllerToPresent didMoveToParentViewController:self];
    }
}
//
- (void)dismissTopViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    [self.modalController willMoveToParentViewController:nil];
    
    [self.modalController beginAppearanceTransition:NO animated:flag];
    if (flag) {
        [UIView animateWithDuration:0.35f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.modalController.view.frameY = self.view.frameHeight;
        } completion:^(BOOL finished) {
            [self.modalController.view removeFromSuperview];
            [self.modalController endAppearanceTransition];
            [self.modalController removeFromParentViewController];
            self.modalController = nil;
            if (completion) {
                completion();
            }
        }];
    } else {
        [self.modalController.view removeFromSuperview];
        [self.modalController endAppearanceTransition];
        [self.modalController removeFromParentViewController];
        self.modalController = nil;
        if (completion) {
            completion();
        }
    }
}

#pragma mark - TPTabBarDelegate

- (BOOL)tabBar:(TCCTabbar *)tabBar shouldSelectItemAtIndex:(NSInteger)index {
    switch (index) {
        default: {
            if ([self selectedViewController] == [self viewControllers][index]) {
                if ([[self selectedViewController] isKindOfClass:[UINavigationController class]]) {
                    UINavigationController *selectedController = (UINavigationController *)[self selectedViewController];

                    if ([selectedController topViewController] != [selectedController viewControllers][0]) {
                        [selectedController popToRootViewControllerAnimated:YES];
                    }
                }

                return NO;
            }
            return YES;
        }
            break;
    }
}

- (void)tabBar:(TCCTabbar *)tabBar didSelectItemAtIndex:(NSInteger)index {
    if (index < 0 || index >= [[self viewControllers] count]) {
        return;
    }
    
    [self setSelectedIndex:index];
}

@end
