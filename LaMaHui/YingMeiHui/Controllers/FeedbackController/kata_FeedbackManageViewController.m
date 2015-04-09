//
//  kata_FeedbackManageViewController.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-21.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "kata_FeedbackManageViewController.h"
#import "kata_FeedbackSubmitViewController.h"
#import "kata_FeedbackHistoryViewController.h"

#define PAGER_TAB_WIDTH         87.0
#define PAGER_TAB_HEIGHT        35.0

@interface kata_FeedbackManageViewController () <ViewPagerDataSource, ViewPagerDelegate,kata_FeedbackSubmitViewControllerDelegate>
{
    NSArray *_channelArr;
    NSMutableArray *_viewsArr;
}

@end

@implementation kata_FeedbackManageViewController

@synthesize navigationController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _channelArr = @[@"我要吐槽", @"历史吐槽"];
        
        _viewsArr = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < _channelArr.count; i++) {
            [_viewsArr addObject:@"EMPTY"];
        }
        self.title = @"不爽吐槽";
    }
    return self;
}

- (void)viewDidLoad {
    
    self.dataSource = self;
    self.delegate = self;
    
    self.view.backgroundColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1];
    
    // Keeps tab bar below navigation bar on iOS 7.0+
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [super viewDidLoad];
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
    label.font = [UIFont systemFontOfSize:14.0];
    label.textColor = [UIColor colorWithRed:0.53 green:0.53 blue:0.53 alpha:1];
    
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
                
                if ([[_channelArr objectAtIndex:index] isEqualToString:@"我要吐槽"]) {
                    kata_FeedbackSubmitViewController *submitVC = [[kata_FeedbackSubmitViewController alloc] initWithNibName:nil bundle:nil];
                    submitVC.hasTabHeight = YES;
                    submitVC.delegate = self;
                    submitVC.navigationController = self.navigationController;
                    [_viewsArr setObject:submitVC atIndexedSubscript:index];
                    cvc = (UIViewController *)submitVC;
                } else if ([[_channelArr objectAtIndex:index] isEqualToString:@"历史吐槽"]) {
                    kata_FeedbackHistoryViewController *historyVC = [[kata_FeedbackHistoryViewController alloc] initWithNibName:nil bundle:nil];
                    historyVC.hasTabHeight = YES;
                    historyVC.navigationController = self.navigationController;
                    [_viewsArr setObject:historyVC atIndexedSubscript:index];
                    cvc = (UIViewController *)historyVC;
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

- (void)changeView:(NSString *)feeStr{
    if ([feeStr isEqualToString:@"历史吐槽"]) {
        [self selectedTabIndex:1];
    }
}

@end