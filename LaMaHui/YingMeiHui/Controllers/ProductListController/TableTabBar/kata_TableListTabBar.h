//
//  kata_TableListTabBar.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-3.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TableListTabBarDelegate;

@interface kata_TableListTabBar : UITabBar
{
    UILabel *lineLbl;
}

@property (copy, nonatomic) NSArray *items;
@property (strong, nonatomic) NSDictionary *selectedTabItem;
@property (assign, nonatomic) id<TableListTabBarDelegate> tableListTabBarDelegate;

@end

@protocol TableListTabBarDelegate <NSObject>

- (void)didSelectedTabItem:(NSDictionary *)item;

@end
