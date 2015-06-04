//
//  LMH_EvaluateViewController.m
//  YingMeiHui
//
//  Created by work on 15/6/1.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import "LMH_EvaluateViewController.h"
#import "kata_LoginViewController.h"
#import "kata_UserManager.h"
#import "LMH_EventVO.h"
#import "LMH_ReviewTableViewCell.h"
#import "LMH_KeyBoradView.h"

#define FIELDHEIGHT 30

@interface LMH_EvaluateViewController ()<LoginDelegate,LMH_ReviewTableViewCellDelegate,LMH_KeyBoradViewDelegate,UITextFieldDelegate>
{
    NSNumber *eveluateUserid;//被回复用户的id
    NSNumber *eveluatesmsID;          //被回复的内容id
    NSString *eveluateTent;
    NSString *userid;
    NSString *usertoken;
    
    NSNumber *eventID;
    CGRect vFrame;
    CGRect tFrame;
    BOOL isAdd;
    NSInteger _type;
    
    UITextField *textField;
    UIButton *reverBtn;
    LMH_KeyBoradView *keyView;
}

@end

@implementation LMH_EvaluateViewController

- (id)initWithEventID:(NSNumber *)eventid andType:(NSInteger)type{
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        eventID = eventid;
        self.title = @"更多评论";
        isAdd = NO;
        
        _type = type;//0表示商品详情进入 1表示专场进入
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadNewer];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    keyView = [[LMH_KeyBoradView alloc] initWithFrame:CGRectMake(0, ScreenH-104, ScreenW, 40)];
    keyView.backgroundColor = [UIColor whiteColor];
    keyView.keyDelegate = self;
    [self.view addSubview:keyView];
    keyView.hidden = YES;
    
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI{
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    vFrame = self.tableView.frame;
    
    textField = [[UITextField alloc] initWithFrame:CGRectMake(0, vFrame.size.height-FIELDHEIGHT, ScreenW-50, 30)];
    textField.placeholder = @"说点儿什么吧~";
    textField.backgroundColor = LMH_COLOR_LIGHTLINE;
    textField.font = LMH_FONT_15;
    textField.delegate = self;
    textField.hidden = YES;
    [self.contentView addSubview:textField];
    
    reverBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW-50, CGRectGetMinY(textField.frame), 50, 30)];
    [reverBtn setTitle:@"发表" forState:UIControlStateNormal];
    [reverBtn.titleLabel setFont:LMH_FONT_15];
    [reverBtn setTitleColor:LMH_COLOR_GRAY forState:UIControlStateNormal];
    reverBtn.layer.borderColor = LMH_COLOR_LINE.CGColor;
    reverBtn.layer.borderWidth = 0.5;
    [reverBtn addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    reverBtn.hidden = YES;
    [self.contentView addSubview:reverBtn];
    
    tFrame = textField.frame;
    
    vFrame.size.height -= FIELDHEIGHT;
    self.tableView.frame = vFrame;
}

- (BOOL)checkLogin{
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isEqualToString:@""]) {
        userid = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"];
    }
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isEqualToString:@""]) {
        usertoken = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"];
    }
    
    if (userid.length <= 0) {
        [kata_LoginViewController showInViewController:self];
        return NO;
    }
    
    return YES;
}


- (KTBaseRequest *)request
{
    KTBaseRequest *req = [[KTBaseRequest alloc] init];
    
    NSMutableDictionary *paramsDict = [req params];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:eventID forKey:@"id"];
    if (_type) {
        [dict setObject:@"campaign" forKey:@"type"];
    }else{
        [dict setObject:@"goods" forKey:@"type"];
    }
    
    [dict setObject:[NSNumber numberWithInteger:self.current] forKey:@"page_no"];
    [dict setObject:[NSNumber numberWithInt:20] forKey:@"page_size"];
    
    [paramsDict setObject:dict forKey:@"params"];
    [paramsDict setObject:@"get_more_evaluate" forKey:@"method"];
    
    return req;
}

