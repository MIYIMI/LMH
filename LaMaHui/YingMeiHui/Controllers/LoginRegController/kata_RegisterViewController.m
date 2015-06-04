//
//  kata_RegisterViewController.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-15.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "kata_RegisterViewController.h"
#import "KTProxy.h"
#import "KTRegisterRequest.h"
#import "kata_UserManager.h"
#import "NSString+KTStringHelper.h"
#import "kata_CartManager.h"
#import "Tools.h"
#import "LMHSecurityCodeRequest.h"
#import <UIImageView+WebCache.h>
#import "kata_AppDelegate.h"

@interface kata_RegisterViewController ()
{
    UIButton *_registerMask;
    kata_TextField *_edittingTF;
    UIView *_footer;
    UIView *halfview;
    NSMutableString *userStr;
    
    UIButton    *_getSecurityCodeBtn;
    NSTimer *timer;
    NSInteger     secondsCountDown;
    NSString *_picurl;
}

@property (readonly, nonatomic) UITableView *registerFormTableView;
@property (strong, nonatomic) kata_TextField *usernameField;
@property (strong, nonatomic) kata_TextField *securityCodeField;
@property (strong, nonatomic) kata_TextField *passwordField;
@property (strong, nonatomic) kata_TextField *invitationCodeField;
@property (strong, nonatomic) kata_TextField *alipayField;
@property (strong, nonatomic) UIButton    *submitButton;

@end

@implementation kata_RegisterViewController

@synthesize registerFormTableView = _registerFormTableView;
@synthesize usernameField = _usernameField;
@synthesize securityCodeField = _securityCodeField;
@synthesize passwordField = _passwordField;
@synthesize invitationCodeField = _invitationCodeField;
@synthesize alipayField = _alipayField;
@synthesize submitButton = _submitButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"注册";
        userStr = [[NSMutableString alloc] init];
        
        secondsCountDown = 60;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)createUI
{
    _registerFormTableView = [self registerFormTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer *tapZer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView)];
    [self.view addGestureRecognizer:tapZer];
}

- (void)tapView{
    [self.view endEditing:YES];
}

#pragma mark - Getter
- (UITableView *)registerFormTableView
{
    if (!_registerFormTableView) {
        _registerFormTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height) style:UITableViewStylePlain];
        _registerFormTableView.delegate = self;
        _registerFormTableView.dataSource = self;
        [_registerFormTableView setBounces:NO];
        [_registerFormTableView setBackgroundView:nil];
        [_registerFormTableView setBackgroundColor:[UIColor whiteColor]];
        [_registerFormTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 15)];
        [_registerFormTableView setTableHeaderView:header];
        [self.contentView addSubview:_registerFormTableView];
    }
    return _registerFormTableView;
}

- (void)updateUserInformation:(NSDictionary *)userData
{
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithDictionary:userData];
    [userInfo setObject:@"false" forKey:@"rememberPsw"];
    [userInfo setObject:self.usernameField.text?self.usernameField.text:[NSNull null] forKey:@"username"];
    [[kata_UserManager sharedUserManager] updateUserInfo:userData];
    
    [self textStateHUD:@"注册成功"];
    if (self.regViewDelegate && [self.regViewDelegate respondsToSelector:@selector(registerSuccessPop:)]) {
        [[self regViewDelegate] registerSuccessPop:self.usernameField.text];
    }
    
    [self performSelector:@selector(viewSheet) withObject:nil afterDelay:1.0];
}

