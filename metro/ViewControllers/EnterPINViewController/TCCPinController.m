  //
//  TCCPinViewController.m
//  Tachcard
//
//  Created by Yaroslav Bulda on 18/11/15.
//  Copyright © 2015 Tachcard. All rights reserved.
//

#import "TCCPinController.h"
#import "GCDSingleton.h"
#import "TCCAccount+Manage.h"

#import "TCCEnterPINViewController.h"

@interface TCCPinController () <TCCEnterPINViewControllerDelegete>

@property (nonatomic) NSTimeInterval startTimerTime;


@property (nonatomic, strong) TCCEnterPINViewController *pinVC;

@end

@implementation TCCPinController

#pragma mark -
#pragma mark Constant defination

static NSTimeInterval TCCPinShowingDelay = 0.f;

#pragma mark -
#pragma mark Class methods

+ (void)setup {
    [self sharedInstance];
}

#pragma mark -
#pragma mark Singletone

+ (instancetype)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        instance = [self new];
        return instance;
    });
}

static TCCPinController *instance = nil;

+(TCCPinController*)sharedInstanse{
    if (!instance) {
        instance = [TCCPinController new];
    }
    return instance;
}

#pragma mark -
#pragma mark Lifecycle methods

- (instancetype)init {
    self = [super init];
    [self addObservers];
    if (self) {
        _pinVC = [TCCEnterPINViewController new];
        _pinVC.view.autoresizingMask = UIViewAutoresizingMaskAll;
        _pinVC.delegate = self;
        
        [self showPinVC];
    }
    return self;
}

#pragma mark -
#pragma mark Helpers

- (void)addObservers {
    NSNotificationCenter *defCenter = [NSNotificationCenter defaultCenter];
    [defCenter addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [defCenter addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (BOOL)didPasscodeTimerEnd {
    NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
    NSDictionary *pinTimerData = ([[NSUserDefaults standardUserDefaults]objectForKey:@"pinTimerValue"])?[[NSUserDefaults standardUserDefaults]objectForKey:@"pinTimerValue"]:@{@"id":@(0),@"text":LS(@"Immediately"),@"value":@(0)};

    TCCPinShowingDelay = [pinTimerData[@"value"]doubleValue];

    NSInteger interval = [self stringFromTimeInterval:now - self.startTimerTime];

    if (interval >= TCCPinShowingDelay) {
        return YES;
    }
    return NO;
}

- (NSInteger)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    return hours*3600 + minutes*60 + seconds;
}

- (void)showPinVC {
    if (!TCCAccount.object.isAuthorized) {
        return;
    }
    if (!TCCAccount.object.settings.pinEnabled) {
        return;
    }
    self.isCurrentlyOnScreen = YES;
    [self.pinVC show];
}


#pragma mark -
#pragma mark UIApplication Events

- (void)applicationWillResignActive {
    if (self.isCurrentlyOnScreen) {
        return;
    }
    self.startTimerTime = [NSDate timeIntervalSinceReferenceDate];
}

- (void)applicationWillEnterForeground {
    if (self.isCurrentlyOnScreen) {
        return;
    }
    
    if ([self didPasscodeTimerEnd]) {
        [self showPinVC];
    }
}

#pragma mark -
#pragma mark TCCEnterPINViewControllerDelegete

- (void)enterPINViewControllerDidEnterPIN:(TCCEnterPINViewController *)pinVC {
    self.isCurrentlyOnScreen = NO;
    [pinVC hide];
}

- (void)logOut {
    self.isCurrentlyOnScreen = NO;
    [_pinVC hide];
}

- (BOOL)currentlyOnScreen {
    return self.isCurrentlyOnScreen;
}
@end
