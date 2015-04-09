//
//  kata_FindBackPwdViewController.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-23.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "kata_FindBackPwdViewController.h"
#import "BOKUNoActionTextField.h"
#import "KTVerificationCodeRequest.h"
#import "KTVerificationCodeCheckRequest.h"
#import "kata_UserManager.h"
#import "KTProxy.h"
#import "kata_WalletPwdViewController.h"

@interface kata_FindBackPwdViewController ()
{
    BOKUNoActionTextField *_usernameTF;
    BOKUNoActionTextField *_checkTF;
    UITextField *_edittingTF;
    UIView *_usernameBg;
    UIView *_checkBg;
    UIButton *_sendBtn;
    UIButton *_comfirmBtn;
    UIButton *_bindMask;
    NSTimer *_counterTimer;
    NSInteger _minCounter;
}

@end

@implementation kata_FindBackPwdViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"忘记密码";
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
    
    UILabel *mobileLbl = [[UILabel alloc] initWithFrame:CGRectMake(8, 12, 302, 15)];
    [mobileLbl setBackgroundColor:[UIColor clearColor]];
    [mobileLbl setTextAlignment:NSTextAlignmentLeft];
    [mobileLbl setFont:[UIFont systemFontOfSize:10.0]];
    [mobileLbl setTextColor:[UIColor colorWithRed:0.55 green:0.55 blue:0.55 alpha:1]];
    [mobileLbl setText:@"请输入您的登录名，您的登录名可能是您的手机号，E-mail"];
    [self.contentView addSubview:mobileLbl];
    
    if (!_usernameBg) {
        _usernameBg = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(mobileLbl.frame),  CGRectGetMaxY(mobileLbl.frame) + 5, 300, 37)];
        [_usernameBg setBackgroundColor:[UIColor whiteColor]];
        [_usernameBg setTag:2020];
        [_usernameBg.layer setBorderWidth:0.5];
        [_usernameBg.layer setBorderColor:[UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1].CGColor];
        [_usernameBg.layer setCornerRadius:2.0];
        [self.contentView addSubview:_usernameBg];
    }
    
    if (!_usernameTF) {
        _usernameTF = [[BOKUNoActionTextField alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(_usernameBg.frame) - 20, CGRectGetHeight(_usernameBg.frame))];
        [_usernameTF setBackgroundColor:[UIColor clearColor]];
        [_usernameTF setTextColor:[UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f]];
        [_usernameTF setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [_usernameTF setFont:[UIFont systemFontOfSize:15.0]];
        [_usernameTF setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [_usernameTF setAutocorrectionType:UITextAutocorrectionTypeNo];
        [_usernameTF setKeyboardType:UIKeyboardTypeASCIICapable];
        [_usernameTF setReturnKeyType:UIReturnKeyDone];
        [_usernameTF setDelegate:self];
        [_usernameTF setPlaceholder:@"请输入登录名："];
        
        [_usernameBg addSubview:_usernameTF];
    }
    
    if (!_checkBg) {
        _checkBg = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_usernameBg.frame), CGRectGetMaxY(_usernameBg.frame) + 15, CGRectGetWidth(_usernameBg.frame) - 125, CGRectGetHeight(_usernameBg.frame))];
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
        [_checkTF setPlaceholder:@"短信验证码"];
        
        [_checkBg addSubview:_checkTF];
    }
    
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_sendBtn setFrame:CGRectMake(CGRectGetMaxX(_checkBg.frame) + 10, CGRectGetMinY(_checkBg.frame), 115, CGRectGetHeight(_checkBg.frame))];
        [_sendBtn setTitle:@"获取短信验证码" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
        [_sendBtn setBackgroundColor:[UIColor colorWithRed:0.53 green:0.76 blue:0.21 alpha:1]];
        [_sendBtn.layer setCornerRadius:3.0];
        [_sendBtn addTarget:self action:@selector(sendCheckCode) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_sendBtn];
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

- (void)sendCheckCode
{
    //账号正则检测：为邮箱格式
    NSString *emailRegex = @"^\\w+((\\-\\w+)|(\\.\\w+))*@[A-Za-z0-9]+((\\.|\\-)[A-Za-z0-9]+)*.[A-Za-z0-9]+$";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    //手机号正则
    NSString *mobileRegex = @"[1][358][0-9]{9}";
    NSPredicate *mobilePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileRegex];
    
    if (!_usernameTF.text || [_usernameTF.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"请输入登录名"
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert setTag:1004];
        [alert show];
        
        return;
    }
    
    if (!([emailPredicate evaluateWithObject:_usernameTF.text] || [mobilePredicate evaluateWithObject:_usernameTF.text])) {
        //        或为4-20个字符，首个字符需要为字母，只能包含数字或下划线
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录名不合法"
                                                        message:@"无效的邮箱或手机号码"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert setTag:1004];
        [alert show];
        
        return;
    }
    
