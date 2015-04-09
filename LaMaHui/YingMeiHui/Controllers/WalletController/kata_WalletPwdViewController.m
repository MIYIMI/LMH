//
//  kata_WalletPwdViewController.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-22.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "kata_WalletPwdViewController.h"
#import "BOKUNoActionTextField.h"
#import "KTModifyPasswordRequest.h"
#import "kata_UserManager.h"
#import "KTProxy.h"

@interface kata_WalletPwdViewController ()
{
    NSString *_code;
    NSString *_userName;
    UITextField *_edittingTF;
    BOKUNoActionTextField *_pwdTF;
    BOKUNoActionTextField *_comfirmTF;
    UIView *_pwdBg;
    UIView *_comfirmBg;
    UIButton *_comfirmBtn;
    UIButton *_pwdMask;
}

@end

@implementation kata_WalletPwdViewController

- (id)initWithCheckCode:(NSString *)code
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        _code = code;
        _userName = nil;
        self.title = @"设置支付密码";
    }
    return self;
}

- (id)initWithCheckCode:(NSString *)code
            andUserName:(NSString *)username
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        _code = code;
        _userName = username;
        self.title = @"重置登录密码";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createUI];
    [self.contentView setFrame:self.view.frame];
    
    if(!IOS_7){
        CGRect frame = self.contentView.frame;
        frame.origin.y -= 20;
        [self.contentView setFrame:frame];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resignCurrentFirstResponder
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow endEditing:YES];
}

