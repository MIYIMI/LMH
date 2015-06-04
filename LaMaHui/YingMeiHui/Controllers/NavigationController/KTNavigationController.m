//
//  KTNavigationController.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-3-28.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTNavigationController.h"
#import "kata_MyViewController.h"
#import "kata_ProductListViewController.h"
#import "kata_AllOrderListViewController.h"

//#define MAIN_NAV_BG_NAME @"nav_bg"
#define MAIN_NAV_BG_NAME @"nav_bg_white"

@interface KTNavigationController ()

- (UIBarButtonItem *)createBackBarButonItem;

- (void)popSelf;

@end

@implementation KTNavigationController

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        NSDictionary* attrs = @{UITextAttributeTextColor:RGB(69, 69, 69),
                                UITextAttributeTextShadowColor:[UIColor clearColor],
                                UITextAttributeFont:[UIFont boldSystemFontOfSize:18]};
        [self.navigationBar setTitleTextAttributes:attrs];
        
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:MAIN_NAV_BG_NAME] forBarMetrics:UIBarMetricsDefault];
//        [self.navigationBar setShadowImage:[[UIImage alloc] init]];
        
        self.navigationController.navigationBar.translucent = NO;
        self.delegate = self;
        _ifPopToRootView = NO;
        _ifPopToOrderView = NO;
        _ifRootLeftButton = NO;
        _ifPaySucess = NO;
        
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - 自定义返回按钮
- (void)popSelf
{
    if (_ifPaySucess) {
        NSArray *vcArray = [self childViewControllers];
        UIViewController *vc = vcArray[vcArray.count-3];
        [self popToViewController:vc animated:YES];
        _ifPaySucess = NO;
        return;
    }
    if (_ifPopToOrderView) {
        kata_AllOrderListViewController *orderListVC = [[kata_AllOrderListViewController alloc] initWithOrderType:@"nopay"];
        orderListVC.navigationController = self;
        self.ifPopToOrderView = NO;
        _ifPopToRootView = YES;
        orderListVC.hidesBottomBarWhenPushed = YES;
        [self pushViewController:orderListVC animated:YES];
        
        return;
    }
    if (_ifPopToRootView) {
        _ifPopToRootView = NO;
        [self popToRootViewControllerAnimated:YES];
    } else {
        [self popViewControllerAnimated:YES];
    }
}

- (UIBarButtonItem *)createBackBarButonItem
{
    if (_ifRootLeftButton) {
        UIButton * backBarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 27)];
        [backBarButton setImage:[UIImage imageNamed:@"icon_goback_gray"] forState:UIControlStateNormal];
        [backBarButton setImage:[UIImage imageNamed:@"icon_goback_gray"] forState:UIControlStateHighlighted];
        
        UIBarButtonItem * backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBarButton];
        backBarButtonItem.style = UIBarButtonItemStylePlain;
        
        return backBarButtonItem;
    }else{
        UIButton * backBarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 27)];
        [backBarButton setImage:[UIImage imageNamed:@"icon_goback_gray"] forState:UIControlStateNormal];
        [backBarButton setImage:[UIImage imageNamed:@"icon_goback_gray"] forState:UIControlStateHighlighted];
        
        [backBarButton addTarget:self action:@selector(popSelf) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem * backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBarButton];
        backBarButtonItem.style = UIBarButtonItemStylePlain;
        
        return backBarButtonItem;
    }
    return nil;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
    
    [viewController didMoveToParentViewController:self];
    
    if (viewController.navigationItem.leftBarButtonItem == nil && [self.viewControllers count] > 1) {
        [viewController.navigationItem setLeftBarButtonItem:[self createBackBarButonItem] animated:NO];
    }
    [self operationTabHidden:YES];
}

