//
//  kata_FeedbackHistoryViewController.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-21.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "kata_FeedbackHistoryViewController.h"
#import "KTMessageListGetRequest.h"
#import "kata_UserManager.h"
#import "MessageListVO.h"
#import "KTMsgListTableViewCell.h"

#define PAGERSIZE           20
#define MYTABLE_COLOR         [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1]

@interface kata_FeedbackHistoryViewController ()
{
    UIBarButtonItem *_refreshItem;
    UIButton *_refreshBtn;
}

@end

@implementation kata_FeedbackHistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // Custom initialization
        self.ifShowTableSeparator = NO;
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
        [self performSelector:@selector(showLoginView) withObject:nil afterDelay:0.1];
    }
}

- (void)showLoginView
{
    [kata_LoginViewController showInViewController:self];
}

- (UIView *)emptyView
{
    UIView * v = [super emptyView];
    if (v) {
        CGFloat w = self.view.bounds.size.width;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 105)];
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"messagelistempty"]];
        [image setFrame:CGRectMake((w - CGRectGetWidth(image.frame)) / 2, -30, CGRectGetWidth(image.frame), CGRectGetHeight(image.frame))];
        [view addSubview:image];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, w, 15)];
        [lbl setBackgroundColor:[UIColor clearColor]];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [lbl setTextColor:[UIColor colorWithRed:0.52 green:0.52 blue:0.52 alpha:1]];
        [lbl setFont:[UIFont systemFontOfSize:14.0]];
        [lbl setText:@"亲，您还没有吐槽哦！"];
        [view addSubview:lbl];
        
        view.center = v.center;
        [v addSubview:view];
    }
    return v;
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
        req = [[KTMessageListGetRequest alloc] initWithUserID:[userid integerValue]
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
                    MessageListVO *listVO = [MessageListVO MessageListVOWithDictionary:dataObj];
                    
                    if ([listVO.Code intValue] == 0) {
                        objArr = listVO.MsgBeanList;
                        
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
        cell = [[KTMsgListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFI];
    }
    
    id vo = [self.listData objectAtIndex:row];
    if ([vo isKindOfClass:[MessageBeanVO class]]) {
        MessageBeanVO *msgVO = (MessageBeanVO *)vo;
        
        [(KTMsgListTableViewCell *)cell setMessageData:msgVO];
        if ([msgVO.FromClient boolValue]) {
//        if (arc4random() % 2 == 0) {
            [(KTMsgListTableViewCell *)cell setCellType:KTMsgListCellCustomer];
        } else {
            [(KTMsgListTableViewCell *)cell setCellType:KTMsgListCellCustomerService];
        }
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    NSInteger row = indexPath.row;
    
    if (!h) {
        id vo = [self.listData objectAtIndex:row];
        if ([vo isKindOfClass:[MessageBeanVO class]]) {
            MessageBeanVO *msgVO = (MessageBeanVO *)vo;
            
            if (msgVO.Content) {
                CGSize contentsize = [msgVO.Content sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(247, 100000) lineBreakMode:NSLineBreakByCharWrapping];
                return ceil(contentsize.height) + 48;
            }
        }
        return 0;
    }
    return h;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMHLog(@" selected indexpath = %@",indexPath);
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
