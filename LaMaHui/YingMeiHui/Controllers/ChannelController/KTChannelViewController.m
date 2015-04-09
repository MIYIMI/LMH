//
//  KTChannelViewController.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-3-28.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTChannelViewController.h"
#import "MenuVO.h"
#import "kata_ProductListViewController.h"
#import "kata_SellSoonViewController.h"
#import "kata_CategoryViewController.h"
#import "kata_CartManager.h"
#import "kata_AppDelegate.h"
#import "CategoryDetailVC.h"
#import "LMH_Config.h"
#import "DMQRCodeViewController.h"

#import "KTNavigationController.h"
#import <Reachability/Reachability.h>

#import "LMH_CategoryViewController.h"

#define PAGER_TAB_WIDTH         70.0
#define PAGER_TAB_HEIGHT        35.0

@interface KTChannelViewController () <ViewPagerDataSource, ViewPagerDelegate,UIGestureRecognizerDelegate>
{
    NSArray *_channelArr;
    NSString *_message;
    BOOL _isFirst;
    UIBarButtonItem *_menuItem;
    UIBarButtonItem *rightMenuItem;
    NSMutableArray *_viewsArr;
    UIViewController *_rightVC;
    DMQRCodeViewController *QRCodeViewController;
}

@end

@implementation KTChannelViewController
@synthesize menuArray;

@synthesize navigationController;

- (id)initWithChannelInfo:(NSArray *)menuArr isFirst:(BOOL)isfirst andMessage:(NSString *)message
{
    self = [super init];
    if (self) {
        _channelArr = menuArr;
        _isFirst = isfirst;
        _message = message;
    }
    return self;
}

-(void)loadView{
    _viewsArr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < _channelArr.count; i++) {
        [_viewsArr addObject:@"EMPTY"];
    }
    [super loadView];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if ([[kata_CartManager sharedCartManager] isGoToHomePage]) {
        [[kata_CartManager sharedCartManager] setGoToHomePage:NO];
        [self selectedTabIndex:0];// add by kevin on 2014.08.26 pm 14:30
    }
}

- (void)viewDidLoad {

    self.dataSource = self;
    self.delegate = self;
    [self createUI];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (_isFirst) {
        UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"new_logo"]];
        [self.navigationItem setTitleView:logo];
    }
    
    // Keeps tab bar below navigation bar on iOS 7.0+
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [super viewDidLoad];
    
//    LMH_CategoryViewController *rightVC = [[LMH_CategoryViewController alloc] initWithNibName:nil bundle:nil];
//    rightVC.navigationController = self.navigationController;
//    rightVC.hidesBottomBarWhenPushed = YES;
//    [(kata_AppDelegate *)[[UIApplication sharedApplication] delegate] deckController].rightController = rightVC;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.hidesBottomBarWhenPushed = YES;
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.hidesBottomBarWhenPushed = NO;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI
{
    [self setupRightMenuButton];
    
    UIView *btnview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 20, 20)];
    [imageview setImage:[UIImage imageNamed:@"sao_icon"]];
    [btnview addSubview:imageview];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 40, 15)];
    lbl.backgroundColor = [UIColor clearColor];
    [lbl setText:@"扫一扫"];
    [lbl setTextColor:[UIColor whiteColor]];
    [lbl setFont:[UIFont systemFontOfSize:12.0]];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [btnview addSubview:lbl];
    
    
    UITapGestureRecognizer *tapClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanCode)];
    tapClick.numberOfTapsRequired = 1;
    [btnview addGestureRecognizer:tapClick];
    
    UIBarButtonItem *homeLeftBtn = [[UIBarButtonItem alloc] initWithCustomView:btnview];
    [self.navigationController addLeftBarButtonItem:homeLeftBtn animation:NO];
}

//扫一扫
-(void)scanCode
{
    QRCodeViewController = [[DMQRCodeViewController alloc] init];
    QRCodeViewController.hidesBottomBarWhenPushed = YES;
    QRCodeViewController.navigationController = self.navigationController;
    [self.navigationController pushViewController:QRCodeViewController animated:YES];
}

-(void)setupRightMenuButton{
    if (!_menuItem) {
        UIButton * menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuBtn setFrame:CGRectMake(0, 0, 20, 27)];
        UIImage *image = [UIImage imageNamed:@"category"];
        [menuBtn setImage:image forState:UIControlStateNormal];
        [menuBtn addTarget:self action:@selector(menuBtnClick) forControlEvents:UIControlEventTouchUpInside];
        //[menuBtn addTarget:self.viewDeckController action:@selector(toggleRightView) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem * menuItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
        _menuItem = menuItem;
    }
    [self.navigationController addRightBarButtonItem:_menuItem animation:NO];
}

- (void)menuBtnClick{
    LMH_CategoryViewController *rightVC = [[LMH_CategoryViewController alloc] initWithNibName:nil bundle:nil];
    rightVC.navigationController = self.navigationController;
    rightVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:rightVC animated:YES];
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return _channelArr.count;
}

- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    CGFloat w = self.view.bounds.size.width;
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    
    if ([[_channelArr objectAtIndex:index] isKindOfClass:[MenuVO class]]) {
        MenuVO *vo = (MenuVO *)[_channelArr objectAtIndex:index];
        
        label.text = vo.Name;
    }
    
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:14.0];
    label.textColor = [UIColor colorWithRed:0.44 green:0.44 blue:0.44 alpha:1];
    
    if (w / _channelArr.count > PAGER_TAB_WIDTH) {
        [label setFrame:CGRectMake(0, 0, w / _channelArr.count, PAGER_TAB_HEIGHT)];
    } else {
        [label setFrame:CGRectMake(0, 0, PAGER_TAB_WIDTH, PAGER_TAB_HEIGHT)];
    }
    
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index
{
    UIViewController *cvc = nil;
    if ([_channelArr objectAtIndex:index]) {
        if ([[_channelArr objectAtIndex:index] isKindOfClass:[MenuVO class]]) {
            MenuVO *vo = (MenuVO *)[_channelArr objectAtIndex:index];
            
            if ([[_viewsArr objectAtIndex:index] isKindOfClass:[NSString class]] &&
                [[_viewsArr objectAtIndex:index] isEqualToString:@"EMPTY"]) {
                
                switch ([vo.TypeID integerValue]) {
                    case 0:     //首页及分类列表
                    {
                        if ([vo.MID integerValue] == 0) {
                            kata_CategoryViewController *categoryVC = [[kata_CategoryViewController alloc]
                                                                       initWithMenuID:[vo.MID intValue]
                                                                       andParentID:[vo.ParentID integerValue]
                                                                       andTitle:vo.Name];
                            categoryVC.hideNavigationBarWhenPush = NO;
                            categoryVC.navigationController = self.navigationController;
                            [categoryVC.listData removeAllObjects];
                            [_viewsArr setObject:categoryVC atIndexedSubscript:index];
                            cvc = (UIViewController *)categoryVC;
                        }else{
                            CategoryDetailVC *categoryVC = [[CategoryDetailVC alloc] initWithAdvData:nil andFlag:@"category"];
                            categoryVC.pid = vo.ParentID;
                            categoryVC.cateid = vo.MID;
                            categoryVC.hideNavigationBarWhenPush = NO;
                            categoryVC.ifShowBtnHigher = YES;
                            categoryVC.is_home = YES;
                            categoryVC.hasTabHeight = YES;
                            categoryVC.navigationController = self.navigationController;
                            [categoryVC.listData removeAllObjects];
                            [_viewsArr setObject:categoryVC atIndexedSubscript:index];
                            cvc = (UIViewController *)categoryVC;
                        }
                    }
                        break;
                        
                    case 1:     //商品列表
                    {
                        kata_ProductListViewController *productListVC = [[kata_ProductListViewController alloc]
                                                                         initWithBrandID:[vo.MID intValue]
                                                                         andTitle:vo.Name
                                                                         andProductID:0
                                                                         andPlatform:nil
                                                                         isChannel:YES];
                        productListVC.hasTabHeight = YES;
                        productListVC.navigationController = self.navigationController;
                        [_viewsArr setObject:productListVC atIndexedSubscript:index];
                        cvc = (UIViewController *)productListVC;
                    }
                        break;
                        
                    case 2:     //订阅列表
                    {
                        kata_SellSoonViewController *sellsoonVC = [[kata_SellSoonViewController alloc]
                                                                   initWithMenuID:[vo.MID intValue]
                                                                   andTitle:vo.Name
                                                                   isRoot:NO];
                        sellsoonVC.hasTabHeight = YES;
                        sellsoonVC.navigationController = self.navigationController;
                        [_viewsArr setObject:sellsoonVC atIndexedSubscript:index];
                        cvc = (UIViewController *)sellsoonVC;
                    }
                        break;
                        
                    default:
                        break;
                }
                
            } else {
                cvc = (UIViewController *)[_viewsArr objectAtIndex:index];
            }
        }
    }
    
    return cvc;
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 0.0;
            break;
        case ViewPagerOptionCenterCurrentTab:
            return 1.0;
            break;
        case ViewPagerOptionTabLocation:
            return 1.0;
            break;
        case ViewPagerOptionTabHeight:
            return PAGER_TAB_HEIGHT;
            break;
        case ViewPagerOptionTabWidth:
        {
            if (self.view.bounds.size.width / _channelArr.count > PAGER_TAB_WIDTH) {
                return self.view.bounds.size.width / _channelArr.count;
            }
            return PAGER_TAB_WIDTH;
        }
            break;
        default:
            break;
    }
    
    return value;
}

- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    
    switch (component) {
        case ViewPagerIndicator:
            return [UIColor colorWithRed:0.96 green:0.3 blue:0.42 alpha:1];
            break;
        case ViewPagerTabsView:
            return [UIColor whiteColor];
            break;
        default:
            break;
    }
    
    return color;
}

- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index
{
    self.pageIndex = index;
}

@end
