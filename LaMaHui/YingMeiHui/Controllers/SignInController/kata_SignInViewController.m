//
//  kata_SignInViewController.m
//  YingMeiHui
//
//  Created by work on 14-11-13.
//  Copyright (c) 2014年 xieyanke. All rights reserved.
//

#import "kata_SignInViewController.h"
#import "CKCalendarView.h"
#import "kata_LoginViewController.h"
#import "ShareTableViewCell.h"
#import "KTBaseRequest.h"
#import "kata_UserManager.h"
#import "KTProxy.h"
#import "kata_SignExplainViewController.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "kata_GlobalConst.h"
#import "kata_AppDelegate.h"
#import "LMH_Config.h"
#import "kata_WebViewController.h"
#import <UIImageView+WebCache.h>

@interface kata_SignInViewController ()<UITableViewDataSource,UITableViewDelegate,LoginDelegate,UMSocialUIDelegate>
{
    CKCalendarView *calendar;
    UITableView *_tableView;
    
    UIView *bgview;
    UILabel *creditLbl;
    UILabel *moneyLbl;
    UILabel *bottomLbl;
    UIView *tapView;
    
    NSInteger userCurcredit;
    NSInteger userMaxcredit;
    CGFloat creditMoeny;
    NSInteger addcredit;
    long serverTime;
    NSInteger currentCredit;
    NSInteger nextCredit;
    BOOL is_Sgin;
    NSInteger today;
    BOOL is_login;
    NSString *sgin_user;
    NSArray *signArray;
    NSString *shareTent;
    NSString *shareUrl;
    NSString *shareTitle;
    NSArray *appRecommend;
    NSString *ruleUrl;
}
@end

@implementation kata_SignInViewController

