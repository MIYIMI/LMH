
//
//  kata_AppDelegate.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-3-28.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "kata_AppDelegate.h"
#import "KTStartupInfoGetRequest.h"
#import "KTProxy.h"
#import "MenuVO.h"
#import "MobClick.h"
#import "UMSocial.h"
#import "kata_GlobalConst.h"
#import "LMH_GeXinAPNSTool.h"
#import "EGOCache.h"
#import "UIImageView+WebCache.h"

#import <QuartzCore/QuartzCore.h>
#import <Reachability/Reachability.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "KTNavigationController.h"
#import "kata_MyViewController.h"
#import "kata_ShopCartViewController.h"
#import "kata_UserManager.h"
#import "IQKeyboardManager.h"
#import "iRate.h"
#import "UIDevice+Resolutions.h"
#import "kata_CategoryViewController.h"
#import "TalkingData.h"
#import <AlipaySDK/AlipaySDK.h>
#import "KATACheckUtils.h"

#import "LMH_TabBarController.h"

@interface kata_AppDelegate ()
{
    NSArray *_menusArr;
    NSArray *_tutorialsArr;
    NSArray *_tutorials_bigArr;
    Reachability *_reach;
    UIView *_errorView;
    UIView *remindView;
    
    BOOL backFlag;//后台加载 yes--后台加载 no--第一次打开app加载
    NSString *payloadMsg;
}
//检查网络
- (void)checkNetwork;

@end


@implementation kata_AppDelegate
@synthesize rootVC;
/**
 *  自动评论弹出框
 */
+ (void)initialize
{
    //https://github.com/nicklockwood/iRate#supported-os--sdk-versions
    //set the bundle ID. normally you wouldn't need to do this
    //as it is picked up automatically from your Info.plist file
    //but we want to test with an app that's actually on the store
    [iRate sharedInstance].applicationBundleID = @"com.lamahui.lamahui";
    [iRate sharedInstance].onlyPromptIfLatestVersion = NO;
    //enable preview mode
    [iRate sharedInstance].previewMode = NO;
    
    [iRate sharedInstance].usesUntilPrompt = 2;
    [iRate sharedInstance].daysUntilPrompt = 7;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSInteger show = [userDefaultes integerForKey:@"boolShow"];
    if (show == 1) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    }
    
    NSNumber *cvNum = [NSNumber numberWithLongLong:[[userDefaultes objectForKey:@"cv"] longLongValue] + 1];
    [userDefaultes setObject:cvNum forKey:@"cv"];
    [userDefaultes synchronize];

    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        //如果是第一次启动的话,使用LMH_GuideViewController (用户引导页面) 作为根视图
        LMH_GuideViewController *guideViewController = [[LMH_GuideViewController alloc] init];
        self.window.rootViewController = guideViewController;
        [guideViewController setButtonBlock:^(UIButton *button)
         {
             [self cacheMenu];
         }];
        //[guideViewController startScrolling];
    }else{
        //如果不是第一次启动的话,使用LMH_HomeViewController作为根视图
        //self.window.rootViewController = _launchVC;
        [self cacheMenu];
    }
    
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor whiteColor];
    [self checkNetwork];
    
    NSString *userAgent = [[[UIWebView alloc] init] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    
    NSString *version = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    NSString *customUserAgent = [NSString stringWithFormat:@"%@ UID/%@ SCR/%@ NET/%@ BRAND/%@ MODEL/%@ OPERATOR/%@ SYSVER/%@ CHANNEL/%@ VER/LMH_IOS_%@",userAgent,[OpenUDID value],[[DeviceModel shareModel] scrResolution],[[DeviceModel shareModel] netType],[[DeviceModel shareModel] deviceType],[[DeviceModel shareModel] phoneType],[[DeviceModel shareModel] carrierName],[[DeviceModel shareModel] systemOS],@"1200",version];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":customUserAgent}];
    
    [MobClick setAppVersion:[[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"]];
    [UMSocialData setAppKey:UMENG_APPKEY];
    [MobClick startWithAppkey:UMENG_APPKEY];
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:BATCH channelId:@"1200"];
    
    //向qq注册app
    [UMSocialQQHandler setQQWithAppId:QQ_APPID appKey:QQ_APPKEY url:APPURL];
    
    //向微信注册app
    [UMSocialWechatHandler setWXAppId:WEIXINPAY_APPID appSecret:WXSECRET url:APPURL];
    
    //向新浪微博注册app
    [UMSocialSinaHandler openSSOWithRedirectURL:APPURL];
    
    // [1]:使用APPID/APPKEY/APPSECRENT创建个推实例
    [[LMH_GeXinAPNSTool sharedAPNSTool] startSdkWith:GeXinAPNS_AppleID appKey:GeXinAPNS_AppKey appSecret:GeXinAPNS_AppSecret];
    
    // [2]:注册APNS
    [[LMH_GeXinAPNSTool sharedAPNSTool] registerRemoteNotification];
    
    // [2-EXT]: 获取启动时收到的APN
    NSDictionary *message = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (message) {
        payloadMsg = [message objectForKey:@"payload"];
    }
    
    //本地通知获取
    message = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (message) {
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"seckill"];
    }
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    // 错误分析
    [TalkingData setExceptionReportEnabled:YES];
    //TalkingSDK
    [TalkingData sessionStarted:@"FF70BAEDFC446EE7C1BC558B33CC4A46" withChannelId:@"1200"];
    
    //取消所有本地通知一次
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"cancelNotif"] boolValue]) {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"cancelNotif"];
    }
    
    return YES;
}

