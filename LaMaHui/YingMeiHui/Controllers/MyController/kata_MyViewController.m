//
//  kata_MyViewController.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-8.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "kata_MyViewController.h"
#import "kata_UserManager.h"
#import "KTUserInfoGetRequest.h"
#import "kata_AddressListViewController.h"
#import "kata_OrderManageViewController.h"
#import "kata_WalletViewController.h"
#import "kata_FeedbackManageViewController.h"
#import "kata_AboutViewController.h"
#import "kata_SettingsViewController.h"
#import "UserInfoVO.h"
#import "kata_FavListViewController.h"
#import "kata_QAListViewController.h"
#import "kata_CartManager.h"
#import "kata_CouponViewController.h"
#import "BDProgressHUD.h"
#import "kata_AppDelegate.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "LMHMybabyViewController.h"
#import "LMHPersonInfoViewController.h"
#import "kata_AllOrderListViewController.h"
#import "kata_OrderManageViewController.h"
#import "LMHContectServiceViewController.h"
#import "LMHinformationBoxListController.h"

@interface kata_MyViewController ()
{
    UIButton *_nopayListBtn;
    UIButton *_nosendListBtn;
    UIButton *_norecvListBtn;
    UIButton *_returnBtn;
    UIButton *_favListBtn;
    UILabel *_nopayCountLbl;
    UIView *_nopayBgView;
    UILabel *_payedCountLbl;
    UIView *_payedBgView;
    UILabel *_postBuyCountLbl;
    UIView *_postBuyBgView;
    UIButton *_loginBtn;
    UIButton *_registerBtn;
    UIView *_welcomeView;
    UIView *_userView;
    UILabel *_userNameLbl;
    UIImageView *_userImageView;
    UIImageView *_vipImageView;//vip1@2x
    NSString *_VIPstr;
    NSString *_VIPNameStr;
    UILabel *_leftMoneyLbl;
    UILabel *_usableMoneyLabel;
    UIBarButtonItem *_menuItem;
    UIView *_headerView;
    UIButton *_settingsBtn;
    UIBarButtonItem *_settingsItem;
    UILabel *_phoneLbl;
    UILabel *_serviceLbl;
    
    UIImageView *goView;
    UIView *headView;
    
    
    NSString *userIconStr; //用户头像
}

@property (strong, nonatomic) NSMutableArray *tableData;

@end

@implementation kata_MyViewController

- (id)initWithIsRoot:(BOOL)isroot
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
        self.ifAddPullToRefreshControl = NO;
    
        _isroot = isroot;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([[kata_UserManager sharedUserManager] isLogin]) {
        [self getUserInfoOperation];
    } else {
        [self layoutUserView:nil];
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;  //去掉系统的row分隔线
    self.tableView.bounces = NO;
    
    UITabBar *tabBar = self.tabBarController.tabBar;
    UITabBarItem *tabBarItem4 = [tabBar.items objectAtIndex:4];
    //未支付订单数量更新
    NSNumber *wntValue = [[kata_UserManager sharedUserManager] userWaitPayCnt];
    if ([wntValue intValue]>0) {
        [tabBarItem4 setBadgeValue:[[[kata_UserManager sharedUserManager] userWaitPayCnt] stringValue]];
    }else{
        [tabBarItem4 setBadgeValue:0];
    }
    
    //判断是否登录
    if ([[kata_UserManager sharedUserManager] isLogin]) {
        [goView setHidden:NO];
        
        //个人信息 点击
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoTaped:)];
        [headView addGestureRecognizer:tapGesture];
    }else{
        [goView setHidden:YES];
        for (UIGestureRecognizer *ges in headView.gestureRecognizers) {
            [headView removeGestureRecognizer:ges];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.hidesBottomBarWhenPushed = YES;
    if (!_settingsItem) {
        
        //设置
        UIButton * settingsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [settingsBtn setFrame:CGRectMake(0, 0, 22, 22)];
        [settingsBtn setBackgroundImage:[UIImage imageNamed:@"icon_setting"] forState:UIControlStateNormal];
        
        [settingsBtn addTarget:self action:@selector(informationBtnPress) forControlEvents:UIControlEventTouchUpInside];
        _settingsBtn = settingsBtn;
        _settingsItem = [[UIBarButtonItem alloc] initWithCustomView:settingsBtn];
    }
//    [self.navigationController addRightBarButtonItem:_settingsItem animation:NO];
    [[(kata_AppDelegate *)[[UIApplication sharedApplication] delegate] deckController] setPanningMode:IIViewDeckNoPanning];
}
- (void)informationBtnPress
{
    LMHinformationBoxListController *informationBoxListController = [[LMHinformationBoxListController alloc]init];
    informationBoxListController.navigationController = self.navigationController;
    [self.navigationController pushViewController:informationBoxListController animated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"个人中心";
    
    [self createUI];
    [self layoutUserView:nil];
    
    //接收通知 
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changePersonInfoNickName:) name:@"changeMycontrollerUserIcon" object:nil];
    
    
}
//接收到通知后会调用
- (void)changePersonInfoNickName:(NSNotification *)notify
{
    if ([notify.object isKindOfClass:[NSString class]]) {
        
        //[_userImageView sd_setImageWithURL:[NSURL URLWithString:notify.object]];

    }

}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)tableData
{
    if(!_tableData){
        _tableData = [NSMutableArray arrayWithCapacity:3];
        
        NSString *titleStr = @"全部订单    汇特卖订单/淘宝订单";
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:titleStr];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.65 green:0.65 blue:0.65 alpha:1] range:NSMakeRange(8,titleStr.length-8)];
        [str addAttribute:NSFontAttributeName value:FONT(15.0) range:NSMakeRange(0,8)];
        [str addAttribute:NSFontAttributeName value:FONT(11.0) range:NSMakeRange(8,titleStr.length-8)];
        
        [_tableData addObject:[NSArray arrayWithObjects:
                               @{@"icon":@"icon_allOrder"      ,@"title":str,@"classname":@"nil"}, nil]];
        [_tableData addObject:[NSArray arrayWithObjects:
                               @{@"icon":@"icon_myCollector"   ,@"title":@"我的收藏",@"classname":@"nil"},
                               @{@"icon":@"icon_discountcoupon",@"title":@"优惠券",@"classname":@"nil"},
                               @{@"icon":@"icon_myBaby"   ,@"title":@"我的宝宝",@"classname":@"nil"},nil]];
        [_tableData addObject:[NSArray arrayWithObjects:
                               @{@"icon":@"icon_tsukkomi"      ,@"title":@"不爽吐槽扔鸡蛋",@"classname":@"nil"},
                               @{@"icon":@"icon_call"          ,@"title":@"辣妈客服",@"classname":@"nil"}, nil]];
        [_tableData addObject:[NSArray arrayWithObjects:
                               @{@"icon":@"icon_set"      ,@"title":@"设置",@"classname":@"nil"},nil]];
        
    }
    
    return _tableData;
}


