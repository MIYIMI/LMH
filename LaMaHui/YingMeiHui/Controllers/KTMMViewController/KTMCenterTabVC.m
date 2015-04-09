//
//  KTMCenterTabVC.m
//  YingMeiHui
//
//  Created by KevinKong on 14-9-12.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTMCenterTabVC.h"

#import "kata_ShopCartViewController.h" // 购物车
#import "kata_MyViewController.h" // 个人中心.
#import "KTNavigationController.h"
#import "KTChannelViewController.h"
#import "kata_CartManager.h"
#import "kata_UserManager.h"
#import "CategoryDetailVC.h"
#import "KTChannelViewController.h"
#import "LMH_CategoryViewController.h"

@interface KTMCenterTabVC()<UITabBarControllerDelegate,LoginDelegate>
{
    kata_MyViewController *myInfoVC;
    kata_ShopCartViewController *shopCartVC;
    LMH_CategoryViewController *categoryVC;
    CategoryDetailVC *lmhVC;
    
    KTNavigationController *myInfoNAVC;
    KTNavigationController *shopCartNAVC;
    KTNavigationController *categoryNAVC;
    KTNavigationController *lmhNAVC;
    
    // Item Dict.
    NSMutableArray *barItemPropertyArray;
    NSInteger selectTabIndex;
    
}
@end

@implementation KTMCenterTabVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(id)init{
    if (self = [super init]) {
        self.delegate = self;
        selectTabIndex = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 
#pragma mark public methods
-(void)selectedVCWithIndex:(NSInteger)index{

}

#pragma mark - 
#pragma mark init Params
-(void)initTabbarItemVC{
    if (categoryVC==nil) {
        categoryVC = [[LMH_CategoryViewController alloc] initWithNibName:nil bundle:nil];
        categoryVC.is_root = YES;
    }
    if (myInfoVC==nil) {
        myInfoVC = [[kata_MyViewController alloc] initWithIsRoot:YES];
    }
    if (shopCartVC == nil) {
        shopCartVC = [[kata_ShopCartViewController alloc] initWithStyle:UITableViewStylePlain];
    }
    if (lmhVC == nil) {
        lmhVC = [[CategoryDetailVC alloc] initWithAdvData:nil andFlag:@"get_special_list"];
    }
    
    if (!categoryNAVC) {
        categoryNAVC = [[KTNavigationController alloc] initWithRootViewController:categoryVC];
        categoryVC.navigationController = categoryNAVC;
    }
    if (!myInfoNAVC) {
        myInfoNAVC = [[KTNavigationController alloc] initWithRootViewController:myInfoVC];
        myInfoVC.navigationController = myInfoNAVC;
    }
    if (!shopCartNAVC) {
        shopCartNAVC = [[KTNavigationController alloc] initWithRootViewController:shopCartVC];
        shopCartVC.navigationController = shopCartNAVC;
        shopCartVC.isRoot=YES;
    }
    if (!lmhNAVC) {
        lmhNAVC = [[KTNavigationController alloc]initWithRootViewController:lmhVC];
        lmhVC.navigationController = lmhNAVC;
        lmhVC.is_root = YES;
        lmhVC.ifShowBtnHigher = YES;
    }
}

#pragma mark -
#pragma mark overwrite super methods
-(void)setViewControllers:(NSArray *)viewControllers{
    [self initTabbarItemVC];
    [self initBottomBaritemPropertys];
    
    NSMutableArray *newVCArray = [NSMutableArray arrayWithArray:viewControllers];
    [newVCArray addObject:lmhNAVC];
    [newVCArray addObject:categoryNAVC];
    [newVCArray addObject:shopCartNAVC];
    [newVCArray addObject:myInfoNAVC];
    [super setViewControllers:newVCArray];
    
    UITabBar *tabBar = self.tabBar;
    NSInteger idx = 0;
    double currentVersion = CurrentOSVersion;
    for (UITabBarItem *item in tabBar.items) {
        item.title = [self getBarItemTitleWithIndex:idx];
        UIImage *selectedImage = [UIImage imageNamed:[self getBarItemImageNameWithIndex:idx withSelected:YES]];
        UIImage *normalImage = [UIImage imageNamed:[self getBarItemImageNameWithIndex:idx withSelected:NO]];

        if (currentVersion>7.0) {
            item.selectedImage =  [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            item.image = normalImage;
        }else{
            if (currentVersion>6.0) {
             [item setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:normalImage];
            }
        }
        [item setTitleTextAttributes:[self getTitleAttributeDictWithIndex:idx withSelected:NO] forState:UIControlStateNormal];
        [item setTitleTextAttributes:[self getTitleAttributeDictWithIndex:idx withSelected:YES] forState:UIControlStateSelected];
        idx++;
    }
    
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:3];
    
    NSNumber *countValue = [[kata_CartManager sharedCartManager] cartCounter];
    if ([countValue intValue]>0) {
        [tabBarItem3 setBadgeValue:[[[kata_CartManager sharedCartManager] cartCounter] stringValue]];
    }else{
        [tabBarItem3 setBadgeValue:0];
    }

    UITabBarItem *tabBarItem4 = [tabBar.items objectAtIndex:4];
    //未支付订单数量更新
    NSNumber *wntValue = [[kata_UserManager sharedUserManager] userWaitPayCnt];
    if ([wntValue intValue]>0) {
        [tabBarItem4 setBadgeValue:[[[kata_UserManager sharedUserManager] userWaitPayCnt] stringValue]];
    }else{
        [tabBarItem4 setBadgeValue:0];
    }
    
    UIImage *bottomBgImage = [UIImage imageNamed:@"MainBottomBarBg.png"];
    UIImage *newBottomBgImage = [bottomBgImage stretchableImageWithLeftCapWidth:0 topCapHeight:10];
    [tabBar setBackgroundImage:newBottomBgImage];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage new]];
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
}