//接收本地推送
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    if ([application applicationState] == UIApplicationStateActive) {
        [self showRemindView];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"seckill"];
        [[LMH_GeXinAPNSTool sharedAPNSTool] pushVC];
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)showRemindView{
    if (!remindView) {
        remindView = [[UIView alloc] initWithFrame:CGRectMake(30, ScreenH/2-60, ScreenW - 60, 40)];
        remindView.backgroundColor = RGBA(0, 0, 0, 0.6);
        remindView.layer.cornerRadius = 20.0;
        remindView.layer.masksToBounds = YES;
        [self.window addSubview:remindView];
        
        UILabel*labelOne = [[UILabel alloc] init];
        labelOne.frame = CGRectMake(15, 10 , CGRectGetWidth(remindView.frame) - 30, 20);
        labelOne.layer.cornerRadius = 10;
        labelOne.backgroundColor = [UIColor clearColor];
        labelOne.text = @"hi 辣妈~还有5分钟秒杀就要开始啦！";
        labelOne.textColor = [UIColor whiteColor];
        labelOne.font = [UIFont systemFontOfSize:14];
        labelOne.textAlignment = NSTextAlignmentCenter;
        [remindView addSubview:labelOne];
    }
    [remindView setHidden:NO];
    
    [self performSelector:@selector(removeRemindView) withObject:nil afterDelay:3.0];
}

- (void)removeRemindView
{
    [remindView setHidden:YES];
}

