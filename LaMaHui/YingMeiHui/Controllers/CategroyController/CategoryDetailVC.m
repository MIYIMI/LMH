//
//  CategoryDetailVC.m
//  YingMeiHui
//
//  Created by KevinKong on 14-9-23.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "CategoryDetailVC.h"
#import "ProductListVO.h"
#import "kata_UserManager.h"
#import "kata_ProductListViewController.h"
#import "HomeVO.h"
#import "XLCycleScrollView.h"
#import "AdvVO.h"
#import <UIImageView+WebCache.h>
#import "kata_AppDelegate.h"
#import "kata_ActivityViewController.h"
#import "kata_WebViewController.h"
#import "kata_DescribeViewController.h"
#import "kata_SignInViewController.h"
#import "LimitedSeckillViewController.h"
#import "Loading.h"

#define PAGERSIZE           20
#define TABLES_COLOR        [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1]
#define SEGMENTHEIGHT       30

@interface CategoryDetailVC ()<XLCycleScrollViewDatasource,XLCycleScrollViewDelegate,UISearchBarDelegate,TableListTabBarDelegate,LoginDelegate>
{
    NSString *flag;
    NSInteger select;
    NSMutableArray *_productDictArr;
    HomeVO *listVO;
    NSInteger pagesize;
    
    UIView *_headerView;
    XLCycleScrollView *cycleScrollView;
    
    NSMutableArray *_tabbarItems;
    UIView *_sortFilterView;
    kata_TableListTabBar *_tableTabB;
    NSInteger _sorttype;
    
    UISearchBar *_searchBar;
    UIButton *_searchBtn;
    UIButton *_clearBtn;
    Loading *loading_two;
}
@end

@implementation CategoryDetailVC
@synthesize pid;
@synthesize cateid;

-(id)initWithAdvData:(AdvVO *)advo andFlag:(NSString *)_flag{
    if (self=[super init]) {
        flag = _flag;
        pagesize = 20;
        self.ifShowTableSeparator = NO;
        self.ifAddPullToRefreshControl = YES;
        self.ifScrollToTop = YES;
        self.ifShowScrollToTopBtn = YES;
        self.is_search = NO;
        _sorttype = 8;
        
        if (!self.listData) {
            self.listData = [NSMutableArray array];
        }
    }
    self.title = _flag;
    if ([_flag isEqualToString:@"get_nine_list"]) {
        self.title = @"9块9包邮";
    }else if ([_flag isEqualToString:@"get_brand_tuan_list"]) {
        self.title = @"品牌团";
    }else if ([_flag isEqualToString:@"get_special_list"]) {
        self.title = @"汇特卖";
        self.isLamahui = YES;
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    if(self.listData.count > 0){
        self.is_Type = [[[NSUserDefaults standardUserDefaults] objectForKey:@"myInteger"] intValue];
        [self changeCell];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    select = [userDefaultes integerForKey:@"myInteger"];
    if (select == 0) {
        select = 2;
    }
    
    if (self.is_root|| self.is_home) {
        CGRect tableFrame =  self.tableView.frame;
        tableFrame.size.height -= 49;
        self.tableView.frame=tableFrame;
    }
    self.tableView.backgroundColor = TABLES_COLOR;
    
    _clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    [_clearBtn setBackgroundColor:[UIColor clearColor]];
    [_clearBtn addTarget:self action:@selector(removeKeyBord) forControlEvents:UIControlEventTouchUpInside];
    [_clearBtn setHidden:YES];
    [[[UIApplication sharedApplication].delegate window] addSubview:_clearBtn];
    
    [self createUI];
    
    [self loadNewer];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_is_root && self.tabBarController.selectedIndex == 0) {
        [[(kata_AppDelegate *)[[UIApplication sharedApplication] delegate] deckController] setPanningMode:IIViewDeckFullViewPanning];
    }else{
        [[(kata_AppDelegate *)[[UIApplication sharedApplication] delegate] deckController] setPanningMode:IIViewDeckNoPanning];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI{
    if(!_searchBar){
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 5, ScreenW-60, 30)];
        [_searchBar setBackgroundColor:[UIColor whiteColor]];
        _searchBar.layer.cornerRadius = 5.0;
        _searchBar.placeholder = @"输入商品关键词搜索";
        _searchBar.delegate = self;
        
        for (UIView *view in _searchBar.subviews) {
            // for before iOS7.0
            if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                [view removeFromSuperview];
                break;
            }
            // for later iOS7.0(include)
            if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
                [[view.subviews objectAtIndex:0] removeFromSuperview];
                break;
            }
        }
        [_searchBar setHidden:YES];
        [self.contentView addSubview:_searchBar];
        
        _searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_searchBar.frame)+5, 5, 40, 30)];
        [_searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
        [_searchBtn setTitleColor:ALL_COLOR forState:UIControlStateNormal];
        [_searchBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [_searchBtn addTarget:self action:@selector(seachBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_searchBtn setHidden:YES];
        [self.contentView addSubview:_searchBtn];
    }
    if (self.is_search) {
        CGRect frame = self.tableView.frame;
        frame.origin.y += CGRectGetMaxY(_searchBar.frame)+5;
        frame.size.height -= CGRectGetMaxY(_searchBar.frame)+5;
        self.tableView.frame = frame;
    }
}

- (KTBaseRequest *)request
{
    KTBaseRequest *req = [[KTBaseRequest alloc] init];
    
    NSMutableDictionary *paramsDict = [req params];
    
    NSString *userid = @"";
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isEqualToString:@""]) {
        userid = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"];
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (pid)
        [dict setObject:pid forKey:@"pid"];
    if (cateid)
        [dict setObject:cateid forKey:@"cate_id"];
    if (flag)
        [dict setObject:flag forKey:@"flag"];
    if (userid) {
        [dict setObject:[NSNumber numberWithInteger:[userid integerValue]] forKey:@"userid"];
    }
    [dict setValue:[NSNumber numberWithInteger:_sorttype] forKey:@"sort"];
    if ([flag isEqualToString:@"get_nine_list"]||[flag isEqualToString:@"get_brand_tuan_list"]||[flag isEqualToString:@"get_special_list"]) {
        [paramsDict setObject:flag forKey:@"method"];
    } else if(![pid integerValue] && ![cateid integerValue] && ![flag isEqualToString:@"attr"]){
        [paramsDict setObject:@"search_goods_by_keyword" forKey:@"method"];
        [dict setValue:flag forKey:@"keyword"];
    }else{
        [paramsDict setObject:@"getGoodsByCategory" forKey:@"method"];
    }
    
    [dict setObject:[NSNumber numberWithInteger:self.current] forKey:@"page_no"];
    [dict setObject:[NSNumber numberWithInteger:pagesize] forKey:@"page_size"];
    [paramsDict setObject:dict forKey:@"params"];

    return req;
}

