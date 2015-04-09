//
//  kata_ActivityViewController.m
//  YingMeiHui
//
//  Created by work on 14-11-13.
//  Copyright (c) 2014年 xieyanke. All rights reserved.
//

#import "kata_ActivityViewController.h"
#import "HomeVO.h"
#import "KTChanelRequest.h"
#import "kata_IndexAdvFocusViewController.h"
#import "AloneProductCellTableViewCell.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "kata_ProductDetailViewController.h"
#import "kata_UserManager.h"
#import "kata_ProductListViewController.h"
#import "kata_DescribeViewController.h"
#import "kata_WebViewController.h"

#define PAGERSIZE           20
#define SEGMENTHEIGHT       40
#define TABLE_COLOR         [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1]
#define SEGMENT_BGCOLOR     [UIColor whiteColor]
#define ADVFOCUSHEIGHT      140

@interface kata_ActivityViewController ()<KATAFocusViewControllerDelegate,AloneProductCellTableViewCellDelgate>
{
    UIView *_headerView;
    kata_IndexAdvFocusViewController *_bannerFV;
    
    //活动id
    NSInteger _chanelid;
    HomeVO *listVO;
    AdvVO *_advo;
}

@end

@implementation kata_ActivityViewController

- (id)initWithData:(AdvVO *)datavo
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // Custom initialization
        self.ifShowTableSeparator = NO;
        self.ifAddPullToRefreshControl = YES;
        self.ifScrollToTop = YES;
        self.ifShowScrollToTopBtn = YES;
        _chanelid = [datavo.Key integerValue];
        self.title = datavo.Title;
        _advo = datavo;
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 46)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = datavo.Title;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor colorWithRed:0.96 green:0.3 blue:0.4 alpha:1];
        titleLabel.font = FONT(17);
        self.navigationItem.titleView = titleLabel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadNewer];
    //self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_some_bgView"] forBarMetrics:UIBarMetricsDefault];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    //返回按钮
    UIButton * backBarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 27)];
    [backBarButton setImage:[UIImage imageNamed:@"icon_goback_red"]
                   forState:UIControlStateNormal];
    [backBarButton setImage:[UIImage imageNamed:@"icon_goback_red"]
                   forState:UIControlStateHighlighted];
    
    [backBarButton addTarget:self
                      action:@selector(popViewVC)
            forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBarButton];
    backBarButtonItem.style = UIBarButtonItemStylePlain;
    
    [self.navigationController addLeftBarButtonItem:backBarButtonItem animation:NO];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[(kata_AppDelegate *)[[UIApplication sharedApplication] delegate] deckController] setPanningMode:IIViewDeckNoPanning];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg_red"] forBarMetrics:UIBarMetricsDefault];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(void)popViewVC{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setTbHeaderView:(NSString *)title
{
    if (_headerView) {
        [_headerView removeFromSuperview];
        _headerView = nil;
    }
    
    if (!_headerView && listVO.banner.count>0) {
        _headerView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    
    [self performSelectorOnMainThread:@selector(layoutAdverView) withObject:nil waitUntilDone:YES];
}

- (void)layoutAdverView
{
    if (_bannerFV) {
        [_bannerFV.view removeFromSuperview];
        _bannerFV = nil;
    }
    
    if (!_bannerFV) {
        kata_IndexAdvFocusViewController *fvc = [[kata_IndexAdvFocusViewController alloc] initWithData:listVO.banner];
        fvc.focusViewControllerDelegate = self;
        _bannerFV = fvc;
    }
    [_headerView addSubview:_bannerFV.view];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    CGRect rect = _headerView.bounds;
    _bannerFV.view.alpha = 1;
    [_headerView setFrame:CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetWidth(rect), CGRectGetHeight(rect) + ADVFOCUSHEIGHT)];
    [self.tableView setTableHeaderView:_headerView];
    [UIView commitAnimations];
}

