//
//  kata_LoginViewController.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-8.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "kata_LoginViewController.h"
#import "SSCheckBoxView.h"
#import "kata_AppDelegate.h"
#import "kata_UserManager.h"
#import "BOKUNoActionTextField.h"
#import "KTLoginRequest.h"
#import "KTProxy.h"
#import "KTNavigationController.h"
#import "NSString+KTStringHelper.h"
#import "kata_EmailFindBackPwdViewController.h"
#import "kata_CartManager.h"
#import "KTThirdLoginRequest.h"
#import "UMSocial.h"
#import <QuartzCore/QuartzCore.h>
#import "Tools.h"
#import "LMHContectServiceViewController.h"
#import "LMHForgetPasswordViewController.h"

#define TABLEBGCOLOR        [UIColor whiteColor]

@interface kata_LoginViewController ()<UMSocialUIDelegate>
{
    UIButton *_loginMask;
    UITextField *_edittingTF;
    UIView *_footerView;
    UIButton *_registerBtn;
    UIBarButtonItem *_registerItem;
    TencentOAuth *_tencentOAuth;
    
    NSString *Openid;
    NSString *wxUnionid;
    NSString *Type;
    NSString *ThirdUsername;
    BOOL QQ_Flag;
    BOOL WX_Flag;
}

@property (readonly, nonatomic) UITableView *loginFormTableView;
@property (strong, nonatomic) kata_TextField *usernameField;
@property (strong, nonatomic) kata_TextField *passwordField;
@property (strong, nonatomic) UILabel     *errorLabel;   ///////// 错误信息提示框 label
@property (strong, nonatomic) SSCheckBoxView *rememberPswCBox;

- (void)startToLogin;
- (void)hideLoginBoard;
- (void)cancelBtnPressed;
- (void)updateUserInformation:(NSDictionary *)userData;
- (void)resignCurrentFirstResponder;
- (void)emptyFieldBecomeFirstResponder;
- (void)didRegister:(NSNotification *)notification;

@end

@implementation kata_LoginViewController
{
    UIButton *_cancelBtn;
}

@synthesize loginFormTableView = _loginFormTableView;
@synthesize usernameField = _usernameField;
@synthesize passwordField = _passwordField;
@synthesize rememberPswCBox = _rememberPswCBox;

+ (void)showInViewController:(id<LoginDelegate>)mainVC
{
    kata_LoginViewController *loginVC = [[kata_LoginViewController alloc] initWithNibName:nil bundle:nil];
    
    [loginVC setLoginDelegate:mainVC];
    [loginVC showLoginBoardWithAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"登录";
        stateHud = nil;
        QQ_Flag = YES;
        WX_Flag = YES;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRegister:) name:@"didRegister" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginWX:) name:@"WXLOGIN" object:nil];
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.loginFormTableView reloadData];
    QQ_Flag = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]?YES:NO;
    WX_Flag = [WXApi isWXAppInstalled]?YES:NO;

    [self createUI];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.contentView setFrame:self.view.frame];
    if (!IOS_7) {
        CGRect frame = self.contentView.frame;
        frame.origin.y -= 20;
        [self.contentView setFrame:frame];
    }
    self.loginFormTableView.backgroundColor = [UIColor greenColor];
    self.loginFormTableView.scrollEnabled = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[(kata_AppDelegate *)[[UIApplication sharedApplication] delegate] deckController] setPanningMode:IIViewDeckNoPanning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self resignCurrentFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didRegister" object:nil];
}

- (void)createUI
{
    if (!_cancelBtn) {
        UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setFrame:CGRectMake(0, 0, 25, 29)];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
        UIImage *image = [UIImage imageNamed:@"return"];
        [cancelBtn setImage:image forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem * cancelItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
        [self.navigationController addLeftBarButtonItem:cancelItem animation:NO];
        _cancelBtn = cancelBtn;
    }
    
    if (!_registerBtn || !_registerItem) {
        UIButton * registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        registerBtn.backgroundColor = [UIColor clearColor];
        [registerBtn setFrame:CGRectMake(0, 0, 50, 30)];
        [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [registerBtn.titleLabel setFont:FONT(16)];
        [registerBtn addTarget:self action:@selector(registerBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        _registerBtn = registerBtn;
        _registerItem = [[UIBarButtonItem alloc] initWithCustomView:_registerBtn];
    }
    [self.navigationController addRightBarButtonItem:_registerItem animation:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelBtnPressed
{
    if (self.loginDelegate && [self.loginDelegate respondsToSelector:@selector(loginCancel)]) {
        [self.loginDelegate loginCancel];
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)registerBtnPressed
{
    kata_RegisterViewController *regVC = [[kata_RegisterViewController alloc] initWithNibName:nil bundle:nil];
    regVC.regViewDelegate = self;
    regVC.navigationController = self.navigationController;
    [self.navigationController pushViewController:regVC animated:YES];
}

//新浪登录
- (void)loginWithSina
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        [self performSelectorOnMainThread:@selector(loginSinaResult:) withObject:response waitUntilDone:YES];
    });
    
    Type = @"sina";
    //设置回调对象
    [UMSocialControllerService defaultControllerService].socialUIDelegate = self;
}

//qq登录
- (void)loginWithQQ
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        [self performSelectorOnMainThread:@selector(loginSinaResult:) withObject:response waitUntilDone:YES];
    });
    
    Type = @"qq";
    //设置回调对象
    [UMSocialControllerService defaultControllerService].socialUIDelegate = self;
}

