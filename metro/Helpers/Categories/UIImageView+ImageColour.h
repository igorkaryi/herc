#import <UIKit/UIKit.h>

@interface UIImageView (ImageColour)

- (void)setImageMainColour;
@property(nonatomic, assign) UIColor* mainImageUIColor;
- (UIImage *)imageWithGradient:(UIImage *)img startColor:(UIColor *)color1 endColor:(UIColor *)color2;

@end
