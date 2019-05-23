//
//  TCCAngleGradientLayer.h
//  Tachcard
//
//  Created by Yaroslav Bulda on 6/11/15.
//  Copyright (c) 2015 Tachcard. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface TCCAngleGradientLayer : CALayer

@property(copy) NSArray *colors;

/* An optional array of NSNumber objects defining the location of each
 * gradient stop as a value in the range [0,1]. The values must be
 * monotonically increasing. If a nil array is given, the stops are
 * assumed to spread uniformly across the [0,1] range. When rendered,
 * the colors are mapped to the output colorspace before being
 * interpolated. Defaults to nil. */

@property(copy) NSArray *locations;

@end