//    if (!_mobileTF.text || [_mobileTF.text isEqualToString:@""]) {
//        UIAlertView *alert = [[UIAlertView alloc]
//                              initWithTitle:@"提示"
//                              message:@"请输入手机号码"
//                              delegate:self
//                              cancelButtonTitle:@"确定"
//                              otherButtonTitles:nil];
//        [alert setTag:1001];
//        [alert show];
//        
//        return;
//    }
//    
//    if (![mobilePredicate evaluateWithObject:_mobileTF.text] && (_mobileTF.text && _mobileTF.text.length > 0)) {
//        UIAlertView *alert = [[UIAlertView alloc]
//                              initWithTitle:@"提示"
//                              message:@"手机格式不正确"
//                              delegate:self
//                              cancelButtonTitle:@"确定"
//                              otherButtonTitles:nil];
//        alert.tag = 1002;
//        [alert show];
//        
//        return;
//    }
    
    if (!stateHud) {
        stateHud = [[MBProgressHUD alloc] initWithView:self.contentView];
        stateHud.delegate = self;
        [self.contentView addSubview:stateHud];
    }
    stateHud.mode = MBProgressHUDModeIndeterminate;
    stateHud.labelFont = [UIFont systemFontOfSize:14.0f];
    [stateHud show:YES];
    
    KTBaseRequest *req = [[KTBaseRequest alloc] init];
    
//    if (_usernameTF.text && _mobileTF.text) {
//        req = [[KTVerificationCodeRequest alloc] initWithFindUsername:_usernameTF.text
//                                                            andMobile:_mobileTF.text
//                                                              andType:1];
//    }
    
    if (_usernameTF.text) {
        req = [[KTVerificationCodeRequest alloc] initWithFindUsername:_usernameTF.text
                                                            andMobile:nil
                                                              andType:1];
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
    
    if (_usernameTF.text && _checkTF.text) {
        req = [[KTVerificationCodeCheckRequest alloc] initWithFindUsername:_usernameTF.text
                                                                   andCode:_checkTF.text
                                                                   andType:1];
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
    [self performSelector:@selector(pushToPwdVC) withObject:nil afterDelay:0.1];
}

- (void)pushToPwdVC
{
    kata_WalletPwdViewController *pwdVC = [[kata_WalletPwdViewController alloc] initWithCheckCode:_checkTF.text andUserName:_usernameTF.text];
    pwdVC.navigationController = self.navigationController;
    pwdVC.navigationController.ifPopToRootView = YES;
    [self.navigationController pushViewController:pwdVC animated:YES];
}

#pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString *text = [textField.text mutableCopy];
    [text replaceCharactersInRange:range withString:string];
    
    if (textField == _usernameTF) {
        return YES;
    }
//    else if (textField == _mobileTF) {
//        return [text length] <= 11;
//    }
    else if (textField == _checkTF) {
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
    
//    if (tag == 1001 || tag == 1002) {
//        [self resignCurrentFirstResponder];
//        [_mobileTF becomeFirstResponder];
//    } else
    if (tag == 1003) {
        [self resignCurrentFirstResponder];
        [_checkTF becomeFirstResponder];
    } else if (tag == 1004) {
        [self resignCurrentFirstResponder];
        [_usernameTF becomeFirstResponder];
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
