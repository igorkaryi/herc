//
//  SettingsCell.h
//  metro
//
//  Created by admin on 4/24/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "CornerCell.h"

@interface SettingsCell : CornerCell
@property (nonatomic, retain) IBOutlet UILabel *titleTextLabel;
@property (nonatomic, retain) IBOutlet UILabel *descTextLabel;
@property (nonatomic, retain) IBOutlet UIImageView *accesoryImageView;
@property (nonatomic, retain) IBOutlet UISwitch *switchView;
@end
