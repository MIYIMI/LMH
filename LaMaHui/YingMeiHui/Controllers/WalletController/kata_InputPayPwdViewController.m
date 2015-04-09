//
//  kata_InputPayPwdViewController.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-7-2.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "kata_InputPayPwdViewController.h"
#import "BOKUNoActionTextField.h"
#import "KTWalletPayRequest.h"
#import "kata_UserManager.h"
#import "KTProxy.h"
#import "kata_OrderDetailViewController.h"

@interface kata_InputPayPwdViewController ()
{
    NSString *_orderid;
    CGFloat _totalPrice;
    UITextField *_edittingTF;
    BOKUNoActionTextField *_pwdTF;
    UIView *_pwdBg;
    UIButton *_comfirmBtn;
    UIButton *_pwdMask;
}

@end

@implementation kata_InputPayPwdViewController

- (id)initWithOrderID:(NSString *)orderid
             andTotal:(CGFloat)total
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _orderid = orderid;
        _totalPrice = total;
        self.title = @"钱包支付密码";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
    UILabel *totalTipLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 90, 25)];
    [totalTipLbl setBackgroundColor:[UIColor clearColor]];
    [totalTipLbl setTextAlignment:NSTextAlignmentLeft];
    [totalTipLbl setFont:[UIFont systemFontOfSize:18.0]];
    [totalTipLbl setTextColor:[UIColor colorWithRed:0.55 green:0.55 blue:0.55 alpha:1]];
    [totalTipLbl setText:@"支付金额："];
    [self.contentView addSubview:totalTipLbl];
    
    UILabel *totalLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(totalTipLbl.frame), 12, 200, 25)];
    [totalLbl setBackgroundColor:[UIColor clearColor]];
    [totalLbl setTextAlignment:NSTextAlignmentLeft];
    [totalLbl setFont:[UIFont systemFontOfSize:18.0]];
    [totalLbl setTextColor:[UIColor colorWithRed:0.98 green:0.3 blue:0.4 alpha:1]];
    NSString *totalPrice;
    CGFloat Price = _totalPrice;
    if ((Price * 10) - (int)(Price * 10) > 0) {
        totalPrice = [NSString stringWithFormat:@"¥%0.2f",_totalPrice];
    } else if(Price - (int)Price > 0) {
        totalPrice = [NSString stringWithFormat:@"¥%0.1f",_totalPrice];
    } else {
        totalPrice = [NSString stringWithFormat:@"¥%0.0f",_totalPrice];
    }
    [totalLbl setText:totalPrice];
    [self.contentView addSubview:totalLbl];
    
    if (!_pwdBg) {
        _pwdBg = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(totalTipLbl.frame),  CGRectGetMaxY(totalTipLbl.frame) + 12, 300, 37)];
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
        [_pwdTF setPlaceholder:@"请输入钱包支付密码："];
        
        [_pwdBg addSubview:_pwdTF];
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
        [_comfirmBtn setFrame:CGRectMake(10, CGRectGetMaxY(_pwdBg.frame) + 25, w - 20, 40)];
        [_comfirmBtn addTarget:self action:@selector(walletPayOperation) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_comfirmBtn];
    }
}

- (void)checkLogin
{
    if (![[kata_UserManager sharedUserManager] isLogin]) {
        [self performSelector:@selector(showLoginView) withObject:nil afterDelay:0.1];
    }
}

- (void)showLoginView
{
    [kata_LoginViewController showInViewController:self];
}

#pragma mark - KTWalletPayRequest
- (void)walletPayOperation
{
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
        req = [[KTWalletPayRequest alloc] initWithUserID:[userid integerValue]
                                            andUserToken:usertoken
                                              andOrderID:_orderid
                                               andPayPwd:_pwdTF.text];
    }
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(walletPaytParseResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (void)walletPaytParseResponse:(NSString *)resp
{
    NSString * hudPrefixStr = @"订单支付";
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            if (nil != [respDict objectForKey:@"data"] && ![[respDict objectForKey:@"data"] isEqual:[NSNull null]] && [[respDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *dataObj = (NSDictionary *)[respDict objectForKey:@"data"];
                if ([[dataObj objectForKey:@"code"] integerValue] == 0) {
                    
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
                    [self performSelectorOnMainThread:@selector(afterPayFinish) withObject:nil waitUntilDone:YES];
                    
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

- (void)afterPayFinish
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"订单支付成功"
                                  delegate:self
                                  cancelButtonTitle:nil
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"查看订单",
                                  @"返回继续购物", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [actionSheet showInView:self.view];
    
    [stateHud hide:YES afterDelay:1.0];
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
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //查看订单详情
        kata_OrderDetailViewController *detailVC = [[kata_OrderDetailViewController alloc] initWithOrderID:_orderid andType:-1 antPartnerID:-1];
        detailVC.navigationController = self.navigationController;
        detailVC.navigationController.ifPopToRootView = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    } else if (buttonIndex == 1) {
        //返回继续购物
        [self.navigationController popToRootViewControllerAnimated:YES];
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