-(UIViewController *)popViewControllerAnimated:(BOOL)animated{
    [self operationTabHidden:NO];
    return  [super popViewControllerAnimated:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    //每次当navigation中的界面切换，设为空。本次赋值只在程序初始化时执行一次
    static UIViewController *lastController = nil;
    
    //若上个view不为空
    if (lastController != nil)
    {
        //若该实例实现了viewWillDisappear方法，则调用
        if ([lastController respondsToSelector:@selector(viewWillDisappear:)])
        {
            [lastController viewWillDisappear:animated];
        }
    }
    
    //将当前要显示的view设置为lastController，在下次view切换调用本方法时，会执行viewWillDisappear
    lastController = viewController;
    
    [viewController viewWillAppear:animated];
}

//- (void)setTitle:(NSString *)title{
//    self.title = title;
//}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark 添加按钮
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)addLeftBarButtonItem:(UIBarButtonItem *)item animation:(BOOL)animation
{
    UINavigationItem * navItem = self.topViewController.navigationItem;
    [navItem setLeftBarButtonItem:item animated:animation];
    
//    NSArray * items = [navItem leftBarButtonItems];
//    
//    if (item && items && [items count]) {
//        items = [items arrayByAddingObject:item];
//        [navItem setLeftBarButtonItems:items animated:animation];
//    }else{
//        [navItem setLeftBarButtonItem:item animated:animation];
//    }
}

- (void)addRightBarButtonItem:(UIBarButtonItem *)item animation:(BOOL)animation
{
    UINavigationItem * navItem = self.topViewController.navigationItem;
    
//    NSArray * items = [navItem rightBarButtonItems];

    [navItem setRightBarButtonItem:item animated:animation];
    
//    if (item && items && [items count]) {
//        items = [items arrayByAddingObject:item];
//        [navItem setRightBarButtonItems:items animated:animation];
//    }else{
    
//        [navItem setRightBarButtonItem:item animated:animation];
//    }
}

#if LMH_Main_Page_Update_logic
-(void)showTabBar{
    UITabBar *tabBar = self.tabBarController.tabBar;
    [UIView animateWithDuration:0
                     animations:^{
                         
                         CGRect tabFrame = tabBar.frame;
                         tabFrame.origin.x = CGRectGetWidth(tabFrame) + CGRectGetMinX(tabFrame);
                         tabFrame.origin.x= tabFrame.origin.x >=ScreenW ? 0 : tabFrame.origin.x;
                         tabBar.frame = tabFrame;
                         tabBar.hidden=NO;
                         
//                         CGFloat currentVerson = CurrentOSVersion;
//                         if (currentVerson>=6.0 && currentVerson<7.0) {
//                             for (UIView *itemV in self.tabBarController.view.subviews) {
//                                 if (![itemV isKindOfClass:[UITabBar class]]) {
//                                     CGRect itemFrame = itemV.frame;
//                                     itemFrame.size.height-=UITabBarHeight;
//                                     itemV.frame = itemFrame;
//                                 }
//                                 
//                             }
//                         }

                         

                     }];

}

-(void)hiddenTabBar{

        UITabBar *tabBar = self.tabBarController.tabBar;
        [UIView animateWithDuration:0.1
                         animations:^{
                             CGRect tabFrame = tabBar.frame;
                             tabFrame.origin.x = 0 - tabFrame.size.width;
                             tabFrame.origin.x = tabFrame.origin.x < 0-tabFrame.size.width ? 0-tabFrame.size.width:tabFrame.origin.x;
                             tabBar.frame = tabFrame;

//                             CGFloat currentVerson = CurrentOSVersion;
//                             if (currentVerson>=6.0 && currentVerson<7.0) {
//                                 for (UIView *itemV in self.tabBarController.view.subviews) {
//                                     if (![itemV isKindOfClass:[UITabBar class]]) {
//                                         CGRect itemFrame = itemV.frame;
//                                         itemFrame.size.height+=UITabBarHeight;
//                                         itemV.frame = itemFrame;
//                                     }
//
//                                 }
//                             }
                         }];
}


- (void)operationTabHidden:(BOOL)isHidden{
    return;
    if (isHidden) {
        [self hiddenTabBar];
    }else{
        [self showTabBar];
    }
}

#endif

@end