- (KTBaseRequest *)request
{
    NSString *userid ;
    NSString *usertoken ;
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isEqualToString:@""]) {
        userid = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"];
    }
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isEqualToString:@""]) {
        usertoken = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"];
    }
    
    KTChanelRequest *req = [[KTChanelRequest alloc] initWithUserID:[userid integerValue]
                                                           andType:[_advo.Type integerValue]
                                                      andUserToken:usertoken
                                                       andPageSize:PAGERSIZE
                                                        andPageNum:self.current
                                                       andChanleID:_chanelid];
    
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
                    listVO = [HomeVO HomeVOWithDictionary:dataObj];
                    
                    if (listVO.productlist.count > 0) {
                        NSMutableArray *cellDataArr = [[NSMutableArray alloc] init];
                        for (NSInteger i = 0; i < ceil((CGFloat)listVO.productlist.count / 2.0); i++) {
                            NSMutableArray *cellArr = [[NSMutableArray alloc] init];
                            if ([listVO.productlist objectAtIndex:i * 2] && [[listVO.productlist objectAtIndex:i * 2] isKindOfClass:[HomeProductVO class]]) {
                                [cellArr addObject:[listVO.productlist objectAtIndex:i * 2]];
                            }
                            
                            if (listVO.productlist.count > i * 2 + 1) {
                                if ([listVO.productlist objectAtIndex:i * 2 + 1] && [[listVO.productlist objectAtIndex:i * 2 + 1] isKindOfClass:[HomeProductVO class]]) {
                                    [cellArr addObject:[listVO.productlist objectAtIndex:i * 2 + 1]];
                                }
                            }
                            [cellDataArr addObject:cellArr];
                        }
                        
                        objArr = [NSArray arrayWithArray:cellDataArr];
                        if (objArr.count > 0) {
                            [self performSelectorOnMainThread:@selector(setTbHeaderView:) withObject:listVO.productlist waitUntilDone:YES];
                        }
                        self.max = ceil([listVO.total_count floatValue] / (CGFloat)PAGERSIZE);
                    }
                }
                return objArr;
            } else {
                self.statefulState = FTStatefulTableViewControllerError;
            }
        } else {
            self.statefulState = FTStatefulTableViewControllerError;
        }
    } else {
        self.statefulState = FTStatefulTableViewControllerError;
    }
    
    return nil;
}

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
        cell = [[AloneProductCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFI];
    }
    [cell setBackgroundColor:[UIColor whiteColor]];
    [(AloneProductCellTableViewCell *)cell setDelegate:self];
    [(AloneProductCellTableViewCell*)cell setCellFrame:self.view.frame];
    [(AloneProductCellTableViewCell*)cell layoutUI:self.listData[row] andColnum:2 is_act:YES is_type:NO];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.listData.count) {
        return 250;
    }else{
        return 30;
    }
}

#pragma mark - AloneProductCellTableViewCell Delegate
- (void)tapAtItem:(HomeProductVO *)vo
{
    if(![vo.source_platform isEqualToString:@"lamahui"]){
//        kata_DescribeViewController *webVC = [[kata_DescribeViewController alloc] initWithProductID:[vo.product_id integerValue] andPlatform:vo.source_platform];
//        webVC.navigationController = self.navigationController;
//        webVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:webVC animated:YES];
//        
//        return;
//    }else if([vo.is_check intValue] == 0 && ![vo.source_platform isEqualToString:@"lamahui"]){
//        
        kata_WebViewController *webVC = [[kata_WebViewController alloc] initWithUrl:vo.click_url title:nil andType:vo.source_platform];
        webVC.navigationController = self.navigationController;
        webVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVC animated:YES];
        
    }else{
        // 商品详情
        kata_ProductDetailViewController *vc = [[kata_ProductDetailViewController alloc] initWithProductID:[vo.product_id integerValue] andType:nil andSeckillID:-1];
        vc.navigationController = self.navigationController;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UIView *)emptyView
{
    UIView * v = [super emptyView];
    if (v) {
        CGFloat w = self.view.bounds.size.width;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 105)];
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"productlistempty"]];
        [image setFrame:CGRectMake((w - CGRectGetWidth(image.frame)) / 2, -40, CGRectGetWidth(image.frame), CGRectGetHeight(image.frame))];
        [view addSubview:image];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, w, 15)];
        [lbl setBackgroundColor:[UIColor clearColor]];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [lbl setTextColor:[UIColor colorWithRed:0.52 green:0.52 blue:0.52 alpha:1]];
        [lbl setFont:[UIFont systemFontOfSize:14.0]];
        [lbl setText:@"暂无商品"];
        [view addSubview:lbl];
        
        view.center = v.center;
        [v addSubview:view];
        
    }
    return v;
}

@end
