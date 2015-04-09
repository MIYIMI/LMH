//
//  LMHChangePassworldViewController.m
//  YingMeiHui
//
//  Created by Zhumingming on 14-11-28.
//  Copyright (c) 2014年 xieyanke. All rights reserved.
//

#import "LMHChangePassworldViewController.h"
#import "LMHChangePasswordRequest.h"
#import "kata_UserManager.h"
#import "KTProxy.h"

@interface LMHChangePassworldViewController ()
{
    UITextField *_edittingTF;
    UIButton *submitButton;
}
@property (readonly, nonatomic) UITableView *changePassworldTableView;

@property (strong, nonatomic) kata_TextField *presentPasswordField;
@property (strong, nonatomic) kata_TextField *changePassworldField;
@property (strong, nonatomic) kata_TextField *retypePasswordField;

@end

@implementation LMHChangePassworldViewController

@synthesize changePassworldTableView = _changePassworldTableView;
@synthesize presentPasswordField = _presentPasswordField;
@synthesize changePassworldField = _changePassworldField;
@synthesize retypePasswordField = _retypePasswordField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.title = @"修改密码";
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    CGRect frame = self.contentView.frame;
    frame.size.height += 20;
    self.contentView.frame = frame;
    
    self.contentView.backgroundColor = [UIColor colorWithRed:1 green:0.97 blue:0.97 alpha:1];
    
    [self createUI];
    UITapGestureRecognizer *tapZer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView)];
    [self.view addGestureRecognizer:tapZer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)tapView{
    [self.view endEditing:YES];
}

- (void)submitBtnClick
{
    [_presentPasswordField resignFirstResponder];
    [_changePassworldField resignFirstResponder];
    [_retypePasswordField resignFirstResponder];
    
    if (_presentPasswordField.text.length == 0) {
        [BDProgressHUD autoShowHUDAddedTo:self.view withText:@"请输入当前密码"];
        [self performSelector:@selector(presentTextFieldHandle) withObject:nil afterDelay:2];
    }
    else if ((_presentPasswordField.text.length < 6) || (_presentPasswordField.text.length > 20)) {
        
        [BDProgressHUD autoShowHUDAddedTo:self.view withText:@"请输入6-20位当前密码"];
        
        [self performSelector:@selector(presentTextFieldHandle) withObject:nil afterDelay:2];
    }
    else if (_changePassworldField.text.length == 0) {
        [BDProgressHUD autoShowHUDAddedTo:self.view withText:@"请输入新密码"];
        [self performSelector:@selector(changePassworldFieldHandle) withObject:nil afterDelay:2];
    }
    else if ((_changePassworldField.text.length < 6) || (_changePassworldField.text.length > 20)) {
        
        [BDProgressHUD autoShowHUDAddedTo:self.view withText:@"请输入6-20位新密码"];
        
        [self performSelector:@selector(changePassworldFieldHandle) withObject:nil afterDelay:2];
    }
    else if (_retypePasswordField.text.length == 0 ) {
        [BDProgressHUD autoShowHUDAddedTo:self.view withText:@"请再次输入新密码"];
        [self performSelector:@selector(retypePasswordFieldHandle) withObject:nil afterDelay:2];
    }
    else if (![_changePassworldField.text isEqualToString:_retypePasswordField.text]) {
        
        [BDProgressHUD autoShowHUDAddedTo:self.view withText:@"两次输入密码不一致"];

        [self performSelector:@selector(retypePasswordFieldHandle) withObject:nil afterDelay:2];
        
    }else{
        [self changePasswordRequest];
    }
    
}

- (void)changePasswordRequest
{
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
        req = [[LMHChangePasswordRequest alloc] initWithUserID:[userid integerValue]
                                                 andUserToken:usertoken
                                                   andold_pwd:_presentPasswordField.text
                                                   andnew_pwd:_changePassworldField.text];
    }
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(changePasswordParseResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (void)changePasswordParseResponse:(NSString *)resp
{
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
                
                [BDProgressHUD autoShowHUDAddedTo:self.view withText:@"密码更新成功"];
    
               [self performSelector:@selector(popTOViewController) withObject:nil afterDelay:2];
            
            
            } else {
                
                //旧密码错误
                
                [BDProgressHUD autoShowHUDAddedTo:self.view withText:[respDict objectForKey:@"msg"]];
                
                [self performSelector:@selector(presentTextFieldHandle) withObject:nil afterDelay:2];
                

            }
    } 
}

#pragma mark -- 延迟处理
- (void)presentTextFieldHandle
{
    [_presentPasswordField becomeFirstResponder];
}

- (void)changePassworldFieldHandle
{
    [_changePassworldField becomeFirstResponder];
}

