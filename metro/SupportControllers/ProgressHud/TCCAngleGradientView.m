//
//  TCCAngleGradientView.m
//  Tachcard
//
//  Created by Yaroslav Bulda on 6/11/15.
//  Copyright (c) 2015 Tachcard. All rights reserved.
//

#import "TCCAngleGradientView.h"
#import "TCCAngleGradientLayer.h"

@implementation TCCAngleGradientView

+ (Class)layerClass {
    return [TCCAngleGradientLayer class];
}

- (id)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    self.backgroundColor = UIColor.clearColor;
    
    TCCAngleGradientLayer *l = (TCCAngleGradientLayer *)self.layer;
    l.colors = @[
                (id)mainColour.CGColor,
                (id)[UIColor clearColor].CGColor,
                (id)[UIColor clearColor].CGColor
                ];
    l.locations = @[@0.f, @0.75f, @1.f];
    
    return self;
}

#pragma mark -
#pragma mark Props

- (void)setColors:(NSArray *)colors {
    TCCAngleGradientLayer *l = (TCCAngleGradientLayer *)self.layer;
    l.colors = colors;
}

- (void)setLocations:(NSArray *)locations {
    TCCAngleGradientLayer *l = (TCCAngleGradientLayer *)self.layer;
    l.locations = locations;
}

@end
