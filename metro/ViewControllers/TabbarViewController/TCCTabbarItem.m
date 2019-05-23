//
//  TCCTabBarItem.m
//  Tachcard
//
//  Created by Yaroslav Bulda on 6/12/15.
//  Copyright (c) 2015 Tachcard. All rights reserved.
//

#import "TCCTabbarItem.h"
#import "UIImageView+ImageColour.h"

@interface TCCTabbarItem ()

@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) UIImage *unselectedImage;

@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) UIColor *unSelectedColor;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *indicatorView;

@end

@implementation TCCTabbarItem

#pragma mark -
#pragma mark Lifecycle methods

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInitialization];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInitialization];
    }
    return self;
}

- (id)init {
    return [self initWithFrame:CGRectZero];
}

- (void)commonInitialization {
    // Setup defaults

    [self setBackgroundColor:[UIColor clearColor]];
    
    _imagePositionAdjustment = UIOffsetZero;
    _iconImageView = [UIImageView new];

    [self addSubview:_iconImageView];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont fontWithName:@"ProbaNav2-Regular" size:10];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.iconImageView setContentMode:UIViewContentModeCenter];

    if (self.iconImageView.tag != 10) {
        self.iconImageView.frameWidth = 30;
        self.iconImageView.frameHeight = 30;
    } else {
        
    }

    
    self.iconImageView.frameX = self.bounds.size.width/2.f - self.iconImageView.frameWidth/2.f;
    //self.iconImageView.frameY = 3.5f;
    self.iconImageView.frameY = (self.iconImageView.tag == 10)?-44.5:4.5f;
    
    self.titleLabel.frameY = 35.5f;
    self.titleLabel.frameX = 5.f;
    self.titleLabel.frameWidth = self.frameWidth - 10.f;
    self.titleLabel.frameHeight = 12.f;
//    self.iconImageView.frameY = self.bounds.size.height/2.f - self.iconImageView.frameHeight/2.f;
}

#pragma mark -
#pragma mark Manage

- (void)setSelectedImageName:(NSString *)selImageName andUnSelectedImageName:(NSString *)unSelImageName {

    self.selectedImage = [UIImage imageNamed:selImageName];
    self.unselectedImage = [UIImage imageNamed:unSelImageName];
    
    self.iconImageView.image = self.unselectedImage;
    [self.iconImageView sizeToFit];
}

- (void)setTitle:(NSString *)title selectedColor:(UIColor *)selcolor andUnSelectedColor:(UIColor *)unselcolor {
    self.titleLabel.text = title;
    self.titleLabel.textColor = unselcolor;
    
    self.selectedColor = mainColour;
    self.unSelectedColor = unselcolor;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.iconImageView.image = selected ? self.selectedImage : self.unselectedImage;
    self.titleLabel.textColor = selected ? self.selectedColor : self.unSelectedColor;
}

- (void)highlight {
    self.iconImageView.tintColor = UIColorFromRGB(0xF0E01C);
}

- (void)setIndicatorHidden:(BOOL)hidden {
    if (!self.indicatorView && !hidden) {
        self.indicatorView = [[UIView alloc] initWithFrame:CGRectMake(self.iconImageView.frameX + self.iconImageView.frameWidth/2.f - 9.f/2.f, self.iconImageView.frameY + self.iconImageView.frameHeight + 5.f, 9.f, 2.f)];
        self.indicatorView.backgroundColor = UIColorFromRGB(0xF0E01C);
        [self addSubview:self.indicatorView];
    }
    self.indicatorView.hidden = hidden;
}

@end
