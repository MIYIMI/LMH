//
//  kata_AllOrderListViewController.h
//  YingMeiHui
//
//  Created by work on 14-11-26.
//  Copyright (c) 2014年 xieyanke. All rights reserved.
//

#import "FTStatefulTableViewController.h"

@interface kata_AllOrderListViewController : FTStatefulTableViewController

- (id)initWithOrderType:(NSString *)ordertype;
@property(nonatomic, strong)UITabBarController *mytabController;

@end
