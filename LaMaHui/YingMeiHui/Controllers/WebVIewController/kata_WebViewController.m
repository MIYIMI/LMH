//
//  kata_WebViewController.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-24.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "kata_WebViewController.h"
#import "WebViewJavascriptBridge_iOS.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "kata_CartManager.h"
#import "kata_LoginViewController.h"
#import "AdvVO.h"


#import "kata_RegisterViewController.h"
#import "kata_ProductDetailViewController.h"
#import "kata_ProductListViewController.h"
#import "CategoryDetailVC.h"
#import "kata_FavListViewController.h"
#import "kata_ShopCartViewController.h"
#import "kata_ActivityViewController.h"
#import "kata_CouponViewController.h"
#import "LimitedSeckillViewController.h"
#import "kata_SignInViewController.h"
#import "kata_AppDelegate.h"

@interface kata_WebViewController ()<LoginDelegate,UIWebViewDelegate,UMSocialUIDelegate>
{
    UIWebView *_webView;
    UIView *rightView;
    
    WebViewJavascriptBridge *_bridge;
    NSURL *_url;
    NSString *userid;
    NSString *usertoken;
    NSString *shareURL;
    NSString *shareTent;
    NSString *shareTitle;
    NSString *_type;
    
    kata_RegisterViewController *regisetVC;
    kata_ProductDetailViewController *detailVC;
    kata_ProductListViewController *listVC;
    CategoryDetailVC *cateVC;
    kata_FavListViewController *favVC;
    kata_ShopCartViewController *cartVC;
    kata_ActivityViewController *actVC;
    kata_CouponViewController *conVC;
    
    NSString *_titleStr;
    UILabel *_titleLabel;
    
    UIButton *_shareHomeBtn;
    UIButton *_shopCartBtn;
}

@end

@implementation kata_WebViewController

- (id)initWithUrl:(NSString *)url title:(NSString *)title andType:(NSString *)type
{
    self = [super init];
    if (self) {
//        NSString *srt = [NSString stringWithFormat:@"http://wap.lamahui.com/campaign/bxtest.html?%0.0f",[[NSDate date] timeIntervalSince1970]];
        _url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",url]];
        if ([type isEqualToString:@"lamahui"]) {
            _url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?frm=ios_1200",url]];
        }
        _type = type;
        
        //默认值
        shareTitle = @"下载辣妈汇APP，享新人好礼 ";
        shareURL = @"http://wap.lamahui.com/inv/f26970";
        shareTent = @"辣妈正品1折起，更懂辣妈的特卖网站";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self createUI];
    [self loadHUD];
    
    [self performSelector:@selector(hideHUD) withObject:nil afterDelay:3.0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeWeb:) name:@"WEB_HTML" object:nil];
}