- (void)loginWithRenren
{
    
}

- (void)loginWithAlipay
{
    
}

//微信登录
- (void)loginWithWechat
{
//    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
//    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
//        [self performSelectorOnMainThread:@selector(loginSinaResult:) withObject:response waitUntilDone:YES];
//    });
//    
//    Type = @"wxsession";
//    //设置回调对象
//    [UMSocialControllerService defaultControllerService].socialUIDelegate = self;
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}

//微信登录获取access_token
-(void)loginWX:(NSNotification *)sender
{
    NSDictionary *dict = sender.userInfo;
    SendAuthResp *resp = [dict objectForKey:@"resp"];
    if (resp.errCode == 0) {
        NSString *urlStr = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/%@?appid=%@&secret=%@&code=%@&grant_type=authorization_code", @"access_token",WEIXINPAY_APPID,WXSECRET,resp.code];
        NSURL *url= [NSURL URLWithString:urlStr];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        AFHTTPRequestOperation *option = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        option.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        [option setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSData *jsondata = [operation responseData];
             NSString *jsonString = [[NSString alloc]initWithBytes:[jsondata bytes]length:[jsondata length]encoding:NSUTF8StringEncoding];
             NSData *respData = [jsonString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
             NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
             [self performSelector:@selector(getWXInfo:) withObject:respDict];
         }
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             [self textStateHUD:@"网络问题，请检查网络后重试"];
         }];
        
        [option start];
    }
    else if(resp.errCode == -2)
    {
        [self textStateHUD:@"登录取消"];
    }
    else
    {
        [self textStateHUD:@"登录失败，请重试"];
    }
}

//微信登录获取个人信息（昵称，unionid）
-(void)getWXInfo:(NSDictionary *)dict
{
    NSString *urlStr = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@", [dict objectForKey:@"access_token"], [dict objectForKey:@"openid"]];
    NSURL *url= [NSURL URLWithString:urlStr];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *option = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    option.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [option setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *jsondata = [operation responseData];
        
        NSString *jsonString = [[NSString alloc]initWithBytes:[jsondata bytes]length:[jsondata length]encoding:NSUTF8StringEncoding];
        NSData *respData = [jsonString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        ThirdUsername = [respDict objectForKey:@"nickname"];
        Openid = [respDict objectForKey:@"openid"];
        wxUnionid = [respDict objectForKey:@"unionid"];
        Type = @"wx";
        [self thirdLoginRequestOperation];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self textStateHUD:@"网络问题，请检查网络后重试"];
    }];
    
    [option start];
}

//第三方账号实现授权回调
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    [self performSelectorOnMainThread:@selector(loginSinaResult:) withObject:response waitUntilDone:YES];
}

//第三方账号获取结果
- (void)loginSinaResult:(UMSocialResponseEntity *)response{
    if (response.viewControllerType == UMSViewControllerOauth) {
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSDictionary *dict = [response.data objectForKey:Type];
            if([Type isEqualToString:@"wxsession"]){
                Type = @"wx";
            }
            Openid = [dict objectForKey:@"usid"];
            ThirdUsername = [dict objectForKey:@"username"];
            [self performSelector:@selector(thirdLoginRequestOperation) withObject:nil afterDelay:0.5];
        }else if(response.responseCode == UMSResponseCodeCancel){
            [self textStateHUD:@"登录取消"];
        }else{
            [self textStateHUD:@"登录失败，请重试"];
        }
    }
}

- (void)findBackPsw
{
//    kata_EmailFindBackPwdViewController *findbackVC = [[kata_EmailFindBackPwdViewController alloc] initWithNibName:nil bundle:nil];
//    findbackVC.navigationController = self.navigationController;
//    [self.navigationController pushViewController:findbackVC animated:YES];
    
    
//    UIAlertView *hotLineAlertView =[[UIAlertView alloc]
//                                    initWithTitle:@"联系客服，找回密码"
//                                    message:[[NSUserDefaults standardUserDefaults] objectForKey:@"service_phone"]
//                                    delegate:self
//                                    cancelButtonTitle:@"取消"
//                                    otherButtonTitles:@"拨打", nil];
//    hotLineAlertView.tag = 666666;
//    
//    [hotLineAlertView show];
    
    //进入客服
//    LMHContectServiceViewController *contect = [[LMHContectServiceViewController alloc]init];
//    contect.navigationController = self.navigationController;
//    self.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:contect animated:YES];
    
    
    //忘记密码界面
    LMHForgetPasswordViewController *forgetPasswordController = [[LMHForgetPasswordViewController alloc]init];
    forgetPasswordController.navigationController = self.navigationController;
    self.hidesBottomBarWhenPushed  = YES;
    [self.navigationController pushViewController:forgetPasswordController animated:YES];
    
}
#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger tag = alertView.tag;
    
    if (tag == 666666) {
        if (buttonIndex == 1) {
            
            NSURL *hotLineURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"service_phone"]]];
            [[UIApplication sharedApplication] openURL:hotLineURL];
        }
    }
}