- (id)initWithTitle:(NSString *)title
{
    self =  [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        self.title = @"每日签到";
        userCurcredit = 0;
        userMaxcredit = 0;
        creditMoeny = 0;
        addcredit = 0;
        currentCredit = 0;
        nextCredit = 0;
        is_Sgin = NO;
        is_login = NO;
        serverTime = [[NSDate date] timeIntervalSince1970];
        
        //默认值
        shareTitle = @"下载辣妈汇APP，享新人好礼 ";
        shareUrl = @"http://wap.lamahui.com/inv/f26970";
        shareTent = @"辣妈正品1折起，更懂辣妈的特卖网站";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hasTabHeight = NO;
    self.hideNavigationBarWhenPush = NO;
    [self createUI];
    [self getUserRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.hidesBottomBarWhenPushed = YES;
    [[(kata_AppDelegate *)[[UIApplication sharedApplication] delegate] deckController] setPanningMode:IIViewDeckNoPanning];
}

-(void)createUI{
    CGRect frame = self.view.frame;
    if (IOS_7) {
        frame.size.height -= 64;
        self.view.frame = frame;
    }else{
        frame.size.height -= 44;
        frame.origin.y -= 20;
    }
    [self.contentView removeFromSuperview];
    _tableView = [[UITableView alloc] initWithFrame:frame];
    _tableView.delegate =self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    if (![[kata_UserManager sharedUserManager] isLogin]) {
        //登录按钮
        UIButton * loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginBtn setFrame:CGRectMake(40, 0, 44, 44)];
        [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [loginBtn.titleLabel setFont:FONT(15.0)];
        [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginBtn addTarget:self action:@selector(loginButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *loginItem = [[UIBarButtonItem alloc] initWithCustomView:loginBtn];
        [self.navigationController addRightBarButtonItem:loginItem animation:NO];
        
        is_login = NO;
    }else{
        is_login = YES;
    }
    
}

-(void)loginButtonPressed{
    if (![[kata_UserManager sharedUserManager] isLogin]) {
        [kata_LoginViewController showInViewController:self];
        return;
    }
}

- (void )getUserRequest
{
    [self loadHUD];
    KTBaseRequest *req = [[KTBaseRequest alloc] init];
    
    NSString *userid = nil;
    NSString *usertoken = nil;
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isEqualToString:@""]) {
        userid = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"];
    }
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isEqualToString:@""]) {
        usertoken = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"];
    }
    
    NSMutableDictionary *paramsDict = [req params];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (userid && usertoken) {
        [dict setObject:userid forKey:@"user_id"];
        [dict setObject:usertoken forKey:@"user_token"];
        [paramsDict setObject:dict forKey:@"params"];
    }else{
        serverTime = [[NSDate date] timeIntervalSince1970];
    }
    
    [paramsDict setObject:@"get_user_credit" forKey:@"method"];
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        [self performSelectorOnMainThread:@selector(getUserParseResponse:) withObject:resp waitUntilDone:YES];
    } failed:^(NSError *error) {
        [self hideHUD];
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (void)getUserParseResponse:(NSString *)resp
{
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            if ([respDict objectForKey:@"data"] != nil && ![[respDict objectForKey:@"data"] isEqual:[NSNull null]]) {
                id dataObj = [respDict objectForKey:@"data"];
                
                if ([dataObj isKindOfClass:[NSDictionary class]]) {
                    userCurcredit = [[dataObj objectForKey:@"user_credit"] integerValue];
                    userMaxcredit = [[dataObj objectForKey:@"user_max_credit"] integerValue];
                    creditMoeny = [[dataObj objectForKey:@"credit_to_moeny"] floatValue];
                    serverTime = [[dataObj objectForKey:@"server_time"] longValue];
                    is_Sgin = [[dataObj objectForKey:@"is_sign"] boolValue];
                    signArray = [dataObj objectForKey:@"sign_days"];
                    addcredit = [[dataObj objectForKey:@"add_credit"] integerValue];
                    nextCredit = [[dataObj objectForKey:@"next_credit"] integerValue];
                    sgin_user = [dataObj objectForKey:@"invitation_code"];
                    shareUrl = [dataObj objectForKey:@"invitation_url"];
                    shareTent = [dataObj objectForKey:@"share_content"];
                    shareTitle = [dataObj objectForKey:@"share_title"];
                    appRecommend = [dataObj objectForKey:@"app_recommend"];
                    ruleUrl = [dataObj objectForKey:@"rule_url"];
                    [self hideHUD];
                    
                    [_tableView reloadData];
                    return;
                }
            }
        }
    }
    [self textStateHUD:@"信息获取失败,请稍后重试"];
}

