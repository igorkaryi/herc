//
//  AppDelegate.m
//  metro
//
//  Created by admin on 4/12/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "AppDelegate.h"
#import "LoaderViewController.h"
#import "RLMRealm+Setup.h"
#import "Reachability.h"

@interface AppDelegate ()
@property (nonatomic, retain) Reachability *reachability;
@end

@implementation AppDelegate


-(void)showAllFonts{
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];

    NSArray *fontNames;
    NSInteger indFamily, indFont;
    for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
    {
        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
        fontNames = [[NSArray alloc] initWithArray:
                     [UIFont fontNamesForFamilyName:
                      [familyNames objectAtIndex:indFamily]]];
        for (indFont=0; indFont<[fontNames count]; ++indFont)
        {
            NSLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);
        }
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [[UIApplication sharedApplication] registerForRemoteNotifications];
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];



    [RLMRealm tcc_setupDefaultRealm];
    [self showAllFonts];
    [self setupBaseAppearance];
    [self reachabilitySetup];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:[LoaderViewController new]];
    self.window.rootViewController = nc;

    [self.window makeKeyAndVisible];

    return YES;
}

- (void)reachabilitySetup {
    self.reachability = [Reachability reachabilityWithHostname:@"www.google.com"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityDidChange:) name:kReachabilityChangedNotification object:nil];
    [self.reachability startNotifier];
}

- (void)reachabilityDidChange:(NSNotification *)notification {
    if ([(Reachability *)[notification object] isReachable]) {
        //NSLog(@"Reachable");
    } else {
        //NSLog(@"Unreachable");
    }
}

#pragma mark -
#pragma mark Appearance

- (void)setupBaseAppearance {
    [[UITextField appearance] setTintColor:mainColour];

    [[UINavigationBar appearance] setBackgroundImage:[UIImage add_resizableImageWithColor:[UIColor clearColor]]
                                      forBarPosition:UIBarPositionAny
                                          barMetrics:UIBarMetricsDefault];

    [[UINavigationBar appearance] setShadowImage:[UIImage add_resizableImageWithColor:[UIColor clearColor]]];
    [[UINavigationBar appearance] setTintColor:UIColorFromRGB(0x24AC66)];

    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    UIImage *arrow = [UIImage imageNamed:@"backBtnIcon"];

    CGFloat offset = 8.f;
    CGSize size = CGSizeMake(arrow.size.width + offset, arrow.size.height + 4.f);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [arrow drawInRect:CGRectMake(offset, 4.f, arrow.size.width, arrow.size.height)];
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    [[UINavigationBar appearance] setBackIndicatorImage:finalImage];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:finalImage];

    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    //    if ([UITableView instancesRespondToSelector:@selector(setLayoutMargins:)]) {
    //        [[UITableView appearance] setLayoutMargins:UIEdgeInsetsZero];
    //        [[UITableViewCell appearance] setLayoutMargins:UIEdgeInsetsZero];
    //        [[UITableViewCell appearance] setPreservesSuperviewLayoutMargins:NO];
    //    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {

}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",[UIScreen mainScreen].brightness] forKey:@"screenBrightness"];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