- (void)showLoginBoardWithAnimated:(BOOL)animated
{
    if (!self.view.superview) {
        KTNavigationController *nav = [[KTNavigationController alloc] initWithRootViewController:self];
        self.navigationController = nav;
        
        [[(kata_AppDelegate *)[[UIApplication sharedApplication] delegate] rootVC] presentViewController:nav animated:animated completion:^{
            if (self.loginDelegate && [self.loginDelegate respondsToSelector:@selector(loginViewPresented)]) {
                [[self loginDelegate] loginViewPresented];
            }
        }];
    }
}

- (void)hideLoginBoard
{
    UIViewController *_rootVC = [(kata_AppDelegate *)[[UIApplication sharedApplication] delegate] rootVC];
    [_rootVC dismissViewControllerAnimated:NO completion:^{
        if (self.loginDelegate && [self.loginDelegate respondsToSelector:@selector(loginViewDismissed)]) {
            [[self loginDelegate] loginViewDismissed];
        }
    }];
}

- (void)updateUserInformation:(NSDictionary *)userData
{
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithDictionary:userData];
    if (ThirdUsername) {
        [userInfo setObject:@"" forKey:@"username"];
        [userInfo setObject:@"false" forKey:@"rememberPsw"];
    }else{
        [userInfo setObject:self.usernameField.text?self.usernameField.text:[NSNull null] forKey:@"username"];
        [userInfo setObject:self.rememberPswCBox.checked?@"true":@"false" forKey:@"rememberPsw"];
    }
    
    [[kata_UserManager sharedUserManager] updateUserInfo:userInfo];
    
    if (self.rememberPswCBox.checked) {
        [[kata_UserManager sharedUserManager] savePsw:self.passwordField.text];
    } else {
        [[kata_UserManager sharedUserManager] savePsw:nil];
    }
    
    [self performSelectorOnMainThread:@selector(hideLoginBoard) withObject:nil waitUntilDone:YES];
    if (self.loginDelegate && [self.loginDelegate respondsToSelector:@selector(didLogin)]) {
        [[self loginDelegate] didLogin];
    }
}

- (void)resignCurrentFirstResponder
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow endEditing:YES];
}

- (void)emptyFieldBecomeFirstResponder
{
    if ([self.usernameField.text isEqualToString:@""] || !self.usernameField.text) {
        [self.usernameField becomeFirstResponder];
        return;
    }
    if ([self.passwordField.text isEqualToString:@""] || !self.passwordField.text) {
        [self.passwordField becomeFirstResponder];
    }
}

- (void)didRegister:(NSNotification *)notification
{
    self.usernameField.text = [[notification userInfo] objectForKey:@"username"];
    self.passwordField.text = [[notification userInfo] objectForKey:@"password"];
}

#pragma mark - Getter
- (UITableView *)loginFormTableView
{
    if (!_loginFormTableView) {
        _loginFormTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height) style:UITableViewStylePlain];
        _loginFormTableView.delegate = self;
        _loginFormTableView.dataSource = self;
        [_loginFormTableView setBounces:NO];
        [_loginFormTableView setBackgroundView:nil];
        [_loginFormTableView setBackgroundColor:[UIColor whiteColor]];
        [_loginFormTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 15)];
        [_loginFormTableView setTableHeaderView:header];
        UIView *tableBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
        tableBgView.backgroundColor = TABLEBGCOLOR;
        [_loginFormTableView setBackgroundView:tableBgView];
        
        [self.contentView addSubview:_loginFormTableView];
    }
    return _loginFormTableView;
}

#pragma mark - TableView Delegate & DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        CGFloat w = CGRectGetWidth([[UIScreen mainScreen] bounds]);
        CGFloat h = CGRectGetHeight([[UIScreen mainScreen] bounds]);
        
        NSUserDefaults *userDeaufalt = [NSUserDefaults standardUserDefaults];
        BOOL flag = [[userDeaufalt objectForKey:@"third_login_flag"] boolValue];
        if (!_footerView) {
            UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, h - 155)];
            [footerView setBackgroundColor:[UIColor clearColor]];
            
            SSCheckBoxView *remeberpwdCheckbox = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(10, 0, 135, 20) style:kSSCheckBoxViewStyleCustom checked:YES];
            remeberpwdCheckbox.textColorChange = NO;
            [remeberpwdCheckbox setText:@"记住登录密码"];
            remeberpwdCheckbox.tag = 101;
            self.rememberPswCBox = remeberpwdCheckbox;
            
