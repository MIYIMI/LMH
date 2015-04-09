//
//  CategoryMainVC.h
//  YingMeiHui
//
//  Created by KevinKong on 14-9-12.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewPagerController.h"
#import "KTNavigationController.h"

@interface CategoryMainVC : ViewPagerController
@property (nonatomic)           NSUInteger                      pageIndex;
@property (nonatomic,strong) KTNavigationController *navigationController;

@end
