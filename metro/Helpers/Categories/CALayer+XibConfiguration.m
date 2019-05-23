//
//  CALayer+XibConfiguration.m
//  TachcardTerminal
//
//  Created by Evgen on 1/13/16.
//  Copyright © 2016 Tachcard. All rights reserved.
//

#import "CALayer+XibConfiguration.h"

@implementation CALayer(XibConfiguration)

-(void)setBorderUIColor:(UIColor*)color {
    self.borderColor = color.CGColor;
}

-(UIColor*)borderUIColor {
    return [UIColor colorWithCGColor:self.borderColor];
}

@end