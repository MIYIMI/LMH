//
//  LMHForgetPasswordViewController.m
//  YingMeiHui
//
//  Created by Zhumingming on 14-12-23.
//  Copyright (c) 2014年 xieyanke. All rights reserved.
//

#import "LMHForgetPasswordViewController.h"
#import "KTProxy.h"
#import "LMHResetPasswordRequest.h"
#import "kata_UserManager.h"
#import "NSString+KTStringHelper.h"
#import "kata_CartManager.h"
#import "Tools.h"
#import "LMHGetMobileCodeRequest.h"
#import "kata_TextField.h"

@interface LMHForgetPasswordViewController ()
{
    UIButton *_registerMask;
    kata_TextField *_edittingTF;
    UIView *_footer;
    NSMutableString *userStr;
    
    UIButton    *_getSecurityCodeBtn;
    
    NSTimer *timer;
    NSInteger     secondsCountDown;
}

@property (readonly, nonatomic) UITableView *registerFormTableView;
@property (strong, nonatomic) kata_TextField *usernameField;
@property (strong, nonatomic) kata_TextField *securityCodeField;
@property (strong, nonatomic) kata_TextField *passwordField;
@property (strong, nonatomic) kata_TextField *invitationCodeField;
@property (strong, nonatomic) UIButton    *submitButton;
@end

@implementation LMHForgetPasswordViewController

@synthesize registerFormTableView = _registerFormTableView;
@synthesize usernameField = _usernameField;
@synthesize securityCodeField = _securityCodeField;
@synthesize passwordField = _passwordField;
@synthesize invitationCodeField = _invitationCodeField;
@synthesize submitButton = _submitButton;

- (void)viewDidLoad {
    [super viewDidLoad];

    CGRect frame = self.contentView.frame;
    frame.size.height += 64;
    self.contentView.frame = frame;

    self.title = @"忘记密码";
    
    secondsCountDown = 60;

    [self createUI];
}

- (void)createUI
{
    _registerFormTableView = [self registerFormTableView];
}

-(void)addTapGesture{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignSelfResponder)];
    tapGesture.numberOfTapsRequired=1;
    [self.view addGestureRecognizer:tapGesture];
}

-(void)resignSelfResponder{
    [self hideInputControl];
    [self resignCurrentFirstResponder];
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
    
    [self textStateHUD:@"密码修改成功"];
    
    [self performSelector:@selector(popRegView) withObject:nil afterDelay:1.0];
}

- (void)popRegView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)resignCurrentFirstResponder
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow endEditing:YES];
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
            [self resignCurrentFirstResponder];
            [self completeOperation];
            
            if (!stateHud) {
                stateHud = [[MBProgressHUD alloc] initWithView:self.contentView];
                stateHud.delegate = self;
                [self.contentView addSubview:stateHud];
            }
            stateHud.mode = MBProgressHUDModeIndeterminate;
//            stateHud.labelText = @"正在提交..";
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
- (void)getMobile_codeRequest
{
    if (!stateHud) {
        stateHud = [[MBProgressHUD alloc] initWithView:self.contentView];
        stateHud.delegate = self;
        [self.contentView addSubview:stateHud];
    }
    stateHud.mode = MBProgressHUDModeIndeterminate;
    stateHud.labelFont = [UIFont systemFontOfSize:14.0f];
    [stateHud show:YES];
    
    
    KTBaseRequest *req = [[LMHGetMobileCodeRequest alloc]initWithMobile:self.usernameField.text];
    
    KTProxy *proxys = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(getMobile_codeRequestResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxys start];
}

- (void)getMobile_codeRequestResponse:(NSString *)resp
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
            
        }
        if ([[[respDict objectForKey:@"data"] objectForKey:@"error_code"] integerValue] == 2) {
            [self textStateHUD:@"该手机号未注册"];
        }
        if ([[[respDict objectForKey:@"data"] objectForKey:@"error_code"] integerValue] == 3) {
            [self textStateHUD:@"发送过于频繁"];
        }
        
    }else{
        [self textStateHUD:@"注册失败"];
    }
}

