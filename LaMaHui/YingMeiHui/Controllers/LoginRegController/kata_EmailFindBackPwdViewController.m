//
//  kata_EmailFindBackPwdViewController.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-7-4.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "kata_EmailFindBackPwdViewController.h"
#import "BOKUNoActionTextField.h"
#import "KTEmailPasswordRequest.h"
#import "KTProxy.h"

@interface kata_EmailFindBackPwdViewController ()
{
    BOKUNoActionTextField *_usernameTF;
    UITextField *_edittingTF;
    UIView *_usernameBg;
    UIButton *_sendBtn;
    UIButton *_findMask;
}

@end

@implementation kata_EmailFindBackPwdViewController

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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(chargeTFChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)chargeTFChanged:(NSNotification *)notification
{
    if (_usernameTF.text.length > 0) {
        [_sendBtn setEnabled:YES];
    } else {
        [_sendBtn setEnabled:NO];
    }
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
    [mobileLbl setText:@"请输入您的登录名，您的登录名需为E-mail"];
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
        [_usernameTF setPlaceholder:@"请输入您的E-mail"];
        
        [_usernameBg addSubview:_usernameTF];
    }
    
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:@"registerbtn"];
        image = [image stretchableImageWithLeftCapWidth:10.0f topCapHeight:10.0f];
        [_sendBtn setBackgroundImage:image forState:UIControlStateNormal];
        image = [UIImage imageNamed:@"registerbtn_selected"];
        image = [image stretchableImageWithLeftCapWidth:10.0f topCapHeight:10.0f];
        [_sendBtn setBackgroundImage:image forState:UIControlStateHighlighted];
        [_sendBtn setBackgroundImage:image forState:UIControlStateSelected];
        [_sendBtn setBackgroundImage:image forState:UIControlStateNormal];
        [_sendBtn setTitle:@"发送重置邮件" forState:UIControlStateNormal];
        [_sendBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [_sendBtn setFrame:CGRectMake(10, CGRectGetMaxY(_usernameBg.frame) + 40, w - 20, 40)];
        [_sendBtn addTarget:self action:@selector(sendVerifyEmail) forControlEvents:UIControlEventTouchUpInside];
        [_sendBtn setEnabled:NO];
        
        [self.contentView addSubview:_sendBtn];
    }
}

- (void)sendVerifyEmail
{
    //账号正则检测：为邮箱格式
    NSString *emailRegex = @"^\\w+((\\-\\w+)|(\\.\\w+))*@[A-Za-z0-9]+((\\.|\\-)[A-Za-z0-9]+)*.[A-Za-z0-9]+$";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    if (!_usernameTF.text || [_usernameTF.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"请输入您的E-mail"
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert setTag:1004];
        [alert show];
        
        return;
    }
    
    if (![emailPredicate evaluateWithObject:_usernameTF.text]) {
        //        或为4-20个字符，首个字符需要为字母，只能包含数字或下划线
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"邮箱格式错误"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
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
    
    if (_usernameTF.text) {
        req = [[KTEmailPasswordRequest alloc] initWithEmail:_usernameTF.text];
    }
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(sendVerifyEmailParseResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (void)sendVerifyEmailParseResponse:(NSString *)resp
{
    NSString *hudPrefixStr = @"发送重置邮件";
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
    [self performSelector:@selector(successPopView) withObject:nil afterDelay:0.3];
}

- (void)hideHUDView
{
    [stateHud hide:YES afterDelay:1.0];
}

- (void)successPopView
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (!_findMask) {
        _edittingTF = textField;
		_findMask = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
		_findMask.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
		[_findMask addTarget:self action:@selector(hideInputControl) forControlEvents:UIControlEventTouchUpInside];
		_findMask.alpha = 0;
		[self.contentView addSubview:_findMask];
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveLinear];
		[UIView setAnimationDuration:0.3];
		_findMask.alpha = 1;
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
	_findMask.alpha = 0;
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
	if (_findMask) {
		[_findMask removeFromSuperview];
		_findMask = nil;
	}
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger tag = alertView.tag;
    
    if (tag == 1004) {
        [self resignCurrentFirstResponder];
        [_usernameTF becomeFirstResponder];
    }
}

@end
