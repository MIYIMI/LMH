//
//  kata_RootViewController.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-3-29.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "kata_RootViewController.h"
#import "kata_LeftSideViewController.h"
#import "KTNavigationController.h"
#import "KTDrawerVisualStateManager.h"
#import "MenuVO.h"
#import "KTChannelViewController.h"
#import "kata_ProductListViewController.h"
#import "kata_SellSoonViewController.h"
#import "kata_HomeViewController.h"

#import "CategoryMainVC.h"

#import <MMDrawerController/MMDrawerController.h>
#import <MMDrawerController/UIViewController+MMDrawerController.h>
#import <Reachability/Reachability.h>

#import "KTMCenterTabVC.h"

@interface kata_RootViewController ()
{
    NSArray *_menusArr;
    NSArray *_tutorialsArr;
    KTChannelViewController *_centerVC;
    kata_HomeViewController *_homeVC;
}

@end

@implementation kata_RootViewController

- (id)initWithMenuInfo:(NSArray *)menuArr
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        _menusArr = menuArr;
    }
    return self;
}

-(KTChannelViewController *)getCenterVC{
    return _centerVC;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self.contentView setFrame:self.view.frame];
    [self createUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI
{
    KTNavigationController * navigationController = nil;
//    FTBaseViewController * rootVC = nil;
    
    _centerVC = [[KTChannelViewController alloc]
                 initWithChannelInfo:_menusArr
                 isFirst:YES];
    
    KTMCenterTabVC *centerTabVC = nil;
    if (_centerVC) {
        navigationController = [[KTNavigationController alloc] initWithRootViewController:_centerVC];
        _centerVC.navigationController = navigationController;
        centerTabVC = [[KTMCenterTabVC alloc] init];
        [centerTabVC setViewControllers:[NSArray arrayWithObjects:navigationController,nil]];
    }
//    CategoryMainVC *rightVC = [[CategoryMainVC alloc] init];
//    self.slidingViewController = [ECSlidingViewController slidingWithTopViewController:centerTabVC];
//    self.slidingViewController.underRightViewController = rightVC;
//    [_centerVC.view addGestureRecognizer:self.slidingViewController.panGesture];
    //self.slidingViewController = [ECSlidingViewController slidingWithTopViewController:_centerVC];
    
//    KTMMSideDrawerViewController * leftSideController = [[KTMMSideDrawerViewController alloc] init];
//    KTMCenterTabVC *centerTabVC = nil;
//    if (_centerVC) {
//        navigationController = [[KTNavigationController alloc] initWithRootViewController:_centerVC];
//        _centerVC.navigationController = navigationController;
//        centerTabVC = [[KTMCenterTabVC alloc] init];
//        [centerTabVC setViewControllers:[NSArray arrayWithObjects:navigationController,nil]];
//        //[leftSideController setFirstVC:navigationController];
//
//    } else if (rootVC) {
//        navigationController = [[KTNavigationController alloc] initWithRootViewController:rootVC];
//        rootVC.navigationController = navigationController;
//    }
//    [navigationController setRestorationIdentifier:@"KTCenterNavigationControllerRestorationKey"];
//    if(OSVersionIsAtLeastiOS7()) {
//        KTNavigationController * leftSideNavController = [[KTNavigationController alloc] initWithRootViewController:leftSideController];
//        //leftSideController.navigationController = leftSideNavController;
//		[leftSideNavController setRestorationIdentifier:@"KTLeftNavigationControllerRestorationKey"];
//        self.drawerController = [[MMDrawerController alloc]
//                                 initWithCenterViewController:centerTabVC
//                                 rightDrawerViewController:leftSideController];
//        [self.drawerController setShowsShadow:NO];
//    }else{
//        self.drawerController = [[MMDrawerController alloc]
//                                 initWithCenterViewController:centerTabVC
//                                 rightDrawerViewController:nil];
//    }
//    [self.drawerController setRestorationIdentifier:@"KTDrawer"];
////    [self.drawerController setShowsStatusBarBackgroundView:YES];
//    [self.drawerController setStatusBarViewBackgroundColor:[UIColor blackColor]];
//    [self.drawerController setMaximumLeftDrawerWidth:250.0];
//    //[self.drawerController setShouldStretchDrawer:YES];
//    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeCustom];
//    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
//    
//    [self.drawerController
//     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
//         if (self.drawerSide == MMDrawerSideRight) {
//             MMDrawerControllerDrawerVisualStateBlock block;
//             block = [[KTDrawerVisualStateManager sharedManager]
//                      drawerVisualStateBlockForDrawerSide:drawerSide];
//             if(block){
//                 block(drawerController, drawerSide, percentVisible);
//             }
//         }
//     }];
//    
//    for (UIGestureRecognizer *recognizer in self.drawerController.view.gestureRecognizers) {
//        if ([recognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
//            recognizer.delegate = self;
//        }
//    }
//    
//    if(!OSVersionIsAtLeastiOS7()){
//        CGRect frame = self.drawerController.view.frame;
//        frame.origin.y -= 40;
//        [self.drawerController.view setFrame:frame];
//    }
//    
//    [self.contentView addSubview:self.drawerController.view];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - UIGestureRecognizer Delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (_centerVC) {
        if (_centerVC.pageIndex == 0) {
            return NO;
        }
    }
    return NO;
}

#pragma mark -
#pragma mark 联网状态变化
- (void)reachabilityChanged:(NSNotification *)notif
{
    Reachability * reach = (Reachability *)notif.object;
    
    if (reach.currentReachabilityStatus == NotReachable) {
        MBProgressHUD * hud = [MBProgressHUD HUDForView:self.contentView];
        if (!hud) {
            hud = [[MBProgressHUD alloc] initWithView:self.contentView];
        }
        [hud setMode:MBProgressHUDModeText];
        [hud setLabelText:@"网络连接中断"];
        [hud setLabelFont:[UIFont systemFontOfSize:15.0]];
        [hud setRemoveFromSuperViewOnHide:YES];
        [self.contentView addSubview:hud];
        
        [hud show:YES];
        [hud hide:YES afterDelay:3.0];
    } else
    if (reach.currentReachabilityStatus == ReachableViaWWAN){
        MBProgressHUD * hud = [MBProgressHUD HUDForView:self.contentView];
        if (!hud) {
            hud = [[MBProgressHUD alloc] initWithView:self.contentView];
        }
        [hud setMode:MBProgressHUDModeText];
        [hud setLabelText:@"当前正在使用2G/3G网络"];
        [hud setLabelFont:[UIFont systemFontOfSize:15.0]];
        [hud setRemoveFromSuperViewOnHide:YES];
        [self.contentView addSubview:hud];
        
        [hud show:YES];
        [hud hide:YES afterDelay:1.5];
    }else{
        [MBProgressHUD hideHUDForView:self.contentView animated:YES];
    }
}

@end
