//
//  category_selectView.h
//  YingMeiHui
//
//  Created by Zhumingming on 15-4-16.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeVO.h"

@protocol Category_selectViewDelegate <NSObject>

- (void)fiter:(NSDictionary *)fiter;

@end

@interface Category_selectView : UIView <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, strong) UITableView *tableview;
@property(nonatomic, strong) NSArray *fitArray;
@property(nonatomic, strong) id<Category_selectViewDelegate> delegate;

@end
