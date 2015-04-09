//
//  kata_FeedbackSubmitViewController.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-21.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "kata_FeedbackSubmitViewController.h"
#import "KTMessageCommitPostRequest.h"
#import "kata_UserManager.h"
#import "KTProxy.h"

#define VIEWBGCOLOR        [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1]

@interface kata_FeedbackSubmitViewController ()
{
    UITextView *_feedbackTV;
    UIButton *_feedbackMask;
    UIBarButtonItem *_saveItem;
    UIButton *_saveBtn;
    UILabel *_placeHolderLbl;
    
    UIButton *_tsukkomiBtn; //我要吐槽 按钮
}

@end

@implementation kata_FeedbackSubmitViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    if (!_saveItem) {
//        UIButton * saveBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        [saveBtn setFrame:CGRectMake(0, 0, 53, 30)];
//        [saveBtn setTitle:@"提交" forState:UIControlStateNormal];
//        [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [saveBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
//        _saveBtn = saveBtn;
//        
//        UIImage *image = [UIImage imageNamed:@"rightheaderbtn"];
//        image = [image stretchableImageWithLeftCapWidth:10.0f topCapHeight:10.0f];
//        [saveBtn setBackgroundImage:image forState:UIControlStateNormal];
//        image = [UIImage imageNamed:@"rightheaderbtn_selected"];
//        image = [image stretchableImageWithLeftCapWidth:10.0f topCapHeight:10.0f];
//        [saveBtn setBackgroundImage:image forState:UIControlStateHighlighted];
//        [saveBtn setBackgroundImage:image forState:UIControlStateSelected];
//        
//        [saveBtn addTarget:self action:@selector(savePressed) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem * saveItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
//        _saveItem = saveItem;
//    }
//    
//    [self.navigationController addRightBarButtonItem:_saveItem animation:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_saveItem) {
        [self.navigationController addRightBarButtonItem:nil animation:NO];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self.contentView setFrame:self.view.frame];
    if (!IOS_7) {
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

- (void)createUI
{
    [self.contentView setBackgroundColor:VIEWBGCOLOR];
    CGFloat w = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(16, 12, w - 32, 133)];
    [bg setBackgroundColor:[UIColor whiteColor]];
    [bg.layer setCornerRadius:4.0];
    [bg.layer setBorderColor:[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1].CGColor];
    [bg.layer setBorderWidth:1.0];
    [bg.layer setShadowColor:[UIColor grayColor].CGColor];
    [bg.layer setShadowOpacity:0.1];
    [bg.layer setShadowOffset:CGSizeMake(0, 0)];
    [self.contentView addSubview:bg];
    
    if (!_tsukkomiBtn) {
        _tsukkomiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tsukkomiBtn setBackgroundImage:[UIImage imageNamed:@"red_btn_big"] forState:UIControlStateNormal];
        _tsukkomiBtn.frame = CGRectMake(15, 170, ScreenW - 30, 40);
        [_tsukkomiBtn setTitle:@"我要吐槽" forState:UIControlStateNormal];
        _tsukkomiBtn.titleLabel.font = FONT(15);
        [_tsukkomiBtn addTarget:self action:@selector(savePressed) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_tsukkomiBtn];
    }
    
    if (!_feedbackTV) {
        _feedbackTV = [[UITextView alloc] initWithFrame:bg.frame];
        [_feedbackTV setFont:[UIFont systemFontOfSize:14.0]];
        [_feedbackTV setBackgroundColor:[UIColor clearColor]];
        _feedbackTV.delegate = self;
        
        [self.contentView addSubview:_feedbackTV];
    }
    
    if (!_placeHolderLbl) {
        _placeHolderLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(bg.frame) + 5, CGRectGetMinY(bg.frame) + 9, CGRectGetWidth(bg.frame) - 10, 15)];
        [_placeHolderLbl setFont:[UIFont systemFontOfSize:14.0]];
        [_placeHolderLbl setText:@"请输入吐槽内容"];
        [_placeHolderLbl setTextColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1]];
        
        [self.contentView addSubview:_placeHolderLbl];
    }
}