- (NSArray *)parseResponse:(NSString *)resp
{
    [self stopLoading];
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
                    
                    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
                    select = [userDefaultes integerForKey:@"myInteger"];
                    if (listVO.productlist) {
                        if (select == 1) {
                            NSMutableArray *cellDataArr_new = [[NSMutableArray alloc] init];
                            if (listVO.productlist.count > 0) {
                                for (NSInteger i = 0; i < listVO.productlist.count; i++) {
                                    if ([listVO.productlist objectAtIndex:i] && [[listVO.productlist objectAtIndex:i] isKindOfClass:[HomeProductVO class]]) {
                                        [cellDataArr_new addObject:[NSArray arrayWithObject:[listVO.productlist objectAtIndex:i]]];
                                    }
                                }
                            }
                            objArr = cellDataArr_new;
                        } else {
                            NSMutableArray *cellDataArr = [[NSMutableArray alloc] init];
                            if (listVO.productlist.count > 0) {
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
                                objArr = cellDataArr;
                            }
                        }
                    }
                    [self performSelectorOnMainThread:@selector(setTbHeaderView) withObject:nil waitUntilDone:YES];
                    self.max = ceil([listVO.total_count floatValue] / (CGFloat)pagesize);
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
    } else {
        self.statefulState = FTStatefulTableViewControllerError;
    }
    self.ifrespErr = YES;
    
    return objArr;
}

- (void)setTbHeaderView
{
    if (self.is_search) {
        [_searchBtn setHidden:NO];
        [_searchBar setHidden:NO];
    }else{
        [_searchBtn setHidden:YES];
        [_searchBar setHidden:YES];
    }
    
    if (_headerView) {
        [_headerView removeFromSuperview];
        _headerView = nil;
    }
    
    if (!_headerView && listVO.banner.count>0) {
        _headerView = [[UIView alloc] initWithFrame:CGRectZero];
    }else{
        [self.tableView setTableHeaderView:_headerView];
        return;
    }
    
    [self performSelectorOnMainThread:@selector(layoutAdverView) withObject:nil waitUntilDone:YES];
}