//            [footerView addSubview:remeberpwdCheckbox];
            
            UIButton *findBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [findBackBtn setBackgroundColor:[UIColor clearColor]];
            [findBackBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
            [findBackBtn setFrame:CGRectMake(ScreenW - 80, 8, 80, 20)];
            [findBackBtn setTitleColor:[UIColor colorWithRed:0.21f green:0.21f blue:0.21f alpha:1.00f] forState:UIControlStateNormal];
            [findBackBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
            [findBackBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
            [findBackBtn addTarget:self action:@selector(findBackPsw) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake((80-[findBackBtn.titleLabel.text sizeWithFont:findBackBtn.titleLabel.font].width)/2, 15, [findBackBtn.titleLabel.text sizeWithFont:findBackBtn.titleLabel.font].width, 1)];
            [line setBackgroundColor:[UIColor colorWithRed:0.21f green:0.21f blue:0.21f alpha:1.00f]];
//            [findBackBtn addSubview:line];
            
            [footerView addSubview:findBackBtn];
            
            UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(remeberpwdCheckbox.frame) + 5, ScreenW - 20, 40)];
            UIImage *image = [UIImage imageNamed:@"red_btn_big"];
            image = [image stretchableImageWithLeftCapWidth:10.0f topCapHeight:10.0f];
            [loginBtn setBackgroundImage:image forState:UIControlStateNormal];
            image = [UIImage imageNamed:@"red_btn_big"];
            image = [image stretchableImageWithLeftCapWidth:10.0f topCapHeight:10.0f];
            [loginBtn setBackgroundImage:image forState:UIControlStateHighlighted];
            [loginBtn setBackgroundImage:image forState:UIControlStateSelected];
            [loginBtn setTitle:@"登  录" forState:UIControlStateNormal];
            [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [[loginBtn titleLabel] setFont:[UIFont boldSystemFontOfSize:17.0f]];
            [loginBtn addTarget:self action:@selector(startToLogin) forControlEvents:UIControlEventTouchUpInside];
            [footerView addSubview:loginBtn];
            
            
            //错误信息》》》》》》》》》》》》》》》》》》》》》》》》》》》
            
            self.errorLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenW/2 - 70, CGRectGetMaxY(loginBtn.frame) + 20, 140, 30)];
            self.errorLabel.backgroundColor = [UIColor colorWithRed:1 green:0.67 blue:0.72 alpha:1];
            self.errorLabel.font = FONT(15);
            self.errorLabel.hidden = YES;
            self.errorLabel.textAlignment = NSTextAlignmentCenter;
            self.errorLabel.textColor = [UIColor whiteColor];
            [footerView addSubview:self.errorLabel];
            
            
            UIImageView *dotline = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logindotline"]];
            [dotline setFrame:CGRectMake(10, CGRectGetMaxY(loginBtn.frame) + 80, ScreenW - 20, 1)];
            if (flag) {
                [footerView addSubview:dotline];
            }
            
            UILabel *loginTipLbl = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(footerView.frame) - 130)/2, CGRectGetMaxY(loginBtn.frame) + 72, 130, 16)];
            [loginTipLbl setBackgroundColor:TABLEBGCOLOR];
            [loginTipLbl setTextColor:[UIColor colorWithRed:0.54 green:0.54 blue:0.54 alpha:1]];
            [loginTipLbl setFont:[UIFont boldSystemFontOfSize:13.0]];
            [loginTipLbl setTextAlignment:NSTextAlignmentCenter];
            [loginTipLbl setText:@"第三方账号快速登录"];
            if (flag) {
                [footerView addSubview:loginTipLbl];
            }
            
            UIButton *sinaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            if (!QQ_Flag && !WX_Flag) {
                [sinaBtn setFrame:CGRectMake( w/3, CGRectGetMaxY(loginTipLbl.frame) + 15, w/3+1, 102)];
            }else{
                [sinaBtn setFrame:CGRectMake(-1, CGRectGetMaxY(loginTipLbl.frame) + 15, w / 3 + 1, 102)];
            }
            [sinaBtn setBackgroundColor:[UIColor clearColor]];
            [sinaBtn addTarget:self action:@selector(loginWithSina) forControlEvents:UIControlEventTouchUpInside];
            [sinaBtn setImage:[UIImage imageNamed:@"icon_login_sina"] forState:UIControlStateNormal];
            [sinaBtn setTitleColor:[UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:1] forState:UIControlStateNormal];
            [sinaBtn setTitle:@"新浪微博" forState:UIControlStateNormal];
            [sinaBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
            [sinaBtn setTitleEdgeInsets:UIEdgeInsetsMake(80, -80, 0, 0)];
            [sinaBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 14, 20, 0)];
            [sinaBtn addTarget:self action:@selector(loginWithSina) forControlEvents:UIControlEventTouchUpInside];
            if (flag) {
                [footerView addSubview:sinaBtn];
            }
            
            UIButton *qqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [qqBtn setFrame:CGRectMake(w / 3 - 1, CGRectGetMaxY(loginTipLbl.frame) + 15, w / 3 + 1, 102)];
            [qqBtn setBackgroundColor:[UIColor clearColor]];
            [qqBtn addTarget:self action:@selector(loginWithQQ) forControlEvents:UIControlEventTouchUpInside];
            [qqBtn setImage:[UIImage imageNamed:@"icon_login_QQ"] forState:UIControlStateNormal];
            [qqBtn setTitle:@"QQ" forState:UIControlStateNormal];
            [qqBtn setTitleColor:[UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:1] forState:UIControlStateNormal];
            [qqBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
            [qqBtn setTitleEdgeInsets:UIEdgeInsetsMake(80, -80, 0, 0)];
            [qqBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 14, 20, 0)];
            [qqBtn addTarget:self action:@selector(loginWithQQ) forControlEvents:UIControlEventTouchUpInside];
            if (QQ_Flag && flag) {
                [footerView addSubview:qqBtn];
            }
            
            
            UIButton *renrenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [renrenBtn setFrame:CGRectMake(-1, CGRectGetMaxY(sinaBtn.frame) - 1, w / 2 + 1, 102)];
            [renrenBtn setBackgroundColor:[UIColor whiteColor]];
            [renrenBtn.layer setBorderWidth:1.0];
            [renrenBtn.layer setBorderColor:[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1].CGColor];
            [renrenBtn addTarget:self action:@selector(loginWithRenren) forControlEvents:UIControlEventTouchUpInside];
            [renrenBtn setImage:[UIImage imageNamed:@"renrenlogin"] forState:UIControlStateNormal];
            [renrenBtn setTitle:@"人人网账号" forState:UIControlStateNormal];
            [renrenBtn setTitleColor:[UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:1] forState:UIControlStateNormal];
            [renrenBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
            [renrenBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [renrenBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 25, 0, 0)];
            [renrenBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
//            [footerView addSubview:renrenBtn];
            
            UIButton *alipayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [alipayBtn setFrame:CGRectMake(w / 2 - 1, CGRectGetMaxY(sinaBtn.frame) - 1, w / 2 + 1, 102)];
            [alipayBtn setBackgroundColor:[UIColor whiteColor]];
            [alipayBtn.layer setBorderWidth:1.0];
            [alipayBtn.layer setBorderColor:[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1].CGColor];
            [alipayBtn addTarget:self action:@selector(loginWithAlipay) forControlEvents:UIControlEventTouchUpInside];
            [alipayBtn setImage:[UIImage imageNamed:@"alipaylogin"] forState:UIControlStateNormal];
            [alipayBtn setTitle:@"支付宝账号" forState:UIControlStateNormal];
            [alipayBtn setTitleColor:[UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:1] forState:UIControlStateNormal];
            [alipayBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
            [alipayBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [alipayBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 25, 0, 0)];
            [alipayBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
//            [footerView addSubview:alipayBtn];
            
            UIButton *weixinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            if (!QQ_Flag) {
                [weixinBtn setFrame:CGRectMake(w / 3- 1, CGRectGetMaxY(loginTipLbl.frame) + 15, w / 3 + 1, 102)];
            }else{
                [weixinBtn setFrame:CGRectMake(w/3*2 - 1, CGRectGetMaxY(loginTipLbl.frame) + 15, w / 3 + 1, 102)];
            }
            [weixinBtn setBackgroundColor:[UIColor clearColor]];
            [weixinBtn addTarget:self action:@selector(loginWithAlipay) forControlEvents:UIControlEventTouchUpInside];
            [weixinBtn setImage:[UIImage imageNamed:@"icon_login_weChat"] forState:UIControlStateNormal];
            [weixinBtn setTitle:@"微信" forState:UIControlStateNormal];
            [weixinBtn setTitleColor:[UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:1] forState:UIControlStateNormal];
            [weixinBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
            [weixinBtn setTitleEdgeInsets:UIEdgeInsetsMake(80, -80, 0, 0)];
            [weixinBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 14, 20, 0)];
            [weixinBtn addTarget:self action:@selector(loginWithWechat) forControlEvents:UIControlEventTouchUpInside];
            if (WX_Flag && flag) {
                [footerView addSubview:weixinBtn];
            }
            
            _footerView = footerView;
        }
        return _footerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat h = CGRectGetHeight([[UIScreen mainScreen] bounds]);
    return h - 155;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    CGFloat w = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    
    UITableViewCell *cell = nil;
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.opaque = YES;
    
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(10, 0, w - 20, 36)];
    [bg setBackgroundColor:[UIColor clearColor]];
    [bg setTag:2020];
    [bg.layer setBorderWidth:0.5];
    [bg.layer setBorderColor:[UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1].CGColor];
    [bg.layer setCornerRadius:2.0];
    [cell.contentView addSubview:bg];
    
    switch (row) {
        case 0:
        {
            
            kata_TextField *aUsernameField = [[kata_TextField alloc] initWithFrame:CGRectMake(10, 1, w - 40, 34)];
            aUsernameField.clearButtonMode = UITextFieldViewModeWhileEditing;
            aUsernameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            aUsernameField.autocorrectionType = UITextAutocorrectionTypeNo;
            aUsernameField.placeholder = @"请输入邮箱/手机号";
            aUsernameField.tag = 101;
            aUsernameField.textColor = [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f];
            aUsernameField.font = [UIFont systemFontOfSize:13.0f];
            aUsernameField.keyboardType = UIKeyboardTypeEmailAddress;
            aUsernameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            aUsernameField.delegate = self;
            
            NSDictionary *userInfoData = [[kata_UserManager sharedUserManager] userInfo];
            if (userInfoData && [userInfoData objectForKey:@"username"]) {
                aUsernameField.text = [userInfoData objectForKey:@"username"];
            }
            
            [bg addSubview:aUsernameField];
            self.usernameField = aUsernameField;
            
            
        }
            break;
            
        case 1:
        {
            kata_TextField *aPasswordField = [[kata_TextField alloc] initWithFrame:CGRectMake(10, 1, w - 40, 34)];
            aPasswordField.keyboardType = UIKeyboardTypeASCIICapable;
            aPasswordField.placeholder = @"请输入您的密码";
            aPasswordField.tag = 102;
            aPasswordField.textColor = [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f];
            aPasswordField.font = [UIFont systemFontOfSize:13.0f];
            aPasswordField.returnKeyType = UIReturnKeyNext;
            aPasswordField.secureTextEntry = YES;
            aPasswordField.clearButtonMode = UITextFieldViewModeWhileEditing;
            aPasswordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            aPasswordField.delegate = self;
            
            
            if ([[kata_UserManager sharedUserManager] isRememberPsw]) {
                // 登陆时显示默认密码
//                aPasswordField.text = [[kata_UserManager sharedUserManager] getPsw];
            }
            
            [bg addSubview:aPasswordField];
            self.passwordField = aPasswordField;
        }
            break;
            
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    
    if (section == 0) {
        return 45;
    }
    return 0;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

#pragma mark - UITextField Input Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.usernameField) {
        [self.passwordField becomeFirstResponder];
    } else if (textField == self.passwordField) {
        [textField resignFirstResponder];
        [self startToLogin];
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    //》》》》》》 重新点击输入框的时候 隐藏错误提示的Label
    
    self.errorLabel.hidden = YES;
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self hideInputControl];
    _edittingTF = textField;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:0.3];
    _loginMask.alpha = 1;
    [UIView commitAnimations];
    [self hideInputControl];
    if (_edittingTF && [_edittingTF.superview isKindOfClass:[UIView class]] && _edittingTF.superview.tag == 2020) {
        UIView *bg = _edittingTF.superview;
        [bg.layer setBorderWidth:1.0];
        [bg.layer setBorderColor:[UIColor colorWithRed:0.98 green:0.32 blue:0.44 alpha:1].CGColor];
        [bg.layer setCornerRadius:2.0];
        
        return YES;
    }

    return YES;
}

