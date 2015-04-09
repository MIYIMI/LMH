//
//  kata_OrderManageViewController.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-6-24.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "kata_OrderManageViewController.h"
#import "kata_AllOrderListViewController.h"

#define PAGER_TAB_WIDTH         60.0
#define PAGER_TAB_HEIGHT        35.0

@interface kata_OrderManageViewController () <ViewPagerDataSource, ViewPagerDelegate>
{
    NSArray *_channelArr;
    NSMutableArray *_viewsArr;
    NSInteger indexNum;
}

@end

@implementation kata_OrderManageViewController

- (id)initIndex:(NSInteger)index andType:(NSInteger)type
{
    self = [super initWithNibName:nil  bundle:nil];
    if (self) {
        _orderType = type;
        indexNum = index;
        
        if (_orderType == 0) {
            _channelArr = @[@"全部", @"待付款", @"待发货", @"待收货", @"待评价", @"已评价"];
            
            _viewsArr = [[NSMutableArray alloc] init];
            for (NSInteger i = 0; i < _channelArr.count; i++) {
                [_viewsArr addObject:@"EMPTY"];
            }
            self.title = @"我的订单";
        }else{
            _channelArr = @[@"退款中", @"退款完成"];
            
            _viewsArr = [[NSMutableArray alloc] init];
            for (NSInteger i = 0; i < _channelArr.count; i++) {
                [_viewsArr addObject:@"EMPTY"];
            }
            self.title = @"退款订单";
        }
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    
    // Keeps tab bar below navigation bar on iOS 7.0+
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [super viewDidLoad];
    [self selectedTabIndex:indexNum];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.hidesBottomBarWhenPushed = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return _channelArr.count;
}
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    CGFloat w = self.view.bounds.size.width;
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];

    if ([[_channelArr objectAtIndex:index] isKindOfClass:[NSString class]]) {
        label.text = [_channelArr objectAtIndex:index];
    }
    
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = LMH_COLOR_BLACK;
    
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
        if ([[_channelArr objectAtIndex:index] isKindOfClass:[NSString class]]) {
            
            if ([[_viewsArr objectAtIndex:index] isKindOfClass:[NSString class]] &&
                [[_viewsArr objectAtIndex:index] isEqualToString:@"EMPTY"]) {
                
                if ([[_channelArr objectAtIndex:index] isEqualToString:@"全部"]) {
                    kata_AllOrderListViewController *orderListVC = [[kata_AllOrderListViewController alloc] initWithOrderType:nil];
                    orderListVC.hasTabHeight = YES;
                    orderListVC.navigationController = self.navigationController;
                    orderListVC.mytabController = self.tabBarController;
                    [_viewsArr setObject:orderListVC atIndexedSubscript:index];
                    cvc = (UIViewController *)orderListVC;
                } else if ([[_channelArr objectAtIndex:index] isEqualToString:@"待付款"]) {
                    kata_AllOrderListViewController *orderListVC = [[kata_AllOrderListViewController alloc] initWithOrderType:@"nopay"];
                    orderListVC.hasTabHeight = YES;
                    orderListVC.navigationController = self.navigationController;
                    orderListVC.mytabController = self.tabBarController;
                    [_viewsArr setObject:orderListVC atIndexedSubscript:index];
                    cvc = (UIViewController *)orderListVC;
                } else if ([[_channelArr objectAtIndex:index] isEqualToString:@"待发货"]) {
                    kata_AllOrderListViewController *orderListVC = [[kata_AllOrderListViewController alloc] initWithOrderType:@"nosend"];
                    orderListVC.hasTabHeight = YES;
                    orderListVC.navigationController = self.navigationController;
                    orderListVC.mytabController = self.tabBarController;
                    [_viewsArr setObject:orderListVC atIndexedSubscript:index];
                    cvc = (UIViewController *)orderListVC;
                } else if ([[_channelArr objectAtIndex:index] isEqualToString:@"待收货"]) {
                    kata_AllOrderListViewController *orderListVC = [[kata_AllOrderListViewController alloc] initWithOrderType:@"noreceive"];
                    orderListVC.hasTabHeight = YES;
                    orderListVC.navigationController = self.navigationController;
                    orderListVC.mytabController = self.tabBarController;
                    [_viewsArr setObject:orderListVC atIndexedSubscript:index];
                    cvc = (UIViewController *)orderListVC;
                }else if ([[_channelArr objectAtIndex:index] isEqualToString:@"待评价"]) {
                    kata_AllOrderListViewController *orderListVC = [[kata_AllOrderListViewController alloc] initWithOrderType:@"evaluate"];
                    orderListVC.hasTabHeight = YES;
                    orderListVC.navigationController = self.navigationController;
                    orderListVC.mytabController = self.tabBarController;
                    [_viewsArr setObject:orderListVC atIndexedSubscript:index];
                    cvc = (UIViewController *)orderListVC;
                }else if ([[_channelArr objectAtIndex:index] isEqualToString:@"已评价"]) {
                    kata_AllOrderListViewController *orderListVC = [[kata_AllOrderListViewController alloc] initWithOrderType:@"evaluated"];
                    orderListVC.hasTabHeight = YES;
                    orderListVC.navigationController = self.navigationController;
                    orderListVC.mytabController = self.tabBarController;
                    [_viewsArr setObject:orderListVC atIndexedSubscript:index];
                    cvc = (UIViewController *)orderListVC;
                }else if ([[_channelArr objectAtIndex:index] isEqualToString:@"退款中"]) {
                    kata_AllOrderListViewController *orderListVC = [[kata_AllOrderListViewController alloc] initWithOrderType:@"refunding"];
                    orderListVC.hasTabHeight = YES;
                    orderListVC.navigationController = self.navigationController;
                    orderListVC.mytabController = self.tabBarController;
                    [_viewsArr setObject:orderListVC atIndexedSubscript:index];
                    cvc = (UIViewController *)orderListVC;
                }else if ([[_channelArr objectAtIndex:index] isEqualToString:@"退款完成"]) {
                    kata_AllOrderListViewController *orderListVC = [[kata_AllOrderListViewController alloc] initWithOrderType:@"refunded"];
                    orderListVC.hasTabHeight = YES;
                    orderListVC.navigationController = self.navigationController;
                    orderListVC.mytabController = self.tabBarController;
                    [_viewsArr setObject:orderListVC atIndexedSubscript:index];
                    cvc = (UIViewController *)orderListVC;
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
            return 0.0;
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
            return LMH_COLOR_SKIN;
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
