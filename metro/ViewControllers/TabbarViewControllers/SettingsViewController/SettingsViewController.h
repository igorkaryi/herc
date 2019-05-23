//
//  SettingsViewController.h
//  metro
//
//  Created by admin on 4/23/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : BaseViewController

typedef NS_ENUM(NSUInteger, SettingsCellType) {
    SettingsCellPhone = 0,
    SettingsCellPin,
    SettingsCellTouch,
    SettingsCellLang,
    SettingsCellTicketsLast,
    SettingsCellTicketsDate,
    SettingsCellAboutUs,
    SettingsCellHelp,
    SettingsCellResponse,
    SettingsCellLogout
};

@end