- (void)createUI
{
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor colorWithRed:1 green:0.97 blue:0.97 alpha:1]];
    [self.tableView setSectionHeaderHeight:12.0];
    [self.tableView setSectionFooterHeight:0.0];
    CGRect tableFrame =  self.tableView.frame;
    tableFrame.size.height -= 49;
    self.tableView.frame=tableFrame;
    
    if (!_headerView) {
        CGFloat w = CGRectGetWidth(self.view.bounds);
        CGFloat height = 90; // 130
        
        headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, height + 70)];
        headView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *headerBg = [[UIImageView alloc] init];
        headerBg.image = [UIImage imageNamed:@"bg_userInfo"];
        headerBg.userInteractionEnabled  = YES;
        [headerBg setFrame:CGRectMake(0, 0, w, height)];
        [headView addSubview:headerBg];
        
        goView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenW - 28, 25, 20, 25)];
        goView.image = [UIImage imageNamed:@"icon_goPersonInfo"];
        [headView addSubview:goView];
        
        if (!_nopayListBtn) {
            _nopayListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_nopayListBtn setBackgroundColor:[UIColor clearColor]];
            [_nopayListBtn setFrame:CGRectMake(0, 90, w/4, 70)];
            [_nopayListBtn addTarget:self action:@selector(nopayBtnPressed) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *btnTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, CGRectGetWidth(_nopayListBtn.frame), 17)];
            [btnTitle setFont:[UIFont boldSystemFontOfSize:13.0]];
            [btnTitle setBackgroundColor:[UIColor clearColor]];
            [btnTitle setTextColor:[UIColor grayColor]];
            [btnTitle setTextAlignment:NSTextAlignmentCenter];
            [btnTitle setText:@"待付款"];
            [_nopayListBtn addSubview:btnTitle];
            
            UIImageView *btnBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 85, CGRectGetWidth(_nopayListBtn.frame), 60)];
            [btnBg setImage:[UIImage imageNamed:@"icon_waitPay"]];
            [btnBg setContentMode:UIViewContentModeCenter];
            [headView addSubview:btnBg];
            
            _nopayCountLbl = [[UILabel alloc] initWithFrame:CGRectMake(55, 10, 0, 15)];
            [_nopayCountLbl setBackgroundColor:[UIColor clearColor]];
            [_nopayCountLbl setFont:[UIFont boldSystemFontOfSize:9]];
            [_nopayCountLbl setTextAlignment:NSTextAlignmentCenter];
            [_nopayCountLbl setTextColor:[UIColor whiteColor]];
            
            _nopayBgView = [[UIView alloc] initWithFrame:_nopayCountLbl.frame];
            [_nopayBgView setBackgroundColor:[UIColor colorWithRed:1 green:0.39 blue:0.01 alpha:1]];
            [_nopayBgView.layer setCornerRadius:7.5];
            
            [_nopayListBtn addSubview:_nopayBgView];
            [_nopayListBtn addSubview:_nopayCountLbl];
            [headView addSubview:_nopayListBtn];
        }
        
        if (!_nosendListBtn) {
            _nosendListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_nosendListBtn setBackgroundColor:[UIColor clearColor]];
            [_nosendListBtn setFrame:CGRectMake(w/4, 90, w/4, 70)];
            [_nosendListBtn addTarget:self action:@selector(payedBtnPressed) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *btnTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, CGRectGetWidth(_nosendListBtn.frame), 17)];
            [btnTitle setFont:[UIFont boldSystemFontOfSize:13.0]];
            [btnTitle setBackgroundColor:[UIColor clearColor]];
            [btnTitle setTextColor:[UIColor grayColor]];
            [btnTitle setTextAlignment:NSTextAlignmentCenter];
            [btnTitle setText:@"待发货"];
            [_nosendListBtn addSubview:btnTitle];
            
            UIImageView *btnBg = [[UIImageView alloc] initWithFrame:CGRectMake(w/4, 85, CGRectGetWidth(_nosendListBtn.frame), 60)];
            [btnBg setImage:[UIImage imageNamed:@"icon_nosend"]];
            [btnBg setContentMode:UIViewContentModeCenter];
            [headView addSubview:btnBg];
            
            [headView addSubview:_nosendListBtn];
        }
        
        if (!_norecvListBtn) {
            _norecvListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_norecvListBtn setBackgroundColor:[UIColor clearColor]];
            [_norecvListBtn setFrame:CGRectMake(w/4*2, 90, w/4, 70)];
            [_norecvListBtn addTarget:self action:@selector(norecvBtnPressed) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *btnTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, CGRectGetWidth(_norecvListBtn.frame), 17)];
            [btnTitle setFont:[UIFont boldSystemFontOfSize:13.0]];
            [btnTitle setBackgroundColor:[UIColor clearColor]];
            [btnTitle setTextColor:[UIColor grayColor]];
            [btnTitle setTextAlignment:NSTextAlignmentCenter];
            [btnTitle setText:@"待收货"];
            [_norecvListBtn addSubview:btnTitle];
            
            UIImageView *btnBg = [[UIImageView alloc] initWithFrame:CGRectMake(w/4*2, 85, CGRectGetWidth(_norecvListBtn.frame), 60)];
            [btnBg setImage:[UIImage imageNamed:@"icon_norecv"]];
            [btnBg setContentMode:UIViewContentModeCenter];
            [headView addSubview:btnBg];
            
            [headView addSubview:_norecvListBtn];
        }
        
        if (!_returnBtn) {
            _returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_returnBtn setBackgroundColor:[UIColor clearColor]];
            [_returnBtn setFrame:CGRectMake(w/4*3, 90, w/4, 70)];
            [_returnBtn addTarget:self action:@selector(returnBtnPressed) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *btnTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, CGRectGetWidth(_returnBtn.frame), 17)];
            [btnTitle setFont:[UIFont boldSystemFontOfSize:13.0]];
            [btnTitle setBackgroundColor:[UIColor clearColor]];
            [btnTitle setTextColor:[UIColor grayColor]];
            [btnTitle setTextAlignment:NSTextAlignmentCenter];
            [btnTitle setText:@"退款订单"];
            [_returnBtn addSubview:btnTitle];
            
            UIImageView *btnBg = [[UIImageView alloc] initWithFrame:CGRectMake(w/4*3, 85, CGRectGetWidth(_returnBtn.frame), 60)];
            [btnBg setImage:[UIImage imageNamed:@"icon_returnMoney"]];
            [btnBg setContentMode:UIViewContentModeCenter];
            [headView addSubview:btnBg];
            
            [headView addSubview:_returnBtn];
        }
        
        [self.tableView setTableHeaderView:headView];
        
        //未登录
        if (!_welcomeView) {
            _welcomeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 75.0f)];
            UILabel *welcomeLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, w, 14)];
            [welcomeLbl setBackgroundColor:[UIColor clearColor]];
            [welcomeLbl setFont:[UIFont boldSystemFontOfSize:14.0]];
            [welcomeLbl setTextAlignment:NSTextAlignmentCenter];
            [welcomeLbl setTextColor:[UIColor whiteColor]];
            [welcomeLbl setText:@"您尚未登录"];
            [_welcomeView addSubview:welcomeLbl];
            
            if (!_loginBtn) {
                _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [_loginBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
                [_loginBtn setTitleColor:[UIColor colorWithRed:0.96 green:0.31 blue:0.41 alpha:1] forState:UIControlStateNormal];
                [_loginBtn.layer setCornerRadius:15];
                [_loginBtn.layer setBackgroundColor:[UIColor whiteColor].CGColor];
                [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
                [_loginBtn setFrame:CGRectMake((ScreenW - 200)/3, 35, 100, 30)];
                [_loginBtn addTarget:self action:@selector(loginBtnPressed) forControlEvents:UIControlEventTouchUpInside];
            }
            
            if (!_registerBtn) {
                _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [_registerBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
                [_registerBtn setTitleColor:[UIColor colorWithRed:0.96 green:0.31 blue:0.41 alpha:1] forState:UIControlStateNormal];
                [_registerBtn.layer setCornerRadius:15];
                [_registerBtn.layer setBackgroundColor:[UIColor whiteColor].CGColor];
                [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
                [_registerBtn setFrame:CGRectMake(CGRectGetMaxX(_loginBtn.frame)+(ScreenW - 200)/3, CGRectGetMinY(_loginBtn.frame), CGRectGetWidth(_loginBtn.frame), CGRectGetHeight(_loginBtn.frame))];
                [_registerBtn addTarget:self action:@selector(registerBtnPressed) forControlEvents:UIControlEventTouchUpInside];
            }
            [_welcomeView addSubview:_registerBtn];
            [_welcomeView addSubview:_loginBtn];
        }
        
        //已登陆
        if (!_userView) {
            _userView = [[UIView alloc] initWithFrame:_welcomeView.frame];
            if (!_vipImageView) {
                
                _vipImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
//                _vipImageView.image = [UIImage imageNamed:@"vip1"];
            }
            [_userView addSubview:_vipImageView];
            
            if (!_userImageView) {
                _userImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 11, 63, 63)];
                //对图片进行圆角处理
                _userImageView.layer.borderWidth = 0.1;
                _userImageView.layer.borderColor = [[UIColor colorWithRed:0.95 green:0.78 blue:0.8 alpha:1]CGColor];
                _userImageView.layer.cornerRadius = 63/2;   //圆角度
                _userImageView.layer.masksToBounds = YES;   //去掉圆角外 多余部分
                _userImageView.contentMode = UIViewContentModeScaleAspectFill;
            }
            [_userView addSubview:_userImageView];
            
            if (!_userNameLbl) {
                
                _userNameLbl = [[UILabel alloc] initWithFrame:CGRectZero];
                [_userNameLbl setTextAlignment:NSTextAlignmentLeft];
                [_userNameLbl setNumberOfLines:1];
                [_userNameLbl setLineBreakMode:NSLineBreakByTruncatingMiddle];
                [_userNameLbl setFont:FONT(16)];
                [_userNameLbl setTextColor:[UIColor whiteColor]];
                [_userNameLbl setBackgroundColor:[UIColor clearColor]];
            }
            [_userView addSubview:_userNameLbl];
            
            if (!_leftMoneyLbl) { //全部金豆
                _leftMoneyLbl = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 100, 18)];
                [_leftMoneyLbl setTextAlignment:NSTextAlignmentLeft];
                [_leftMoneyLbl setNumberOfLines:1];
                _leftMoneyLbl.lineBreakMode = NSLineBreakByTruncatingTail;
                [_leftMoneyLbl setFont:[UIFont boldSystemFontOfSize:14.0]];
                [_leftMoneyLbl setTextColor:[UIColor whiteColor]];
                [_leftMoneyLbl setBackgroundColor:[UIColor clearColor]];
            }
            [_userView addSubview:_leftMoneyLbl];
            
            if (!_usableMoneyLabel) {//可用金豆
                _usableMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 50, 100, 18)];
                [_usableMoneyLabel setTextAlignment:NSTextAlignmentLeft];
                [_usableMoneyLabel setNumberOfLines:1];
                _usableMoneyLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                [_usableMoneyLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
                [_usableMoneyLabel setTextColor:[UIColor whiteColor]];
                [_usableMoneyLabel setBackgroundColor:[UIColor clearColor]];
            }
            [_userView addSubview:_usableMoneyLabel];
        }
        
        if ([[kata_UserManager sharedUserManager] isLogin]) {
            [_welcomeView setHidden:YES];
            [_userView setHidden:NO];
            [goView setHidden:NO];
        } else {
            [_welcomeView setHidden:NO];
            [_userView setHidden:YES];
            [goView setHidden:YES];
        }
        
        [headView addSubview:_welcomeView];
        [headView addSubview:_userView];
        _headerView = headView;
    }
}
- (void)userInfoTaped:(UITapGestureRecognizer *)tap
{
    //  去个人信息、
    
    LMHPersonInfoViewController *personInfo = [[LMHPersonInfoViewController alloc]init];
    personInfo.hideNavigationBarWhenPush = YES;
    personInfo.navigationController = self.navigationController;
    
    personInfo.userNameStr = _userNameLbl.text;
    personInfo.iconViewURL = userIconStr;
    personInfo.VIPRankStr = _VIPstr;
    personInfo.VIPNameStr = _VIPNameStr;
    
    
    [self.navigationController pushViewController:personInfo animated:YES];
    
}

