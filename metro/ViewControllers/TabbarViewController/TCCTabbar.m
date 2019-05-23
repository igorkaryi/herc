//
//  TCCTabbar.m
//  Tachcard
//
//  Created by Yaroslav Bulda on 6/12/15.
//  Copyright (c) 2015 Tachcard. All rights reserved.
//

#import "TCCTabbar.h"

@interface TCCTabbar ()

@property (nonatomic, strong) UIView *topSeparatorView;
//@property (nonatomic, strong) NSArray *separators;

@end

@implementation TCCTabbar

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
    self.backgroundColor = UIColorFromRGB(0xFFFFFF);
    
    _topSeparatorView = [UIView new];
    _topSeparatorView.backgroundColor = [UIColor clearColor];

    _separatoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width/5, 2)]; //4
    _separatoView.backgroundColor = UIColorFromRGB(0x0585E5);

    //[_topSeparatorView addSubview:_separatoView];

    [self addSubview:_topSeparatorView];
}

- (void)layoutSubviews {
    self.topSeparatorView.frame = (CGRect){0.f, 0.f, self.frameWidth, 2.0f};
    
    CGFloat itemWidth = self.frameWidth / (float)(self.items.count);
    
    NSInteger index = 0;
    
    // Layout items
    
    for (TCCTabbarItem *item in self.items) {
        [item setFrame:CGRectMake(index * itemWidth, 0, itemWidth, self.frameHeight)];
        [item setNeedsDisplay];
        index++;
    }
    
    //[self bringSubviewToFront:self.topSeparatorView];
}

#pragma mark - Configuration

- (void)setItems:(NSArray *)items {
    [_items makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
//    [self.separators makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    self.separators = nil;
    
    _items = [items copy];
    for (TCCTabbarItem *item in _items) {
        [item addTarget:self action:@selector(tabBarItemWasSelected:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:item];
    }
    
//    NSMutableArray *separators = [NSMutableArray arrayWithCapacity:_items.count - 3];
//    for (NSInteger idx = 0; idx < (_items.count-2); idx++) {
//        UIView *separator = [UIView new];
//        separator.backgroundColor = self.topSeparatorView.backgroundColor;
//        [self addSubview:separator];
//        [separators addObject:separator];
//    }
//    
//    self.separators = separators.copy;
}

- (void)setHeight:(CGFloat)height {
    [self setFrame:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame),
                              CGRectGetWidth(self.frame), height)];
}

#pragma mark - Item selection

- (void)tabBarItemWasSelected:(id)sender {
    if ([[self delegate] respondsToSelector:@selector(tabBar:shouldSelectItemAtIndex:)]) {
        NSInteger index = [self.items indexOfObject:sender];
        if (![[self delegate] tabBar:self shouldSelectItemAtIndex:index]) {
            return;
        }
    }
    
    [self setSelectedItem:sender];
    
    if ([[self delegate] respondsToSelector:@selector(tabBar:didSelectItemAtIndex:)]) {
        NSInteger index = [self.items indexOfObject:self.selectedItem];
        [[self delegate] tabBar:self didSelectItemAtIndex:index];
    }
}

- (void)setSelectedItem:(TCCTabbarItem *)selectedItem {
    if (selectedItem == _selectedItem) {
        return;
    }

    [self moveSelector:selectedItem.frame.origin.x];

    [_selectedItem setSelected:NO];
    
    _selectedItem = selectedItem;
    [_selectedItem setSelected:YES];
}

- (void)moveSelector: (float)xPosition {
    [UIView animateWithDuration:0.3 animations:^{
        [_separatoView setFrameX:xPosition];
    }];
}

- (void)setIndicatorAtIndex:(NSInteger)idx hidden:(BOOL)hidden {
    TCCTabbarItem *item = self.items[idx];
    [item setIndicatorHidden:hidden];
}

- (void)highlightTabAtIndex:(NSInteger)idx {
    [self setIndicatorAtIndex:idx hidden:NO];
    TCCTabbarItem *item = self.items[idx];
    if (item != self.selectedItem) {
        [item highlight];
    }
}

@end