- (void)createUI
{
    CGFloat w = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *mobileLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 200, 11)];
    [mobileLbl setBackgroundColor:[UIColor clearColor]];
    [mobileLbl setTextAlignment:NSTextAlignmentLeft];
    [mobileLbl setFont:[UIFont systemFontOfSize:10.0]];
    [mobileLbl setTextColor:[UIColor colorWithRed:0.55 green:0.55 blue:0.55 alpha:1]];
    if (_userName == nil) {
        [mobileLbl setText:@"密码为数字加字母组合，最少6位"];
    } else {
        [mobileLbl setText:@"登录密码最少6位"];
    }
    [self.contentView addSubview:mobileLbl];
    
    if (!_pwdBg) {
        _pwdBg = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(mobileLbl.frame),  CGRectGetMaxY(mobileLbl.frame) + 5, 300, 37)];
        [_pwdBg setBackgroundColor:[UIColor whiteColor]];
        [_pwdBg setTag:2020];
        [_pwdBg.layer setBorderWidth:0.5];
        [_pwdBg.layer setBorderColor:[UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1].CGColor];
        [_pwdBg.layer setCornerRadius:2.0];
        [self.contentView addSubview:_pwdBg];
    }
    
    if (!_pwdTF) {
        _pwdTF = [[BOKUNoActionTextField alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(_pwdBg.frame) - 20, CGRectGetHeight(_pwdBg.frame))];
        [_pwdTF setBackgroundColor:[UIColor clearColor]];
        [_pwdTF setTextColor:[UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f]];
        [_pwdTF setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [_pwdTF setFont:[UIFont systemFontOfSize:15.0]];
        [_pwdTF setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [_pwdTF setAutocorrectionType:UITextAutocorrectionTypeNo];
        [_pwdTF setKeyboardType:UIKeyboardTypeASCIICapable];
        [_pwdTF setReturnKeyType:UIReturnKeyDone];
        [_pwdTF setSecureTextEntry:YES];
        [_pwdTF setDelegate:self];
        if (_userName == nil) {
            [_pwdTF setPlaceholder:@"请输入支付密码："];
        } else {
            [_pwdTF setPlaceholder:@"请输入登录密码："];
        }
        
        [_pwdBg addSubview:_pwdTF];
    }
    
    if (!_comfirmBg) {
        
        _comfirmBg = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_pwdBg.frame), CGRectGetMaxY(_pwdBg.frame) + 15, CGRectGetWidth(_pwdBg.frame), CGRectGetHeight(_pwdBg.frame))];
        [_comfirmBg setBackgroundColor:[UIColor whiteColor]];
        [_comfirmBg setTag:2020];
        [_comfirmBg.layer setBorderWidth:0.5];
        [_comfirmBg.layer setBorderColor:[UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1].CGColor];
        [_comfirmBg.layer setCornerRadius:2.0];
        [self.contentView addSubview:_comfirmBg];
    }
    
    if (!_comfirmTF) {
        _comfirmTF = [[BOKUNoActionTextField alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(_comfirmBg.frame) - 20, CGRectGetHeight(_comfirmBg.frame))];
        [_comfirmTF setBackgroundColor:[UIColor clearColor]];
        [_comfirmTF setTextColor:[UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f]];
        [_comfirmTF setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [_comfirmTF setFont:[UIFont systemFontOfSize:15.0]];
        [_comfirmTF setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [_comfirmTF setAutocorrectionType:UITextAutocorrectionTypeNo];
        [_comfirmTF setKeyboardType:UIKeyboardTypeASCIICapable];
        [_comfirmTF setReturnKeyType:UIReturnKeyDone];
        [_comfirmTF setSecureTextEntry:YES];
        [_comfirmTF setDelegate:self];
        if (_userName == nil) {
            [_comfirmTF setPlaceholder:@"再次输入确定密码："];
        } else {
            [_comfirmTF setPlaceholder:@"再次输入登录密码："];
        }
        
        [_comfirmBg addSubview:_comfirmTF];
    }
    
    if (!_comfirmBtn) {
        _comfirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:@"registerbtn"];
        image = [image stretchableImageWithLeftCapWidth:10.0f topCapHeight:10.0f];
        [_comfirmBtn setBackgroundImage:image forState:UIControlStateNormal];
        image = [UIImage imageNamed:@"registerbtn_selected"];
        image = [image stretchableImageWithLeftCapWidth:10.0f topCapHeight:10.0f];
        [_comfirmBtn setBackgroundImage:image forState:UIControlStateHighlighted];
        [_comfirmBtn setBackgroundImage:image forState:UIControlStateSelected];
        [_comfirmBtn setBackgroundImage:image forState:UIControlStateNormal];
        [_comfirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_comfirmBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [_comfirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_comfirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [_comfirmBtn setFrame:CGRectMake(10, CGRectGetMaxY(_comfirmBg.frame) + 25, w - 20, 40)];
        [_comfirmBtn addTarget:self action:@selector(modifyPwdOperation) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_comfirmBtn];
    }
}

- (void)checkLogin
{
    if (![[kata_UserManager sharedUserManager] isLogin]) {
        [self performSelector:@selector(showLoginView) withObject:nil afterDelay:0.2];
    }
}

- (void)showLoginView
{
    [kata_LoginViewController showInViewController:self];
}

- (void)modifyPwdOperation
{
    if (_userName == nil) {
        if (![[kata_UserManager sharedUserManager] isLogin]) {
            [kata_LoginViewController showInViewController:self];
            return;
        }
    }
    
    //支付密码正则
    NSString *paypwdRegex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,10000}$";
    NSPredicate *paypwdPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", paypwdRegex];
    
    if (!_pwdTF.text || [_pwdTF.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"请输入支付密码"
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert setTag:1001];
        [alert show];
        
        return;
    }
    
    if (_pwdTF.text.length < 6) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"支付密码至少需6位"
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert setTag:1001];
        [alert show];
        
        return;
    }
    
    if (_userName == nil) {
        if (![paypwdPredicate evaluateWithObject:_pwdTF.text] && (_pwdTF.text && _pwdTF.text.length > 0)) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"提示"
                                  message:@"支付密码必须为数字加字母组合"
                                  delegate:self
                                  cancelButtonTitle:@"确定"
                                  otherButtonTitles:nil];
            alert.tag = 1001;
            [alert show];
            
            return;
        }
    }
    
    if (!_comfirmTF.text || [_comfirmTF.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"请再次输入支付密码"
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert setTag:1002];
        [alert show];
        
        return;
    }
    
    if (_comfirmTF.text.length < 6) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"确认密码至少需6位"
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert setTag:1002];
        [alert show];
        
        return;
    }
    
    if (_userName == nil) {
        if (![paypwdPredicate evaluateWithObject:_comfirmTF.text] && (_comfirmTF.text && _comfirmTF.text.length > 0)) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"提示"
                                  message:@"确认支付密码必须为数字加字母组合"
                                  delegate:self
                                  cancelButtonTitle:@"确定"
                                  otherButtonTitles:nil];
            alert.tag = 1002;
            [alert show];
            
            return;
        }
    }
    
    if (![_pwdTF.text isEqualToString:_comfirmTF.text]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"两次输入密码不一致"
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert setTag:1002];
        [alert show];
        
        return;
    }
    
    if (!stateHud) {
        stateHud = [[MBProgressHUD alloc] initWithView:self.contentView];
        stateHud.delegate = self;
        [self.contentView addSubview:stateHud];
    }
    stateHud.mode = MBProgressHUDModeIndeterminate;
    stateHud.labelFont = [UIFont systemFontOfSize:14.0f];
    [stateHud show:YES];
    
    KTBaseRequest *req = [[KTBaseRequest alloc] init];
    
    NSString *userid = nil;
    NSString *usertoken = nil;
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isEqualToString:@""]) {
        userid = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"];
    }
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isEqualToString:@""]) {
        usertoken = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"];
    }
    
    if (_userName == nil) {
        if (userid && usertoken) {
            req = [[KTModifyPasswordRequest alloc] initWithBindUsername:nil
                                                              andUserID:[userid integerValue]
                                                           andUserToken:usertoken
                                                                andCode:_code
                                                         andNewLoginPwd:nil
                                                         andOldLoginPwd:nil
                                                           andNewPayPwd:_comfirmTF.text
                                                           andOldPayPwd:nil];
        }
    } else {
        if (_comfirmTF.text) {
            req = [[KTModifyPasswordRequest alloc] initWithBindUsername:_userName
                                                              andUserID:-1
                                                           andUserToken:nil
                                                                andCode:_code
                                                         andNewLoginPwd:_comfirmTF.text
                                                         andOldLoginPwd:nil
                                                           andNewPayPwd:nil
                                                           andOldPayPwd:nil];
        }
    }
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(modifyPwdResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxy start];
}


