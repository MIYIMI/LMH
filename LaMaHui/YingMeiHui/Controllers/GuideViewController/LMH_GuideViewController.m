//
//  LMH_GuideViewController.m
//  LaMaHui
//
//  Created by work on 14-8-11.
//  Copyright (c) 2014年 LYQ. All rights reserved.
//

#import "LMH_GuideViewController.h"
#import "UIDevice+Resolutions.h"
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonHMAC.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netdb.h>
#import <arpa/inet.h>

//#define AUTO_SEC 4.0f   //自动切换视图间隔时间
//#define VIEWCOUNT 3     //引导页总页数
#define SIZE [[UIScreen mainScreen] bounds].size

@interface LMH_GuideViewController ()
{
    UIPageControl *_control;
    UIPageViewController *pageView;
    UIScrollView *_scrollView;
    BOOL scrollLeftOrRight;
    NSTimer *timer;
    NSInteger count;
    NSArray *startArray;
    NSString *startImageFile;
}
@end

@implementation LMH_GuideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        pageView = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationVertical options:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    startImageFile = [documentsPath stringByAppendingPathComponent:@"startImageFile"];
//    NSLog(@">>>>>%@", documentsPath);
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    startArray = [[NSArray alloc] init];
    startArray = [userDefaultes arrayForKey:@"startImage"];
//    NSArray *myArray = [userDefaultes arrayForKey:@"startImage"];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSError *error = nil;
//    startArray = [[NSArray alloc] init];
//    startArray = [fileManager contentsOfDirectoryAtPath:startImageFile error:&error];
    if (startArray.count == 0) {
        count = 1;
    } else {
        count = startArray.count;
    }
    if (count == 1) {
        timer =[NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
        [_control removeFromSuperview];
    }
    [self createUI];
    // 设置自动跳转
    [NSTimer scheduledTimerWithTimeInterval:6.f target:self selector:@selector(PageConllorAction) userInfo:self repeats:YES];
}