- (NSInteger)numberOfPages
{
    NSInteger bannerCount = listVO.banner.count;
    return bannerCount;
}

- (void)layoutAdverView
{
    if (cycleScrollView) {
        [cycleScrollView removeFromSuperview];
        [cycleScrollView.animationTimer invalidate];
        cycleScrollView.animationTimer = nil;
        cycleScrollView = nil;
    }
    
    [_headerView setFrame:CGRectMake(0, 0, ScreenW, ScreenW*290/720)];
    if (!cycleScrollView) {
        cycleScrollView = [[XLCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenW*290/720) animationDuration:8];
    }
    cycleScrollView.xldelegate = self;
    cycleScrollView.xldatasource = self;
    
    [_headerView addSubview:cycleScrollView];
    [self.tableView setTableHeaderView:_headerView];
}

- (UIView *)pageAtIndex:(NSInteger)index
{
    CGRect rect = _headerView.bounds;
    if (index < listVO.banner.count) {
        AdvVO *adv = listVO.banner[index];
        NSString *imageName = adv.Pic;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(rect), ScreenW*290/720)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:[UIImage imageNamed:@"place_4"]];
        return imageView;
    }
    return nil;
}

- (void)didClickPage:(XLCycleScrollView *)csView atIndex:(NSInteger)index
{
    if(index < listVO.banner.count){
        AdvVO *adv = listVO.banner[index];
        [self nextView:adv];
    }
}

- (void)changeCell{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    select = [userDefaultes integerForKey:@"myInteger"];
    
    NSMutableArray *array =[[NSMutableArray alloc] init];
    
    if (select == 1) {
        for (NSArray *oneArray in self.listData) {
            for (HomeProductVO *vo in oneArray) {
                [array addObject:[NSArray arrayWithObject:vo]];
            }
        }
    }else{
        if (self.listData.count > 0) {
            NSMutableArray *cellArr = [[NSMutableArray alloc] init];
            for (NSInteger i = 0; i < self.listData.count; i ++) {
                NSArray *uarray = self.listData[i];
                if (uarray.count == 2) {
                    return;
                }else{
                    [cellArr addObjectsFromArray:uarray];
                }
                if (cellArr.count == 2) {
                    [array addObject:cellArr];
                    cellArr = [[NSMutableArray alloc] init];
                }else if (cellArr.count == 1 && i == self.listData.count-1){
                    [array addObject:cellArr];
                }
            }
        }
    }
    [self.listData removeAllObjects];
    self.listData = array;
    [self.tableView reloadData];

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

    NSString *SECTION_TENT = [NSString stringWithFormat:@"SECTION4_TENT%zi",select];

    if (row < self.listData.count) {
        cell = [tableView dequeueReusableCellWithIdentifier:SECTION_TENT];
        if (!cell) {
            cell = [[AloneProductCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SECTION_TENT];
        }
        
        [cell setBackgroundColor:TABLES_COLOR];
        [(AloneProductCellTableViewCell*)cell setCellFrame:self.view.frame];
        [(AloneProductCellTableViewCell*)cell setDelegate:self];
        [(AloneProductCellTableViewCell*)cell setRow:row];
        if ([flag isEqualToString:@"get_brand_tuan_list"]) {
            [(AloneProductCellTableViewCell*)cell layoutUI:self.listData[row] andColnum:select is_act:NO is_type:YES];
        } else {
            [(AloneProductCellTableViewCell*)cell layoutUI:self.listData[row] andColnum:select is_act:NO is_type:NO];
        }
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:SECTION_TENT];
        if (!cell) {
            cell = [[AloneProductCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SECTION_TENT];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.listData.count) {
        if (select == 1) {
            return 140;
        }
        return (ScreenW-30)/2+75;
    }else{
        return 30.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.listData.count > 0 && (self.is_root || !self.is_home) && ![flag isEqual:@"get_brand_tuan_list"] && ![flag isEqual:@"get_nine_list"]) {
        return SEGMENTHEIGHT;
    }
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (!_sortFilterView) {
        _sortFilterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        kata_TableListTabBar *tableTabBar = [[kata_TableListTabBar alloc] initWithFrame:CGRectMake(0, 0, ScreenW, SEGMENTHEIGHT)];
        tableTabBar.tableListTabBarDelegate = self;
        tableTabBar.backgroundColor = [UIColor clearColor];
        _tabbarItems = [[NSMutableArray alloc] initWithCapacity:3];
        [_tabbarItems addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"最新", @"title", @"", @"icon",@"", @"selecticon", @"103", @"tag", @"8", @"sort", @"8", @"sort_op", @"sort_op", @"status", nil]];
        [_tabbarItems addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"销量", @"title", @"", @"icon",@"", @"selecticon", @"101", @"tag", @"6", @"sort", @"6", @"sort_op", @"sort", @"status", nil]];
        [_tabbarItems addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"价格", @"title", @"updown", @"icon",@"downup", @"selecticon", @"102", @"tag", @"1", @"sort", @"2", @"sort_op", @"sort", @"status", nil]];
        tableTabBar.items = _tabbarItems;
        tableTabBar.selectedTabItem = [_tabbarItems objectAtIndex:0];
        _tableTabB = tableTabBar;
        
        UILabel *lineLbl1 = [[UILabel alloc] initWithFrame:CGRectMake(ScreenW/_tabbarItems.count, 5, 0.3, SEGMENTHEIGHT-10)];
        [lineLbl1 setBackgroundColor:LMH_COLOR_LIGHTLINE];
        [_sortFilterView addSubview:lineLbl1];
        UILabel *lineLbl2 = [[UILabel alloc] initWithFrame:CGRectMake(ScreenW/_tabbarItems.count*2, 5, 0.3, SEGMENTHEIGHT-10)];
        [lineLbl2 setBackgroundColor:LMH_COLOR_LIGHTLINE];
        [_sortFilterView addSubview:lineLbl2];
        [_sortFilterView addSubview:tableTabBar];
    }
    
    [_sortFilterView setFrame:CGRectMake(0, 0, ScreenW, SEGMENTHEIGHT)];
    [_sortFilterView setBackgroundColor:[UIColor whiteColor]];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self stopLoading];
