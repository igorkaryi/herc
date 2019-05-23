#import "UIImageView+ImageColour.h"
#import "UIImage+Additions.h"

@implementation UIImageView (ImageColour)
@dynamic mainImageUIColor;

- (void)setMainImageUIColor:(UIColor*)color {
    self.image = [self.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    //self.image = [self imageWithGradient:self.image startColor:UIColorFromRGB(0x3BB9EB) endColor:UIColorFromRGB(0x585AE6)];
    [self setTintColor:mainColour];//mainColour
}

- (UIImage *)imageWithGradient:(UIImage *)img startColor:(UIColor *)color1 endColor:(UIColor *)color2 {
    UIGraphicsBeginImageContextWithOptions(img.size, NO, img.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);

    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    //CGContextDrawImage(context, rect, img.CGImage);

    // Create gradient
    NSArray *colors = [NSArray arrayWithObjects:(id)color2.CGColor,(id)color1.CGColor, (id)color1.CGColor, nil];
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(space, (__bridge CFArrayRef)colors, NULL);

    // Apply gradient
    CGContextClipToMask(context, rect, img.CGImage);
    CGContextDrawLinearGradient(context, gradient,CGPointMake(img.size.width, 0) ,CGPointMake(0,img.size.height) , 11);
    UIImage *gradientImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    CGGradientRelease(gradient);
    CGColorSpaceRelease(space);

    return gradientImage;
}

- (void)setImageMainColour {
    [self setMainImageUIColor:[UIColor clearColor]];
}

@end
