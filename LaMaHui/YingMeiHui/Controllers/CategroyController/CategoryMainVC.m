//
//  CategoryMainVC.m
//  YingMeiHui
//
//  Created by KevinKong on 14-9-12.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "CategoryMainVC.h"
#import "CategoryVC.h"
#import "BrandVC.h"
#import "LMH_Config.h"

#define PAGER_TAB_WIDTH         50.0
#define PAGER_IOS6TAB_HEIGHT        44.0
#define PAGER_IOS7TAB_HEIGHT        64.0

@interface CategoryMainVC ()
<ViewPagerDataSource, ViewPagerDelegate>
{
    NSArray *_channelArr;
    NSMutableArray *_viewsArr;
}
@end

@implementation CategoryMainVC
@synthesize navigationController;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)init{
    if (self=[super init]) {
        _channelArr = @[@"分类", @"品牌"];
        
        _viewsArr = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < _channelArr.count; i++) {
            [_viewsArr addObject:@"EMPTY"];
        }
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad
{
    self.dataSource = self;
    self.delegate = self;
    
//    self.view.backgroundColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1];
    
    // Keeps tab bar below navigation bar on iOS 7.0+
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    CGRect Frame =  self.view.frame;
    CGFloat currentVersion = CurrentOSVersion;
    if (currentVersion<7.0) {
        Frame.origin.y += 20;
    }

    self.view.frame = Frame;
    self.is_Sidebar = YES;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return _channelArr.count;
}

- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    CGFloat w = self.view.bounds.size.width - 100;
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    
    if ([[_channelArr objectAtIndex:index] isKindOfClass:[NSString class]]) {
        label.text = [_channelArr objectAtIndex:index];
    }
    
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14.0];
    [label setTextColor:[UIColor colorWithRed:0.43 green:0.43 blue:0.43 alpha:1]];
    [label setBackgroundColor:[UIColor clearColor]];
    
    CGFloat h = CurrentOSVersion>=7.0?PAGER_IOS7TAB_HEIGHT:PAGER_IOS6TAB_HEIGHT;
    
    if (w / _channelArr.count > h) {
        [label setFrame:CGRectMake(0, 20, w / _channelArr.count, h-20)];
    } else {
        [label setFrame:CGRectMake(0, 0, PAGER_TAB_WIDTH, h)];
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
                
                if ([[_channelArr objectAtIndex:index] isEqualToString:@"分类"]) {
                    CategoryVC *categoryVC = [[CategoryVC alloc] init];
                    categoryVC.hasTabHeight = NO;
                    categoryVC.hideNavigationBarWhenPush = YES;
                    categoryVC.navigationController = self.navigationController;
                    [_viewsArr setObject:categoryVC atIndexedSubscript:index];
                    cvc = (UIViewController *)categoryVC;
                } else if ([[_channelArr objectAtIndex:index] isEqualToString:@"品牌"]) {
                    BrandVC *brandVC = [[BrandVC alloc] init];
                    brandVC.hasTabHeight = NO;
                    brandVC.hideNavigationBarWhenPush = YES;
                    brandVC.navigationController = self.navigationController;
                    [_viewsArr setObject:brandVC atIndexedSubscript:index];
                    cvc = (UIViewController *)brandVC;
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
            return CurrentOSVersion>=7.0?PAGER_IOS7TAB_HEIGHT:PAGER_IOS6TAB_HEIGHT;
            break;
        case ViewPagerOptionTabWidth:
        {
            if ((ScreenW-100) / _channelArr.count > PAGER_TAB_WIDTH) {
                return (ScreenW-100) / _channelArr.count;
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
