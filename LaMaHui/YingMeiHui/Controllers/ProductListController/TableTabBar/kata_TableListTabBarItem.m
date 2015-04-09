//
//  kata_TableListTabBarItem.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-3.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "kata_TableListTabBarItem.h"

@interface kata_TableListTabBarItem ()
{
    NSString *iconStr;
    NSString *iconSelectedStr;
}

@end

@implementation kata_TableListTabBarItem

- (id)initWithTitle:(NSString *)title icon:(NSString *)icon selectedIcon:(NSString *)selectIcon tag:(NSInteger)tag
{
    self = [super init];
    if (self) {
        iconStr = icon;
        iconSelectedStr = selectIcon;
        if (![iconStr isEqualToString:@""] && ![iconStr isEqualToString:@""]) {
            [self setTitle:title forState:UIControlStateNormal];
            [self setImage:[UIImage imageNamed:iconStr] forState:UIControlStateNormal];
            [self setImage:[UIImage imageNamed:iconSelectedStr] forState:UIControlStateSelected];
            [self setImage:[UIImage imageNamed:iconSelectedStr] forState:UIControlStateHighlighted];
        } else {
            [self setTitle:title forState:UIControlStateNormal];
        }
        self.tag = tag;
        
        [self setTitleColor:LMH_COLOR_BLACK forState:UIControlStateNormal];
        [self setTitleColor:LMH_COLOR_SKIN forState:UIControlStateSelected];
        [self setTitleColor:LMH_COLOR_SKIN forState:UIControlStateHighlighted];
        
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = self.frame;
    CGFloat w = frame.size.width;
    if (![iconStr isEqualToString:@""]) {
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, w/2+10, 0, 0)];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -w/3, 0, 0)];
    }else{
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, w/4, 0, w/4)];
    }
}

@end