#pragma mark - 网络请求 解析 -- 完成
- (void)completeOperation
{
    if (!stateHud) {
        stateHud = [[MBProgressHUD alloc] initWithView:self.contentView];
        stateHud.delegate = self;
        [self.contentView addSubview:stateHud];
    }
    stateHud.mode = MBProgressHUDModeIndeterminate;
    stateHud.labelFont = [UIFont systemFontOfSize:14.0f];
    [stateHud show:YES];
    
    LMHResetPasswordRequest *req = [[LMHResetPasswordRequest alloc] initWithcode:self.securityCodeField.text
                                                                          mobile:self.usernameField.text
                                                                         new_pwd:self.passwordField.text];

    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(completeOperationResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (void)completeOperationResponse:(NSString *)resp
{
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        
        
        if ([[respDict objectForKey:@"code"] integerValue] == 0) {
            
            [self textStateHUD:@"密码重置成功，请牢记"];
            
            [self performSelector:@selector(poptoViewController) withObject:nil afterDelay:1.5];
            
        } else {
            
            [self textStateHUD:[respDict objectForKey:@"msg"]];
            
        }
    }
}
- (void)poptoViewController
{
    [self.navigationController popViewControllerAnimated:YES];
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
    }
    else if (self.usernameField.text.length !=0 && ![ Tools isValidateTelephone:self.usernameField.text]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请输入正确手机号码"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
        [self.usernameField becomeFirstResponder];
    }
    else{
        [self.securityCodeField becomeFirstResponder];
        
        [_getSecurityCodeBtn setEnabled:NO];
        
        [_getSecurityCodeBtn setTitle:[NSString stringWithFormat:@"%zi秒后重新获取",secondsCountDown] forState:UIControlStateDisabled];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFireMethod) userInfo:nil repeats:YES];
        
        
        [self getMobile_codeRequest];
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
    return 3;
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
    
    UIView *bg = [[UIView alloc] initWithFrame:CGRectZero];        //CGRectMake(10, 0, w - 20, 36)];
    [bg setBackgroundColor:[UIColor clearColor]];
    [bg setTag:2020];
    [bg.layer setBorderWidth:0.5];
    [bg.layer setBorderColor:[UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1].CGColor];
    [bg.layer setCornerRadius:2.0];
    [cell.contentView addSubview:bg];
    
    if(indexPath.row == 1){
        
        bg.frame = CGRectMake(10, 0, 160, 36);
    }
    else
    {
        bg.frame = CGRectMake(10, 0, w - 20, 36);
    }
    
    switch (row) {
        case 0:
        {
            kata_TextField *aUsernameField = [[kata_TextField alloc] initWithFrame:CGRectMake(10, 1, w - 40, 34)];
            aUsernameField.clearButtonMode = UITextFieldViewModeWhileEditing;
            aUsernameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            aUsernameField.autocorrectionType = UITextAutocorrectionTypeNo;
            aUsernameField.placeholder = @"请输入手机号获取验证码";
            aUsernameField.tag = 101;
            aUsernameField.textColor = [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f];
            aUsernameField.font = [UIFont systemFontOfSize:13.0f];
            aUsernameField.keyboardType = UIKeyboardTypeEmailAddress;
            aUsernameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            aUsernameField.delegate = self;
            
            [bg addSubview:aUsernameField];
            self.usernameField = aUsernameField;
            
        }
            break;
            
        case 1:
        {
            kata_TextField *securitycodeField = [[kata_TextField alloc] initWithFrame:CGRectMake(10, 1, 150, 34)];
            securitycodeField.keyboardType = UIKeyboardTypeASCIICapable;
            securitycodeField.backgroundColor = [UIColor clearColor];
            securitycodeField.placeholder = @"请输入6位验证码";
            securitycodeField.tag = 102;
            securitycodeField.textColor = [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f];
            securitycodeField.font = [UIFont systemFontOfSize:13.0f];
            securitycodeField.returnKeyType = UIReturnKeyNext;
            //            securitycodeField.secureTextEntry = YES;
            securitycodeField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            securitycodeField.delegate = self;
            
            [bg addSubview:securitycodeField];
            
            self.securityCodeField = securitycodeField;
            
            
            //获取短信验证码按钮
            _getSecurityCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_getSecurityCodeBtn setBackgroundColor:ALL_COLOR];
            [_getSecurityCodeBtn setBackgroundImage:[UIImage imageNamed:@"outOfStockBtnBg"] forState:UIControlStateDisabled];
            [_getSecurityCodeBtn setTitle:@"获取短信验证码" forState:UIControlStateNormal];
            _getSecurityCodeBtn.titleLabel.font = FONT(13);
            [_getSecurityCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _getSecurityCodeBtn.frame = CGRectMake( 180, 0, ScreenW - 190, 35 );
            [_getSecurityCodeBtn addTarget:self action:@selector(getSecurityCodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:_getSecurityCodeBtn];
        }
            break;
            
        case 2:
        {
            kata_TextField *passwordField = [[kata_TextField alloc] initWithFrame:CGRectMake(10, 1, w - 40, 34)];
            passwordField.keyboardType = UIKeyboardTypeASCIICapable;
            passwordField.placeholder = @"请输入新密码（6-20位数字或字母)";
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
        case 3:
        {
            
        }
            break;
            
        default:
            break;
    }
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        if (!_footer) {
            
            UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), 60)];
            [footer setBackgroundColor:[UIColor clearColor]];
            
            UIButton *regBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage *image = [UIImage imageNamed:@"red_btn_big"];
            image = [image stretchableImageWithLeftCapWidth:10.0f topCapHeight:10.0f];
            [regBtn setBackgroundImage:image forState:UIControlStateNormal];
            image = [UIImage imageNamed:@"red_btn_big"];
            image = [image stretchableImageWithLeftCapWidth:10.0f topCapHeight:10.0f];
            [regBtn setBackgroundImage:image forState:UIControlStateHighlighted];
            [regBtn setBackgroundImage:image forState:UIControlStateSelected];
            [regBtn setTitle:@"完 成" forState:UIControlStateNormal];
            [regBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
            [regBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [regBtn setFrame:CGRectMake((CGRectGetWidth(footer.frame) - 300)/2, 20, 300, 40)];
            [regBtn addTarget:self action:@selector(submitReg) forControlEvents:UIControlEventTouchUpInside];
            [footer addSubview:regBtn];
            _footer = footer;
        }
        return _footer;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 70;
}