- (void)savePressed
{
    NSString *feedbackValue = _feedbackTV.text;
    
    if (!feedbackValue || [feedbackValue isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"吐槽 内容不得为空"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        alert.tag = 30007;
        [alert show];
        
        return;
    }
    
    [_feedbackTV resignFirstResponder];
    [self saveOperation];
}

- (void)enableSaveButton
{
    [_saveBtn setEnabled:YES];
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

#pragma mark - SubmitRequest
- (void)saveOperation
{
    [_saveBtn setEnabled:NO];
    if (!stateHud) {
        stateHud = [[MBProgressHUD alloc] initWithView:self.contentView];
        stateHud.delegate = self;
        [self.contentView addSubview:stateHud];
    }
    stateHud.mode = MBProgressHUDModeIndeterminate;
    stateHud.labelFont = [UIFont systemFontOfSize:14.0f];
    [stateHud show:YES];
    
    NSString *userid = nil;
    NSString *usertoken = nil;
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isEqualToString:@""]) {
        userid = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"];
    }
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isEqualToString:@""]) {
        usertoken = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"];
    }
    
    KTBaseRequest *req = [[KTMessageCommitPostRequest alloc]initWithUserID:[userid integerValue] andUserToken:usertoken Content:_feedbackTV.text];
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(saveParseResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (void)saveParseResponse:(NSString *)resp
{
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            id dataObj = [respDict objectForKey:@"data"];
            
            if ([[dataObj objectForKey:@"code"] intValue] == 0) {
                [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"提交成功" waitUntilDone:YES];
                [self performSelector:@selector(saveSuccess) withObject:nil afterDelay:1];
            } else {
                id messageObj = [dataObj objectForKey:@"msg"];
                if (messageObj && [messageObj isKindOfClass:[NSString class]]) {
                    if (![messageObj isEqualToString:@""]) {
                        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:messageObj waitUntilDone:YES];
                    } else {
                        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"提交失败" waitUntilDone:YES];
                    }
                } else {
                    [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"提交失败" waitUntilDone:YES];
                }
                [self performSelectorOnMainThread:@selector(enableSaveButton) withObject:nil waitUntilDone:YES];
                
                if ([[dataObj objectForKey:@"code"] intValue] == -102) {
                    [[kata_UserManager sharedUserManager] logout];
                    [self performSelectorOnMainThread:@selector(checkLogin) withObject:nil waitUntilDone:YES];
                    
                }
            }
        } else {
            id messageObj = [respDict objectForKey:@"msg"];
            if (messageObj && [messageObj isKindOfClass:[NSString class]]) {
                if (![messageObj isEqualToString:@""]) {
                    [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:messageObj waitUntilDone:YES];
                } else {
                    [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"提交失败" waitUntilDone:YES];
                }
            } else {
                [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"提交失败" waitUntilDone:YES];
            }
            [self performSelectorOnMainThread:@selector(enableSaveButton) withObject:nil waitUntilDone:YES];
        }
    } else {
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"提交失败" waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(enableSaveButton) withObject:nil waitUntilDone:YES];
    }
}

- (void)saveSuccess
{
    if ([self.delegate respondsToSelector:@selector(changeView:)]) {
        [self.delegate changeView:@"历史吐槽"];
    }
}

#pragma mark - UITextView Delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location == 0) {
        if (textView.text.length > 0) {
            [_placeHolderLbl setHidden:NO];
        } else {
            [_placeHolderLbl setHidden:YES];
        }
    } else {
        if (textView.text.length > 0) {
            [_placeHolderLbl setHidden:YES];
        } else {
            [_placeHolderLbl setHidden:NO];
        }
    }
    
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (!_feedbackMask) {
		_feedbackMask = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
		_feedbackMask.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
		[_feedbackMask addTarget:self action:@selector(hideInputControl) forControlEvents:UIControlEventTouchUpInside];
		_feedbackMask.alpha = 0;
		[self.contentView addSubview:_feedbackMask];
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveLinear];
		[UIView setAnimationDuration:0.3];
		_feedbackMask.alpha = 1;
		[UIView commitAnimations];
	}
    return YES;
}

- (void)hideInputControl
{
    [_feedbackTV resignFirstResponder];
    
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(removeMask)];
	_feedbackMask.alpha = 0;
	[UIView commitAnimations];
}

- (void)removeMask
{
	if (_feedbackMask) {
		[_feedbackMask removeFromSuperview];
		_feedbackMask = nil;
	}
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSInteger tag = alertView.tag;
    if (tag == 30007) {
        [_feedbackTV becomeFirstResponder];
    }
}

#pragma mark - Login Delegate
- (void)didLogin
{
    
}

- (void)loginCancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
