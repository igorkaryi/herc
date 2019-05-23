//
//  CALayer+XibConfiguration.h
//  TachcardTerminal
//
//  Created by Evgen on 1/13/16.
//  Copyright © 2016 Tachcard. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CALayer(XibConfiguration)

// This assigns a CGColor to borderColor.
@property(nonatomic, assign) UIColor* borderUIColor;

@end