#pragma mark - 
#pragma mark UITabBarControllerDelegate methods
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if ([viewController isKindOfClass:[KTNavigationController class]]) {
        [(KTNavigationController *)viewController popToRootViewControllerAnimated:YES];
    }
    
    NSArray *viewControllers =[viewController childViewControllers];
    for (UIViewController *vc in viewControllers) {
        if ([vc isKindOfClass:[KTChannelViewController class]]) {
            [(KTChannelViewController *)vc selectedTabIndex:0];
        }
    }
    
    if (tabBarController.selectedIndex == 3) {
        UITabBarItem *tabBarItem3 = [tabBarController.tabBar.items objectAtIndex:3];
        
        NSNumber *countValue = [[kata_CartManager sharedCartManager] cartCounter];
        if ([countValue intValue]>0) {
            [tabBarItem3 setBadgeValue:[[[kata_CartManager sharedCartManager] cartCounter] stringValue]];
        }else{
            [tabBarItem3 setBadgeValue:0];
        }
    }else if (tabBarController.selectedIndex == 4) {
        UITabBarItem *tabBarItem4 = [tabBarController.tabBar.items objectAtIndex:4];
        //未支付订单数量更新
        NSNumber *wntValue = [[kata_UserManager sharedUserManager] userWaitPayCnt];
        if ([wntValue intValue]>0) {
            [tabBarItem4 setBadgeValue:[[[kata_UserManager sharedUserManager] userWaitPayCnt] stringValue]];
        }else{
            [tabBarItem4 setBadgeValue:0];
        }
    }
}

- (void)tabBarController:(UITabBarController *)tabBarController willBeginCustomizingViewControllers:(NSArray *)viewControllers{

}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    BOOL isLogin = [[kata_UserManager sharedUserManager] isLogin];
    if (isLogin) {
        return YES;
    }else{
        NSArray *viewControllers =[viewController childViewControllers];
        BOOL isHaveMyVC = NO;
        for (UIViewController *vc in viewControllers) {
            if ([vc isKindOfClass:[kata_MyViewController class]]) {
                isHaveMyVC = YES;
                selectTabIndex = 4;
                [[tabBarController.tabBar.items objectAtIndex:4] setBadgeValue:0];
            }
//            else if ([vc isKindOfClass:[kata_ShopCartViewController class]]){
//                isHaveMyVC = YES;
//                selectTabIndex = 3;
//            }
        }
        
        if (isHaveMyVC) {
            [kata_LoginViewController showInViewController:self];
            return NO;
        }
        return YES;
    }
    
    return YES;
}


