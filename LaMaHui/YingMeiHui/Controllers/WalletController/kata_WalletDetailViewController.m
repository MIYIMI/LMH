//
//  kata_WalletDetailViewController.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-21.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "kata_WalletDetailViewController.h"
#import "KTWalletDetailGetRequest.h"
#import "kata_UserManager.h"
#import "TradeListVO.h"
#import "KTWalletDetailTableViewCell.h"

#define PAGERSIZE           20
#define MYTABLE_COLOR         [UIColor whiteColor]

@interface kata_WalletDetailViewController ()

@end

@implementation kata_WalletDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // Custom initialization
        self.title = @"钱包明细";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadNewer];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self loadNewer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI
{
    [self.tableView setBackgroundColor:MYTABLE_COLOR];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)checkLogin
{
    if (![[kata_UserManager sharedUserManager] isLogin]) {
        [self performSelector:@selector(showLoginView) withObject:nil afterDelay:0.2];
    }
}

- (UIView *)emptyView
{
    UIView * v = [super emptyView];
    if (v) {
        CGFloat w = self.view.bounds.size.width;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 105)];
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"walletempty"]];
        [image setFrame:CGRectMake((w - CGRectGetWidth(image.frame)) / 2, -20, CGRectGetWidth(image.frame), CGRectGetHeight(image.frame))];
        [view addSubview:image];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, w, 34)];
        [lbl setBackgroundColor:[UIColor clearColor]];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [lbl setNumberOfLines:2];
        [lbl setTextColor:[UIColor colorWithRed:0.52 green:0.52 blue:0.52 alpha:1]];
        [lbl setFont:[UIFont systemFontOfSize:14.0]];
        [lbl setText:@"亲，没发现您的钱包交易记录，\n让我们一起去Shopping吧！"];
        [view addSubview:lbl];
        
        view.center = v.center;
        [v addSubview:view];
    }
    return v;
}

- (void)showLoginView
{
    [kata_LoginViewController showInViewController:self];
}

- (KTBaseRequest *)request
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
        req = [[KTWalletDetailGetRequest alloc] initWithUserID:[userid integerValue]
                                                  andUserToken:usertoken
                                                   andPageSize:PAGERSIZE
                                                    andPageNum:self.current];
    }
    
    return req;
}

- (NSArray *)parseResponse:(NSString *)resp
{
    NSArray *objArr = nil;
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            if ([respDict objectForKey:@"data"] != nil && ![[respDict objectForKey:@"data"] isEqual:[NSNull null]]) {
                id dataObj = [respDict objectForKey:@"data"];
                if ([dataObj isKindOfClass:[NSDictionary class]]) {
                    TradeListVO *listVO = [TradeListVO TradeListVOWithDictionary:dataObj];
                    
                    if ([listVO.Code intValue] == 0) {
                        objArr = listVO.TradeList;
                        
                        if (self.max == -1) {
                            self.max = ceil([listVO.Total floatValue] / PAGERSIZE);
                            if (self.max == 0) {
                                self.max = 1;
                            }
                        }
                    } else {
                        //listVO.Msg
                        self.statefulState = FTStatefulTableViewControllerError;
                        if ([listVO.Code intValue] == -102) {
                            [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:listVO.Msg waitUntilDone:YES];
                            [[kata_UserManager sharedUserManager] logout];
                            [self performSelectorOnMainThread:@selector(checkLogin) withObject:nil waitUntilDone:YES];
                        }
                    }
                } else {
                    self.statefulState = FTStatefulTableViewControllerError;
                }
            } else {
                self.statefulState = FTStatefulTableViewControllerError;
            }
        } else {
            self.statefulState = FTStatefulTableViewControllerError;
        }
    } else {
        self.statefulState = FTStatefulTableViewControllerError;
    }
    
    return objArr;
}

#pragma mark -
#pragma tableView delegate && datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        return cell;
    }
    
    NSInteger row = indexPath.row;
    static NSString *CELL_IDENTIFI = @"CATEINFO_CELL";
    
    cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFI];
    if (!cell) {
        cell = [[KTWalletDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFI];
    }
    
    id vo = [self.listData objectAtIndex:row];
    if ([vo isKindOfClass:[TradeInfoVO class]]) {
        TradeInfoVO *tradeVO = (TradeInfoVO *)vo;
        [(KTWalletDetailTableViewCell *)cell setTradeData:tradeVO];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    
    if (!h) {
        return 48;
    }
    return h;
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