- (void)initRootView
{
    if(IOS_7){
        UIColor * tintColor = [UIColor colorWithRed:29.0/255.0
                                              green:173.0/255.0
                                               blue:234.0/255.0
                                              alpha:1.0];
        [self.window setTintColor:tintColor];
    }

    CATransition *transition = [CATransition animation];
    transition.duration = 1.0f; //间隔时间
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]; //动画的开始与结束的快慢
    transition.type = @"fade"; //各种动画效果
    transition.subtype = kCATransitionFromRight; //动画方向
    transition.delegate = self;
    [self.window.layer addAnimation:transition forKey:nil];
    
    rootVC = [[kata_CategoryViewController alloc] initWithMenuID:0 andParentID:0 andTitle:nil];
    rootVC.hasTabHeight = NO;
    
    KTNavigationController *navigationController1 = [[KTNavigationController alloc] initWithRootViewController:rootVC];
    rootVC.navigationController = navigationController1;
    LMH_TabBarController *centerTabVC = [[LMH_TabBarController alloc] initWithFisrtVC:navigationController1];
    
    self.window.rootViewController = centerTabVC;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"getdevicetoken"]) {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"getdevicetoken"] isEqualToString:@"YES"])
        {
            [[LMH_GeXinAPNSTool sharedAPNSTool] registerRemoteNotification];
        }
    }
    //进入app强制拉取首页数据
    [[NSUserDefaults standardUserDefaults] setObject:@"1234567890" forKey:@"home_secret"];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    // [EXT] 切后台关闭SDK，让SDK第一时间断线，让个推先用APN推送
    [[LMH_GeXinAPNSTool sharedAPNSTool] stopSdk];
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UMSocialSnsService applicationDidBecomeActive];
    // [EXT] 重新上线
    [[LMH_GeXinAPNSTool sharedAPNSTool] startSdkWith:GeXinAPNS_AppleID appKey:GeXinAPNS_AppKey appSecret:GeXinAPNS_AppSecret];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    
	_deviceToken = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[NSUserDefaults standardUserDefaults] setObject:_deviceToken forKey:@"devicetoken"];
    
        // [3]:向个推服务器注册deviceToken
    [[LMH_GeXinAPNSTool sharedAPNSTool].gexinPusher registerDeviceToken:_deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    // [3-EXT]:如果APNS注册失败，通知个推服务器
    if ([LMH_GeXinAPNSTool sharedAPNSTool].gexinPusher) {
        [[LMH_GeXinAPNSTool sharedAPNSTool].gexinPusher registerDeviceToken:@""];
    }
    
    LMHLog(" register for remote notification  failed %@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userinfo
{
    // [4-EXT]:处理APN
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
    
     UIApplicationState applicationState = [[UIApplication sharedApplication] applicationState];
    [[LMH_GeXinAPNSTool sharedAPNSTool] setApplicationState:applicationState];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler NS_AVAILABLE_IOS(7_0){
     UIApplicationState applicationState = [[UIApplication sharedApplication] applicationState];
    [[LMH_GeXinAPNSTool sharedAPNSTool] setApplicationState:applicationState];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSString *urlStr = [url absoluteString];
    
	if ([urlStr hasPrefix:WEIXINPAY_APPID]){
        [WXApi handleOpenURL:url delegate:self];
        [UMSocialSnsService handleOpenURL:url wxApiDelegate:self];
    }else if ([urlStr hasPrefix:@"YingMeiHuiStoreApp"]){
        if ([url.host isEqualToString:@"safepay"]) {
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
            }];
        }
        if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
            [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
            }];
        }
    }else if ([urlStr hasPrefix:WEIXINPAY_APPID]){
        return [WXApi handleOpenURL:url delegate:self];
    }else if ([urlStr hasPrefix:[NSString stringWithFormat:@"tencent%@", QQ_APPID]]){
        return [TencentOAuth HandleOpenURL:url];
    }else if ([urlStr hasPrefix:@"QQ"]){
        return  [UMSocialSnsService handleOpenURL:url];
    }else if ([urlStr hasPrefix:@"sina."]){
        return  [UMSocialSnsService handleOpenURL:url];
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSString *urlStr = [url absoluteString];
    
    if ([urlStr hasPrefix:WEIXINPAY_APPID]){
        return [UMSocialSnsService handleOpenURL:url wxApiDelegate:self];
    }else if ([urlStr hasPrefix:@"YingMeiHuiStoreApp"]){
//        [self parse:url application:application];
    }else if ([urlStr hasPrefix:WEIXINPAY_APPID]){
        return [WXApi handleOpenURL:url delegate:self];
    }else if ([urlStr hasPrefix:[NSString stringWithFormat:@"tencent%@", QQ_APPID]]){
        return [TencentOAuth HandleOpenURL:url ];
    }else if ([urlStr hasPrefix:@"QQ"]){
        return  [UMSocialSnsService handleOpenURL:url];
    }else if ([urlStr hasPrefix:@"sina."]){
        return  [UMSocialSnsService handleOpenURL:url];
    }
    
    return YES;
}