- (void)modifyPwdResponse:(NSString *)resp
{
    NSString *hudPrefixStr = @"设置";
    if (_userName) {
        hudPrefixStr = @"重置";
    }
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            if (nil != [respDict objectForKey:@"data"] && ![[respDict objectForKey:@"data"] isEqual:[NSNull null]] && [[respDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *dataObj = (NSDictionary *)[respDict objectForKey:@"data"];
                if ([[dataObj objectForKey:@"code"] integerValue] == 0) {
                    if ([[dataObj objectForKey:@"result"] boolValue]) {
                        id messageObj = [dataObj objectForKey:@"msg"];
                        if (messageObj) {
                            if ([messageObj isKindOfClass:[NSString class]] && ![messageObj isEqualToString:@""]) {
                                [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:messageObj waitUntilDone:YES];
                            } else {
                                [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[hudPrefixStr stringByAppendingString:@"成功"] waitUntilDone:YES];
                            }
                        } else {
                            [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[hudPrefixStr stringByAppendingString:@"成功"] waitUntilDone:YES];
                        }
                        [self performSelectorOnMainThread:@selector(modifySuccess) withObject:nil waitUntilDone:YES];
                    } else {
                        id messageObj = [dataObj objectForKey:@"msg"];
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
                    id messageObj = [dataObj objectForKey:@"msg"];
                    if (messageObj) {
                        if ([messageObj isKindOfClass:[NSString class]] && ![messageObj isEqualToString:@""]) {
                            [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:messageObj waitUntilDone:YES];
                        } else {
                            [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[hudPrefixStr stringByAppendingString:@"失败"] waitUntilDone:YES];
                        }
                    } else {
                        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[hudPrefixStr stringByAppendingString:@"失败"] waitUntilDone:YES];
                    }
                    if ([[dataObj objectForKey:@"code"] integerValue] == -102) {
                        [[kata_UserManager sharedUserManager] logout];
                        [self performSelectorOnMainThread:@selector(checkLogin) withObject:nil waitUntilDone:YES];
                    }
                }
            } else {
                [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[hudPrefixStr stringByAppendingString:@"失败"] waitUntilDone:YES];
            }
        } else {
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
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[hudPrefixStr stringByAppendingString:@"失败"] waitUntilDone:YES];
    }
}

- (void)modifySuccess
{
    [_comfirmBtn setEnabled:NO];
    [self performSelector:@selector(successPop) withObject:nil afterDelay:0.2];
}

- (void)successPop
{
    if (self.pwdViewDelegate && [self.pwdViewDelegate respondsToSelector:@selector(pwdSetSuccess)]) {
        [self.pwdViewDelegate pwdSetSuccess];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (!_pwdMask) {
        _edittingTF = textField;
		_pwdMask = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
		_pwdMask.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
		[_pwdMask addTarget:self action:@selector(hideInputControl) forControlEvents:UIControlEventTouchUpInside];
		_pwdMask.alpha = 0;
		[self.contentView addSubview:_pwdMask];
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveLinear];
		[UIView setAnimationDuration:0.3];
		_pwdMask.alpha = 1;
		[UIView commitAnimations];
        
        if (_edittingTF && [_edittingTF.superview isKindOfClass:[UIView class]] && _edittingTF.superview.tag == 2020) {
            UIView *bg = _edittingTF.superview;
            [bg.layer setBorderWidth:1.0];
            [bg.layer setBorderColor:[UIColor colorWithRed:0.98 green:0.32 blue:0.44 alpha:1].CGColor];
            [bg.layer setCornerRadius:2.0];
        }
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
	_pwdMask.alpha = 0;
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
	if (_pwdMask) {
		[_pwdMask removeFromSuperview];
		_pwdMask = nil;
	}
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger tag = alertView.tag;
    
    if (tag == 1001) {
        [self resignCurrentFirstResponder];
        [_pwdTF becomeFirstResponder];
    } else if (tag == 1002) {
        [self resignCurrentFirstResponder];
        [_comfirmTF becomeFirstResponder];
    }
}

#pragma mark - Login Delegate
- (void)didLogin
{
    
}

- (void)loginCancel
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