- (void )SignRequest
{
    [self loadHUD];
    KTBaseRequest *req = [[KTBaseRequest alloc] init];
    tapView.userInteractionEnabled = NO;
    
    NSString *userid = nil;
    NSString *usertoken = nil;
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isEqualToString:@""]) {
        userid = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"];
    }
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isEqualToString:@""]) {
        usertoken = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"];
    }

    NSMutableDictionary *paramsDict = [req params];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:userid?userid:[NSNumber numberWithInteger:-1] forKey:@"user_id"];
    [dict setObject:usertoken?usertoken:[NSNull null] forKey:@"user_token"];
    [paramsDict setObject:dict forKey:@"params"];
    
    [paramsDict setObject:@"signin_get_credit" forKey:@"method"];
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        [self performSelectorOnMainThread:@selector(SignRequestParseResponse:) withObject:resp waitUntilDone:YES];
    } failed:^(NSError *error) {
        tapView.userInteractionEnabled = YES;
        [stateHud hide:YES];
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (void)SignRequestParseResponse:(NSString *)resp
{
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            if ([respDict objectForKey:@"data"] != nil && ![[respDict objectForKey:@"data"] isEqual:[NSNull null]]) {
                id dataObj = [respDict objectForKey:@"data"];
                
                if ([dataObj isKindOfClass:[NSDictionary class]]) {
                    currentCredit = [[dataObj objectForKey:@"credit"] integerValue];
                    nextCredit = [[dataObj objectForKey:@"next_credit"] integerValue];
                    is_Sgin = [[dataObj objectForKey:@"signin"] boolValue];
                    serverTime = [[dataObj objectForKey:@"server_time"] longValue];
                    today = [[dataObj objectForKey:@"today"] integerValue];
                    userCurcredit = [[dataObj objectForKey:@"user_credit"] integerValue];
                    creditMoeny = [[dataObj objectForKey:@"credit_to_moeny"] floatValue];
                    [self performSelectorOnMainThread:@selector(SignResult) withObject:nil waitUntilDone:YES];
                    return;
                }
            }
        }
    }
    tapView.userInteractionEnabled = YES;
    [self textStateHUD:@"签到失败,请重试"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (serverTime > 0) {
        return 9;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    static NSString *CELL_1 = @"CELL_1";
    static NSString *CELL_2 = @"CELL_2";
    static NSString *CELL_3 = @"CELL_3";
    static NSString *CELL_4 = @"CELL_4";
    static NSString *CELL_5 = @"CELL_5";
    static NSString *CELL_6 = @"CELL_6";
//    static NSString *CELL_7 = @"CELL_7";
//    static NSString *CELL_8 = @"CELL_8";
    static NSString *CELL_9 = @"CELL_9";
    static NSString *CELL_10 = @"CELL_10";
    static NSString *CELL_11 = @"CELL_11";
    
    if (row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_1];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_1];
        }
        if (!bgview) {
            bgview = [[UIView alloc] initWithFrame:CGRectMake((ScreenW-(ScreenW-40)/2)/2, 10, (ScreenW-40)/2, ScreenW/3)];
            bgview.backgroundColor = [UIColor whiteColor];
            bgview.layer.masksToBounds = YES;
            bgview.layer.cornerRadius = 3.0f;
            [cell addSubview:bgview];
            
            creditLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(bgview.frame), 30)];
            [creditLbl setTextAlignment:NSTextAlignmentCenter];
            [bgview addSubview:creditLbl];
            
            moneyLbl = [[UILabel alloc ] initWithFrame:CGRectMake(0, CGRectGetMaxY(creditLbl.frame)+10, CGRectGetWidth(bgview.frame), 20)];
            [moneyLbl setTextAlignment:NSTextAlignmentCenter];
            [moneyLbl setFont:FONT(13.0)];
            [bgview addSubview:moneyLbl];
            
            bottomLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(bgview.frame) - 40, CGRectGetWidth(bgview.frame), 40)];
            bottomLbl.layer.cornerRadius = 3.0;
            [bottomLbl setBackgroundColor:ALL_COLOR];
            [bottomLbl setTextColor:[UIColor whiteColor]];
            [bottomLbl setFont:FONT(18.0)];
            [bottomLbl setTextAlignment:NSTextAlignmentCenter];
            [bgview addSubview:bottomLbl];
            
            tapView = [[UIView alloc] initWithFrame:bgview.frame];
            [tapView setBackgroundColor:[UIColor clearColor]];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signClick)];
            [tapView addGestureRecognizer:tap];
            [cell addSubview:tapView];
        }
        if (is_Sgin) {
            tapView.userInteractionEnabled = NO;
            [moneyLbl setFont:FONT(13.0)];
            creditLbl.hidden = NO;
            moneyLbl.frame = CGRectMake(0, CGRectGetMaxY(creditLbl.frame)+10, CGRectGetWidth(bgview.frame), 20);
            bottomLbl.text = [NSString stringWithFormat:@"明日签到+%zi", nextCredit];
            [bottomLbl setBackgroundColor:[UIColor colorWithRed:0.73 green:0.73 blue:0.73 alpha:1]];
            bgview.layer.borderColor = [[UIColor colorWithRed:0.73 green:0.73 blue:0.73 alpha:1] CGColor];
            [bottomLbl setTextColor:[UIColor whiteColor]];
            [self textAttr];
        }else{
            if (is_login) {
                creditLbl.hidden = NO;
                [moneyLbl setFont:FONT(13.0)];
                moneyLbl.frame = CGRectMake(0, CGRectGetMaxY(creditLbl.frame)+10, CGRectGetWidth(bgview.frame), 20);
                bottomLbl.text = [NSString stringWithFormat:@"今日签到+%zi", addcredit];
                [self textAttr];
            }else{
                [tapView setFrame:bgview.frame];
                moneyLbl.frame = CGRectMake(0, 0, CGRectGetWidth(bgview.frame), CGRectGetHeight(bgview.frame)-CGRectGetHeight(bottomLbl.frame));
                creditLbl.hidden = YES;
                [moneyLbl setFont:FONT(18.0)];
                moneyLbl.text = @"未登录";
                bottomLbl.text = @"签到赚金豆";
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (row == 1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_2];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_2];
        }
        if (!calendar) {
            calendar = [[CKCalendarView alloc] init];
            calendar.frame = CGRectMake(10, 10, ScreenW-20, ScreenW-20);
            [cell addSubview:calendar];
        }
        calendar.date = [NSDate dateWithTimeIntervalSince1970:serverTime];
        for (NSString *day in signArray) {
            [calendar layoutSign:[day integerValue]];
        }
        
        
        [cell setBackgroundColor:[UIColor whiteColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if(row == 2){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_3];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_3];
            
            NSString *helpStr = @"金豆怎么赚? 点这里来查看";
            CGSize helpSize = [helpStr sizeWithFont:LMH_FONT_13 constrainedToSize:CGSizeMake(ScreenW, 15) lineBreakMode:NSLineBreakByWordWrapping];
            UILabel *helpLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenW-20, 15)];
            [helpLbl setText:helpStr];
            [helpLbl setTextAlignment:NSTextAlignmentRight];
            [helpLbl setFont:FONT(13.0)];
            [helpLbl setTextColor:[UIColor colorWithRed:0.51 green:0.51 blue:0.51 alpha:1]];
            [cell addSubview:helpLbl];
            
            UILabel *lineLbl = [[UILabel alloc] initWithFrame:CGRectMake(ScreenW-helpSize.width-10, 15, helpSize.width, 0.5)];
            [lineLbl setBackgroundColor:[UIColor colorWithRed:0.51 green:0.51 blue:0.51 alpha:1]];
            [cell addSubview:lineLbl];
        }
        [cell setBackgroundColor:[UIColor whiteColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if(row == 3){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_4];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_4];
        }
        [cell setBackgroundColor:[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if(row == 4){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_5];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_5];
        }
        [cell.imageView setImage:LOCAL_IMG(@"event")];
        [cell.textLabel setText:@"赚更多金豆"];
        [cell.textLabel setFrame:CGRectMake(12, 0, 80, 30)];
        [cell.textLabel setFont:FONT(16.0)];
        [cell.textLabel setTextColor:[UIColor colorWithRed:0.98 green:0.31 blue:0.42 alpha:1]];
        [cell setBackgroundColor:[UIColor whiteColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (row == 5){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_6];
        if (!cell) {
            cell = [[ShareTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_6];
        }
        [cell setBackgroundColor:[UIColor whiteColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [(ShareTableViewCell*)cell layoutUI:row];
        
        return cell;
    }
//    else if (row == 6){
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_7];
//        if (!cell) {
//            cell = [[ShareTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_6];
//        }
//        [cell setBackgroundColor:[UIColor whiteColor]];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        [(ShareTableViewCell*)cell layoutUI:row];
//        
//        return cell;
//    }else if (row == 7){
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_8];
//        if (!cell) {
//            cell = [[ShareTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_6];
//        }
//        [cell setBackgroundColor:[UIColor whiteColor]];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        [(ShareTableViewCell*)cell layoutUI:row];
//        
//        return cell;
//    }
    else if(row == 6){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_9];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_4];
        }
        [cell setBackgroundColor:[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if(row == 7){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_10];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_5];
        }
        [cell.imageView setImage:LOCAL_IMG(@"event")];
        [cell.textLabel setText:@"应用推荐"];
        [cell.textLabel setFrame:CGRectMake(12, 0, 80, 30)];
        [cell.textLabel setFont:FONT(16.0)];
        [cell.textLabel setTextColor:[UIColor colorWithRed:0.98 green:0.31 blue:0.42 alpha:1]];
        [cell setBackgroundColor:[UIColor whiteColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else{
        // 应用推荐
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_11];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_4];
            if ([appRecommend isKindOfClass:[NSArray class]]) {
                for (int i = 0; i<appRecommend.count; i++) {
                    NSDictionary *dic = appRecommend[i];
                    UIImageView *appView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenW/11 *(i%4+1) + (i%4)*(ScreenW/22*3), i/4 *(ScreenW/22*3 + 35), ScreenW/22*3, ScreenW/22*3)];
                    [appView sd_setImageWithURL:dic[@"app_image"]];
                    appView.userInteractionEnabled = YES;
                    [cell addSubview:appView];
                    
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
                    button.frame = CGRectMake(0, 0, ScreenW/22*3, ScreenW/22*3);
                    [button setBackgroundImage:nil forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(appLogin:) forControlEvents:UIControlEventTouchUpInside];
                    button.tag = 1000+i;
                    //                button.layer.masksToBounds = YES;
                    //                button.layer.cornerRadius = ScreenW/44 + 1;
                    [appView addSubview:button];
                    
                    UILabel *appName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(appView.frame) - ScreenW/22, CGRectGetMaxY(appView.frame) + 3, CGRectGetWidth(appView.frame) + ScreenW/11, 20)];
                    appName.text = dic[@"app_title"];
                    appName.textAlignment = 1;
                    appName.font = FONT(14);
                    [cell addSubview:appName];
                }
            }
        }
        [cell setBackgroundColor:[UIColor whiteColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}

// 应用推荐
- (void)appLogin:(id)sender {
    UIButton *appButton = (UIButton *)sender;
    for (int i = 0; i < appRecommend.count; i++) {
        if (appButton.tag == 1000 +i) {
            NSString *httpStr = appRecommend[i][@"app_url_ios"];
            NSString *itmsStr = [httpStr stringByReplacingOccurrencesOfString:@"http://" withString:@"itms-apps://"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:itmsStr]];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/jie-zou-da-shi/id493901993?mt=8"]];
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row == 0) {
        return ScreenW/3+20;
    }else if (row == 1){
        return ScreenW;
    }else if (row == 2){
        return 25;
    }else if(row == 3){
        return 10;
    }else if(row == 4){
        return 40;
    }else if(row == 5){
        return 40;
    }
//    else if(row == 6){
//        return 40;
//    }else if(row == 7){
//        return 40;
//    }
    else if(row == 6){
        return 10;
    }else if(row == 7){
        return 40;
    }else {
        if ((int)appRecommend.count%4 > 0) {
            return (appRecommend.count/4 + 1) * (ScreenW/22*3 + 35);
        } else {
            return appRecommend.count/4 * (ScreenW/22*3 + 35);
        }
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    
    if (row == 2) {
        if (ruleUrl) {
            kata_WebViewController *webVC = [[kata_WebViewController alloc] initWithUrl:ruleUrl title:nil andType:@"lamahui"];
            webVC.navigationController = self.navigationController;
            webVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webVC animated:YES];
            return;
        }
        kata_SignExplainViewController *explainVC = [[kata_SignExplainViewController alloc] initWithNibName:nil bundle:nil];
        explainVC.navigationController = self.navigationController;
        explainVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:explainVC animated:YES];
    }else if(row == 5){
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
        [UMSocialData defaultData].extConfig.qqData.url = shareUrl;
        [UMSocialData defaultData].extConfig.wechatSessionData.url = shareUrl;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareUrl;
        [UMSocialData defaultData].extConfig.title = shareTitle;
        
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:UMENG_APPKEY
                                          shareText:[NSString stringWithFormat:@"%@%@%@",shareTitle,shareTent,shareUrl]
                                         shareImage:nil
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToSina,UMShareToSms,nil]
                                           delegate:nil];
    }
    
}

