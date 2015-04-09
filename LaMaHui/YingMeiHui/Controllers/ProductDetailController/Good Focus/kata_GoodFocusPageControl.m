//
//  kata_GoodFocusPageControl.m
//  SanDing
//
//  Created by 林 程宇 on 13-6-7.
//  Copyright (c) 2013年 Codeoem. All rights reserved.
//

#import "kata_GoodFocusPageControl.h"
#import "KATACheckUtils.h"

#define DOT_WIDTH 13

@implementation kata_GoodFocusPageControl
@synthesize imagePageStateNormal = _imagePageStateNormal;
@synthesize imagePageStateHighlighted = _imagePageStateHighlighted;

- (void)setFocusPageControlDelegate:(id<KATAFocusPageControlDelegate>)focusPageControlDelegate
{
    [super setFocusPageControlDelegate:focusPageControlDelegate];
    
    if (!self.imagePageStateNormal) {
        self.imagePageStateNormal = [UIImage imageNamed:@"images_slides"];
    }
    
    if (!self.imagePageStateHighlighted) {
        self.imagePageStateHighlighted = [UIImage imageNamed:@"images_slides_active"];
    }
    self.backgroundColor = [UIColor clearColor];
    
    //  Init background
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    //    bgView.backgroundColor = [UIColor colorWithPatternImage:<#(UIImage *)#>]
    bgView.backgroundColor = [UIColor clearColor];
    if ([KATACheckUtils isOS4]) {
        bgView.alpha = 0.5;
    }
    
    [self addSubview:bgView];
    
    //  Init dots
    NSMutableArray *itemViews = [[NSMutableArray alloc] initWithCapacity:kNumbOfControls];
    CGFloat itemWidth = DOT_WIDTH;
    CGFloat itemHeight = self.frame.size.height;
    CGFloat xOffset = (self.frame.size.width - itemWidth *kNumbOfControls) / 2;
    for (NSUInteger i = 0; i < kNumbOfControls; i++) {
        UIImageView *itemView = [[UIImageView alloc] initWithImage:self.imagePageStateNormal];
        itemView.frame = CGRectMake(i * itemWidth + xOffset, 0, itemWidth, itemHeight);
        itemView.contentMode = UIViewContentModeCenter;
        [self addSubview:itemView];
        [itemViews addObject:itemView];
    }
    self.views = itemViews;
    
    [self updateState];
}

- (void)updateState
{
    for (NSInteger i = 0; i < kNumbOfControls; i++) {
        UIImageView *itemView = (UIImageView *)[self.views objectAtIndex:i];
        if (i != kCurrentPage) {
            itemView.image = self.imagePageStateNormal;
        }
        else {
            itemView.image = self.imagePageStateHighlighted;
        }
    }
}

@end
