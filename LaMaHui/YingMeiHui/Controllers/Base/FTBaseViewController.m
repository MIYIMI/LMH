//
//  FTBaseViewController.m
//  FantooApp
//
//  Created by hark2046 on 13-7-3.
//  Copyright (c) 2013年 Fantoo. All rights reserved.
//

#import "FTBaseViewController.h"
#import <Reachability/Reachability.h>

//#import "UIViewController+AKTabBarController.h"

@interface FTBaseViewController ()
{
    UIViewController *_rightVC;
}

- (CGRect) viewBoundsWithOrientation:(UIInterfaceOrientation)orientation;

@end

@implementation FTBaseViewController

@synthesize navigationController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _hideNavigationBarWhenPush = NO;
        _hasTabHeight = NO;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    CGRect viewRect = [self viewBoundsWithOrientation:self.interfaceOrientation];
    CGFloat yOffset = [self hideNavigationBarWhenPush]?0:kNavigationBarHeight;
    yOffset += (![self hasTabHeight])?0:kTabBarHeight;
    
    if (IOS_7){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(viewRect), CGRectGetHeight(viewRect) - yOffset)];
    
    [_contentView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [_contentView setBackgroundColor:[UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f]];
    [self.view addSubview:_contentView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(reachabilityChanged:)
//                                                 name:kReachabilityChangedNotification
//                                               object:nil];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textStateHUD:(NSString *)text
{
    if (!stateHud) {
        stateHud = [[MBProgressHUD alloc] initWithView:self.view];
        stateHud.delegate = self;
        [self.view addSubview:stateHud];
    }
    stateHud.mode = MBProgressHUDModeText;
    stateHud.detailsLabelText = text;
    stateHud.detailsLabelFont = [UIFont systemFontOfSize:13.0f];
    //stateHud.labelFont = [UIFont systemFontOfSize:13.0f];
    [stateHud show:YES];
    [stateHud hide:YES afterDelay:1.5];
}

- (void)loadHUD
{
    if (!loading) {
        loading = [[Loading alloc] initWithFrame:CGRectMake(0, 0, 180, 100) andName:[NSString stringWithFormat:@"loading.gif"]];
        loading.center = self.contentView.center;
        [loading.layer setCornerRadius:10.0];
        [self.view addSubview:loading];
    }
    [loading start];
//    if (!stateHud) {
//        stateHud = [[MBProgressHUD alloc] initWithView:self.view];
//        stateHud.delegate = self;
//        [self.view addSubview:stateHud];
//    }
//    stateHud.mode = MBProgressHUDModeIndeterminate;
//    [stateHud show:YES];
}

- (void)hideHUD{
//    if (stateHud) {
//        [stateHud hide:YES afterDelay:0];
//    }
    if (loading) {
        [loading stop];
    }
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
        [hud setRemoveFromSuperViewOnHide:YES];
        [self.contentView addSubview:hud];
        
        [hud show:YES];
    }else if (reach.currentReachabilityStatus == ReachableViaWWAN){
        MBProgressHUD * hud = [MBProgressHUD HUDForView:self.contentView];
        if (!hud) {
            hud = [[MBProgressHUD alloc] initWithView:self.contentView];
        }
        [hud setMode:MBProgressHUDModeText];
        [hud setLabelText:@"当前正在使用2G/3G网络"];
        [hud setRemoveFromSuperViewOnHide:YES];
        [self.contentView addSubview:hud];
        
        [hud show:YES];
        
        [hud hide:YES afterDelay:1.5];
    }else{
        [MBProgressHUD hideHUDForView:self.contentView animated:YES];
    }
}

#pragma mark - createUI
- (void)createUI
{
    
}

#pragma mark - Get the size of view in the main screen
- (CGRect) viewBoundsWithOrientation:(UIInterfaceOrientation)orientation{
	CGRect bounds = [UIScreen mainScreen].bounds;
    
    if([[UIApplication sharedApplication] isStatusBarHidden]){
        if(UIInterfaceOrientationIsLandscape(orientation)){
            CGFloat width = bounds.size.width;
            bounds.size.width = bounds.size.height;
            bounds.size.height = width;
        }
    }else{
        double version = [[UIDevice currentDevice].systemVersion doubleValue];
        if(UIInterfaceOrientationIsLandscape(orientation)){
            CGFloat width = bounds.size.width;
            bounds.size.width = bounds.size.height;
//            if (version>6.0 && version<7.0) {
//                bounds.size.height = width - 20;
//            }
            if (version > 6.0) {
                bounds.size.height = width - 20;
            }
        }else{
            if (version > 6.0) {
                bounds.size.height = bounds.size.height - 20;
            }
//            if (version>6.0 && version<7.0) {
//                bounds.size.height -= 20;
//            }


        }
    }
    return bounds;
}

#pragma mark - MBProgressHUD Delegate
- (void)hudWasHidden:(MBProgressHUD *)ahud
{
	[stateHud removeFromSuperview];
	stateHud = nil;
}
@end