- (void)layoutUserView:(UserInfoVO *)userInfo
{
    if (userInfo) {
        if (userInfo.UserName) {
            
            CGSize size = [userInfo.UserName sizeWithFont:FONT(16) constrainedToSize:CGSizeMake(ScreenW - 100 -30, 18)];
            
            _userNameLbl.frame = CGRectMake(100, 20, size.width, 18);        //用户名坐标
            _vipImageView.frame = CGRectMake(100+size.width+8, 18, 22, 17); //vip 标志坐标
            
            [_userNameLbl setText:[NSString stringWithFormat:@"%@",userInfo.UserName]];
        }
        
        if (userInfo.Money) {
//            [_leftMoneyLbl setText:[NSString stringWithFormat:@"金豆：%@", userInfo.Money]];
        }
        
        if (userInfo.WaitPayNum && [userInfo.WaitPayNum integerValue] != 0) {
            [_nopayCountLbl setText:[NSString stringWithFormat:@"%@", userInfo.WaitPayNum]];
            CGSize size = [_nopayCountLbl.text sizeWithFont:_nopayCountLbl.font];
            [_nopayCountLbl setFrame:CGRectMake(CGRectGetMinX(_nopayCountLbl.frame), CGRectGetMinY(_nopayCountLbl.frame), size.width + 9, CGRectGetHeight(_nopayCountLbl.frame))];
            [_nopayBgView setFrame:_nopayCountLbl.frame];
            [_nopayCountLbl setHidden:NO];
            [_nopayBgView setHidden:NO];
        } else {
            [_nopayCountLbl setHidden:YES];
            [_nopayBgView setHidden:YES];
        }
        
        if (userInfo.PayedNum && [userInfo.PayedNum intValue] != 0) {
            [_payedCountLbl setText:[NSString stringWithFormat:@"%@", userInfo.PayedNum]];
            CGSize size = [_payedCountLbl.text sizeWithFont:_payedCountLbl.font];
            [_payedCountLbl setFrame:CGRectMake(CGRectGetMinX(_payedCountLbl.frame), CGRectGetMinY(_payedCountLbl.frame), size.width + 9, CGRectGetHeight(_payedCountLbl.frame))];
            [_payedBgView setFrame:_payedCountLbl.frame];
            [_payedCountLbl setHidden:NO];
            [_payedBgView setHidden:NO];
        } else {
            [_payedCountLbl setHidden:YES];
            [_payedBgView setHidden:YES];
        }
        
        if (userInfo.AfterSaleNum && [userInfo.AfterSaleNum intValue] != 0) {
            [_postBuyCountLbl setText:[NSString stringWithFormat:@"%@", userInfo.AfterSaleNum]];
            CGSize size = [_postBuyCountLbl.text sizeWithFont:_postBuyCountLbl.font];
            [_postBuyCountLbl setFrame:CGRectMake(CGRectGetMinX(_postBuyCountLbl.frame), CGRectGetMinY(_postBuyCountLbl.frame), size.width + 9, CGRectGetHeight(_postBuyCountLbl.frame))];
            [_postBuyBgView setFrame:_postBuyCountLbl.frame];
            [_postBuyCountLbl setHidden:NO];
            [_postBuyBgView setHidden:NO];
        } else {
            [_postBuyCountLbl setHidden:YES];
            [_postBuyBgView setHidden:YES];
        }
    } else {
//        [_userNameLbl setText:@"账户："];
//        [_leftMoneyLbl setText:@"余额："];
    }
    
    if ([[kata_UserManager sharedUserManager] isLogin]) {
        [_welcomeView setHidden:YES];
        [_userView setHidden:NO];
    } else {
        [_welcomeView setHidden:NO];
        [_userView setHidden:YES];
        [_nopayCountLbl setHidden:YES];
        [_nopayBgView setHidden:YES];
        [_payedCountLbl setHidden:YES];
        [_payedBgView setHidden:YES];
        [_postBuyCountLbl setHidden:YES];
        [_postBuyBgView setHidden:YES];
    }
}