#pragma mark - StartupInfoGetRequest  首页启动图
- (void)starupOperation
{
    KTStartupInfoGetRequest *req = [[KTStartupInfoGetRequest alloc] init];
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(starupParseResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        //载入失败处理 载入失败界面
        if (!backFlag) {
            [self errView];
        }
    }];
    
    [proxy start];
}

- (void)starupParseResponse:(NSString *)resp
{
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            if (nil != [respDict objectForKey:@"data"] && ![[respDict objectForKey:@"data"] isEqual:[NSNull null]] && [[respDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *dataObj = [respDict objectForKey:@"data"];
                
                NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                [def setObject:dataObj[@"app_cache_secret"]?dataObj[@"app_cache_secret"]:@"123456790" forKey:@"menu_secret"];
                [def synchronize];
                
                if ([[dataObj objectForKey:@"code"] integerValue] == 0) {
                    
                    StartVO *svo = [StartVO StartVOWithDictionary:dataObj];
                    _menusArr = svo.menus;
                    
                    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
                    [userDef setObject:svo.third_login_flag?svo.third_login_flag:@1 forKey:@"third_login_flag"];
                    [userDef setObject:svo.user_uuid?svo.user_uuid:@"00000" forKey:@"user_uuid"];
                    
                    if (svo.tutorials.count > 0 && [[[DeviceModel shareModel] phoneType] hasPrefix:@"iPhone 4"]) {
                        _tutorialsArr = svo.tutorials;
                        [userDef setObject:_tutorialsArr forKey:@"startImage"];
                        [self performSelectorOnMainThread:@selector(addStartImage:) withObject:_tutorialsArr waitUntilDone:YES];
                    }
                    
                    if (svo.tutorials_big.count > 0 && ![[[DeviceModel shareModel] phoneType] hasPrefix:@"iPhone 4"]) {
                        _tutorials_bigArr = (NSArray *)[dataObj objectForKey:@"tutorials_big"];
                        [userDef setObject:_tutorials_bigArr forKey:@"startImage"];
                        [self performSelectorOnMainThread:@selector(addStartImage:) withObject:_tutorials_bigArr waitUntilDone:YES];
                    }
                    
                    [userDef setBool:[svo.is_show boolValue] forKey:@"boolShow"];
                    if (svo.service_phone) {
                        [userDef setObject:svo.service_phone forKey:@"service_phone"];
                    }
                    [userDef synchronize];
                    
                    if (dataObj) {
                        [[kata_UserManager sharedUserManager] updateMenuData:dataObj];
                    }
                    if (!backFlag) {
                        [self performSelectorOnMainThread:@selector(cacheMenu) withObject:nil waitUntilDone:YES];
                    }
                    return;
                } else {
                }
            } else {
            }
        } else {
        }
    }
    if (!backFlag) {
        [self errView];
    }
}