- (void)retypePasswordFieldHandle
{
    [_retypePasswordField becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _presentPasswordField) {
        [_changePassworldField becomeFirstResponder];
    }else if (textField == _changePassworldField){
        [_retypePasswordField becomeFirstResponder];
    }else{
         [_retypePasswordField resignFirstResponder];
    }
    return YES;
}

- (void)popTOViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createUI
{
    _changePassworldTableView = [self registerFormTableView];
}

#pragma mark - Getter
- (UITableView *)registerFormTableView
{
    if (!_changePassworldTableView) {
        _changePassworldTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height) style:UITableViewStylePlain];
        _changePassworldTableView.delegate = self;
        _changePassworldTableView.dataSource = self;
        _changePassworldTableView.bounces = NO;
        [_changePassworldTableView setBackgroundView:nil];
        [_changePassworldTableView setBackgroundColor:[UIColor whiteColor]];
        [_changePassworldTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 15)];
        [_changePassworldTableView setTableHeaderView:header];
        [self.contentView addSubview:_changePassworldTableView];
    }
    return _changePassworldTableView;
}
#pragma mark - TableView Delegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row < 3) {
        return 46;
    }else{
        return 80;
    }
    return 0;
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
    
    if(indexPath.row == 3){
        bg.frame = CGRectZero;
    }else{
        bg.frame = CGRectMake(10, 0, w - 20, 36);
    }
    
    switch (row) {
        case 0:
        {
            kata_TextField *presentPassworldField = [[kata_TextField alloc] initWithFrame:CGRectMake(10, 1, w - 40, 30)];
            presentPassworldField.clearButtonMode = UITextFieldViewModeWhileEditing;
            presentPassworldField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            presentPassworldField.autocorrectionType = UITextAutocorrectionTypeNo;
            presentPassworldField.placeholder = @"当前密码";
            presentPassworldField.tag = 101;
            presentPassworldField.secureTextEntry = YES;
            presentPassworldField.returnKeyType = UIReturnKeyNext;
            presentPassworldField.textColor = [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f];
            presentPassworldField.font = [UIFont systemFontOfSize:15.0f];
            presentPassworldField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            presentPassworldField.delegate = self;
            
            [bg addSubview:presentPassworldField];
            self.presentPasswordField = presentPassworldField;
        }
            break;
            
        case 1:
        {
            kata_TextField *changePassworldField = [[kata_TextField alloc] initWithFrame:CGRectMake(10, 1, w - 40, 30)];
            changePassworldField.keyboardType = UIKeyboardTypeASCIICapable;
            changePassworldField.backgroundColor = [UIColor clearColor];
            changePassworldField.placeholder = @"新密码";
            changePassworldField.tag = 102;
            changePassworldField.autocorrectionType = UITextAutocorrectionTypeNo;
            changePassworldField.secureTextEntry = YES;
            changePassworldField.textColor = [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f];
            changePassworldField.font = [UIFont systemFontOfSize:15.0f];
            changePassworldField.returnKeyType = UIReturnKeyNext;
            changePassworldField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            changePassworldField.delegate = self;
            
            [bg addSubview:changePassworldField];
            
            self.changePassworldField = changePassworldField;
            
            
            
        }
            break;
            
        case 2:
        {
            kata_TextField *retypePasswordField = [[kata_TextField alloc] initWithFrame:CGRectMake(10, 1, w - 40, 30)];
            retypePasswordField.keyboardType = UIKeyboardTypeASCIICapable;
            retypePasswordField.placeholder = @"确认新密码";
            retypePasswordField.tag = 102;
            retypePasswordField.textColor = [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f];
            retypePasswordField.font = [UIFont systemFontOfSize:15.0f];
            retypePasswordField.returnKeyType = UIReturnKeyDone;
            retypePasswordField.secureTextEntry = YES;
            retypePasswordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            retypePasswordField.delegate = self;
            
            [bg addSubview:retypePasswordField];
            self.retypePasswordField = retypePasswordField;
        }
            break;
        case 3:{
            //确认提交按钮
            if (!submitButton) {
                submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
                submitButton.frame = CGRectMake(10, 20, ScreenW - 20 , 40);
                [submitButton setBackgroundImage:[UIImage imageNamed:@"red_btn_big"] forState:UIControlStateNormal];    [submitButton setTitle:@"确认提交" forState:UIControlStateNormal];
                submitButton.titleLabel.font = FONT(16);
                [submitButton addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
            }
            [cell.contentView addSubview:submitButton];
        }
            break;
        default:
            break;
    }
    return cell;
}



#pragma mark - UITextField Input Delegate
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(paste:))
        return NO;
    return [super canPerformAction:action withSender:sender];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self hideInputControl];
    _edittingTF = textField;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:0.3];
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyboardWillChange:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    frame.size.height -= keyboardRect.size.height;
    _changePassworldTableView.frame = frame;
}

- (void)keyboardWillHide:(NSNotification *)notification{
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    _changePassworldTableView.frame = frame;
}

@end
