//
//  KTNavigationController.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-3-28.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface KTNavigationController : UINavigationController<UINavigationControllerDelegate>

@property (nonatomic) BOOL ifPopToRootView;
@property (nonatomic) BOOL ifPopToOrderView;
@property (nonatomic) BOOL ifRootLeftButton;
@property (nonatomic) BOOL ifPaySucess;

- (void)addLeftBarButtonItem:(UIBarButtonItem *)item animation:(BOOL)animation;
- (void)addRightBarButtonItem:(UIBarButtonItem *)item animation:(BOOL)animation;
//- (void)operationTabHidden:(BOOL)isHidden;

@end
