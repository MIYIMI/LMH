//
//  MySentCommentVController.m
//  YingMeiHui
//
//  Created by Zhumingming on 15-5-27.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import "MySentCommentVController.h"
#import "kata_UserManager.h"
#import "LMHMyCommentRequest.h"
#import "MyCommentCell.h"
#import "LMHMyCommentVO.h"
#import "DeleteCommentRequest.h"
#import "kata_ProductDetailViewController.h"
#import "LMH_EventViewController.h"

#define PAGERSIZE           20

@interface MySentCommentVController ()<MyCommentCellDelegate>
{
    NSArray *_commentArray;
    
    LMHMyCommentVO *_commentVO;
    
    //无数据界面
    UIView      *emptyBgView;
    UIImageView *emptyView;
    UILabel     *emptyLbl;
}
@end

@implementation MySentCommentVController
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}
- (void)createUI{
    
//        self.tableView.backgroundColor = [UIColor greenColor];
        self.tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
}
- (void)viewWillAppear:(BOOL)animated
{
    [self  loadNewer];
}
//无数据时 界面(重写基类方法)
- (UIView *)emptyView{
    
    if (!emptyView) {
        emptyBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
        emptyBgView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:emptyBgView];
        
        emptyView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenW/3, 100, ScreenW/3, ScreenW/3-20)];
        emptyView.image = [UIImage imageNamed:@"emptyView"];
        [emptyBgView addSubview:emptyView];
        
        emptyLbl = [[UILabel alloc]initWithFrame:CGRectMake(ScreenW/3 - 30, CGRectGetMaxY(emptyView.frame), ScreenW/3 + 60, ScreenW/3)];
        emptyLbl.text = [NSString stringWithFormat:@"%@\n\n%@",@"您还没收到任何评论哦",@"快去参与一下网友们的讨论吧"];
        emptyLbl.textAlignment = NSTextAlignmentCenter;
        emptyLbl.numberOfLines = 0;
        emptyLbl.lineBreakMode = NSLineBreakByWordWrapping;
        emptyLbl.backgroundColor = [UIColor clearColor];
        emptyLbl.textColor = LMH_COLOR_GRAY;
        emptyLbl.font = LMH_FONT_12;
        [emptyBgView addSubview:emptyLbl];
    }
    
    return emptyBgView;
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
    
    req = [[LMHMyCommentRequest alloc] initWithUserID:[userid integerValue]
                                         andUserToken:usertoken
                                          andIs_reply:@"0"
                                          andPageSize:PAGERSIZE
                                           andPageNum:self.current];
    
    
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
            if ([respDict objectForKey:@"data"] != nil && [[respDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                id dataObj = [respDict objectForKey:@"data"];
                
                if ([dataObj isKindOfClass:[NSDictionary class]]) {
                    
                    if ([[respDict objectForKey:@"code"] intValue] == 0) {
                        if ([dataObj[@"comments_list"] isKindOfClass:[NSArray class]]) {
                            
                            //用数组保存数据 之后 在cellForRow 里面赋值
                            _commentArray =  [LMHMyCommentVO LMHMyCommentVOListWithArray:dataObj[@"comments_list"]];
                        }
                        
                        objArr = _commentArray;
                        self.max = _commentArray.count / (CGFloat)PAGERSIZE;
                        return objArr;
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
#pragma mark -- 删除按钮 代理
- (void)delegateButtonMethod:(LMHMyCommentVO *)commentVO
{
    _commentVO = commentVO;
    [self delegateRequestOperation];
}
#pragma mark -- 删除按钮 数据请求
- (void)delegateRequestOperation
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
    
    req = [[DeleteCommentRequest alloc] initWithUserID:[userid integerValue]
                                          andUserToken:usertoken
                                        andEvaluate_id:_commentVO.evaluate_id];
    
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(delegateRequestResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (NSArray *)delegateRequestResponse:(NSString *)resp
{
    NSArray *objArr = nil;
    if (resp) {
        [self hideHUD];
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            
            if ([[respDict objectForKey:@"code"] intValue] == 0) {
                
                [self hideHUD];
                
                [self loadNewer];
                
                [self.tableView reloadData];
            }
            
        }else {
            [self textStateHUD:[respDict objectForKey:@"msg"]];
            [self hideHUD];
        }
        
    }else {
        [self textStateHUD:@"删除失败"];
        [self hideHUD];
    }
    return objArr;
}
#pragma mark -- tableView delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listData.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMHMyCommentVO *commentVO = _commentArray[indexPath.section];
    CGSize contentHight = [commentVO.content sizeWithFont:LMH_FONT_11 constrainedToSize:CGSizeMake(ScreenW-140, 70) lineBreakMode:NSLineBreakByCharWrapping];
    
    //RATIO(266) --  这个值  是除去content区域 其他总高度
    return contentHight.height + RATIO(270);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[MyCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    [(MyCommentCell *)cell setDelegate:self];
    [(MyCommentCell *)cell setIsReceiveComment:YES];
    [(MyCommentCell *)cell layoutUI:_commentArray[indexPath.section]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = LMH_COLOR_CELL;
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushWX{
    [self textStateHUD:@"微信号已复制到剪切板,请前往微信添加"];
}

- (void)pushNextVC:(LMHMyCommentVO *)commentVO{
    if ([commentVO.goods_infor.type isEqualToString:@"goods"]) {
        kata_ProductDetailViewController *productVC = [[kata_ProductDetailViewController alloc] initWithProductID:[commentVO.goods_infor.goodsInfoid integerValue] andType:nil andSeckillID:-1];
        productVC.navigationController = self.navigationController;
        productVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:productVC animated:YES];
    }else if([commentVO.goods_infor.type isEqualToString:@"campaign"]){
        LMH_EventViewController *productVC = [[LMH_EventViewController alloc] initWithDataVO:nil];
        productVC.eventID = [commentVO.goods_infor.goodsInfoid integerValue];
        productVC.navigationController = self.navigationController;
        productVC.vcTitle = commentVO.goods_infor.title;
        productVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:productVC animated:YES];
    }
}

@end