-(void)signClick{
    if (![[kata_UserManager sharedUserManager] isLogin]) {
        [kata_LoginViewController showInViewController:self];
        return;
    }
    [self SignRequest];
}

-(void)SignResult{
    if (is_Sgin) {
        [self hideHUD];
        [self performSelector:@selector(textStateHUD:) withObject:@"购买汇特卖的商品可使用金豆抵现哦~" afterDelay:0.5];
        [tapView setUserInteractionEnabled:NO];
        [bottomLbl setBackgroundColor:[UIColor colorWithRed:0.73 green:0.73 blue:0.73 alpha:1]];
        [bottomLbl setTextColor:[UIColor whiteColor]];
        [bottomLbl setText:[NSString stringWithFormat:@"明日签到+%zi", nextCredit]];
        [calendar layoutSign:today];
        
        [self textAttr];
    }else{
        [self textAttr];
        [stateHud hide:YES];
        [self hideHUD];
    }
}

-(void)textAttr{
    NSInteger creditLenght = [[NSString stringWithFormat:@"%zi", userCurcredit] length];
    
    NSString *aStr = [NSString stringWithFormat:@"%zi金豆",userCurcredit];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:aStr];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.98 green:0.21 blue:0.36 alpha:1] range:NSMakeRange(0,creditLenght)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.98 green:0.21 blue:0.36 alpha:1] range:NSMakeRange(creditLenght,2)];
    [str addAttribute:NSFontAttributeName value:FONT(28.0) range:NSMakeRange(0, creditLenght)];
    [str addAttribute:NSFontAttributeName value:FONT(13.0) range:NSMakeRange(creditLenght, 2)];
    creditLbl.attributedText = str;
    
    creditLenght = [[NSString stringWithFormat:@"%0.2f", creditMoeny] length];
    aStr = [NSString stringWithFormat:@"可抵现%0.2f元",creditMoeny];
    NSMutableAttributedString *moneyStr = [[NSMutableAttributedString alloc] initWithString:aStr];
    [moneyStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.30 green:0.30 blue:0.30 alpha:1] range:NSMakeRange(0,3)];
    [moneyStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.98 green:0.21 blue:0.36 alpha:1] range:NSMakeRange(3,creditLenght)];
    [moneyStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.30 green:0.30 blue:0.30 alpha:1] range:NSMakeRange(3+creditLenght,1)];
    moneyLbl.attributedText = moneyStr;
}

