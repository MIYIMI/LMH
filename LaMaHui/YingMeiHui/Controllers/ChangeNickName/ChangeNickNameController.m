//
//  ChangeNickNameController.m
//  YingMeiHui
//
//  Created by Zhumingming on 14-12-22.
//  Copyright (c) 2014年 xieyanke. All rights reserved.
//

#import "ChangeNickNameController.h"
#import "kata_UserManager.h"
#import "KTProxy.h"
#import "LMHChangeUserIconRequest.h"


@interface ChangeNickNameController ()
{
    UITextField *_textField;
    
    
}
@end

@implementation ChangeNickNameController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"修改昵称";
    
    //保存按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 50, 30);
    rightBtn.backgroundColor = [UIColor clearColor];
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = FONT(15);
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect frame = self.contentView.frame;
    frame.size.height += 64;
    self.contentView.frame = frame;
    self.contentView.backgroundColor = [UIColor colorWithRed:1 green:0.97 blue:0.97 alpha:1];
    
   
    
    [self createUI];
}
- (void)createUI
{
    //输入框
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 15, ScreenW - 20, 50)];
    _textField.textColor = BLACK_COLOR;
    _textField.font = FONT(18);
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.borderStyle = UITextBorderStyleNone;
    _textField.layer.borderWidth = 1.0;
    _textField.clearButtonMode = YES;
    _textField.text = self.niciname;
    _textField.layer.borderColor = [GRAY_LINE_COLOR CGColor];
    _textField.layer.masksToBounds = YES;
    _textField.layer.cornerRadius = 3;
    _textField.delegate = self;
    _textField.returnKeyType = UIReturnKeyNext;
    
    UIView *leftview = [[UIView alloc]initWithFrame:CGRectMake(0, 10, 10, 20)];
    leftview.backgroundColor = [UIColor clearColor];
    _textField.leftView = leftview;
    _textField.leftViewMode = UITextFieldViewModeAlways;
    
    [self.contentView addSubview:_textField];
    
    
    //文字label
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 65, ScreenW - 20, 50)];
    label.text = @"昵称支持中英文、数字、下划线";
    label.backgroundColor = [UIColor clearColor];
    label.textColor = GRAY_COLOR;
//    label.textAlignment = NSTextAlignmentCenter;
    label.font = FONT(15);
    label.numberOfLines = 1;
    [self.contentView addSubview:label];
    
    
}
#pragma mark -- 网络 修改昵称

- (void)changeUserNickNameInfoOperation
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
        
        req = [[LMHChangeUserIconRequest alloc]initWithUserID:[userid integerValue]
                                                 andUserToken:usertoken
                                                   user_image:nil
                                                    user_name:_textField.text];
        
    }
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(changeUserNickNameInfoParseResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (void)changeUserNickNameInfoParseResponse:(NSString *)resp
{
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            
            [self textStateHUD:@"修改成功"];
            
            //通知 上个界面 改变nickName 
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc postNotificationName:@"changePersonInfoNickName" object:_textField.text userInfo:nil];
            
            [self performSelector:@selector(POPTOViewController) withObject:nil afterDelay:3];
        }
        else{
            [self textStateHUD:[respDict objectForKey:@"msg"]];
        }
        
    }
}
- (void)POPTOViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- textField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

- (void)rightBtnClick
{
    //保存
    
    if (_textField.text.length == 0) {
        
        [_textField resignFirstResponder];
        
        [self textStateHUD:@"昵称不能为空哦！"];
    }
    else
    {
        [_textField resignFirstResponder];
        
        [self changeUserNickNameInfoOperation];

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