- (void)nopayBtnPressed
{
    if (![[kata_UserManager sharedUserManager] isLogin]) {
        [kata_LoginViewController showInViewController:self];
        return;
    }
    kata_OrderManageViewController *orderListVC = [[kata_OrderManageViewController alloc]initIndex:1 andType:0];
    orderListVC.navigationController = self.navigationController;
    orderListVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderListVC animated:YES];
    
}
- (void)payedBtnPressed
{
    if (![[kata_UserManager sharedUserManager] isLogin]) {
        [kata_LoginViewController showInViewController:self];
        return;
    }
    kata_OrderManageViewController *orderListVC = [[kata_OrderManageViewController alloc]initIndex:2 andType:0];
    orderListVC.navigationController = self.navigationController;
    orderListVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderListVC animated:YES];

}

- (void)norecvBtnPressed{
    if (![[kata_UserManager sharedUserManager] isLogin]) {
        [kata_LoginViewController showInViewController:self];
        return;
    }
    kata_OrderManageViewController *orderListVC = [[kata_OrderManageViewController alloc]initIndex:3 andType:0];
    orderListVC.navigationController = self.navigationController;
    orderListVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderListVC animated:YES];
}

- (void)postBuyBtnPressed
{
    if (![[kata_UserManager sharedUserManager] isLogin]) {
        [kata_LoginViewController showInViewController:self];
        return;
    }
    
    kata_OrderManageViewController *orderVC = [[kata_OrderManageViewController alloc] initWithNibName:nil bundle:nil];
    orderVC.navigationController = self.navigationController;
    orderVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderVC animated:YES];
}