- (void)hideInputControl
{
	[self resignCurrentFirstResponder];
    
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(removeMask)];
	_loginMask.alpha = 0;
	[UIView commitAnimations];
    
    if (_edittingTF && [_edittingTF.superview isKindOfClass:[UIView class]] && _edittingTF.superview.tag == 2020) {
        UIView *bg = _edittingTF.superview;
        [bg.layer setBorderWidth:0.5];
        [bg.layer setBorderColor:[UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1].CGColor];
        [bg.layer setCornerRadius:2.0];
    }
}

- (void)removeMask
{
	if (_loginMask) {
		[_loginMask removeFromSuperview];
		_loginMask = nil;
	}
}

#pragma mark - UIAlertView Delegation
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 201) {
        [self.usernameField setText:@""];
        [self.usernameField becomeFirstResponder];
    } else if (alertView.tag == 202) {
        [self.passwordField setText:@""];
        [self.passwordField becomeFirstResponder];
    }
}

#pragma mark - Start to Login
- (void)startToLogin
{
    NSString *usernameValue = self.usernameField.text;
    NSString *passwordValue = self.passwordField.text;
    
    if (usernameValue && usernameValue.length > 0 && passwordValue && passwordValue.length > 0) {
        //          账号正则检测：为邮箱格式
        NSString *emailRegex = @"^\\w+((\\-\\w+)|(\\.\\w+))*@[A-Za-z0-9]+((\\.|\\-)[A-Za-z0-9]+)*.[A-Za-z0-9]+$";
        NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        //          密码正则检测：密码不得少于六个字符
        NSString *pwdRegex = @"^.{6,12}$";
        NSPredicate *pwdPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pwdRegex];
        
        if (![emailPredicate evaluateWithObject:usernameValue] &&  ![ Tools isValidateTelephone:usernameValue]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"手机号/邮箱格式错误"
                                                            message:@""
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
            alert.tag = 201;
            [alert show];
        } else if (![pwdPredicate evaluateWithObject:self.passwordField.text]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"密码不合法" message:@"密码长度需在6-20个字符之间" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.tag = 202;
            [alert show];
        } else {
            [self resignCurrentFirstResponder];
            
            [self startLoginRequestOperation];
            
            if (!stateHud) {
                stateHud = [[MBProgressHUD alloc] initWithView:self.contentView];
                stateHud.delegate = self;
                [self.contentView addSubview:stateHud];
            }
            stateHud.mode = MBProgressHUDModeIndeterminate;
            stateHud.labelText = @"正在登录...";
            stateHud.labelFont = [UIFont systemFontOfSize:14.0f];
            [stateHud show:YES];
        }
    } else if (!usernameValue || usernameValue.length == 0) {
        if (!stateHud) {
            stateHud = [[MBProgressHUD alloc] initWithView:self.contentView];
            stateHud.delegate = self;
            [self.contentView addSubview:stateHud];
        }
        stateHud.mode = MBProgressHUDModeText;
        stateHud.yOffset = 50 - CGRectGetHeight(self.contentView.frame) / 2;
        stateHud.labelText = @"用户名不能为空";
        stateHud.labelFont = [UIFont systemFontOfSize:14.0f];
        [stateHud show:YES];
        [stateHud hide:YES afterDelay:1.0];
        
        [self.usernameField becomeFirstResponder];
        return;
    } else if (!passwordValue || passwordValue.length == 0) {
        if (!stateHud) {
            stateHud = [[MBProgressHUD alloc] initWithView:self.contentView];
            stateHud.delegate = self;
            [self.contentView addSubview:stateHud];
        }
        stateHud.mode = MBProgressHUDModeText;
        stateHud.yOffset = 50 - CGRectGetHeight(self.contentView.frame) / 2;
        stateHud.labelText = @"密码不能为空";
        stateHud.labelFont = [UIFont systemFontOfSize:14.0f];
        [stateHud show:YES];
        [stateHud hide:YES afterDelay:1.0];
        
        [self.passwordField becomeFirstResponder];
        return;
    }
}