-(void)didLogin{
    self.navigationItem.rightBarButtonItem = nil;
    is_login = YES;
    [self getUserRequest];
}

-(void)loginCancel{

}

- (void)textStateHUD:(NSString *)text{
    if (!stateHud) {
        stateHud = [[MBProgressHUD alloc] initWithView:self.contentView];
        stateHud.delegate = self;
        [_tableView addSubview:stateHud];
    }
    stateHud.mode = MBProgressHUDModeText;
    stateHud.labelText = text;
    stateHud.labelFont = [UIFont systemFontOfSize:13.0f];
    [stateHud show:YES];
    [stateHud hide:YES afterDelay:3.0];

}

- (void)loadHUD
{
//    if (!stateHud) {
//        stateHud = [[MBProgressHUD alloc] initWithView:self.view];
//        stateHud.delegate = self;
//        [self.view addSubview:stateHud];
//    }
//    stateHud.mode = MBProgressHUDModeIndeterminate;
//    [stateHud show:YES];
    if (!loading) {
        loading = [[Loading alloc] initWithFrame:CGRectMake(0, 0, 180, 100) andName:[NSString stringWithFormat:@"loading.gif"]];
        loading.center = self.contentView.center;
        [loading.layer setCornerRadius:10.0];
        [self.view addSubview:loading];
    }
    [loading start];
}

- (void)hideHUD{
//    if (stateHud) {
//        [stateHud hide:YES afterDelay:0];
//    }
    if (loading) {
        [loading stop];
    }
}

@end