- (void)returnBtnPressed
{
    if (![[kata_UserManager sharedUserManager] isLogin]) {
        [kata_LoginViewController showInViewController:self];
        return;
    }
    kata_OrderManageViewController *orderListVC = [[kata_OrderManageViewController alloc]initIndex:0 andType:1];
    orderListVC.navigationController = self.navigationController;
    orderListVC.hidesBottomBarWhenPushed = YES;
    orderListVC.orderType = 1;//退款订单管理
    [self.navigationController pushViewController:orderListVC animated:YES];
    
//    kata_OrderManageViewController *orderListVC = [[kata_OrderManageViewController alloc] initWithNibName:nil bundle:nil];
//    orderListVC.navigationController = self.navigationController;
//    orderListVC.orderType = 1;//退款订单管理
//    orderListVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:orderListVC animated:YES];
}

- (void)loginBtnPressed
{
    if (![[kata_UserManager sharedUserManager] isLogin]) {
        [kata_LoginViewController showInViewController:(id)self];
        return;
    }
}

- (void)registerBtnPressed
{
    kata_RegisterViewController *regVC = [[kata_RegisterViewController alloc] initWithNibName:nil bundle:nil];
    regVC.regViewDelegate = self;
    regVC.navigationController = self.navigationController;
    [self.navigationController pushViewController:regVC animated:YES];
    
}