#pragma mark - kata_TextField Input Delegate
- (BOOL)textFieldShouldReturn:(kata_TextField *)textField
{
    if (textField == self.usernameField) {
        [self.securityCodeField becomeFirstResponder];
    } else if (textField == self.securityCodeField) {
        [self.passwordField becomeFirstResponder];
    } else if (textField == self.passwordField) {
        [self.invitationCodeField resignFirstResponder];
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




- (void)textFieldDidEndEditing:(kata_TextField *)textField
{
    
}

- (BOOL)textFieldShouldBeginEditing:(kata_TextField *)textField
{
    [self hideInputControl];
    _edittingTF = textField;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:0.3];
    _registerMask.alpha = 1;
    [UIView commitAnimations];
    [self hideInputControl];
    if (_edittingTF && [_edittingTF.superview isKindOfClass:[UIView class]] && _edittingTF.superview.tag == 2020) {
        UIView *bg = _edittingTF.superview;
        [bg.layer setBorderWidth:1.0];
        [bg.layer setBorderColor:[UIColor colorWithRed:0.98 green:0.32 blue:0.44 alpha:1].CGColor];
        [bg.layer setCornerRadius:2.0];
    }
    
    return YES;
}

- (void)hideInputControl
{
    if (_edittingTF && [_edittingTF.superview isKindOfClass:[UIView class]] && _edittingTF.superview.tag == 2020) {
        UIView *bg = _edittingTF.superview;
        [bg.layer setBorderWidth:0.5];
        [bg.layer setBorderColor:[UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1].CGColor];
        [bg.layer setCornerRadius:2.0];
    }
}

- (void)removeMask
{
    if (_registerMask) {
        [_registerMask removeFromSuperview];
        _registerMask = nil;
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