#pragma mark - 活动弹出窗
-(void)viewSheet{
    if (!halfview) {
        halfview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
        [self.view addSubview:halfview];
        halfview.hidden = YES;
    }
    CGFloat h = CGRectGetHeight(self.view.frame);
    
    UIView *sheetView = [[UIView alloc] initWithFrame:CGRectMake(ScreenW/8, (h-ScreenW/4*3/1.6)/2, ScreenW/4*3, ScreenW/4*3/1.6)];
    sheetView.layer.masksToBounds = YES;
    sheetView.layer.cornerRadius = 10.0;
    UITapGestureRecognizer *sheetTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sheetPushView)];
    [sheetView addGestureRecognizer:sheetTap];
    [halfview addSubview:sheetView];
    
    UIImageView *sheetImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(sheetView.frame), CGRectGetHeight(sheetView.frame))];
    sheetView.layer.masksToBounds = YES;
    sheetImg.layer.cornerRadius = 10.0;
    [sheetView addSubview:sheetImg];
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(sheetView.frame)-10, CGRectGetMinY(sheetView.frame)-10, 20, 20)];
    [cancelBtn setBackgroundImage:LOCAL_IMG(@"icon_close") forState:UIControlStateNormal];
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.layer.cornerRadius = 10.0;
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setBackgroundColor:LMH_COLOR_SKIN];
    [halfview addSubview:cancelBtn];
    NSURL *picUrl;
    if (![_picurl isKindOfClass:[NSNull class]] && _picurl.length > 0) {
        picUrl = [NSURL URLWithString:_picurl];
        [sheetImg sd_setImageWithURL:picUrl placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                halfview.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
                halfview.hidden = NO;
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)cancelClick{
    [halfview setHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)sheetPushView{
    [halfview setHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)submitReg
{
    NSString *usernameValue = self.usernameField.text;
    NSString *securityCodeValue = self.securityCodeField.text;
    NSString *passwordValue = self.passwordField.text;
    
    if (usernameValue && usernameValue.length > 0 && securityCodeValue && securityCodeValue.length > 0 && passwordValue && passwordValue.length > 0) {
        
        if (![Tools isValidateTelephone:usernameValue]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请输入正确的手机号"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
            [self.usernameField becomeFirstResponder];
            
            [alert show];
        }
        else if (securityCodeValue.length != 6) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请输入6位验证码"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
            [self.securityCodeField becomeFirstResponder];
            
            [alert show];
            
            return;
        } else if ((passwordValue.length < 6) || (passwordValue.length > 20)) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"密码为6-20位数字或英文字母"
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil, nil];
            [self.passwordField becomeFirstResponder];
            [alert show];
        } else {
            [self.view endEditing:YES];
            [self registerOperation];
            
            if (!stateHud) {
                stateHud = [[MBProgressHUD alloc] initWithView:self.contentView];
                stateHud.delegate = self;
                [self.contentView addSubview:stateHud];
            }
            stateHud.mode = MBProgressHUDModeIndeterminate;
            stateHud.labelText = @"正在提交..";
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
        stateHud.yOffset = 110 - CGRectGetHeight(self.contentView.frame) / 2;
        stateHud.labelText = @"请输入您的手机号码";
        stateHud.labelFont = [UIFont systemFontOfSize:14.0f];
        [stateHud show:YES];
        [stateHud hide:YES afterDelay:1.0];
        
        [self.usernameField becomeFirstResponder];
        return;
    } else if (!securityCodeValue || securityCodeValue.length == 0) {
        if (!stateHud) {
            stateHud = [[MBProgressHUD alloc] initWithView:self.contentView];
            stateHud.delegate = self;
            [self.contentView addSubview:stateHud];
        }
        stateHud.mode = MBProgressHUDModeText;
        stateHud.yOffset = 110 - CGRectGetHeight(self.contentView.frame) / 2;
        stateHud.labelText = @"请输入验证码";
        stateHud.labelFont = [UIFont systemFontOfSize:14.0f];
        [stateHud show:YES];
        [stateHud hide:YES afterDelay:1.0];
        
        [self.securityCodeField becomeFirstResponder];
        return;
    } else if (!passwordValue || passwordValue.length == 0) {
        if (!stateHud) {
            stateHud = [[MBProgressHUD alloc] initWithView:self.contentView];
            stateHud.delegate = self;
            [self.contentView addSubview:stateHud];
        }
        stateHud.mode = MBProgressHUDModeText;
        stateHud.yOffset = 110 - CGRectGetHeight(self.contentView.frame) / 2;
        stateHud.labelText = @"请输入密码";
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
#pragma mark - 网络请求 解析 -- 获取验证码
- (void)registerOperation_securityCode
{
    if (!stateHud) {
        stateHud = [[MBProgressHUD alloc] initWithView:self.contentView];
        stateHud.delegate = self;
        [self.contentView addSubview:stateHud];
    }
    stateHud.mode = MBProgressHUDModeIndeterminate;
    stateHud.labelFont = [UIFont systemFontOfSize:14.0f];
    [stateHud show:YES];
    
    LMHSecurityCodeRequest *reqs = [[LMHSecurityCodeRequest alloc] initWithMobile:self.usernameField.text];
    
    KTProxy *proxys = [KTProxy loadWithRequest:reqs completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(registerParseResponse_securityCode:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxys start];
}

- (void)registerParseResponse_securityCode:(NSString *)resp
{
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        if ([[respDict objectForKey:@"code"] integerValue] == 0) {
            
            [self performSelectorOnMainThread:@selector(hideHUDView) withObject:nil waitUntilDone:YES];
            
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"提示"
                                  message:@"验证码已成功发送至您的手机"
                                  delegate:self
                                  cancelButtonTitle:@"确定"
                                  otherButtonTitles:nil];
            [alert show];
            
        }else if ([[respDict objectForKey:@"code"] integerValue] == 308){
            [self textStateHUD:@"该号码已注册过辣妈汇"];
        }else{
            [self textStateHUD:@"注册失败"];
        }
    }else{
        [self textStateHUD:@"注册失败"];
    }
}

#pragma mark - 网络请求 解析 -- 注册
- (void)registerOperation
{
    if (!stateHud) {
        stateHud = [[MBProgressHUD alloc] initWithView:self.contentView];
        stateHud.delegate = self;
        [self.contentView addSubview:stateHud];
    }
    stateHud.mode = MBProgressHUDModeIndeterminate;
    stateHud.labelFont = [UIFont systemFontOfSize:14.0f];
    [stateHud show:YES];
    
    NSString *cartid = nil;
    if ([[kata_CartManager sharedCartManager] hasCartID]) {
        cartid = [[kata_CartManager sharedCartManager] cartID];
    }
    
    KTRegisterRequest *req = [[KTRegisterRequest alloc] initWithUserName:self.usernameField.text
                                                                password:self.passwordField.text
                                                               andCartID:cartid
                                                            andSend_code:self.securityCodeField.text
                                                               andAlipay:self.alipayField.text
                                                           andGet_credit:@"1"
                                                           andInvitation:self.invitationCodeField.text];
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(registerParseResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (void)registerParseResponse:(NSString *)resp
{
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            if ([respDict objectForKey:@"data"] != nil && ![[respDict objectForKey:@"data"] isEqual:[NSNull null]]) {
                id dataObj = [respDict objectForKey:@"data"];
                
                if ([dataObj isKindOfClass:[NSDictionary class]] && [dataObj objectForKey:@"user_token"] && [dataObj objectForKey:@"user_id"]) {
                    NSInteger code = [[dataObj objectForKey:@"code"] integerValue];
                    
                    switch (code) {
                        case 0:
                        {
                            [self performSelectorOnMainThread:@selector(hideHUDView) withObject:nil waitUntilDone:YES];
                            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[[dataObj objectForKey:@"user_id"] stringValue], @"user_id", [dataObj objectForKey:@"user_token"], @"user_token", nil];
                            _picurl = [dataObj objectForKey:@"image_url"];
                            [self performSelectorOnMainThread:@selector(updateUserInformation:) withObject:dict waitUntilDone:YES];
                        }
                            break;
                            
                        default:
                        {
                            [self performSelectorOnMainThread:@selector(hideHUDView) withObject:nil waitUntilDone:YES];
                            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"", @"title", [dataObj objectForKey:@"msg"], @"message", nil];
                            [self performSelectorOnMainThread:@selector(regStateAlertTitle:) withObject:dict waitUntilDone:YES];
                        }
                            break;
                    }
                } else {
                    [self performSelectorOnMainThread:@selector(hideHUDView) withObject:nil waitUntilDone:YES];
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"", @"title", @"注册失败", @"message", nil];
                    [self performSelectorOnMainThread:@selector(regStateAlertTitle:) withObject:dict waitUntilDone:YES];
                }
                
            } else {
                [self performSelectorOnMainThread:@selector(hideHUDView) withObject:nil waitUntilDone:YES];
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"", @"title", @"注册失败", @"message", nil];
                [self performSelectorOnMainThread:@selector(regStateAlertTitle:) withObject:dict waitUntilDone:YES];
            }
        } else {
            if ([respDict objectForKey:@"msg"]) {
                if (![[respDict objectForKey:@"msg"] isEqualToString:@""]) {
                    [self performSelectorOnMainThread:@selector(hideHUDView) withObject:nil waitUntilDone:YES];
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"", @"title", [respDict objectForKey:@"msg"], @"message", nil];
                    [self performSelectorOnMainThread:@selector(regStateAlertTitle:) withObject:dict waitUntilDone:YES];
                } else {
                    [self performSelectorOnMainThread:@selector(hideHUDView) withObject:nil waitUntilDone:YES];
                    NSString *errorStr = @"未知错误";
                    if (![[respDict objectForKey:@"code"] isEqualToString:@""]) {
                        errorStr = [errorStr stringByAppendingFormat:@",错误代码:%@", [respDict objectForKey:@"code"]];
                    }
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"", @"title", errorStr, @"message", nil];
                    [self performSelectorOnMainThread:@selector(regStateAlertTitle:) withObject:dict waitUntilDone:YES];
                }
            } else {
                [self performSelectorOnMainThread:@selector(hideHUDView) withObject:nil waitUntilDone:YES];
                NSString *errorStr = @"未知错误";
                if (![[respDict objectForKey:@"code"] isEqualToString:@""]) {
                    errorStr = [errorStr stringByAppendingFormat:@",错误代码:%@", [respDict objectForKey:@"code"]];
                }
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"", @"title", errorStr, @"message", nil];
                [self performSelectorOnMainThread:@selector(regStateAlertTitle:) withObject:dict waitUntilDone:YES];
            }
        }
    }
}