- (void)changeWeb:(NSNotification*)notification{
    NSDictionary *_dict = [notification userInfo];
    _titleStr = [_dict objectForKey:@"web_title"];

    _titleLabel.text = _titleStr;
    [self hideHUD];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[(kata_AppDelegate *)[[UIApplication sharedApplication] delegate] deckController] setPanningMode:IIViewDeckNoPanning];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self didLogin];
    
    _titleLabel.hidden = NO;
    rightView.hidden = NO;
    
    if ([_type isEqualToString:@"lamahui"]) {
        _shopCartBtn.hidden = YES;
    }else{
        _shopCartBtn.hidden = NO;
        _shareHomeBtn.hidden = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    rightView.hidden = YES;
    _titleLabel.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)createUI{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
//    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    for (NSHTTPCookie *cookie in [storage cookies]){
//        [storage deleteCookie:cookie];
//    }

    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    [_webView loadRequest:[NSURLRequest requestWithURL:_url]];
    
    CGRect frame = _webView.frame;
    if (IOS_7) {
        frame.size.height -= 64;
    }else{
        frame.size.height -= 44;
    }
    _webView.frame = frame;
    [self.view addSubview:_webView];
    
    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"ObjC received message from JS: %@", data);
        responseCallback(@"Response for message from ObjC");
    }];
    
    //接收js传递数据打开app各种页面  （方法）
    [_bridge registerHandler:@"open_view" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSDictionary *dict = data;
        AdvVO *adv = [AdvVO AdvVOWithDictionary:dict];
        [self performSelectorOnMainThread:@selector(js_Action:) withObject:adv waitUntilDone:YES];
    }];
    
    //接收分享内容
    [_bridge registerHandler:@"share_info" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSDictionary *respDict = data;
        shareURL = [respDict objectForKey:@"share_url"];
        shareTent = [respDict objectForKey:@"share_tent"];
        shareTitle = [respDict objectForKey:@"share_title"];
    }];
    
    //web登陆后传回用户信息
    [_bridge registerHandler:@"web_login" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSDictionary *respDict = data;
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        if([respDict objectForKey:@"user_id"] && ![[respDict objectForKey:@"user_id"] isEqual:[NSNull null]]){
            [dict setObject:[respDict objectForKey:@"user_id"] forKey:@"user_id"];
        }
        if([respDict objectForKey:@"user_token"] && ![[respDict objectForKey:@"user_token"] isEqual:[NSNull null]]){
            [dict setObject:[respDict objectForKey:@"user_token"] forKey:@"user_token"];
        }
        if([respDict objectForKey:@"username"] && ![[respDict objectForKey:@"username"] isEqual:[NSNull null]]){
            [dict setObject:[respDict objectForKey:@"user_name"] forKey:@"username"];
        }
        
        [[kata_UserManager sharedUserManager] updateUserInfo:dict];
    }];
    
    UIButton * backBarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 27)];
    [backBarButton setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    [backBarButton setImage:[UIImage imageNamed:@"return"] forState:UIControlStateHighlighted];
    [backBarButton addTarget:self action:@selector(popToView) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBarButton];
    backBarButtonItem.style = UIBarButtonItemStylePlain;
    [self.navigationController addLeftBarButtonItem:backBarButtonItem animation:NO];
    
    //右
    rightView = [[UIView alloc]initWithFrame:CGRectMake(ScreenW - 70, 3, 70, 40)];
    rightView.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar addSubview:rightView];
    
    _shareHomeBtn = [[UIButton alloc] initWithFrame:CGRectMake(35, 3, 28, 28)];
    if ([_type isEqualToString:@"lamahui"]) {
        [_shareHomeBtn setImage:[UIImage imageNamed:@"icon_share_white"] forState:UIControlStateNormal];
    }else{
        [_shareHomeBtn setImage:[UIImage imageNamed:@"white_home"] forState:UIControlStateNormal];
    }
    [_shareHomeBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _shopCartBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 3, 28, 28)];
    [_shopCartBtn setImage:[UIImage imageNamed:@"white_shopCar"] forState:UIControlStateNormal];
    [_shopCartBtn addTarget:self action:@selector(shopCarBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [rightView addSubview:_shareHomeBtn];
    [rightView addSubview:_shopCartBtn];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 3, ScreenW - 120, 40)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = FONT(18);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    if ([_type isEqualToString:@"lamahui"]){
        CGRect frame = _titleLabel.frame;
        frame.origin.x += 20;
        _titleLabel.frame = frame;
    }
    [self.navigationController.navigationBar addSubview:_titleLabel];
}

- (void)shopCarBtnClick
{
    if (![[kata_UserManager sharedUserManager] isLogin]) {
        [kata_LoginViewController showInViewController:self];
        return;
    }else{
        cartVC = [[kata_ShopCartViewController alloc] initWithStyle:UITableViewStylePlain];
        cartVC.navigationController = self.navigationController;
        [self.navigationController pushViewController:cartVC animated:YES];
    }
}

- (void)popToView{
    if (_webView.canGoBack) {
        [_webView goBack];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)closeView{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didLogin{
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isEqualToString:@""]) {
        userid = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"];
    }
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isEqualToString:@""]) {
        usertoken = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"];
    }
    [self performSelectorOnMainThread:@selector(sendtoWap) withObject:nil waitUntilDone:YES];
}

- (void)loginCancel{

}