//    });

    return _sortFilterView;
}

- (void)seachBtnClick{
    flag = _searchBar.text;

    //过滤字符串前后的空格
    flag = [flag stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //过滤中间空格
    flag = [flag stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(flag.length <= 0){
        [_searchBar becomeFirstResponder];
        return;
    }
    self.title = flag;
    self.current = 1;
    [self loadNewer];
}

#pragma mark - TableListTabBar Delegate
- (void)didSelectedTabItem:(NSDictionary *)item
{
    if (_sorttype != [[item objectForKey:[item objectForKey:@"status"]] intValue]) {
        _sorttype = [[item objectForKey:[item objectForKey:@"status"]] intValue];
        
        if ([table_proxy isLoading]) {
            [table_proxy.oper cancel];
            self.statefulState = FTStatefulTableViewControllerStateIdle;
        }
        
        [self startLoading];
        self.current = 1;
        [self loadNoState];
    }
}

#pragma mark - AloneProductCellTableViewCell Delegate ---(cell 的点击事件)
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

-(void)nextView:(AdvVO *)nextVO
{
    NSString *userid ;
    NSString *usertoken ;
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isEqualToString:@""]) {
        userid = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"];
    }
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isEqualToString:@""]) {
        usertoken = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"];
    }
    
    NSString *webStr = [NSString stringWithFormat:@"?user=%@&token=%@", userid,usertoken];
    
    if (nextVO.Type) {
        NSInteger type = [nextVO.Type integerValue];
        switch (type) {
//            case 0:
//            {
//                if (![[kata_UserManager sharedUserManager] isLogin]) {
//                    [kata_LoginViewController showInViewController:self];
//                }
//            }
//                break;
            case 1://商品详情页
            {
                if(![nextVO.platform isEqualToString:@"lamahui"]){
                    kata_DescribeViewController *webVC = [[kata_DescribeViewController alloc] initWithProductID:[nextVO.Key integerValue] andPlatform:nextVO.platform];
                    webVC.navigationController = self.navigationController;
                    webVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:webVC animated:YES];
                    
                    return;
                }
                
                if (nextVO.Key && [nextVO.Key intValue] != -1) {
                    kata_ProductDetailViewController *detailVC = [[kata_ProductDetailViewController alloc] initWithProductID:[nextVO.Key intValue] andType:nil andSeckillID:-1];
                    detailVC.hidesBottomBarWhenPushed = YES;
                    detailVC.navigationController = self.navigationController;
                    [self.navigationController pushViewController:detailVC animated:YES];
                }
            }
                break;
                
            case 2:
            {
                //商品列表页
                if (nextVO.Key && [nextVO.Key integerValue] != -1) {
                    kata_ProductListViewController *productlistVC = [[kata_ProductListViewController alloc] initWithBrandID:[nextVO.Key intValue] andTitle:nextVO.Title andProductID:0 andPlatform:nextVO.platform isChannel:NO];
                    productlistVC.navigationController = self.navigationController;
                    productlistVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:productlistVC animated:YES];
                }
            }
                break;
                
            case 3:
            {
                //web页
                if (nextVO.Key && ![nextVO.Key isEqualToString:@""]) {
                    if(![nextVO.platform isEqualToString:@"lamahui"]){
                        kata_DescribeViewController *webVC = [[kata_DescribeViewController alloc] initWithProductID:[nextVO.Key integerValue] andPlatform:nextVO.platform];
                        webVC.navigationController = self.navigationController;
                        webVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:webVC animated:YES];
                        
                        return;
                    }
                    NSString *webUrl = [nextVO.Key stringByAppendingString:webStr];
                    kata_WebViewController *webVC = [[kata_WebViewController alloc] initWithUrl:webUrl title:nil andType:nextVO.platform];
                    webVC.navigationController = self.navigationController;
                    webVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:webVC animated:YES];
                }
            }
                break;
            case 4:// 活动类页.
            {
                kata_ActivityViewController *actvityVC = [[kata_ActivityViewController alloc] initWithData:nextVO];
                actvityVC.navigationController = self.navigationController;
                actvityVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:actvityVC animated:YES];
            }
                break;
            case 5://弹窗活动类
            {
                if ([nextVO.Key isEqualToString:@"register"]) {// 注册活动
                    kata_RegisterViewController *regisetVC = [[kata_RegisterViewController alloc] initWithNibName:nil bundle:nil];
                    regisetVC.hidesBottomBarWhenPushed = YES;
                    regisetVC.navigationController = self.navigationController;
                    [self.navigationController pushViewController:regisetVC animated:YES];
                }
            }
                break;
            case 6:
            {
                //web页可操作app页面
                if (nextVO.Key && ![nextVO.Key isEqualToString:@""]) {
                    if(![nextVO.platform isEqualToString:@"lamahui"]){
                        kata_DescribeViewController *webVC = [[kata_DescribeViewController alloc] initWithProductID:[nextVO.Key integerValue] andPlatform:nextVO.platform];
                        webVC.navigationController = self.navigationController;
                        webVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:webVC animated:YES];
                        
                        return;
                    }
                    NSString *webUrl = [nextVO.Key stringByAppendingString:webStr];
                    kata_WebViewController *webVC = [[kata_WebViewController alloc] initWithUrl:webUrl title:nil andType:nextVO.platform];
                    webVC.navigationController = self.navigationController;
                    webVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:webVC animated:YES];
                }
            }
                break;
            case 7://专场活动类
            {
                kata_ActivityViewController *actvityVC = [[kata_ActivityViewController alloc] initWithData:nextVO];
                actvityVC.navigationController = self.navigationController;
                actvityVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:actvityVC animated:YES];
            }
                break;
            case 8://分类页
            {
                CategoryDetailVC *cateVC = [[CategoryDetailVC alloc] initWithAdvData:nextVO andFlag:@"category"];
                cateVC.pid = @0;
                cateVC.cateid = [NSNumber numberWithInteger:[nextVO.Key integerValue]];
                cateVC.navigationItem.title = nextVO.Title;
                cateVC.navigationController = self.navigationController;
                cateVC.hidesBottomBarWhenPushed = YES;
                cateVC.navigationController = self.navigationController;
                [self.navigationController pushViewController:cateVC animated:YES];
            }
                break;
            case 9:
            {
                // 品牌团
                if (nextVO.Key && [nextVO.Key integerValue] != -1) {
                    CategoryDetailVC *productlistVC = [[CategoryDetailVC alloc] initWithAdvData:nextVO andFlag:@"get_brand_tuan_list"];
                    productlistVC.pid = @0;
                    productlistVC.cateid = [NSNumber numberWithInteger:[nextVO.Key integerValue]];
                    productlistVC.navigationController = self.navigationController;
                    productlistVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:productlistVC animated:YES];
                }
            }
                break;
            case 10:
            {
                // 9.9包邮
                if (nextVO.Key && [nextVO.Key integerValue] != -1) {
                    CategoryDetailVC *productlistVC = [[CategoryDetailVC alloc] initWithAdvData:nextVO andFlag: @"get_nine_list"];
                    productlistVC.pid = @0;
                    productlistVC.cateid = [NSNumber numberWithInteger:[nextVO.Key integerValue]];
                    productlistVC.navigationController = self.navigationController;
                    productlistVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:productlistVC animated:YES];
                }
            }
                break;
            case 99:
            {
                //签到赚金豆
                kata_SignInViewController *signInVC = [[kata_SignInViewController alloc] initWithTitle:@"每日签到"];
                signInVC.navigationController = self.navigationController;
                signInVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:signInVC animated:YES];
            }
                break;
            case 100:
            {
                // 红包裂变
                NSString *webUrl = [nextVO.Key stringByAppendingString:webStr];
                kata_WebViewController *webVC = [[kata_WebViewController alloc] initWithUrl:webUrl title:nil andType:@"lamahui"];
                webVC.navigationController = self.navigationController;
                webVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:webVC animated:YES];
            }
                break;
            case 101:
            {
                //秒杀
                LimitedSeckillViewController *skillVC = [[LimitedSeckillViewController alloc] initWithStyle:UITableViewStylePlain];
                skillVC.navigationController = self.navigationController;
                skillVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:skillVC animated:YES];
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark -
#pragma mark overwrite super methods
- (UIView *)emptyView
{
    UIView * v = [super emptyView];
    if (v) {
        CGFloat w = self.view.bounds.size.width;
        CGFloat h = self.view.bounds.size.height;
        UIView *tagview = [v viewWithTag:1001];
        if (!tagview) {
            tagview = [[UIView alloc] initWithFrame:self.view.frame];
            UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"productlistempty"]];
            [image setFrame:CGRectMake((w - CGRectGetWidth(image.frame)) / 2, (h-ScreenW/3)/2-100, CGRectGetWidth(image.frame), CGRectGetHeight(image.frame))];
            if (self.is_search) {
                image.image = [UIImage imageNamed:@"icon_search"];
                image.frame = CGRectMake(ScreenW/3, (h-ScreenW/3)/2-100, ScreenW/3, ScreenW/3);
            }
            [tagview addSubview:image];
            
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(image.frame)+20, ScreenW, 15)];
            [lbl setBackgroundColor:[UIColor clearColor]];
            [lbl setTextAlignment:NSTextAlignmentCenter];
            [lbl setTextColor:[UIColor colorWithRed:0.52 green:0.52 blue:0.52 alpha:1]];
            [lbl setFont:[UIFont systemFontOfSize:14.0]];
            [lbl setText:@"暂无商品信息"];
            if (self.is_search) {
                [lbl setText:@"没找到合适的商品，换个其他的词试试吧~"];
            }
            [tagview addSubview:lbl];
            
            tagview.center = v.center;
            tagview.tag = 1001;
            [v addSubview:tagview];
        }
    }
    return v;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [_clearBtn setHidden:NO];
    return YES;
}

//点击SearchButton隐藏键盘
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [_searchBar resignFirstResponder];
    [_clearBtn setHidden:YES];
    self.current = 1;
    [self seachBtnClick];
}

//点击屏幕隐藏键盘
- (void)removeKeyBord{
    [_searchBar resignFirstResponder];
    [_clearBtn setHidden:YES];
}

-(void)didLogin{
    
}

- (void)loginCancel{
    
}

- (void)startLoading
{
    if (!loading_two) {
        loading_two = [[Loading alloc] initWithFrame:CGRectMake((ScreenW-180)/2, (CGRectGetHeight(self.view.frame)-100)/2, 180, 100) andName:[NSString stringWithFormat:@"loading.gif"]];
        loading.center = self.view.center;
        [loading.layer setCornerRadius:10.0];
        [self.view addSubview:loading_two];
    }
    [loading_two start];
}

- (void)stopLoading
{
    if (loading_two) {
        [loading_two stop];
    }
}
@end