- (void)regStateAlertTitle:(NSDictionary *)alertDict
{
    if (![[alertDict objectForKey:@"title"] isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:[alertDict objectForKey:@"title"]
                              message:[alertDict objectForKey:@"message"]
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:nil
                              message:[alertDict objectForKey:@"message"]
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)hideHUDView
{
    [stateHud hide:YES afterDelay:0];
}

#pragma mark -- 按钮点击事件

- (void)getSecurityCodeBtnClick
{
//    NSLog(@"获取短信验证码");
    
    if (self.usernameField.text.length == 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请输入手机号"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
        [self.usernameField becomeFirstResponder];
    }else if (self.usernameField.text.length !=0 && ![ Tools isValidateTelephone:self.usernameField.text]) {

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请输入正确手机号码"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
        [self.usernameField becomeFirstResponder];
    }else{
        [self.securityCodeField becomeFirstResponder];
        
        [_getSecurityCodeBtn setEnabled:NO];
        
        [_getSecurityCodeBtn setTitle:[NSString stringWithFormat:@"%zi秒后重新获取",secondsCountDown] forState:UIControlStateDisabled];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFireMethod) userInfo:nil repeats:YES];
        
        
        [self registerOperation_securityCode];
    }
    
    
    
}
- (void)timerFireMethod
{
    
    secondsCountDown --;
    
    if (secondsCountDown == 0) {
        [timer invalidate];
        timer = nil;
        if (!_getSecurityCodeBtn.isEnabled) {
            [_getSecurityCodeBtn setEnabled:YES];
        }
        secondsCountDown = 60;
        [_getSecurityCodeBtn setTitle:[NSString stringWithFormat:@"%zi秒后重新获取",secondsCountDown] forState:UIControlStateDisabled];
    }
    else{
        
        [_getSecurityCodeBtn setTitle:[NSString stringWithFormat:@"%zi秒后重新获取",secondsCountDown] forState:UIControlStateDisabled];
        if (_getSecurityCodeBtn.isEnabled) {
            [_getSecurityCodeBtn setEnabled:NO];
        }
    }
    
    
}

