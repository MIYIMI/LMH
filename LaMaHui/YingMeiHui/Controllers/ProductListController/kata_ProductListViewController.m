//
//  kata_ProductListViewController.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-2.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "kata_ProductListViewController.h"
#import "KTProductListDataGetRequest.h"
#import "ProductListVO.h"
#import "SSCheckBoxView.h"
#import "kata_ProductDetailViewController.h"
#import "kata_FavManager.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "kata_GlobalConst.h"
#import "kata_MyViewController.h"
#import "kata_ShopCartViewController.h"
#import "KTLimitListRequest.h"
#import "AloneProductCellTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "HomeVO.h"
#import "kata_AppDelegate.h"
#import "LMH_Config.h"
#import "kata_UserManager.h"
#import "AdvListVO.h"
#import "kata_WebViewController.h"

#define PAGERSIZE           20
#define SEGMENTHEIGHT       40
#define TABLE_COLOR         [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1]
#define SEGMENT_BGCOLOR     [UIColor whiteColor]
#define ADVFOCUSHEIGHT      130

@interface kata_ProductListViewController ()<AloneProductCellTableViewCellDelgate>
{
    NSInteger _brandid;
    NSInteger _productid;
    BOOL _isFav;
    BOOL _ischannel;
    UIBarButtonItem *_menuItem;
    
    NSInteger _filterstock;
    NSInteger _sorttype;
    NSInteger _cateid;
    NSInteger _sizeid;
    NSMutableArray *_productDictArr;
    
    UIView *_sortFilterView;
    NSMutableArray *_tabbarItems;
    kata_TableListTabBar *_tableTabB;
    UILabel *timeLbl;
    UIButton *_showFilterBtn;
    UIImageView *_headerView;
    
    HomeVO *listVO;
    NSTimer *backTimer;
    NSTimeInterval startTime;
    NSTimeInterval curTime;

    UIViewController *_prevViewController;
    UIBarButtonItem *_shareItem;
    UIView *_listEmptyView;
    NSInteger select;
    NSString *_platform;
    
    BOOL is_limit;
    BOOL _isAdvLoaded;
    
}

@end

@implementation kata_ProductListViewController

- (id)initWithBrandID:(NSInteger)brandid
             andTitle:(NSString *)title
         andProductID:(NSInteger)productid
          andPlatform:(NSString *)platform
            isChannel:(BOOL)ischannel
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // Custom initialization
        self.ifShowTableSeparator = NO;
        self.ifAddPullToRefreshControl = YES;
        self.ifScrollToTop = YES;
        self.ifShowScrollToTopBtn = YES;
        _brandid = brandid;
        _productid = productid;
        _ischannel = ischannel;
        _isFav = NO;
        self.title = title;
        _platform = platform;
        
        _filterstock = 0;
        _sorttype = 8;
        _cateid = -1;
        _sizeid = -1;
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
    // Do any additional setup after loading the view.
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    select = [userDefaultes integerForKey:@"myInteger"];
    if (select == 0) {
        select = 2;
    }
    [self loadNewer];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTbHeaderView
{
    if (_headerView) {
        [_headerView removeFromSuperview];
        _headerView = nil;
    }

    if (!_headerView) {
        _headerView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    
    [self.tableView setBackgroundColor:TABLE_COLOR];
    [self performSelectorOnMainThread:@selector(layoutAdverView) withObject:nil waitUntilDone:YES];
}

- (void)layoutAdverView
{
    if (listVO.brandBanner.length > 4) {
        [_headerView setFrame:CGRectMake(0, 0, ScreenW, ADVFOCUSHEIGHT)];
        [_headerView sd_setImageWithURL:[NSURL URLWithString:listVO.brandBanner] placeholderImage:nil];
    }
    
    [self.tableView setTableHeaderView:_headerView];
}

- (void)loadWithHud
{
    if (!stateHud) {
        stateHud = [[MBProgressHUD alloc] initWithView:self.contentView];
        stateHud.delegate = self;
        [self.contentView addSubview:stateHud];
    }
    stateHud.mode = MBProgressHUDModeIndeterminate;
    [stateHud show:YES];
    
    [self loadNoState];
}

- (KTBaseRequest *)request
{
    NSString *userid = @"";
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isEqualToString:@""]) {
        userid = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"];
    }
    
    KTProductListDataGetRequest *req = [[KTProductListDataGetRequest alloc] initWithBrandID:_brandid
                                                andFilterStock:_filterstock
                                                     andCateID:_cateid
                                                     andSizeID:_sizeid
                                                  andProductID:_productid
                                                       andSort:_sorttype
                                                   andPageSize:PAGERSIZE
                                                    andPageNum:self.current
                                                   andPlatform:_platform
                                                     andUserID:[userid integerValue]];
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
                    if (objArr.count > 0) {
                        [self performSelectorOnMainThread:@selector(setTbHeaderView) withObject:nil waitUntilDone:YES];
                    }
                    self.max = ceil([listVO.total_count floatValue] / (CGFloat)PAGERSIZE);
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
                    [array addObjectsFromArray:uarray];
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.listData.count > 0) {
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
        [_sortFilterView addSubview:tableTabBar];
    }
    
    if (!timeLbl) {
        timeLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        [timeLbl setTextAlignment:NSTextAlignmentLeft];
        [timeLbl setTextColor:[UIColor colorWithRed:0.68 green:0.68 blue:0.68 alpha:1]];
        [timeLbl setTextAlignment:NSTextAlignmentRight];
        [_sortFilterView addSubview:timeLbl];
    }
    [_sortFilterView setFrame:CGRectMake(0, 0, ScreenW, SEGMENTHEIGHT)];
    [_sortFilterView setBackgroundColor:SEGMENT_BGCOLOR];

    return _sortFilterView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (cell) {
        return cell;
    }
    
    NSInteger row = indexPath.row;
    NSString *CELL_IDENTIFI = [NSString stringWithFormat:@"CATEINFO_CELL%zi",select];

    cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFI];
    if (!cell) {
        cell = [[AloneProductCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFI];
    }
    
    [cell setBackgroundColor:[UIColor whiteColor]];
    [(AloneProductCellTableViewCell*)cell setCellFrame:self.view.frame];
    [(AloneProductCellTableViewCell *)cell setDelegate:self];
    [(AloneProductCellTableViewCell*)cell layoutUI:self.listData[row] andColnum:select is_act:NO is_type:NO];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.listData.count) {
        if (select == 1) {
            return 140;
        }
        return (ScreenW-15)/2*447/350+60;
    }else{
        return 30;
    }
}

#pragma mark - CheckBox State Changed
- (void)stockFilterPressed
{
    [self loadWithHud];
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
        
        [self loadWithHud];
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

#pragma mark - KTBaseFilterViewController Delegate
- (void)isFilterViewAppear:(BOOL)isappear
{
    if (isappear) {
        [_showFilterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        [_showFilterBtn setTitleColor:[UIColor colorWithRed:0.67 green:0.67 blue:0.67 alpha:1] forState:UIControlStateNormal];
    }
}

- (UIView *)emptyView
{
    UIView * v = [super emptyView];
    if (v) {
        if (!_listEmptyView) {
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
            _listEmptyView = v;
        }
    }
    return _listEmptyView;
}

@end