#pragma mark - 
#pragma mark 
- (void)didLogin{
    [self setSelectedIndex:selectTabIndex];
}

-(void)loginCancel{

}
#pragma mark - 
#pragma mark Bar item property get/set methods
#define BottomBarItemImageName_Normal @"imageName_normal"
#define BottomBarItemImageName_Selected @"imageName_selected"
#define BottomBarItemTitle @"item_title"
#define BottomBarItemTitleDict_Normal @"title_normal"
#define BottomBarItemTitleDict_Selected @"title_selected"
-(void)initBottomBaritemPropertys{
    if (!barItemPropertyArray) {
        barItemPropertyArray = [NSMutableArray array];
        
        /**/
        NSDictionary* attrs = @{UITextAttributeTextColor:[UIColor grayColor],
                                UITextAttributeFont:[UIFont boldSystemFontOfSize:11]};
        
        NSDictionary* attrsSelected = @{UITextAttributeTextColor:UIColorRGBA(245,58,98,1),
                                        UITextAttributeFont:[UIFont boldSystemFontOfSize:11]};
        for (NSInteger i=0; i<5; i++) {
            NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
            [dict1 setObject:[NSString stringWithFormat:@"BarItemNormal%zi.png",i+1] forKey:BottomBarItemImageName_Normal];
            [dict1 setObject:[NSString stringWithFormat:@"BarItemSelected%zi.png",i+1] forKey:BottomBarItemImageName_Selected];
            [dict1 setObject:attrs forKey:BottomBarItemTitleDict_Normal];
            [dict1 setObject:attrsSelected forKey:BottomBarItemTitleDict_Selected];
            NSString *title=@"";
            switch (i) {
                case 0:
                    title = @"首页";
                    break;
                case 1:
                    title = @"汇特卖";
                    break;
                case 2:
                    title = @"分类";
                    break;
                case 3:
                    title = @"购物车";
                    break;
                case 4:
                    title = @"我的";
                    break;
                default:
                    break;
            }
            [dict1 setObject:title forKey:BottomBarItemTitle];
            [barItemPropertyArray addObject:dict1];
        }
    }
}

-(NSDictionary *)getBarItemPropertyDictWithIndex:(NSInteger)index{
    if (barItemPropertyArray) {
        if (index<barItemPropertyArray.count) {
            NSDictionary *dict = [barItemPropertyArray objectAtIndex:index];
            return dict;
        }
    }
    return nil;
}

-(NSString *)getBarItemImageNameWithIndex:(NSInteger )index withSelected:(BOOL)selected{
    NSDictionary *dict = [self getBarItemPropertyDictWithIndex:index];
    if (selected) {
        return [dict objectForKey:BottomBarItemImageName_Selected];
    }else{
        return [dict objectForKey:BottomBarItemImageName_Normal];
    }
    return nil;
}

-(NSString *)getBarItemTitleWithIndex:(NSInteger)index{
    NSDictionary *dict = [self getBarItemPropertyDictWithIndex:index];
    if (dict) {
        return [dict objectForKey:BottomBarItemTitle];
    }
    return nil;
}

-(NSDictionary *)getTitleAttributeDictWithIndex:(NSInteger)index withSelected:(BOOL)selected{
    NSDictionary *dict = [self getBarItemPropertyDictWithIndex:index];
    if (selected) {
        return [dict objectForKey:BottomBarItemTitleDict_Selected];
    }else{
        return [dict objectForKey:BottomBarItemTitleDict_Normal];
    }
    return nil;
}
@end