#pragma mark - TableView Delegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
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
    
    UIView *bg = [[UIView alloc] initWithFrame:CGRectZero];
    [bg setBackgroundColor:[UIColor clearColor]];
    [bg setTag:2020];
    [bg.layer setBorderWidth:0.5];
    [bg.layer setBorderColor:[UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1].CGColor];
    [bg.layer setCornerRadius:2.0];
    [cell.contentView addSubview:bg];
                  
    if(indexPath.row == 1){
      bg.frame = CGRectMake(10, 0, 160, 36);
    }else if(indexPath.row == 5){
      bg.frame = CGRectZero;
    }else{
        bg.frame = CGRectMake(10, 0, w - 20, 36);
    }
    
    switch (row) {
        case 0:
        {
            kata_TextField *aUsernameField = [[kata_TextField alloc] initWithFrame:CGRectMake(10, 1, w - 40, 34)];
            aUsernameField.keyboardType = UIKeyboardTypePhonePad;
            aUsernameField.clearButtonMode = UITextFieldViewModeWhileEditing;
            aUsernameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            aUsernameField.autocorrectionType = UITextAutocorrectionTypeNo;
            aUsernameField.placeholder = @"请输入您的手机号";
            aUsernameField.tag = 101;
            aUsernameField.textColor = [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f];
            aUsernameField.font = [UIFont systemFontOfSize:13.0f];
            aUsernameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            aUsernameField.delegate = self;
            
            [bg addSubview:aUsernameField];
            self.usernameField = aUsernameField;
        }
            break;
            
        case 1:
        {
            kata_TextField *securitycodeField = [[kata_TextField alloc] initWithFrame:CGRectMake(10, 1, 150, 34)];
            securitycodeField.backgroundColor = [UIColor clearColor];
            securitycodeField.placeholder = @"请输入6位验证码";
            securitycodeField.tag = 102;
            securitycodeField.textColor = [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f];
            securitycodeField.font = [UIFont systemFontOfSize:13.0f];
            securitycodeField.returnKeyType = UIReturnKeyNext;
            securitycodeField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            securitycodeField.delegate = self;
            
            [bg addSubview:securitycodeField];
            
            self.securityCodeField = securitycodeField;
            
            //获取短信验证码按钮
            _getSecurityCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            [_getSecurityCodeBtn setBackgroundColor:ALL_COLOR];
//            [_getSecurityCodeBtn setBackgroundImage:[UIImage imageNamed:@"outOfStockBtnBg"] forState:UIControlStateDisabled];
            [_getSecurityCodeBtn setTitle:@"获取短信验证码" forState:UIControlStateNormal];
            _getSecurityCodeBtn.titleLabel.font = FONT(13);
            _getSecurityCodeBtn.layer.borderWidth = 1;
            _getSecurityCodeBtn.layer.borderColor = LMH_COLOR_SKIN.CGColor;
            [_getSecurityCodeBtn setTitleColor:LMH_COLOR_SKIN forState:UIControlStateNormal];
            [_getSecurityCodeBtn.layer setCornerRadius:4];
            _getSecurityCodeBtn.frame = CGRectMake(180, 0, ScreenW - 190, 35 );
            [_getSecurityCodeBtn addTarget:self action:@selector(getSecurityCodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:_getSecurityCodeBtn];
        }
            break;
            
        case 2:
        {
            kata_TextField *passwordField = [[kata_TextField alloc] initWithFrame:CGRectMake(10, 1, w - 20, 34)];
            passwordField.placeholder = @"请输入密码（6-20位数字或字母）";
            passwordField.tag = 102;
            passwordField.textColor = [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f];
            passwordField.font = [UIFont systemFontOfSize:13.0f];
            passwordField.returnKeyType = UIReturnKeyNext;
            passwordField.secureTextEntry = YES;
            passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            passwordField.delegate = self;
            
            [bg addSubview:passwordField];
            self.passwordField = passwordField;
        }
            break;
//        case 3:
//        {
//            kata_TextField *alipayField = [[kata_TextField alloc] initWithFrame:CGRectMake(10, 1, w - 20, 34)];
//            alipayField.keyboardType = UIKeyboardTypeASCIICapable;
//            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"绑定支付宝账号领取集分宝"];
//            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:1 green:0.4 blue:0.5 alpha:1] range:NSMakeRange(0,str.length)];
//            alipayField.attributedPlaceholder = str;
//            alipayField.tag = 102;
//            alipayField.textColor = [UIColor colorWithRed:1 green:0.4 blue:0.5 alpha:1];
//            alipayField.font = [UIFont systemFontOfSize:13.0f];
//            alipayField.returnKeyType = UIReturnKeyNext;
//            alipayField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//            alipayField.delegate = self;
//            
//            [bg addSubview:alipayField];
//            self.alipayField = alipayField;
//        }
//            break;
        case 3:
        {
            kata_TextField *invitationCodeField = [[kata_TextField alloc] initWithFrame:CGRectMake(10, 1, w - 20, 34)];
            invitationCodeField.placeholder = @"请输入好友的邀请码（选填）";
            invitationCodeField.tag = 102;
            invitationCodeField.textColor = [UIColor colorWithRed:1 green:0.4 blue:0.5 alpha:1];
            invitationCodeField.font = [UIFont systemFontOfSize:13.0f];
            invitationCodeField.returnKeyType = UIReturnKeyDone;
            invitationCodeField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            invitationCodeField.delegate = self;
            
            [bg addSubview:invitationCodeField];
            self.invitationCodeField = invitationCodeField;
        }
            break;
        case 4:
        {
            UIButton *regBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage *image = [UIImage imageNamed:@"red_btn_small"];
            image = [image stretchableImageWithLeftCapWidth:10.0f topCapHeight:10.0f];
            [regBtn setBackgroundImage:image forState:UIControlStateNormal];
            image = [UIImage imageNamed:@"red_btn_small"];
            image = [image stretchableImageWithLeftCapWidth:10.0f topCapHeight:10.0f];
            [regBtn setBackgroundImage:image forState:UIControlStateHighlighted];
            [regBtn setBackgroundImage:image forState:UIControlStateSelected];
            [regBtn setTitle:@"完 成" forState:UIControlStateNormal];
            [regBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
            [regBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [regBtn setFrame:CGRectMake(10, 0, ScreenW-20, 40)];
            [regBtn addTarget:self action:@selector(submitReg) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:regBtn];
        }
            break;
            
        default:
            break;
    }
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 5) {
        return 60;
    }
    return 45;
}

#pragma mark - kata_TextField Input Delegate
- (BOOL)textFieldShouldReturn:(kata_TextField *)textField
{
    if (textField == self.usernameField) {
        [self.securityCodeField becomeFirstResponder];
    } else if (textField == self.securityCodeField) {
        [self.passwordField becomeFirstResponder];
    } else if (textField == self.passwordField) {
        [self.alipayField becomeFirstResponder];
    }else if (textField == self.alipayField) {
        [self.invitationCodeField becomeFirstResponder];
    }else if (textField == self.invitationCodeField){
        [textField resignFirstResponder];
        [self submitReg];
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(kata_TextField *)textField
{
    [userStr setString:@""];
    return YES;
}

#pragma mark - TextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(kata_TextField *)textField
{
    return YES;
}

- (void)keyboardWillChange:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    frame.size.height -= keyboardRect.size.height;
    self.registerFormTableView.frame = frame;
}

- (void)keyboardWillHide:(NSNotification *)notification{
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    self.registerFormTableView.frame = frame;
}

#pragma mark - UIAlertView Delegation
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 201) {
        [self.usernameField becomeFirstResponder];
    } else if (alertView.tag == 202) {
        [self.securityCodeField becomeFirstResponder];
    } else if (alertView.tag == 203) {
        [self.passwordField becomeFirstResponder];
    }
}
@end
