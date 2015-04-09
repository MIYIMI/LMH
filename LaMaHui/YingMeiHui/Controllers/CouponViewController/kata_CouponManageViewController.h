//
//  kata_CouponManageViewController.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-17.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ViewPagerController.h"
#import "KTNavigationController.h"

@interface kata_CouponManageViewController : ViewPagerController

@property (nonatomic)           NSUInteger                      pageIndex;
@property (nonatomic, strong)   KTNavigationController      *   navigationController;

@end
