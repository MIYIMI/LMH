//
//  kata_OrderManageViewController.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-6-24.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "ViewPagerController.h"
#import "KTNavigationController.h"

@interface kata_OrderManageViewController : ViewPagerController

@property (nonatomic)           NSUInteger                      pageIndex;
@property (nonatomic, strong)   KTNavigationController      *   navigationController;
@property (nonatomic) NSInteger orderType;

- (id)initIndex:(NSInteger)index andType:(NSInteger)type;
@end
