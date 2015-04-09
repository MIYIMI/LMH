//
//  kata_WalletBindViewController.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-22.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "kata_WalletBindViewController.h"
#import "BOKUNoActionTextField.h"
#import "KTVerificationCodeRequest.h"
#import "KTVerificationCodeCheckRequest.h"
#import "kata_UserManager.h"
#import "KTProxy.h"
#import <QuartzCore/QuartzCore.h>

@interface kata_WalletBindViewController ()
{
    BOKUNoActionTextField *_mobileTF;
    BOKUNoActionTextField *_checkTF;
    UITextField *_edittingTF;
    UIView *_mobileBg;
    UIView *_checkBg;
    UIButton *_sendBtn;
    UIButton *_comfirmBtn;
    UIButton *_bindMask;
    NSTimer *_counterTimer;
    NSInteger _minCounter;
}

@end

@implementation kata_WalletBindViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"手机绑定";
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
    
    UILabel *mobileLbl = [[UILabel alloc] initWithFrame:CGRectMake(8, 12, 200, 15)];
    [mobileLbl setBackgroundColor:[UIColor clearColor]];
    [mobileLbl setTextAlignment:NSTextAlignmentLeft];
    [mobileLbl setFont:[UIFont systemFontOfSize:14.0]];
    [mobileLbl setTextColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1]];
    [mobileLbl setText:@"请输入您的手机号码进行验证"];
    [self.contentView addSubview:mobileLbl];
    
    if (!_mobileBg) {
        _mobileBg = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(mobileLbl.frame),  CGRectGetMaxY(mobileLbl.frame) + 10, 190, 37)];
        [_mobileBg setBackgroundColor:[UIColor whiteColor]];
        [_mobileBg setTag:2020];
        [_mobileBg.layer setBorderWidth:0.5];
        [_mobileBg.layer setBorderColor:[UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1].CGColor];
        [_mobileBg.layer setCornerRadius:2.0];
        [self.contentView addSubview:_mobileBg];
    }
    
    if (!_mobileTF) {
        _mobileTF = [[BOKUNoActionTextField alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(_mobileBg.frame) - 20, CGRectGetHeight(_mobileBg.frame))];
        [_mobileTF setBackgroundColor:[UIColor clearColor]];
        [_mobileTF setTextColor:[UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f]];
        [_mobileTF setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [_mobileTF setFont:[UIFont systemFontOfSize:15.0]];
        [_mobileTF setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [_mobileTF setAutocorrectionType:UITextAutocorrectionTypeNo];
        [_mobileTF setKeyboardType:UIKeyboardTypePhonePad];
        [_mobileTF setReturnKeyType:UIReturnKeyDone];
        [_mobileTF setDelegate:self];
        [_mobileTF setPlaceholder:@"请输入手机号码"];
        [_mobileBg addSubview:_mobileTF];
    }
    
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_sendBtn setFrame:CGRectMake(CGRectGetMaxX(_mobileBg.frame) + 10, CGRectGetMinY(_mobileBg.frame), 105, CGRectGetHeight(_mobileBg.frame))];
        [_sendBtn setTitle:@"获取短信验证码" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
        [_sendBtn setBackgroundColor:[UIColor colorWithRed:0.53 green:0.76 blue:0.21 alpha:1]];
        [_sendBtn.layer setCornerRadius:3.0];
        [_sendBtn addTarget:self action:@selector(sendCheckCode) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_sendBtn];
    }
    
    if (!_checkBg) {
        _checkBg = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_mobileBg.frame), CGRectGetMaxY(_mobileBg.frame) + 10, CGRectGetWidth(_mobileBg.frame), CGRectGetHeight(_mobileBg.frame))];
        [_checkBg setBackgroundColor:[UIColor whiteColor]];
        [_checkBg setTag:2020];
        [_checkBg.layer setBorderWidth:0.5];
        [_checkBg.layer setBorderColor:[UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1].CGColor];
        [_checkBg.layer setCornerRadius:2.0];
        [self.contentView addSubview:_checkBg];
    }
    
    if (!_checkTF) {
        _checkTF = [[BOKUNoActionTextField alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(_checkBg.frame) - 20, CGRectGetHeight(_checkBg.frame))];
        [_checkTF setBackgroundColor:[UIColor clearColor]];
        [_checkTF setTextColor:[UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f]];
        [_checkTF setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [_checkTF setFont:[UIFont systemFontOfSize:15.0]];
        [_checkTF setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [_checkTF setAutocorrectionType:UITextAutocorrectionTypeNo];
        [_checkTF setKeyboardType:UIKeyboardTypeNumberPad];
        [_checkTF setReturnKeyType:UIReturnKeyDone];
        [_checkTF setDelegate:self];
        [_checkTF setPlaceholder:@"请输入短信验证码"];
        
        [_checkBg addSubview:_checkTF];
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
        [_comfirmBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_comfirmBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [_comfirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_comfirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [_comfirmBtn setFrame:CGRectMake(10, CGRectGetMaxY(_checkBg.frame) + 25, w - 20, 40)];
        [_comfirmBtn addTarget:self action:@selector(checkOperation) forControlEvents:UIControlEventTouchUpInside];
        [_comfirmBtn setEnabled:NO];
        
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

- (void)sendCheckCode
{
    if (![[kata_UserManager sharedUserManager] isLogin]) {
        [kata_LoginViewController showInViewController:self];
        return;
    }
    
    if (!_mobileTF.text || [_mobileTF.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"请输入手机号码"
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert setTag:1001];
        [alert show];
        
        return;
    }
    
    //手机号正则
    NSString *mobileRegex = @"[1][358][0-9]{9}";
    NSPredicate *mobilePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileRegex];
    
    if (![mobilePredicate evaluateWithObject:_mobileTF.text] && (_mobileTF.text && _mobileTF.text.length > 0)) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"手机格式不正确"
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        alert.tag = 1002;
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
    
    if (userid && usertoken) {
        req = [[KTVerificationCodeRequest alloc] initWithBindUserID:[userid integerValue]
                                                       andUserToken:usertoken
                                                          andMobile:_mobileTF.text
                                                            andType:2];
    }
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(sendCheckCodeParseResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (void)sendCheckCodeParseResponse:(NSString *)resp
{
    NSString *hudPrefixStr = @"发送验证码";
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
                        [self performSelectorOnMainThread:@selector(sendCheckSuccess) withObject:nil waitUntilDone:YES];
                        [self performSelectorOnMainThread:@selector(hideHUDView) withObject:nil waitUntilDone:YES];
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

- (void)sendCheckSuccess
{
    [_sendBtn setEnabled:NO];
    [_comfirmBtn setEnabled:YES];
    
    if (!_counterTimer) {
        _minCounter = 60;
        NSTimer *counter = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateBtnTitle) userInfo:nil repeats:YES];
        _counterTimer = counter;
    }
}

- (void)updateBtnTitle
{
    NSString *str = [@"获取短信验证码" stringByAppendingFormat:@"(%zi)", _minCounter--];
    [_sendBtn.titleLabel setFont:[UIFont systemFontOfSize:10.0]];
    [_sendBtn setTitle:str forState:UIControlStateDisabled];
    if (_minCounter < 0) {
        [_sendBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        [_sendBtn setEnabled:YES];
        [_sendBtn setTitle:@"获取短信验证码" forState:UIControlStateNormal];
        [_counterTimer invalidate];
        _counterTimer = nil;
    }
}

- (void)hideHUDView
{
    [stateHud hide:YES afterDelay:1.0];
}

- (void)checkOperation
{
    if (![[kata_UserManager sharedUserManager] isLogin]) {
        [kata_LoginViewController showInViewController:self];
        return;
    }
    
    if (!_checkTF.text || [_checkTF.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"请输入手机验证码"
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert setTag:1003];
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
    
    if (userid && usertoken) {
        req = [[KTVerificationCodeCheckRequest alloc] initWithBindUserID:[userid integerValue]
                                                            andUserToken:usertoken
                                                                 andCode:_checkTF.text
                                                                 andType:2];
    }
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(checkParseResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxy start];
}


- (void)checkParseResponse:(NSString *)resp
{
    NSString *hudPrefixStr = @"验证";
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
                        [self performSelectorOnMainThread:@selector(checkSuccess) withObject:nil waitUntilDone:YES];
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

- (void)checkSuccess
{
    [_comfirmBtn setEnabled:NO];
    [self performSelector:@selector(pushToPwdVC) withObject:nil afterDelay:0.2];
}

- (void)pushToPwdVC
{
    kata_WalletPwdViewController *pwdVC = [[kata_WalletPwdViewController alloc] initWithCheckCode:_checkTF.text];
    pwdVC.navigationController = self.navigationController;
    pwdVC.pwdViewDelegate = self;
    pwdVC.navigationController.ifPopToRootView = YES;
    [self.navigationController pushViewController:pwdVC animated:YES];
}

#pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString *text = [textField.text mutableCopy];
    [text replaceCharactersInRange:range withString:string];
    
    if (textField == _mobileTF) {
        return [text length] <= 11;
    } else if (textField == _checkTF) {
        return [text length] <= 6;
    }
    return NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (!_bindMask) {
        _edittingTF = textField;
		_bindMask = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
		_bindMask.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
		[_bindMask addTarget:self action:@selector(hideInputControl) forControlEvents:UIControlEventTouchUpInside];
		_bindMask.alpha = 0;
		[self.contentView addSubview:_bindMask];
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveLinear];
		[UIView setAnimationDuration:0.3];
		_bindMask.alpha = 1;
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
	_bindMask.alpha = 0;
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
	if (_bindMask) {
		[_bindMask removeFromSuperview];
		_bindMask = nil;
	}
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger tag = alertView.tag;
    
    if (tag == 1001 || tag == 1002) {
        [self resignCurrentFirstResponder];
        [_mobileTF becomeFirstResponder];
    } else if (tag == 1003) {
        [self resignCurrentFirstResponder];
        [_checkTF becomeFirstResponder];
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

#pragma mark - kata_WalletPwdViewController Delegate
- (void)pwdSetSuccess
{
    if (self.bindViewDelegate && [self.bindViewDelegate respondsToSelector:@selector(walletBindSuccess)]) {
        [self.bindViewDelegate walletBindSuccess];
    }
    [self.navigationController popViewControllerAnimated:NO];
}

@end