- (void)logoutBtnPressed
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提醒"
                          message:@"确定退出账号"
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:@"取消", nil];
    alert.tag = 100001;
    [alert show];
}

- (void)settingsBtnPressed
{
    kata_SettingsViewController *settingsVC = [[kata_SettingsViewController alloc] initWithNibName:nil bundle:nil];
    settingsVC.navigationController = self.navigationController;
    [self.navigationController pushViewController:settingsVC animated:YES];
}

#pragma mark - GetUserInfoRequest
- (void)getUserInfoOperation
{
    KTBaseRequest *req = [[KTBaseRequest alloc] init];
    
    NSString *userid = nil;
    NSString *usertoken = nil;
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isEqualToString:@""]) {
        userid = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"];
    }
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isEqualToString:@""]) {
        usertoken = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"];
    }
    
    if (userid && usertoken) {
        req = [[KTUserInfoGetRequest alloc] initWithUserID:[userid integerValue]
                                              andUserToken:usertoken];
    }
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(getUserInfoParseResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        [[kata_UserManager sharedUserManager] updateWaitPayCnt:[NSNumber numberWithInteger:0]];
        [self performSelectorOnMainThread:@selector(updateWaitPay) withObject:nil waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (void)getUserInfoParseResponse:(NSString *)resp
{
    NSString *hudPrefixStr = @"获取用户信息";
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            if (nil != [respDict objectForKey:@"data"] && ![[respDict objectForKey:@"data"] isEqual:[NSNull null]] && [[respDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dataObj = (NSDictionary *)[respDict objectForKey:@"data"];
                
                _VIPNameStr = [dataObj objectForKey:@"vip_name"]; //VIP 名称
                
                _VIPstr = [dataObj objectForKey:@"vip"];     //VIP 等级
                if ([_VIPstr intValue]== 1) {
                    _vipImageView.image = [UIImage imageNamed:@"vip1"];
                }
                if ([_VIPstr intValue] == 2) {
                    _vipImageView.image = [UIImage imageNamed:@"vip2"];
                }
                if ([_VIPstr intValue] == 3) {
                    _vipImageView.image = [UIImage imageNamed:@"vip3"];
                }
                if ([_VIPstr intValue] == 4) {
                    _vipImageView.image = [UIImage imageNamed:@"vip4"];
                }
                if ([_VIPstr intValue] == 5) {
                    _vipImageView.image = [UIImage imageNamed:@"vip5"];
                }
                
                //用户头像
                userIconStr = [dataObj objectForKey:@"user_image"];
                
                [[SDImageCache sharedImageCache] clearDisk];
                [[SDImageCache sharedImageCache] clearMemory];
                
                //文件管理器
                NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSString *imageFilePath = [documentsPath stringByAppendingPathComponent:@"usericonFile"];
                // 创建目录
                [fileManager createDirectoryAtPath:imageFilePath withIntermediateDirectories:YES attributes:nil error:nil];
                NSString *imageFile = [imageFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"usericon.png"]];
                _userImageView.image = [UIImage imageWithContentsOfFile:imageFile]?[UIImage imageWithContentsOfFile:imageFile]:[UIImage imageNamed:@"defaultIcon"];
                
                [self performSelector:@selector(downIcon:) withObject:imageFile afterDelay:3.0];
                
                NSInteger totalJifen = [[dataObj objectForKey:@"credit"] integerValue]+[[dataObj objectForKey:@"freeze_credit"] integerValue]; //全部金豆
                
                _leftMoneyLbl.text = [NSString stringWithFormat:@"全部金豆:%zi",totalJifen];
                _usableMoneyLabel.text = [NSString stringWithFormat:@"可用金豆:%@",[dataObj objectForKey:@"credit"]];
                
                UserInfoVO *vo = [UserInfoVO UserInfoVOWithDictionary:dataObj];
                
                if ([vo.Code intValue] == 0) {
                    
                    [self layoutUserView:vo];
                    NSArray *cartSku = vo.cartSkuArr;
                    
                    NSArray *skuArr = [[kata_CartManager sharedCartManager] cartSkuID];
                    
                    NSInteger skuNum = skuArr.count + cartSku.count;
                    
                    for (NSInteger i = 0; i < skuArr.count; i++) {  
                        for(NSDictionary *dict in cartSku)
                        {
                            if ([[dict objectForKey:@"sku_id"] isEqualToString:skuArr[i]])
                            {
                                skuNum -= 1;
                                break;
                            }
                        }
                    }
                    [[kata_UserManager sharedUserManager] updateWaitPayCnt:vo.WaitPayNum];
                } else {
                    [[kata_UserManager sharedUserManager] updateWaitPayCnt:[NSNumber numberWithInteger:0]];
                    if (vo.Msg) {
                        if ([vo.Msg isKindOfClass:[NSString class]] && ![vo.Msg isEqualToString:@""]) {
                            [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:vo.Msg waitUntilDone:YES];
                        } else {
                            [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[hudPrefixStr stringByAppendingString:@"失败"] waitUntilDone:YES];
                        }
                    } else {
                        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[hudPrefixStr stringByAppendingString:@"失败"] waitUntilDone:YES];
                    }
                    if ([vo.Code intValue] == -102) {
                        [[kata_UserManager sharedUserManager] logout];
                        [self performSelectorOnMainThread:@selector(layoutUserView:) withObject:nil waitUntilDone:YES];
                        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
                    }
                }
            } else {
                [[kata_UserManager sharedUserManager] updateWaitPayCnt:[NSNumber numberWithInteger:0]];
                [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[hudPrefixStr stringByAppendingString:@"失败"] waitUntilDone:YES];
            }
        } else {
            [[kata_UserManager sharedUserManager] updateWaitPayCnt:[NSNumber numberWithInteger:0]];
            id messageObj = [respDict objectForKey:@"msg"];
            if (messageObj) {
                if ([messageObj isKindOfClass:[NSString class]] && ![messageObj isEqualToString:@""]) {
                    [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:messageObj waitUntilDone:YES];
                } else {
                    [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[hudPrefixStr stringByAppendingString:@"失败"] waitUntilDone:YES];
                }
            } else {
                [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[hudPrefixStr stringByAppendingString:@"失败"] waitUntilDone:YES];
            }
        }
    } else {
        [[kata_UserManager sharedUserManager] updateWaitPayCnt:[NSNumber numberWithInteger:0]];
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[hudPrefixStr stringByAppendingString:@"失败"] waitUntilDone:YES];
    }
    [self performSelectorOnMainThread:@selector(updateWaitPay) withObject:nil waitUntilDone:YES];
    
    [[kata_CartManager sharedCartManager] removeCartSku];
}