//字符长度检测
- (NSInteger)convertToInt:(NSString*)strtemp
{
    NSInteger strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (NSInteger i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}

#pragma mark - startLoginRequest
- (void)startLoginRequestOperation
{
    NSString *cartid = nil;
    if ([[kata_CartManager sharedCartManager] hasCartID]) {
        cartid = [[kata_CartManager sharedCartManager] cartID];
    }
    
    KTLoginRequest *req = [[KTLoginRequest alloc] initWithUserName:self.usernameField.text
                                                          password:self.passwordField.text
                                                            cartID:cartid];
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(loginParseResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        stateHud.labelText = @"网络异常";
        stateHud.mode = MBProgressHUDModeText;
        [stateHud show:YES];
        [stateHud hide:YES afterDelay:1.0];
    }];
    
    [proxy start];
}

- (void)loginParseResponse:(NSString *)resp
{
    NSString *errStr = @"";
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            if ([respDict objectForKey:@"data"] != nil && ![[respDict objectForKey:@"data"] isEqual:[NSNull null]]) {
                id dataObj = [respDict objectForKey:@"data"];
                
                if ([dataObj isKindOfClass:[NSDictionary class]]) {
                    NSInteger code = [[dataObj objectForKey:@"code"] integerValue];
                    
                    switch (code) {
                        case 0:
                        {
                            [self performSelectorOnMainThread:@selector(hideHUDView) withObject:nil waitUntilDone:YES];
                            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[dataObj objectForKey:@"user_id"], @"user_id", [dataObj objectForKey:@"user_token"], @"user_token", nil];
                            [self performSelectorOnMainThread:@selector(updateUserInformation:) withObject:dict waitUntilDone:YES];
                            return;
                            
                        }
                            break;
                            
                        default:
                        {
                            [self performSelectorOnMainThread:@selector(hideHUDView) withObject:nil waitUntilDone:YES];
                        }
                            break;
                    }
                } else {
                    [self performSelectorOnMainThread:@selector(hideHUDView) withObject:nil waitUntilDone:YES];
                    errStr = @"登录失败";
                }
                
            } else {

            }
            
        } else {
            
        }
    }
    [self performSelectorOnMainThread:@selector(hideHUDView) withObject:nil waitUntilDone:YES];
    [self performSelector:@selector(showErr:) withObject:errStr afterDelay:0.3];
}