-(void)createUI
{
    UIScrollView *uiScrollview = [[UIScrollView alloc] init];
    uiScrollview.frame = self.view.bounds;
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    //设置引导页图片
    for (NSInteger i = 0; i < count; i++) {
        UIImage *image;
        if ([[[DeviceModel shareModel] phoneType] hasPrefix:@"iPhone 4"]) {
            if (startArray.count == 0) {
                image = [UIImage imageNamed:[NSString stringWithFormat:@"guiimage4_%zi", i + 1]];
            } else {
                NSString *startImagePath = [startImageFile stringByAppendingPathComponent:[NSString stringWithFormat:@"guiimage4_%zi.png", i]];
                image = [UIImage imageWithContentsOfFile:startImagePath];
            }
        }else if(![[[DeviceModel shareModel] phoneType] hasPrefix:@"iPhone 4"]){
            if (startArray.count == 0) {
                image = [UIImage imageNamed:[NSString stringWithFormat:@"guiimage5_%zi", i + 1]];
            } else {
                NSString *startImagePath = [startImageFile stringByAppendingPathComponent:[NSString stringWithFormat:@"guiimage5_%zi.png", i]];
                image = [UIImage imageWithContentsOfFile:startImagePath];
            }
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(i*width, 0, width, height);
        [uiScrollview addSubview:imageView];
    }

    //设置进入主页按钮属性
    UIButton *enterHome = [UIButton buttonWithType:UIButtonTypeCustom];
    [enterHome setFrame:CGRectMake((count - 1)*W + W - 80, 30, 66, 24)];
    [enterHome.layer setCornerRadius:8];
    [enterHome setBackgroundImage:[UIImage imageNamed:@"guibtn"] forState:UIControlStateNormal];
    [enterHome setBackgroundImage:[UIImage imageNamed:@"guibtn"] forState:UIControlStateHighlighted];
    [enterHome setBackgroundImage:[UIImage imageNamed:@"guibtn"] forState:UIControlStateSelected];
    [enterHome addTarget:self action:@selector(didClickOnButton:) forControlEvents:UIControlEventTouchUpInside];
    [uiScrollview addSubview:enterHome];
    
    //设置uiScrollview属性
    uiScrollview.showsHorizontalScrollIndicator = NO;
    uiScrollview.contentSize = CGSizeMake(count*width, height);
    uiScrollview.pagingEnabled = YES;
    uiScrollview.backgroundColor = [UIColor grayColor];
    uiScrollview.delegate = self;
    _scrollView = uiScrollview;
    _scrollView.bounces = NO;
    [self.view addSubview:_scrollView];
    
    //设置UIPageControl属性
    UIPageControl *control = [[UIPageControl alloc] init];
    control.numberOfPages = count;
    control.bounds = CGRectMake(0, 0, 200, 50);
    control.center = CGPointMake(width*0.5, height-50);
    control.currentPage = 0;
    _control = control;
    _control.currentPageIndicatorTintColor = [UIColor colorWithRed:0.95 green:0.37 blue:0.45 alpha:1];
    [_control setUserInteractionEnabled:NO];
    [self.view addSubview:control];
    if (count == 1) {
        [_control removeFromSuperview];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 手动滑动引导页
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger pageNum = scrollView.contentOffset.x / scrollView.frame.size.width;
    _currentPageIndex = pageNum;
    _control.currentPage = pageNum;
//    if (_currentPageIndex == 0) {
//        _scrollView.bounces = NO;
//    }else{
//        _scrollView.bounces = YES;
//    }
}

////滑动进入主页
//-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    //[self startScrolling];
//    CGFloat newx = scrollView.contentOffset.x;
//    CGFloat oldx = scrollView.frame.size.width * (VIEWCOUNT - 1);
//    if (newx > oldx ) {
//        scrollLeftOrRight = YES;
//    }else{
//        scrollLeftOrRight = NO;
//    }
//    if (_currentPageIndex == VIEWCOUNT -1 && scrollLeftOrRight) {
//        [self performSelectorOnMainThread:@selector(didClickOnButton:) withObject:nil waitUntilDone:YES];
//    }
//}

//点击进入主页
- (void)setButtonBlock:(ButtonBlock)block{
        _buttonBlock = block;
}

// 判断网络
-(BOOL) connectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
//        printf("Error. Could not recover network reachability flags\n");
        return NO;
    }
    
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}

- (IBAction)didClickOnButton:(id)sender
{
    // 暂停NSTimer
    [timer setFireDate:[NSDate distantFuture]];
    
    if(![self connectedToNetwork])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    if (_buttonBlock) {
        _buttonBlock(sender);
    }
}

//// 设置当前页属性
//- (void)animateScrolling
//{
//    if (++_currentPageIndex < VIEWCOUNT)
//    {
//        [_scrollView setContentOffset:CGPointMake(_currentPageIndex * SIZE.width, 0)
//                             animated:YES];
//        [_control setCurrentPage:_currentPageIndex];
//        [self autoScrollToNextPage];
//    }
//    else
//    {
//        //自动进入主页
////        [self performSelectorOnMainThread:@selector(didClickOnButton:) withObject:nil waitUntilDone:YES];
//    }
//}

// 间隔时间跳转到下一页
//- (void)autoScrollToNextPage
//{
//        [self performSelector:@selector(animateScrolling) withObject:nil afterDelay:AUTO_SEC];
//}
//
//// 开始自动跳转
//- (void)startScrolling
//{
//    [self autoScrollToNextPage];
//}

// 最后一页自动跳转
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger inder = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    if (inder == (count - 1)) {
    // 设置自动跳转主页
    timer =[NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
    } else {
        // 重置timer
        [timer invalidate];
    }
}
- (void)delayMethod
{
    [self performSelectorOnMainThread:@selector(didClickOnButton:) withObject:nil waitUntilDone:YES];
}

- (void)PageConllorAction
{
        _control.currentPage = _control.currentPage+1;
        [_scrollView setContentOffset:CGPointMake(_control.currentPage*320, 0) animated:YES];
}


@end
