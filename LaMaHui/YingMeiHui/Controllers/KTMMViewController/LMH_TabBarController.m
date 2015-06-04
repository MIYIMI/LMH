//
//  LMH_TabBarController.m
//  LaMaHui
//
//  Created by 米翊米 on 15/4/8.
//  Copyright (c) 2015年 米翊米. All rights reserved.
//

#import "LMH_TabBarController.h"
#import "KTNavigationController.h"
#import "CategoryDetailVC.h"    //商品列表页
#import "LMH_CategoryViewController.h"  //分类页
#import "kata_ShopCartViewController.h" // 购物车
#import "kata_MyViewController.h" // 个人中心.
#import "kata_CartManager.h"    //购物车管理
#import "kata_UserManager.h"    //用户信息管理

@interface LMH_TabBarController ()<LoginDelegate,UITabBarControllerDelegate>
{
    NSMutableArray *tabArray;
    NSInteger selectIndex;
}

@end

@implementation LMH_TabBarController

/**
 *  初始化tabBar
 */
- (id)initWithFisrtVC:(id)firstVC{
    self = [super init];
    if (self) {
        self.delegate = self;
        //汇特卖
        CategoryDetailVC *secVC = [[CategoryDetailVC alloc] initWithAdvData:nil andFlag:@"get_special_list"];
        secVC.is_root = YES;
        secVC.ifShowBtnHigher = YES;
        KTNavigationController *navigation2 = [[KTNavigationController alloc] initWithRootViewController:secVC];
        secVC.navigationController = navigation2;
        
        //分类
        LMH_CategoryViewController *threeVC = [[LMH_CategoryViewController alloc] initWithNibName:nil bundle:nil];
        threeVC.is_root = YES;
        KTNavigationController *navigation3 = [[KTNavigationController alloc] initWithRootViewController:threeVC];
        threeVC.navigationController = navigation3;
        
        //购物车
        kata_ShopCartViewController *fourVC = [[kata_ShopCartViewController alloc] initWithStyle:UITableViewStylePlain];
        fourVC.isRoot=YES;
        KTNavigationController *navigation4 = [[KTNavigationController alloc] initWithRootViewController:fourVC];
        fourVC.navigationController = navigation4;
        
        //个人中心
        kata_MyViewController *fiveVC = [[kata_MyViewController alloc] initWithIsRoot:YES];
        KTNavigationController *navigation5 = [[KTNavigationController alloc] initWithRootViewController:fiveVC];
        fiveVC.navigationController = navigation5;
        
        //视图加入TabBar组
        tabArray = [NSMutableArray arrayWithObjects:firstVC, navigation2, navigation3, navigation4, navigation5, nil];
        [super setViewControllers:tabArray];
        
        //设置TabBar图文
        [self initTabBarItem];
        
        //移除tabBar顶部阴影和黑线
//        [self.tabBar setClipsToBounds:YES];
        //移除阴影
        [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
        
        for (int i = 0; i < self.tabBar.items.count; i++) {
            UITabBarItem *tabBarItem = self.tabBar.items[i];
            if (i == 3) {
                //购物车数量显示
                NSNumber *countValue = [[kata_CartManager sharedCartManager] cartCounter];
                if ([countValue intValue]>0) {
                    [tabBarItem setBadgeValue:[[[kata_CartManager sharedCartManager] cartCounter] stringValue]];
                }else{
                    [tabBarItem setBadgeValue:0];
                }
            }else if (i == 4) {
                //未支付订单数量显示
                NSNumber *wntValue = [[kata_UserManager sharedUserManager] userWaitPayCnt];
                if ([wntValue intValue]>0) {
                    [tabBarItem setBadgeValue:[[[kata_UserManager sharedUserManager] userWaitPayCnt] stringValue]];
                }else{
                    [tabBarItem setBadgeValue:0];
                }
            }
        }
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  设置TabBar图文
 */
#pragma mark - 设置TabBar图文
- (void)initTabBarItem{
    UITabBar *tabBar = self.tabBar;
    
    //TabBar的文字
    NSArray *titleArray = [NSArray arrayWithObjects:@"首页", @"汇特卖", @"分类", @"购物车", @"我的", nil];
    for (int i = 0; i < tabBar.items.count; i ++) {
        UITabBarItem *unitItem = tabBar.items[i];
        
        //设置TabBar文字
        unitItem.title = titleArray[i];
        
        //设置默认时字体颜色
        NSDictionary *attrs = @{UITextAttributeTextColor:[UIColor grayColor], UITextAttributeFont:LMH_FONT_11};
        [unitItem setTitleTextAttributes:attrs forState:UIControlStateNormal];
        
        //设置被选中时的字体颜色
        attrs = @{UITextAttributeTextColor:LMH_COLOR_SKIN, UITextAttributeFont:LMH_FONT_11};
        [unitItem setTitleTextAttributes:attrs forState:UIControlStateSelected];
        
        //设置默认图片
        NSString *imgStr = [NSString stringWithFormat:@"BarItemNormal%d",i+1];
        UIImage *barImage = [LOCAL_IMG(imgStr) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        unitItem.image = barImage;
        
        //设置选中时的图片
        imgStr = [NSString stringWithFormat:@"BarItemSelected%d",i+1];
        barImage = [LOCAL_IMG(imgStr) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        unitItem.selectedImage = barImage;
    }
}

#pragma mark UITabBarControllerDelegate 点击事件
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    //被点击的tab选项回到根视图
    [(KTNavigationController *)viewController popToRootViewControllerAnimated:YES];
    selectIndex = tabBarController.selectedIndex;
}

#pragma mark UITabBarControllerDelegate 点击事件
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    BOOL isLogin = [[kata_UserManager sharedUserManager] isLogin];
    
    //点击个人中心判断是否登录
    NSArray *viewControllers =[viewController childViewControllers];
    for (UIViewController *vc in viewControllers) {
        if ([vc isKindOfClass:[kata_MyViewController class]] && !isLogin) {
            [kata_LoginViewController showInViewController:self];
            selectIndex = 4;
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - 登陆回调
- (void)didLogin{
    [self setSelectedIndex:selectIndex];
}

-(void)loginCancel{
    
}

@end