-(void)showErr:(NSString *)errstr{
    if ([errstr isEqualToString:@""]) {
        self.errorLabel.text = @"用户名或密码错误";
    }else{
        self.errorLabel.text = errstr;
    }
    
    self.errorLabel.hidden = NO;
}

- (void)loginStateAlertTitle:(NSDictionary *)alertDict
{
    self.errorLabel.text = [alertDict objectForKey:@"message"];
}

- (void)hideHUDView
{
    [stateHud hide:YES afterDelay:1.0];
}

- (void)checkAlert
{
    [self hideHUDView];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"用户未认证，是否验证"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"去认证", nil];
    alert.tag = 6700001;
    [alert show];
}

#pragma mark - Findback Delegate
- (void)didFindBack{
    
}

#pragma mark - kata_RegisterViewController Delegate
- (void)registerSuccessPop:(NSString *)username
{
    if (username && ![username isEqualToString:@""]) {
        self.usernameField.text = username;
    }
    self.passwordField.text = @"";
    
    [self performSelector:@selector(hideLoginBoard) withObject:nil afterDelay:0.1];
    if (self.loginDelegate && [self.loginDelegate respondsToSelector:@selector(didLogin)]) {
        [[self loginDelegate] didLogin];
    }
}


//第三方登录信息获取
#pragma mark - Third Login
- (void)thirdLoginRequestOperation
{
    NSString *cartid = nil;
    if ([[kata_CartManager sharedCartManager] hasCartID]) {
        cartid = [[kata_CartManager sharedCartManager] cartID];
    }
    
    if (!Openid || !ThirdUsername) {
        stateHud.labelText = @"登录失败，请重试";
        stateHud.mode = MBProgressHUDModeText;
        [stateHud show:YES];
        [stateHud hide:YES afterDelay:0.8];
        return;
    }
    KTThirdLoginRequest *req = [[KTThirdLoginRequest alloc] initWithOpenD:Openid andUnionID:wxUnionid andType:Type andUsername:ThirdUsername andCartID:cartid];
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        [self performSelectorOnMainThread:@selector(thirdLoginParseResponse:) withObject:resp waitUntilDone:YES];
    } failed:^(NSError *error) {
        stateHud.labelText = @"网络异常";
        stateHud.mode = MBProgressHUDModeText;
        [stateHud show:YES];
        [stateHud hide:YES afterDelay:1.0];
    }];
    
    [proxy start];
}

