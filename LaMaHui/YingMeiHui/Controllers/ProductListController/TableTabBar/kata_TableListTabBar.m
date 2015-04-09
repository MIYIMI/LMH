//
//  kata_TableListTabBar.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-3.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "kata_TableListTabBar.h"
#import "kata_TableListTabBarItem.h"

@interface kata_TableListTabBarItem (/*private method*/)

- (void)selectTabWithClick:(id)sender;

@end

@implementation kata_TableListTabBar{
    NSInteger tabNum;
}

@synthesize items = __items;
@synthesize selectedTabItem = __selectedTabItem;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImage *bgImg = [[UIImage alloc] init];
        [self setBackgroundImage:bgImg];
        [self setShadowImage:bgImg];
        if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] == NSOrderedAscending) {
            [[UITabBar appearance] setSelectedImageTintColor:[UIColor colorWithRed:127.0/255.0 green:186.0/255.0 blue:235.0/255.0 alpha:1.0]];
            [[UITabBar appearance] setSelectionIndicatorImage:bgImg];
        }
        lineLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        [lineLbl setBackgroundColor:LMH_COLOR_SKIN];
        [self addSubview:lineLbl];
    }
    return self;
}

- (void)setItems:(NSArray *)aItems
{
    __items = aItems;
    NSUInteger count = [aItems count];
    CGFloat w = ceilf((CGRectGetWidth(self.frame)) / count);
    CGFloat h = CGRectGetHeight(self.frame);
    
    for (NSUInteger i = 0; i < count; i++) {
        NSDictionary *itemData = [aItems objectAtIndex:i];
        kata_TableListTabBarItem *item = [[kata_TableListTabBarItem alloc] initWithTitle:[itemData objectForKey:@"title"] icon:[itemData objectForKey:@"icon"] selectedIcon:[itemData objectForKey:@"selecticon"] tag:[[itemData objectForKey:@"tag"] integerValue]];
        [item addTarget:self action:@selector(selectTabWithClick:) forControlEvents:UIControlEventTouchUpInside];
        CGRect itemFrame = CGRectMake(i * w, 0, w, h);
        item.frame = itemFrame;
        if (tabNum<3) {
            [self addSubview:item];
            tabNum ++;
        }
    }
//    [self setSelectedTabItem:[self.items objectAtIndex:0]];
}

- (void)setSelectedTabItem:(NSDictionary *)aSelectedTabItem
{
    __selectedTabItem = aSelectedTabItem;
    NSUInteger selectedTag = [[aSelectedTabItem objectForKey:@"tag"] intValue];
    NSUInteger count = [self.items count];
    
    for (NSUInteger i = 0; i < count; i++) {
        NSUInteger itemTag = [[[self.items objectAtIndex:i] objectForKey:@"tag"] intValue];
        NSMutableDictionary *tempDict = [self.items objectAtIndex:i];
        if (itemTag != selectedTag) {
            [(kata_TableListTabBarItem *)[self viewWithTag:itemTag] setSelected:NO];
            [tempDict setObject:@"sort" forKey:@"status"];
            [[(kata_TableListTabBarItem *)[self viewWithTag:itemTag] imageView] setTransform:CGAffineTransformMakeRotation(0)];
        } else {
            [(kata_TableListTabBarItem *)[self viewWithTag:itemTag] setSelected:YES];
            if (![[tempDict objectForKey:@"sort"] isEqualToString:[tempDict objectForKey:@"sort_op"]]) {
                if ([[tempDict objectForKey:@"status"] isEqualToString:@"sort"]) {
                    [tempDict setObject:@"sort_op" forKey:@"status"];
                    [[(kata_TableListTabBarItem *)[self viewWithTag:itemTag] imageView] setTransform:CGAffineTransformMakeRotation(0)];
                } else {
                    [tempDict setObject:@"sort" forKey:@"status"];
                    [[(kata_TableListTabBarItem *)[self viewWithTag:itemTag] imageView] setTransform:CGAffineTransformMakeScale(1.0,-1.0)];
                }
            }
            
            kata_TableListTabBarItem *item = (kata_TableListTabBarItem *)[self viewWithTag:itemTag];
            
            CGRect frame = item.frame;
            frame.size.width = item.frame.size.width/2;
            frame.origin.x = item.frame.origin.x+(frame.size.width/2);
            frame.origin.y = item.frame.size.height - 2;
            frame.size.height = 2;
            lineLbl.frame = frame;
        }
    }
}

- (NSDictionary *)selectedTabItem
{
    return __selectedTabItem;
}

- (void)selectTabWithClick:(id)sender
{
    NSUInteger selectedTag = [(kata_TableListTabBarItem *)sender tag];
    NSUInteger count = [self.items count];
    for (NSUInteger i = 0; i < count; i++) {
        NSDictionary *itemData = [self.items objectAtIndex:i];
        if ([[itemData objectForKey:@"tag"] intValue] == selectedTag) {
            [self setSelectedTabItem:itemData];
            
            if (self.tableListTabBarDelegate && [self.tableListTabBarDelegate respondsToSelector:@selector(didSelectedTabItem:)]) {
                [self.tableListTabBarDelegate didSelectedTabItem:itemData];
            }
            break;
        }
    }
}

@end