-(void)cacheMenu{
    if ([[kata_UserManager sharedUserManager] getMenuData]) {
        NSDictionary *dataObj = [[kata_UserManager sharedUserManager] getMenuData];
        StartVO *svo = [StartVO StartVOWithDictionary:dataObj];
        _menusArr = svo.menus;
        
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        [userDef setObject:svo.third_login_flag?svo.third_login_flag:@1 forKey:@"third_login_flag"];
        [userDef setObject:svo.user_uuid?svo.user_uuid:@"00000" forKey:@"user_uuid"];
        
        
        if (svo.tutorials.count > 0 && [[[DeviceModel shareModel] phoneType] hasPrefix:@"iPhone 4"]) {
            _tutorialsArr = svo.tutorials;
            [userDef setObject:_tutorialsArr forKey:@"startImage"];
            [self performSelectorOnMainThread:@selector(addStartImage:) withObject:_tutorialsArr waitUntilDone:YES];
        }
        
        if (svo.tutorials_big.count > 0 && ![[[DeviceModel shareModel] phoneType] hasPrefix:@"iPhone 4"]) {
            _tutorials_bigArr = (NSArray *)[dataObj objectForKey:@"tutorials_big"];
            [userDef setObject:_tutorials_bigArr forKey:@"startImage"];
            [self performSelectorOnMainThread:@selector(addStartImage:) withObject:_tutorials_bigArr waitUntilDone:YES];
        }
        
        [userDef setBool:[svo.is_show boolValue] forKey:@"boolShow"];
        if (svo.service_phone) {
            [userDef setObject:svo.service_phone forKey:@"service_phone"];
        }
        [userDef synchronize];
        
        backFlag = YES;
        [self performSelectorOnMainThread:@selector(initRootView) withObject:nil waitUntilDone:YES];
    }else{
        backFlag = NO;
    }
    [self performSelector:@selector(starupOperation) withObject:nil afterDelay:1.0];
}

//首次安装打开app失败
- (void)errView{
    _errorView = [[UIView alloc] initWithFrame:self.window.frame];
    CGFloat w = _errorView.frame.size.width;
    CGFloat h = _errorView.frame.size.height;
    
    [_errorView setBackgroundColor:ALL_COLOR];
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"neterror"]];
    [image setFrame:CGRectMake((w - CGRectGetWidth(image.frame)) / 2, h/2 - CGRectGetHeight(image.frame), CGRectGetWidth(image.frame), CGRectGetHeight(image.frame))];
    [_errorView addSubview:image];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, h/2 + 10, w, 34)];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setNumberOfLines:2];
    [lbl setTextColor:[UIColor whiteColor]];
    [lbl setFont:[UIFont systemFontOfSize:14.0]];
    [lbl setText:@"网络抛锚\r\n请检查网络后点击屏幕重试！"];
    [_errorView addSubview:lbl];
    
    _errorView.center = self.window.center;
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScreen)];
    [_errorView addGestureRecognizer:tapGesture];
    
    [self.window addSubview:_errorView];
}

- (void)tapScreen{
    [self cacheMenu];
    
    [_errorView removeFromSuperview];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark 检查网络
////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)checkNetwork
{
    _reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    _reach.reachableOnWWAN = YES;
    [_reach startNotifier];
}

//微信支付结果
- (void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[PayResp class]]) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:resp.errCode], @"errCode", resp.errStr, @"errStr", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WXPAY" object:nil userInfo:dict];
    }
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:resp, @"resp", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WXLOGIN" object:nil userInfo:dict];
    }
}

// 加载引导页图片
- (void)addStartImage:(NSArray *)arr
{
    //后台加载引导页图片
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *startImageFile = [documentsPath stringByAppendingPathComponent:@"startImageFile"];
    [[NSFileManager defaultManager] createDirectoryAtPath:startImageFile withIntermediateDirectories:YES attributes:nil error:nil];
    for (NSInteger i = 0; i < arr.count; i++) {
        NSURL *url = [NSURL URLWithString:arr[i]];
        NSMutableURLRequest *reqest = [NSMutableURLRequest requestWithURL:url];
        [reqest setHTTPMethod:@"GET"];
        [NSURLConnection sendAsynchronousRequest:reqest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            if ([[[DeviceModel shareModel] phoneType] hasPrefix:@"iPhone 4"]) {
                NSString *startImagePath = [startImageFile stringByAppendingPathComponent:[NSString stringWithFormat:@"guiimage4_%zi.png", i]];
                [data writeToFile:startImagePath atomically:YES];
            } else{
                NSString *startImagePath = [startImageFile stringByAppendingPathComponent:[NSString stringWithFormat:@"guiimage5_%zi.png", i]];
                [data writeToFile:startImagePath atomically:YES];
            }
        }];
    }
}

@end
