//
//  KTChannelViewController.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-3-28.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ViewPagerController.h"
#import "KTNavigationController.h"

@interface KTChannelViewController : ViewPagerController

@property (nonatomic)           NSUInteger                      pageIndex;
@property (nonatomic, strong)   KTNavigationController      *   navigationController;
@property (nonatomic, strong)   NSArray *menuArray;

- (id)initWithChannelInfo:(NSArray *)menuArr isFirst:(BOOL)isfirst andMessage:(NSString *)message;

@end
