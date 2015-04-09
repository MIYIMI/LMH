//
//  kata_OrderReturnViewController.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-7-2.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "kata_OrderReturnViewController.h"
#import "BOKUNoActionTextField.h"
#import "kata_UserManager.h"
#import "KTProxy.h"
#import "KTOrderReturnRequest.h"

@interface kata_OrderReturnViewController ()
{
    NSString *_orderID;
    UITextField *_edittingTF;
    UITextView *_edittingTV;
    BOKUNoActionTextField *_companyTF;
    BOKUNoActionTextField *_lognumTF;
    BOKUNoActionTextField *_mobileTF;
    UITextView *_reasonTV;
    UIView *_companyBg;
    UIView *_lognumBg;
    UIView *_mobileBg;
    UIButton *_rtnMask;
    UILabel *_reasonTVPHLbl;
    UIBarButtonItem *_submitItem;
    UIButton *_submitBtn;
}

@end

@implementation kata_OrderReturnViewController

- (id)initWithOrderID:(NSString *)orderid
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        _orderID = orderid;
        self.title = @"申请退款";
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
    
    if (!_submitItem) {
        UIButton * submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [submitBtn setFrame:CGRectMake(0, 0, 30, 30)];
        [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [submitBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
        _submitBtn = submitBtn;
        
        UIImage *image = [UIImage imageNamed:@"nav_comfirm_btn"];
        [submitBtn setImage:image forState:UIControlStateNormal];
        
        [submitBtn addTarget:self action:@selector(orderReturnOperation) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem * submitItem = [[UIBarButtonItem alloc] initWithCustomView:submitBtn];
        _submitItem = submitItem;
    }
    [self.navigationController addRightBarButtonItem:_submitItem animation:NO];
    
    if (!_companyBg) {
        _companyBg = [[UIView alloc] initWithFrame:CGRectMake(10,  10, w - 20, 37)];
        [_companyBg setBackgroundColor:[UIColor whiteColor]];
        [_companyBg setTag:2020];
        [_companyBg.layer setBorderWidth:0.5];
        [_companyBg.layer setBorderColor:[UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1].CGColor];
        [_companyBg.layer setCornerRadius:4.0];
        [self.contentView addSubview:_companyBg];
    }
    
    if (!_companyTF) {
        _companyTF = [[BOKUNoActionTextField alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(_companyBg.frame) - 20, CGRectGetHeight(_companyBg.frame))];
        [_companyTF setBackgroundColor:[UIColor clearColor]];
        [_companyTF setTextColor:[UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f]];
        [_companyTF setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [_companyTF setFont:[UIFont systemFontOfSize:15.0]];
        [_companyTF setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [_companyTF setAutocorrectionType:UITextAutocorrectionTypeNo];
        [_companyTF setReturnKeyType:UIReturnKeyDefault];
        [_companyTF setSecureTextEntry:NO];
        [_companyTF setDelegate:self];
        [_companyTF setPlaceholder:@"请输入快递公司名称"];
        
        [_companyBg addSubview:_companyTF];
    }
    
    if (!_lognumBg) {
        _lognumBg = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_companyBg.frame), CGRectGetMaxY(_companyBg.frame) + 10, CGRectGetWidth(_companyBg.frame), CGRectGetHeight(_companyBg.frame))];
        [_lognumBg setBackgroundColor:[UIColor whiteColor]];
        [_lognumBg setTag:2020];
        [_lognumBg.layer setBorderWidth:0.5];
        [_lognumBg.layer setBorderColor:[UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1].CGColor];
        [_lognumBg.layer setCornerRadius:4.0];
        
        [self.contentView addSubview:_lognumBg];
    }
    
    if (!_lognumTF) {
        _lognumTF = [[BOKUNoActionTextField alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(_lognumBg.frame) - 20, CGRectGetHeight(_lognumBg.frame))];
        [_lognumTF setBackgroundColor:[UIColor clearColor]];
        [_lognumTF setTextColor:[UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f]];
        [_lognumTF setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [_lognumTF setFont:[UIFont systemFontOfSize:15.0]];
        [_lognumTF setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [_lognumTF setAutocorrectionType:UITextAutocorrectionTypeNo];
        [_lognumTF setKeyboardType:UIKeyboardTypeASCIICapable];
        [_lognumTF setReturnKeyType:UIReturnKeyDefault];
        [_lognumTF setDelegate:self];
        [_lognumTF setPlaceholder:@"请输入您的快递单号"];
        
        [_lognumBg addSubview:_lognumTF];
    }
    
    if (!_mobileBg) {
        _mobileBg = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_lognumBg.frame), CGRectGetMaxY(_lognumBg.frame) + 10, CGRectGetWidth(_lognumBg.frame), CGRectGetHeight(_lognumBg.frame))];
        [_mobileBg setBackgroundColor:[UIColor whiteColor]];
        [_mobileBg setTag:2020];
        [_mobileBg.layer setBorderWidth:0.5];
        [_mobileBg.layer setBorderColor:[UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1].CGColor];
        [_mobileBg.layer setCornerRadius:4.0];
        
        [self.contentView addSubview:_mobileBg];
    }
    
    if (!_mobileTF) {
        _mobileTF = [[BOKUNoActionTextField alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(_lognumBg.frame) - 20, CGRectGetHeight(_lognumBg.frame))];
        [_mobileTF setBackgroundColor:[UIColor clearColor]];
        [_mobileTF setTextColor:[UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f]];
        [_mobileTF setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [_mobileTF setFont:[UIFont systemFontOfSize:15.0]];
        [_mobileTF setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [_mobileTF setAutocorrectionType:UITextAutocorrectionTypeNo];
        [_mobileTF setKeyboardType:UIKeyboardTypePhonePad];
        [_mobileTF setDelegate:self];
        [_mobileTF setPlaceholder:@"请输入您的联系方式"];
        
        [_mobileBg addSubview:_mobileTF];
    }
    
    if (!_reasonTV) {
        _reasonTV = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_mobileBg.frame), CGRectGetMaxY(_mobileBg.frame) + 10, CGRectGetWidth(_mobileBg.frame), 126)];
        [_reasonTV setTextContainerInset:UIEdgeInsetsMake(5, 5, 5, 5)];
        [_reasonTV setBackgroundColor:[UIColor clearColor]];
        [_reasonTV setTextColor:[UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f]];
        [_reasonTV setFont:[UIFont systemFontOfSize:15.0]];
        [_reasonTV setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [_reasonTV setAutocorrectionType:UITextAutocorrectionTypeNo];
        [_reasonTV setReturnKeyType:UIReturnKeyDone];
        [_reasonTV setDelegate:self];
        [_reasonTV.layer setBorderWidth:0.5];
        [_reasonTV.layer setBorderColor:[UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1].CGColor];
        [_reasonTV.layer setCornerRadius:4.0];
        
        [self.contentView addSubview:_reasonTV];
    }
    
    if (!_reasonTVPHLbl) {
        _reasonTVPHLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_reasonTV.frame) + 10, CGRectGetMinY(_reasonTV.frame) + 4, 150, 20)];
        [_reasonTVPHLbl setBackgroundColor:[UIColor clearColor]];
        [_reasonTVPHLbl setTextColor:[UIColor colorWithRed:0.78 green:0.78 blue:0.8 alpha:1]];
        [_reasonTVPHLbl setFont:[UIFont systemFontOfSize:15.0]];
        [_reasonTVPHLbl setText:@"请输入您退款的理由"];
        
        [self.contentView addSubview:_reasonTVPHLbl];
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
- (void)orderReturnOperation
{
    [self hideInputControl];
    if (!_companyTF.text || [_companyTF.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"请输入快递公司名称"
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert setTag:1001];
        [alert show];
        
        return;
    }
    
    if (!_lognumTF.text || [_lognumTF.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"请输入快递单号"
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert setTag:1002];
        [alert show];
        
        return;
    }
    
    if (!_mobileTF.text || [_mobileTF.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"请输入您的联系方式"
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert setTag:1003];
        [alert show];
        
        return;
    }
    
    if (!_reasonTV.text || [_reasonTV.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"请输入退款理由"
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert setTag:1004];
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
        req = [[KTOrderReturnRequest alloc] initWithUserID:[userid integerValue]
                                              andUserToken:usertoken
                                                andOrderID:[_orderID integerValue]
                                                andContack:_mobileTF.text
                                              andLogistics:_lognumTF.text
                                                 andReason:_reasonTV.text
                                                andCompany:_companyTF.text];
    }
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(orderReturnParseResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (void)orderReturnParseResponse:(NSString *)resp
{
    NSString * hudPrefixStr = @"订单退款";
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
                    [self performSelectorOnMainThread:@selector(afterReturnSuccess) withObject:nil waitUntilDone:YES];
                    
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

- (void)afterReturnSuccess
{
    [self.navigationController popViewControllerAnimated:YES];
    if (self.rtnViewDelegate && [self.rtnViewDelegate respondsToSelector:@selector(returnSuccess)]) {
        [self.rtnViewDelegate returnSuccess];
    }
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (!_rtnMask) {
        _edittingTF = textField;
		_rtnMask = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
		_rtnMask.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
		[_rtnMask addTarget:self action:@selector(hideInputControl) forControlEvents:UIControlEventTouchUpInside];
		_rtnMask.alpha = 0;
		[self.contentView addSubview:_rtnMask];
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveLinear];
		[UIView setAnimationDuration:0.3];
		_rtnMask.alpha = 1;
		[UIView commitAnimations];
	}
    
    if (_edittingTF && [_edittingTF.superview isKindOfClass:[UIView class]] && _edittingTF.superview.tag == 2020) {
        UIView *bg = _edittingTF.superview;
        [bg.layer setBorderWidth:1.0];
        [bg.layer setBorderColor:[UIColor colorWithRed:0.98 green:0.32 blue:0.44 alpha:1].CGColor];
    }
    
    return YES;
}

#pragma mark - UITextView Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (!_rtnMask) {
        _edittingTV = textView;
		_rtnMask = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
		_rtnMask.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
		[_rtnMask addTarget:self action:@selector(hideInputControl) forControlEvents:UIControlEventTouchUpInside];
		_rtnMask.alpha = 0;
		[self.contentView addSubview:_rtnMask];
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveLinear];
		[UIView setAnimationDuration:0.3];
		_rtnMask.alpha = 1;
		[UIView commitAnimations];
	}
    
    if (_edittingTV) {
        [_edittingTV.layer setBorderWidth:1.0];
        [_edittingTV.layer setBorderColor:[UIColor colorWithRed:0.98 green:0.32 blue:0.44 alpha:1].CGColor];
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        [_reasonTVPHLbl setHidden:NO];
    } else {
        [_reasonTVPHLbl setHidden:YES];
    }
}

- (void)hideInputControl
{
	[self resignCurrentFirstResponder];
    
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(removeMask)];
	_rtnMask.alpha = 0;
	[UIView commitAnimations];
    
    if (_edittingTF && [_edittingTF.superview isKindOfClass:[UIView class]] && _edittingTF.superview.tag == 2020) {
        UIView *bg = _edittingTF.superview;
        [bg.layer setBorderWidth:0.5];
        [bg.layer setBorderColor:[UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1].CGColor];
    }
    
    if (_edittingTV) {
        [_edittingTV.layer setBorderWidth:0.5];
        [_edittingTV.layer setBorderColor:[UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1].CGColor];
    }
}

- (void)removeMask
{
	if (_rtnMask) {
		[_rtnMask removeFromSuperview];
		_rtnMask = nil;
	}
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSInteger tag = alertView.tag;
    
    switch (tag) {
        case 1001:
        {
            [_companyTF becomeFirstResponder];
        }
            break;
            
        case 1002:
        {
            [_lognumTF becomeFirstResponder];
        }
            break;
            
        case 1003:
        {
            [_mobileTF becomeFirstResponder];
        }
            break;
            
        case 1004:
        {
            [_reasonTV becomeFirstResponder];
        }
            break;
            
        default:
            break;
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