- (void)thirdLoginParseResponse:(NSString *)resp
{
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            if ([respDict objectForKey:@"data"] != nil && ![[respDict objectForKey:@"data"] isEqual:[NSNull null]]) {
                id dataObj = [respDict objectForKey:@"data"];
                
                if ([dataObj isKindOfClass:[NSDictionary class]]) {
                    NSInteger code = [[dataObj objectForKey:@"code"] integerValue];
                    
                    switch (code) {
                        case 0:
                        {
                            [self performSelectorOnMainThread:@selector(hideHUDView) withObject:nil waitUntilDone:YES];
                            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[[dataObj objectForKey:@"user_id"] stringValue], @"user_id", [dataObj objectForKey:@"user_token"], @"user_token", nil];
                            [self performSelectorOnMainThread:@selector(updateUserInformation:) withObject:dict waitUntilDone:YES];
                        }
                            break;
                            
                        default:
                        {
                            [self performSelectorOnMainThread:@selector(hideHUDView) withObject:nil waitUntilDone:YES];
                            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"", @"title", [dataObj objectForKey:@"msg"], @"message", nil];
                            [self performSelectorOnMainThread:@selector(loginStateAlertTitle:) withObject:dict waitUntilDone:YES];
                        }
                            break;
                    }
                } else {
                    [self performSelectorOnMainThread:@selector(hideHUDView) withObject:nil waitUntilDone:YES];
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"", @"title", @"登录失败", @"message", nil];
                    [self performSelectorOnMainThread:@selector(loginStateAlertTitle:) withObject:dict waitUntilDone:YES];
                }
                
            } else {
                [self performSelectorOnMainThread:@selector(hideHUDView) withObject:nil waitUntilDone:YES];
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"", @"title", @"登录失败", @"message", nil];
                [self performSelectorOnMainThread:@selector(loginStateAlertTitle:) withObject:dict waitUntilDone:YES];
            }
            
        } else {
            if ([respDict objectForKey:@"msg"]) {
                if (![[respDict objectForKey:@"msg"] isEqualToString:@""]) {
                    [self performSelectorOnMainThread:@selector(hideHUDView) withObject:nil waitUntilDone:YES];
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"", @"title", [respDict objectForKey:@"msg"], @"message", nil];
                    [self performSelectorOnMainThread:@selector(loginStateAlertTitle:) withObject:dict waitUntilDone:YES];
                } else {
                    [self performSelectorOnMainThread:@selector(hideHUDView) withObject:nil waitUntilDone:YES];
                    NSString *errorStr = @"未知错误";
                    if (![[respDict objectForKey:@"code"] isEqualToString:@""]) {
                        errorStr = [errorStr stringByAppendingFormat:@",错误代码:%@", [respDict objectForKey:@"code"]];
                    }
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"", @"title", errorStr, @"message", nil];
                    [self performSelectorOnMainThread:@selector(loginStateAlertTitle:) withObject:dict waitUntilDone:YES];
                }
            } else {
                [self performSelectorOnMainThread:@selector(hideHUDView) withObject:nil waitUntilDone:YES];
                NSString *errorStr = @"未知错误";
                if (![[respDict objectForKey:@"code"] isEqualToString:@""]) {
                    errorStr = [errorStr stringByAppendingFormat:@",错误代码:%@", [respDict objectForKey:@"code"]];
                }
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"", @"title", errorStr, @"message", nil];
                [self performSelectorOnMainThread:@selector(loginStateAlertTitle:) withObject:dict waitUntilDone:YES];
            }
        }
    }
}


@end
