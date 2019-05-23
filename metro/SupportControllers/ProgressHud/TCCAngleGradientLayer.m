//
//  TCCAngleGradientLayer.m
//  Tachcard
//
//  Created by Yaroslav Bulda on 6/11/15.
//  Copyright (c) 2015 Tachcard. All rights reserved.
//

#import "TCCAngleGradientLayer.h"

#if __has_feature(objc_arc)
#define BRIDGE_CAST(T) (__bridge T)
#else
#define BRIDGE_CAST(T) (T)
#endif

#define byte unsigned char
#define F2CC(x) ((byte)(255 * x))
#define RGBAF(r,g,b,a) (F2CC(r) << 24 | F2CC(g) << 16 | F2CC(b) << 8 | F2CC(a))
#define RGBA(r,g,b,a) ((byte)r << 24 | (byte)g << 16 | (byte)b << 8 | (byte)a)
#define RGBA_R(c) ((uint)c >> 24 & 255)
#define RGBA_G(c) ((uint)c >> 16 & 255)
#define RGBA_B(c) ((uint)c >> 8 & 255)
#define RGBA_A(c) ((uint)c >> 0 & 255)

@interface TCCAngleGradientLayer()

- (CGImageRef)newImageGradientInRect:(CGRect)rect;

@end


static void angleGradient(byte* data, int w, int h, int* colors, int colorCount, float* locations, int locationCount);


@implementation TCCAngleGradientLayer

- (id)init {
    if (!(self = [super init]))
        return nil;
    
    self.needsDisplayOnBoundsChange = YES;
    
    return self;
}

#if !__has_feature(objc_arc)
- (void)dealloc
{
    [_colors release];
    [_locations release];
    [super dealloc];
}
#endif

- (void)drawInContext:(CGContextRef)ctx
{
    CGContextSetFillColorWithColor(ctx, self.backgroundColor);
    CGRect rect = CGContextGetClipBoundingBox(ctx);
    CGContextFillRect(ctx, rect);
    
    CGImageRef img = [self newImageGradientInRect:rect];
    CGContextDrawImage(ctx, rect, img);
    CGImageRelease(img);
}

- (CGImageRef)newImageGradientInRect:(CGRect)rect
{
    int w = CGRectGetWidth(rect);
    int h = CGRectGetHeight(rect);
    int bitsPerComponent = 8;
    int bpp = 4 * bitsPerComponent / 8;
    int byteCount = w * h * bpp;
    
    int colorCount = (int)self.colors.count;
    int locationCount = 0;
    int* colors = NULL;
    float* locations = NULL;
    
    if (colorCount > 0) {
        colors = calloc(colorCount, bpp);
        int *p = colors;
        for (id cg in self.colors) {
            CGColorRef c = BRIDGE_CAST(CGColorRef)cg;
            float r, g, b, a;
            
            size_t n = CGColorGetNumberOfComponents(c);
            const CGFloat *comps = CGColorGetComponents(c);
            if (comps == NULL) {
                *p++ = 0;
                continue;
            }
            r = comps[0];
            if (n >= 4) {
                g = comps[1];
                b = comps[2];
                a = comps[3];
            }
            else {
                g = b = r;
                a = comps[1];
            }
            *p++ = RGBAF(r, g, b, a);
        }
    }
    if (self.locations.count > 0 && self.locations.count == colorCount) {
        locationCount = (int)self.locations.count;
        locations = calloc(locationCount, sizeof(locations[0]));
        float *p = locations;
        for (NSNumber *n in self.locations) {
            *p++ = [n floatValue];
        }
    }
    
    byte* data = malloc(byteCount);
    angleGradient(data, w, h, colors, colorCount, locations, locationCount);
    
    if (colors) free(colors);
    if (locations) free(locations);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Little;
    CGContextRef ctx = CGBitmapContextCreate(data, w, h, bitsPerComponent, w * bpp, colorSpace, bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    CGImageRef img = CGBitmapContextCreateImage(ctx);
    CGContextRelease(ctx);
    free(data);
    return img;
}

@end

static inline byte blerp(byte a, byte b, float w)
{
    return a + w * (b - a);
}
static inline int lerp(int a, int b, float w)
{
    return RGBA(blerp(RGBA_R(a), RGBA_R(b), w),
                blerp(RGBA_G(a), RGBA_G(b), w),
                blerp(RGBA_B(a), RGBA_B(b), w),
                blerp(RGBA_A(a), RGBA_A(b), w));
}
static inline int multiplyByAlpha(int c)
{
    float a = 1.f;
    return RGBA((byte)(RGBA_R(c) * a),
                (byte)(RGBA_G(c) * a),
                (byte)(RGBA_B(c) * a),
                RGBA_A(c));
}

void angleGradient(byte* data, int w, int h, int* colors, int colorCount, float* locations, int locationCount)
{
    if (colorCount < 1) return;
    if (locationCount > 0 && locationCount != colorCount) return;
    
    int* p = (int*)data;
    float centerX = (float)w / 2;
    float centerY = (float)h / 2;
    
    for (int y = 0; y < h; y++)
        for (int x = 0; x < w; x++) {
            float dirX = x - centerX;
            float dirY = y - centerY;
            float angle = atan2f(dirY, dirX);
            if (dirY < 0) angle += 2 * M_PI;
            angle /= 2 * M_PI;
            
            int index = 0, nextIndex = 0;
            float t = 0;
            
            if (locationCount > 0) {
                for (index = locationCount - 1; index >= 0; index--) {
                    if (angle >= locations[index]) {
                        break;
                    }
                }
                if (index >= locationCount) index = locationCount - 1;
                nextIndex = index + 1;
                if (nextIndex >= locationCount) nextIndex = locationCount - 1;
                float ld = locations[nextIndex] - locations[index];
                t = ld <= 0 ? 0 : (angle - locations[index]) / ld;
            }
            else {
                t = angle * (colorCount - 1);
                index = t;
                t -= index;
                nextIndex = index + 1;
                if (nextIndex >= colorCount) nextIndex = colorCount - 1;
            }
            
            int lc = colors[index];
            int rc = colors[nextIndex];
            int color = lerp(lc, rc, t);
            color = multiplyByAlpha(color);
            *p++ = color;
        }
}