- (NSArray *)parseResponse:(NSString *)resp
{
    NSArray *array = nil;
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            if (respDict[@"data"] && ![respDict[@"data"] isEqual:[NSNull null]] && [respDict[@"data"] isKindOfClass:[NSDictionary class]]) {
                id dataObj = respDict[@"data"];
                
                NSInteger allCount = [dataObj[@"evaluate_count"] integerValue];
                self.max = ceil(allCount/20.0);
                
                array = [LMH_EvaluatedVO LMH_EvaluatedVOListWithArray:dataObj[@"evaluate_data"]];
                if (isAdd) {
                    allCount = [dataObj[@"evaluate_data"][@"evaluate_count"] integerValue];
                    self.max = ceil(allCount/20.0);
                    array = [LMH_EvaluatedVO LMH_EvaluatedVOListWithArray:dataObj[@"evaluate_data"][@"evaluate_list"]];
                    if (array.count > 0) {
                        [self.listData replaceObjectAtIndex:0 withObject:array[0]];
                    }
                    [self.tableView reloadData];
                    isAdd = NO;
                }
                textField.hidden = NO;
                reverBtn.hidden = NO;
                
                return array;
            }
        }
    }
    [self textStateHUD:@"网络问题，请稍后重试"];
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CELL_SECTION = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_SECTION];
    if (!cell) {
        cell = [[LMH_ReviewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_SECTION];
    }
    [(LMH_ReviewTableViewCell *)cell layoutUI:self.listData[indexPath.row]];
    [(LMH_ReviewTableViewCell *)cell setReviewDelegate:self];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
        CGFloat imgX = (ScreenW-20)/9;
        
    LMH_EvaluatedVO *vo = self.listData[row];
    if (vo.content) {
        CGSize revH = [vo.content sizeWithFont:LMH_FONT_12 constrainedToSize:CGSizeMake(ScreenW-imgX-60, 10000)];
        if (revH.height > 18) {
            return 80;
        }else{
            return 45+revH.height;
        }
    }
    return 45;
}

//评论
- (void )evaluateRequest
{
    if (![self checkLogin]) {
        return;
    }
    
    isAdd = YES;
    
    [self loadHUD];
    KTBaseRequest *req = [[KTBaseRequest alloc] init];
    
    NSMutableDictionary *paramsDict = [req params];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:eventID forKey:@"id"];
    [dict setObject:@"campaign" forKey:@"type"];
    [dict setObject:eveluateTent forKey:@"content"];
    [dict setObject:eveluatesmsID forKey:@"reply_id"];
    [dict setObject:eveluateUserid forKey:@"reply_user_id"];
    [dict setObject:userid forKey:@"user_id"];
    [dict setObject:usertoken forKey:@"user_token"];
    
    [paramsDict setObject:dict forKey:@"params"];
    [paramsDict setObject:@"add_evaluate" forKey:@"method"];
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        [self hideHUD];
        [self performSelectorOnMainThread:@selector(parseResponse:) withObject:resp waitUntilDone:YES];
    } failed:^(NSError *error) {
        [self hideHUD];
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxy start];
}

#pragma mark - 发送按钮点击后
- (void)sendClick{
    eveluateTent = textField.text;
    eveluateTent =[eveluateTent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //过滤中间空格
    eveluateTent = [eveluateTent stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (eveluateTent.length > 0) {
        eveluateTent = textField.text;
    }else{
        return;
    }
    eveluateUserid = @0;
    eveluatesmsID = @0;
    
    [self evaluateRequest];
}

#pragma mark - 回复按钮点击后的代理
- (void)sendSms:(LMH_EvaluatedVO *)evaVO{
    keyView.hidden = NO;
    textField.hidden = YES;
    reverBtn.hidden = YES;
    [keyView.textField becomeFirstResponder];
    
    eveluateUserid = evaVO.reply_user_id?evaVO.reply_user_id:@0;
    eveluatesmsID = evaVO.evaluaid?evaVO.evaluaid:@0;
}

#pragma mark - 信息发送按钮点击后的代理
- (void)keySendSms:(NSString *)smsInfo{
    keyView.hidden = YES;
    [keyView.textField resignFirstResponder];
    textField.hidden = NO;
    reverBtn.hidden = NO;
    
    eveluateTent = keyView.textField.text;
    eveluateTent =[eveluateTent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //过滤中间空格
    eveluateTent = [eveluateTent stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (eveluateTent.length > 0) {
        eveluateTent = keyView.textField.text;
    }else{
        return;
    }
    [self evaluateRequest];
}

- (void)keyHeight:(CGFloat)height{
    CGRect frame = vFrame;
    if (textField.isFirstResponder) {
        frame.size.height -= height;
        
        textField.frame = CGRectMake(0, tFrame.origin.y-height, ScreenW-50, FIELDHEIGHT);
        reverBtn.frame = CGRectMake(ScreenW-50, CGRectGetMinY(textField.frame), 50, 30);
    }else{
        textField.frame = CGRectMake(0, tFrame.origin.y, ScreenW-50, FIELDHEIGHT);
        reverBtn.frame = CGRectMake(ScreenW-50, CGRectGetMinY(textField.frame), 50, 30);
    }
    self.tableView.frame = frame;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    keyView.textField.text = @"";
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    keyView.hidden = YES;
    [keyView.textField resignFirstResponder];
    textField.hidden = NO;
    
    self.tableView.frame = vFrame;
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    keyView.hidden = YES;
    [keyView.textField resignFirstResponder];
    [textField resignFirstResponder];
    textField.hidden = NO;
    reverBtn.hidden = NO;
    
    self.tableView.frame = vFrame;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didLogin{

}

- (void)loginCancel{

}

@end