- (void)js_Action:(AdvVO *)adv{
    if (!adv) {
        return;
    }
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isEqualToString:@""]) {
        userid = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"];
    }
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isEqualToString:@""]) {
        usertoken = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"];
    }
    
    NSString *webStr = [NSString stringWithFormat:@"?user=%@&token=%@", userid,usertoken];
    
    NSInteger type = [adv.Type integerValue];
    
    switch (type) {
        case 0://打开登陆页面
            [self login_app];
            break;
        case 1://打开注册页面
            regisetVC = [[kata_RegisterViewController alloc] initWithNibName:nil bundle:nil];
            regisetVC.hidesBottomBarWhenPushed = YES;
            regisetVC.navigationController = self.navigationController;
            [self.navigationController pushViewController:regisetVC animated:YES];
            break;
        case 2://打开商品详情页面
            detailVC = [[kata_ProductDetailViewController alloc] initWithProductID:[adv.Key integerValue] andType:nil andSeckillID:-1];
            detailVC.hidesBottomBarWhenPushed = YES;
            detailVC.navigationController = self.navigationController;
            [self.navigationController pushViewController:detailVC animated:YES];
            break;
        case 3://打开品牌列表页面
            listVC = [[kata_ProductListViewController alloc] initWithBrandID:[adv.Key integerValue] andTitle:adv.Title andProductID:-1 andPlatform:nil isChannel:NO];
            listVC.hidesBottomBarWhenPushed = YES;
            listVC.navigationController = self.navigationController;
            [self.navigationController pushViewController:listVC animated:YES];
            break;
        case 4://打开活动列表页面
            actVC = [[kata_ActivityViewController alloc] initWithData:adv];
            actVC.hidesBottomBarWhenPushed = YES;
            actVC.navigationController = self.navigationController;
            [self.navigationController pushViewController:actVC animated:YES];
            break;
        case 5://打开分类列表页面
            cateVC = [[CategoryDetailVC alloc] initWithAdvData:adv andFlag:@"category"];
            cateVC.pid = adv.Pid;
            cateVC.cateid = [NSNumber numberWithInteger:[adv.Key integerValue]];
            cateVC.hidesBottomBarWhenPushed = YES;
            cateVC.navigationItem.title = adv.Title;
            cateVC.navigationController = self.navigationController;
            [self.navigationController pushViewController:cateVC animated:YES];
            break;
        case 6://打开收藏列表页面
            favVC = [[kata_FavListViewController alloc] initWithStyle:UITableViewStylePlain];
            favVC.hidesBottomBarWhenPushed = YES;
            favVC.navigationController = self.navigationController;
            [self.navigationController pushViewController:favVC animated:YES];
            break;
        case 7://打开购物车页面
            cartVC = [[kata_ShopCartViewController alloc] initWithStyle:UITableViewStylePlain];
            cartVC.hidesBottomBarWhenPushed = YES;
            cartVC.navigationController = self.navigationController;
            [self.navigationController pushViewController:cartVC animated:YES];
            break;
        case 8://打开优惠券页面
            conVC = [[kata_CouponViewController alloc] initWithStyle:UITableViewStylePlain];
            conVC.hidesBottomBarWhenPushed = YES;
            conVC.navigationController = self.navigationController;
            [self.navigationController pushViewController:conVC animated:YES];
            break;
        case 9:
        {
            // 品牌团
            if (adv.Key && [adv.Key integerValue] != -1) {
                CategoryDetailVC *productlistVC = [[CategoryDetailVC alloc] initWithAdvData:adv andFlag:@"get_brand_tuan_list"];
                productlistVC.pid = @0;
                productlistVC.cateid = [NSNumber numberWithInteger:[adv.Key integerValue]];
                productlistVC.navigationController = self.navigationController;
                productlistVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:productlistVC animated:YES];
            }
        }
            break;
        case 10:
        {
            // 9.9包邮
            if (adv.Key && [adv.Key integerValue] != -1) {
                CategoryDetailVC *productlistVC = [[CategoryDetailVC alloc] initWithAdvData:adv andFlag:@"get_nine_list"];
                productlistVC.pid = @0;
                productlistVC.cateid = [NSNumber numberWithInteger:[adv.Key integerValue]];
                productlistVC.navigationController = self.navigationController;
                productlistVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:productlistVC animated:YES];
            }
        }
            break;
        case 11://分类页
        {
            CategoryDetailVC *productlistVC = [[CategoryDetailVC alloc] initWithAdvData:adv andFlag:@"category"];
            productlistVC.pid = adv.Pid;
            productlistVC.cateid = [NSNumber numberWithInteger:[adv.Key integerValue]];
            productlistVC.navigationItem.title = adv.Title;
            productlistVC.navigationController = self.navigationController;
            productlistVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:productlistVC animated:YES];
        }
            break;
        case 12:
        {
            // 属性分类页
            CategoryDetailVC *productlistVC = [[CategoryDetailVC alloc] initWithAdvData:adv andFlag:@"flag"];
            productlistVC.pid = adv.Pid;
            productlistVC.cateid = [NSNumber numberWithInteger:[adv.Key integerValue]];
            productlistVC.navigationItem.title = adv.Title;
            productlistVC.navigationController = self.navigationController;
            productlistVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:productlistVC animated:YES];
        }
            break;
            break;
        case 99:
        {
            //签到赚金豆
            kata_SignInViewController *signInVC = [[kata_SignInViewController alloc] initWithTitle:@"每日签到"];
            signInVC.navigationController = self.navigationController;
            signInVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:signInVC animated:YES];
        }
            break;
        case 100:
        {
            //红包裂变
            NSString *webUrl = [_url.absoluteString stringByAppendingString:webStr];
            kata_WebViewController *webVC = [[kata_WebViewController alloc] initWithUrl:webUrl title:nil andType:@"lamahui"];
            webVC.navigationController = self.navigationController;
            webVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
        case 101:
        {
            //秒杀
            LimitedSeckillViewController *skillVC = [[LimitedSeckillViewController alloc] initWithStyle:UITableViewStylePlain];
            skillVC.navigationController = self.navigationController;
            skillVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:skillVC animated:YES];
        }
            break;
        case 102:
        {
            //进入首页
            NSArray *viewControllers =[[[self.tabBarController childViewControllers] objectAtIndex:0] childViewControllers];
            for (UIViewController *vc in viewControllers) {
                if ([vc isKindOfClass:[KTChannelViewController class]]) {
                    [(KTChannelViewController *)vc selectedTabIndex:0];
                }
            }
            self.tabBarController.selectedIndex=0;
            if (self.tabBarController.selectedIndex == 0) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
            break;
        default:
            break;
    }
}