- (void)downIcon:(NSString *)imageFile{
    [[[UIImageView alloc] init] sd_setImageWithURL:[NSURL URLWithString:userIconStr] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            NSData *imgData = UIImagePNGRepresentation(image);
            [imgData writeToFile:imageFile atomically:YES];
        }
    }];
}

-(void)updateWaitPay{
    UITabBar *tabBar = self.tabBarController.tabBar;
    UITabBarItem *tabBarItem4 = [tabBar.items objectAtIndex:4];
    //未支付订单数量更新
    NSNumber *wntValue = [[kata_UserManager sharedUserManager] userWaitPayCnt];
    if ([wntValue intValue]>0) {
        [tabBarItem4 setBadgeValue:[[[kata_UserManager sharedUserManager] userWaitPayCnt] stringValue]];
    }
    else
    {
        [tabBarItem4 setBadgeValue:0];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark tableView datasource && delegate
////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.tableData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.tableData objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CELL_IDENTIFY ";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *iconImg = [[[self.tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"icon"];
    [cell.imageView setImage:[UIImage imageNamed:iconImg]];
    
    if (indexPath.row == 0 && indexPath.section == 0) {
        NSAttributedString *titleStr = [[[self.tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"title"];
        cell.textLabel.attributedText = titleStr;
    }else{
        NSString *titleStr = [[[self.tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"title"];
        cell.textLabel.text = titleStr;
    }
    
    //分隔线
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW , 0.5)];
            lineView.backgroundColor = GRAY_LINE_COLOR;
            [cell addSubview:lineView];
        }
    }
    if (indexPath.section == 1 ) {
        if (indexPath.row == 0 || indexPath.row == 1) {
            
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(18, 43, ScreenW - 20 , 0.5)];
            lineView.backgroundColor = GRAY_LINE_COLOR;
            [cell addSubview:lineView];
        }
    }
    if (indexPath.section == 2 ) {
        if (indexPath.row == 0 ) {
            
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(18, 43, ScreenW - 20 , 0.5)];
            lineView.backgroundColor = GRAY_LINE_COLOR;
            [cell addSubview:lineView];
        }
    }

    [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    [cell.textLabel setBackgroundColor:[UIColor whiteColor]];
    [cell.textLabel setFont:[UIFont systemFontOfSize:14.0]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    UIImageView *logoutImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_go"]];
    logoutImg.frame = CGRectMake(ScreenW-20, 14.5, 10, 15);
    [cell addSubview:logoutImg];
    
    return cell;
    

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    self.selectedIndexPath = indexPath;
    
    if (section == 0) {
         if (row == 0) {
             
             if (![[kata_UserManager sharedUserManager] isLogin]) {
                 [kata_LoginViewController showInViewController:self];
                 return;
             }
             
             kata_OrderManageViewController *orderVC = [[kata_OrderManageViewController alloc] initIndex:0 andType:0];
             orderVC.navigationController = self.navigationController;
             orderVC.hidesBottomBarWhenPushed = YES;
             [self.navigationController pushViewController:orderVC animated:YES];
        }
    } else if (section == 1) {
        if (row == 0) {
            if (![[kata_UserManager sharedUserManager] isLogin]) {
                [kata_LoginViewController showInViewController:self];
                return;
            }
            
            kata_FavListViewController *favVC = [[kata_FavListViewController alloc] initWithStyle:UITableViewStylePlain];
            favVC.navigationController = self.navigationController;
            [self.navigationController pushViewController:favVC animated:YES];

            
        } else if (row == 1) {
            if (![[kata_UserManager sharedUserManager] isLogin]) {
                [kata_LoginViewController showInViewController:self];
                return;
            }
            //我的优惠券
            kata_CouponViewController *couponVC = [[kata_CouponViewController alloc] initWithStyle:UITableViewStylePlain];
            couponVC.navigationController = self.navigationController;
            [self.navigationController pushViewController:couponVC animated:YES];

        }else if (row == 2){
        
            if (![[kata_UserManager sharedUserManager] isLogin]) {
                [kata_LoginViewController showInViewController:self];
                return;
            }
            LMHMybabyViewController *myBaby = [[LMHMybabyViewController alloc]init];
            myBaby.navigationController = self.navigationController;
            [self.navigationController pushViewController:myBaby animated:YES];
        }
    }
    
    else if (section == 2) {
        if (row == 0) {
//            if (![[kata_UserManager sharedUserManager] isLogin]) {
//                [kata_LoginViewController showInViewController:self];
//                return;
//            }
            
            //  会员留言 不爽吐槽
            kata_FeedbackManageViewController *feedbackVC = [[kata_FeedbackManageViewController alloc] initWithNibName:nil bundle:nil];
            feedbackVC.navigationController = self.navigationController;
            [self.navigationController pushViewController:feedbackVC animated:YES];
        }
        if (row == 1) {
            //  辣妈汇客服
            UIAlertView *hotLineAlertView =[[UIAlertView alloc]
                                            initWithTitle:@"客服热线"
                                            message:[[NSUserDefaults standardUserDefaults] objectForKey:@"service_phone"]
                                            delegate:self
                                            cancelButtonTitle:@"取消"
                                            otherButtonTitles:@"拨打", nil];
            hotLineAlertView.tag = 100002;
            [hotLineAlertView show];
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
//            LMHContectServiceViewController *contect = [[LMHContectServiceViewController alloc]init];
//            contect.navigationController = self.navigationController;
//            self.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:contect animated:YES];
        }
    }else if (section == 3){
    
        [self settingsBtnPressed];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 12;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 12)];
    view.backgroundColor = [UIColor clearColor];
    return view;

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
//    if (section == 1 && [[kata_UserManager sharedUserManager] isLogin]) {
//        return 60;
//    }
    return 0;
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger tag = alertView.tag;
    
    if (tag == 100001) {
        if (buttonIndex == 0) {
            [[kata_UserManager sharedUserManager] logout];
            [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            [self performSelectorOnMainThread:@selector(layoutUserView:) withObject:nil waitUntilDone:YES];
        }
    } else if (tag == 100002) {
        if (buttonIndex == 1) {
            NSURL *hotLineURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"service_phone"]]];
            [[UIApplication sharedApplication] openURL:hotLineURL];
        }
    }
}

#pragma mark - Login Delegate
- (void)didLogin
{
    [self.tableView reloadData];
    [self layoutUserView:nil];
}

- (void)loginCancel
{
    [self.tableView reloadData];
}

#pragma mark - kata_RegisterViewController Delegate
- (void)registerSuccessPop:(NSString *)username
{
    [self.tableView reloadData];
}

@end