- (void)sendtoWap{
    NSString *verSion = [NSString stringWithFormat:@"V%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys:verSion, @"version",userid,@"userid",usertoken,@"usertoken", nil];
    [_bridge callHandler:@"app_login" data:data];
}

#pragma mark -- 分享按钮点击事件
- (void)shareBtnClick
{
    if (![_type isEqualToString:@"lamahui"]) {
        NSArray *viewControllers =[[[self.tabBarController childViewControllers] objectAtIndex:0] childViewControllers];
        for (UIViewController *vc in viewControllers) {
            if ([vc isKindOfClass:[KTChannelViewController class]]) {
                [(KTChannelViewController *)vc selectedTabIndex:0];
            }
        }
        self.tabBarController.selectedIndex=0;
        if (self.tabBarController.selectedIndex == 0) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        return;
    }
    if (shareURL) {
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
        shareTent = [shareTent stringByAppendingString:shareURL];
    }else{
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeText;
    }

    [UMSocialData defaultData].extConfig.qqData.url = shareURL;
    [UMSocialData defaultData].extConfig.qzoneData.url = shareURL;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = shareURL;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareURL;
    [UMSocialData defaultData].extConfig.title = shareTitle;
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMENG_APPKEY
                                      shareText:shareTent
                                     shareImage:nil
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToSina,UMShareToSms,nil]
                                       delegate:self];
}

- (void)login_app{
    if (![[kata_UserManager sharedUserManager] isLogin]) {
        [kata_LoginViewController showInViewController:self];
    }else{
        if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isEqualToString:@""]) {
            userid = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"];
        }
        
        if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isEqualToString:@""]) {
            usertoken = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"];
        }
        [self performSelectorOnMainThread:@selector(sendtoWap) withObject:nil waitUntilDone:YES];
    }
}


@end
