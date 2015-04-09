 //
//  FTStatefulTableViewController.m
//  FantooApp
//
//  Created by hark2046 on 13-7-9.
//  Copyright (c) 2013年 Fantoo. All rights reserved.
//

#import "FTStatefulTableViewController.h"
#import "kata_CartManager.h"
#import "kata_UserManager.h"
#import "kata_CategoryViewController.h"
#import "CategoryDetailVC.h"
static const NSInteger kLoadingCellTag = 257;

@interface FTStatefulTableViewController ()
{
    UITableViewStyle _tableStyle;
    UIButton *_reloadMask;
    UIButton *_userCentBtn;
    UIButton *_shopCartBtn;
    UIButton *_scrollToTopBtn;
    UIButton *_layoutBtn;
    UILabel *labelImage;
    NSInteger select;
    
    UILabel *_cartCountLbl;
    UIView *_cartCntBgView;
    
    UILabel *_userWaitPayNumLab;
    UIView *_userWaitPayNumbView;
    
}

@property (assign, nonatomic)   BOOL            hasAddedPullToRefreshControl;

- (void)setExtraCellLineHidden:(UITableView *)tableView;
//loading
- (void)loadFirstPage;
- (void)loadNextPage;
- (void)loadFromPullToRefresh;

@end

@implementation FTStatefulTableViewController
- (id) initWithStyle:(UITableViewStyle)style
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        _isLamahui = NO;
        _tableStyle = style;
        _current = 1;
        _max = -1;
        _ifAddPullToRefreshControl = YES;
        _ifShowTableSeparator = YES;
        _isCountingRows = YES;
        _ifScrollToTop = NO;
        _ifShowUserCenterBtn = NO;
        _ifShowBtnHigher = NO;
        _ifRemoveLoadNoState = YES;
        _ifrespErr = NO;
        _is_home = NO;
        _statefulState = FTStatefulTableViewControllerStateIdle;
        table_proxy = nil;
        _listData = [NSMutableArray arrayWithCapacity:20];
    }
    return self;
}

- (void)loadView
{
    [super loadView];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([self.contentView frame]), CGRectGetHeight([self.contentView frame])) style:_tableStyle];
    [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    _tableView.opaque = YES;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self.contentView addSubview:_tableView];
    
    if (_ifAddPullToRefreshControl) {
        _pullToRefreshView = [[SSPullToRefreshView alloc] initWithScrollView:_tableView delegate:self];
    }
    
    if (_ifShowScrollToTopBtn) {
        [self setupScrollToTopButton];
    }
    if (_ifShowToTop) {
        [self setupShowToTop];
    }
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    select = [userDefaultes integerForKey:@"myInteger"];
    if (select == 0) {
        select = 1;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setInteger:select forKey:@"myInteger"];
        [userDefaultes synchronize];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.contentView setAutoresizingMask:UIViewAutoresizingNone];
    
    [self setExtraCellLineHidden:self.tableView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_selectedIndexPath) {
        [self.tableView deselectRowAtIndexPath:_selectedIndexPath animated:YES];
        _selectedIndexPath = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)hideHUDView
{
    [stateHud hide:YES afterDelay:0.3];
}

- (void)setupScrollToTopButton
{
    if (!labelImage) {
        labelImage = [[UILabel alloc] init];
        if (!_ifShowBtnHigher) {
            [labelImage setFrame:CGRectMake(CGRectGetWidth(self.contentView.frame) - 53, CGRectGetHeight(self.contentView.frame) - 85, 34, 76)];
        } else {
            [labelImage setFrame:CGRectMake(CGRectGetWidth(self.contentView.frame) - 53, CGRectGetHeight(self.contentView.frame) - 131, 34, 76)];
        }
//        labelImage.backgroundColor     = [UIColor colorWithRed:239/255.0 green:80/255.0 blue:108/255.0 alpha:0.85];
//        labelImage.layer.masksToBounds = YES;
//        labelImage.layer.cornerRadius  = 17.0;
//        [self.view addSubview:labelImage];
//        [labelImage setHidden:YES];
    }
    if (!_scrollToTopBtn) {
        _scrollToTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if (!_ifShowBtnHigher) {
            [_scrollToTopBtn setFrame:CGRectMake(ScreenW - 50, CGRectGetHeight(self.contentView.frame) - 60, 40, 40)];
        } else {
            [_scrollToTopBtn setFrame:CGRectMake(ScreenW - 50, CGRectGetHeight(self.contentView.frame) - 100, 40, 40)];
        }
        UIImage *image = [UIImage imageNamed:@"icon_TopShow"];
        [_scrollToTopBtn setImage:image forState:UIControlStateNormal];
        [_scrollToTopBtn addTarget:self action:@selector(scrollToTopCenter) forControlEvents:UIControlEventTouchUpInside];
        [_scrollToTopBtn setHidden:YES];
        
        [self.view addSubview:_scrollToTopBtn];
    }
    if (!_layoutBtn) {
        _layoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_layoutBtn setFrame:CGRectMake(ScreenW-50, CGRectGetHeight(self.contentView.frame) - (_ifShowBtnHigher?150:110), 40, 50)];
        UIImage *image;
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        select = [userDefaultes integerForKey:@"myInteger"];
        if (select == 1) {
            image = [UIImage imageNamed:@"icon_BigShow"];
        } else {
            image = [UIImage imageNamed:@"icon_SmallShow"];
        }
        [_layoutBtn setImage:image forState:UIControlStateNormal];
        _layoutBtn.imageEdgeInsets = UIEdgeInsetsMake(5,2,5,2);
        [_layoutBtn addTarget:self action:@selector(changeView) forControlEvents:UIControlEventTouchUpInside];
        [_layoutBtn setHidden:YES];

        [self.view addSubview:_layoutBtn];
    }
}

- (void)setupShowToTop
{
    if (!_scrollToTopBtn) {
        _scrollToTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if (!_ifShowBtnHigher) {
            [_scrollToTopBtn setFrame:CGRectMake(CGRectGetWidth(self.contentView.frame) - 49, CGRectGetHeight(self.contentView.frame) - 50, 35, 35)];
        } else {
            [_scrollToTopBtn setFrame:CGRectMake(CGRectGetWidth(self.contentView.frame) - 49, CGRectGetHeight(self.contentView.frame) - 93, 35, 35)];
        }
        UIImage *image = [UIImage imageNamed:@"icon_TopShow"];
        [_scrollToTopBtn setImage:image forState:UIControlStateNormal];
        [_scrollToTopBtn addTarget:self action:@selector(scrollToTopCenter) forControlEvents:UIControlEventTouchUpInside];
        [_scrollToTopBtn setHidden:YES];
        
        [self.view addSubview:_scrollToTopBtn];
    }
}

- (void)scrollToTopCenter
{
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)changeView
{
    if (select == 2) {
        UIImage *image = [UIImage imageNamed:@"icon_BigShow"];
        [_layoutBtn setImage:image forState:UIControlStateNormal];
        select = 1;
    } else {
        UIImage *image = [UIImage imageNamed:@"icon_SmallShow"];
        [_layoutBtn setImage:image forState:UIControlStateNormal];
        select = 2;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:select forKey:@"myInteger"];
    [userDefaults synchronize];
    
    CGSize size = self.tableView.contentSize;
    if(select == 2){
        [self.tableView setContentOffset:CGPointMake(0, size.height/2)];
    }
    [self performSelectorOnMainThread:@selector(changeCell) withObject:nil waitUntilDone:YES];
}
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
#pragma mark - state info view
//所有的状态信息提示视图
//////////////////////////////////////////////////////////////////////////////////
- (UIView *)idleView
{
    return nil;
}

- (UIView *)loadingView
{

    if (!_loadingView) {
        _loadingView = [[UIView alloc] initWithFrame:self.tableView.bounds];
        [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
//        [_loadingView setBackgroundColor:[UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f]];
        loading = [[Loading alloc]initWithFrame:CGRectMake(0, 0, 180, 100) andName:[NSString stringWithFormat:@"loading.gif"]];
//        [loading setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.7]];
        loading.center = _loadingView.center;
        [loading start];
        [_loadingView addSubview:loading];
    }
    
    return _loadingView;
}

- (UIView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        [_emptyView setBackgroundColor:[UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f]];

//        CGFloat w = self.view.bounds.size.width;
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 105)];
//        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"productlistempty"]];
//        [image setFrame:CGRectMake((w - CGRectGetWidth(image.frame)) / 2, -40, CGRectGetWidth(image.frame), CGRectGetHeight(image.frame))];
//        [view addSubview:image];
//        
//        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, w, 15)];
//        [lbl setBackgroundColor:[UIColor clearColor]];
//        [lbl setTextAlignment:NSTextAlignmentCenter];
//        [lbl setTextColor:[UIColor colorWithRed:0.52 green:0.52 blue:0.52 alpha:1]];
//        [lbl setFont:[UIFont systemFontOfSize:14.0]];
//        [lbl setText:@"暂无商品"];
//        [view addSubview:lbl];
//        
//        view.center = _emptyView.center;
//        
//        [_emptyView addSubview:view];
    }
    return _emptyView;
}

- (UIView *)errorView
{
    if (!_errorView) {
        _errorView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        [_errorView setBackgroundColor:[UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f]];
        
        CGFloat w = self.view.bounds.size.width;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 160)];
        [view setBackgroundColor:[UIColor clearColor]];
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"neterror"]];
        [image setFrame:CGRectMake((w - CGRectGetWidth(image.frame)) / 2, 15, CGRectGetWidth(image.frame), CGRectGetHeight(image.frame))];
        [view addSubview:image];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 105, w, 34)];
        [lbl setBackgroundColor:[UIColor clearColor]];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [lbl setNumberOfLines:2];
        [lbl setTextColor:[UIColor colorWithRed:0.52 green:0.52 blue:0.52 alpha:1]];
        [lbl setFont:[UIFont systemFontOfSize:14.0]];
        [lbl setText:@"网络抛锚\r\n请检查网络后点击屏幕重试！"];
        [view addSubview:lbl];
        
        view.center = _errorView.center;
        [_errorView addSubview:view];
    }
    
    if (!_reloadMask) {
        UIButton *reloadMask = [[UIButton alloc] initWithFrame:_errorView.bounds];
        reloadMask.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        [reloadMask addTarget:self action:@selector(reloadAfterError) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:reloadMask];
        _reloadMask = reloadMask;
    }
    
    return _errorView;
}

- (void)reloadAfterError
{
    [self loadNewer];
    if (_reloadMask) {
        [_reloadMask removeFromSuperview];
        _reloadMask = nil;
    }
}

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
#pragma mark - start to load
//所有的加载数据相关方法
//////////////////////////////////////////////////////////////////////////////////
- (void)loadNewer
{
    //    [self loadFirstPage];
    if (self.statefulState == FTStatefulTableViewControllerStateInitialLoading) {
        return;
    }
    
    [self.listData removeAllObjects];
    _current = 1;
    //_max = -1;
    
    self.statefulState = FTStatefulTableViewControllerStateInitialLoading;
    
    [self.tableView reloadData];
    
    [self performSelector:@selector(loadFirstPage) withObject:nil afterDelay:0];
}

- (void)loadNoState
{
    //    [self loadFirstPage];
    if (self.statefulState == FTStatefulTableViewControllerStateInitialLoading) {
        return;
    }
    
//    [self.listData removeAllObjects];
    _current = 1;
    _max = -1;
    self.statefulState = FTStatefulTableViewControllerStateInitialLoading;
    [self.tableView reloadData];
    
    [self performSelector:@selector(loadFirstPage) withObject:nil afterDelay:0];
}

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////        ////////////////////////////////////////////////////
#pragma mark - load first page
//加载第一页数据
//////////////////////////////////////////////////////////////////////////////////
- (void)loadFirstPage
{
//    已经在加载或者已经完成第一次加载，直接跳过
    
    KTBaseRequest * req = [self request];
    
    table_proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        NSArray * items = [self parseResponse:resp];
        
        if (items && [items count]){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_listData && _listData.count > 0) {
                    [_listData removeAllObjects];
                }
                [_listData addObjectsFromArray:items];
                [self.tableView reloadData];
                
            });
            
            self.statefulState = FTStatefulTableViewControllerStateIdle;
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
            if (![_listData count]) {
                if (_ifrespErr) {
                    self.statefulState = FTStatefulTableViewControllerError;
                }else{
                    self.statefulState = FTStatefulTableViewControllerStateEmpty;
                }
            }else{
                self.statefulState = FTStatefulTableViewControllerStateIdle;
            }
            });
        }
    } failed:^(NSError *error) {
        NSArray * items = [self parseResponse:nil];
        
        if (items && [items count]){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_listData addObjectsFromArray:items];
                [self.tableView reloadData];
                
            });
            
            self.statefulState = FTStatefulTableViewControllerStateIdle;
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (![_listData count]) {
                    if (_ifrespErr) {
                        self.statefulState = FTStatefulTableViewControllerError;
                    }else{
                        self.statefulState = FTStatefulTableViewControllerStateEmpty;
                    }
                }else{
                    self.statefulState = FTStatefulTableViewControllerStateIdle;
                }
            });
        }
    }];
    
    [table_proxy start];
}

- (void)loadNextPage
{
    if (self.statefulState == FTStatefulTableViewControllerStateLoadingNextPage) return;
    
    if ([self canLoadMore]) {
        
        self.statefulState = FTStatefulTableViewControllerStateLoadingNextPage;
        
//        切换页码到下一页
        _current++;
        
        KTBaseRequest * req = [self request];
        table_proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
            
            NSArray * items = [self parseResponse:resp];
            
            if (items && [items count]){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [_listData addObjectsFromArray:items];
                    
                    [self.tableView reloadData];
                    
                    
                });
            }
            self.statefulState = FTStatefulTableViewControllerStateIdle;
        } failed:^(NSError *error) {
//            NSLog(@"%@:::%@:::加载数据失败", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
            self.statefulState = FTStatefulTableViewControllerStateIdle;
        }];
        
        [table_proxy start];
        
    }
}

- (void)loadFromPullToRefresh
{
    if  (self.statefulState == FTStatefulTableViewControllerStateLoadingFromPullToRefresh) return;
    
    self.statefulState = FTStatefulTableViewControllerStateLoadingFromPullToRefresh;
    
    _current = 1;
    
    KTBaseRequest * req = [self request];
    table_proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        NSArray * items = [self parseResponse:resp];
        
        if (items && [items count]){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (_listData && [_listData count]) {
                    [_listData removeAllObjects];
                }
                
                [_listData addObjectsFromArray:items];
                
                [self.tableView reloadData];
            });
            
            self.statefulState = FTStatefulTableViewControllerStateIdle;
        }else{
            self.statefulState = FTStatefulTableViewControllerStateIdle;
        }
        
        [_pullToRefreshView performSelectorOnMainThread:@selector(finishLoading) withObject:nil waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        if (_is_home) {
            [self parseResponse:nil];
            self.statefulState = FTStatefulTableViewControllerStateIdle;
        }else{
            self.statefulState = FTStatefulTableViewControllerError;
        }
        
        [_pullToRefreshView performSelectorOnMainThread:@selector(finishLoading) withObject:nil waitUntilDone:YES];
    }];
    
    [table_proxy start];
}

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
#pragma mark - give request, need override
//提供需要的请求数据
//////////////////////////////////////////////////////////////////////////////////
- (KTBaseRequest *)request
{
    return nil;
}

- (BOOL)canLoadMore
{
    return _current < _max;
}

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
#pragma mark - parse response data, need override
//解析返回的数据
//////////////////////////////////////////////////////////////////////////////////
- (NSArray *)parseResponse:(NSString *)resp
{
    _max = 1;
    return nil;
}


//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
#pragma mark - change state
//切换状态
//////////////////////////////////////////////////////////////////////////////////
- (void) setStatefulState:(FTStatefulTableViewControllerState)statefulState
{
    _statefulState = statefulState;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (_statefulState) {
            case FTStatefulTableViewControllerStateIdle:
                [self.tableView setBackgroundView:self.idleView];
                if (_ifShowTableSeparator) {
                    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
                } else {
                    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
                }
                [self.tableView setScrollEnabled:YES];
//                [self.tableView.tableHeaderView setHidden:YES];
                [self.tableView.tableFooterView setHidden:YES];
                [self.tableView reloadData];
                if (stateHud) {
                    [self hideHUDView];
                    if (self.ifScrollToTop) {
                        [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
                    }
                }
                break;
            case FTStatefulTableViewControllerStateInitialLoading:
                [self.tableView setBackgroundView:self.loadingView];
                [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
                [self.tableView setScrollEnabled:NO];
//                [self.tableView.tableHeaderView setHidden:YES];
                [self.tableView.tableFooterView setHidden:YES];
                [self.tableView reloadData];
                break;
            case FTStatefulTableViewControllerStateEmpty:
                [self.tableView setBackgroundView:self.emptyView];
                [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
                [self.tableView setScrollEnabled:NO];
//                [self.tableView.tableHeaderView setHidden:YES];
                [self.tableView.tableFooterView setHidden:YES];
                [self.tableView reloadData];
                if (stateHud) {
                    [self hideHUDView];
                }
                break;
            case FTStatefulTableViewControllerError:
                [self.tableView setBackgroundView:self.errorView];
                [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
                [self.tableView setScrollEnabled:NO];
//                [self.tableView.tableHeaderView setHidden:YES];
                [self.tableView.tableFooterView setHidden:YES];
                [self.tableView reloadData];
                if (stateHud) {
                    [self hideHUDView];
                }
                break;
            case FTStatefulTableViewControllerStateLoadingNextPage:
                break;
            case FTStatefulTableViewControllerStateLoadingFromPullToRefresh:
                break;
            default:
                break;
        }
    });
}

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
#pragma mark - pull to refresh
//下拉刷新
//////////////////////////////////////////////////////////////////////////////////
- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view
{
    [self loadFromPullToRefresh];
}

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
#pragma mark - tableview datasource && tableview delegate
//常规表格的数据和委托
//////////////////////////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = _listData.count;
    if (count > 8) {
        count++;
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row && row == _listData.count) {
        return 30.0f;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * LOAD_MORE_CELL = @"LOAD_MORE_CELL_IDENTIFITY";
    static NSString * LOAD_EMPTY_CELL = @"LOAD_EMPTY_CELL_IDENTIFITY";
    
    UITableViewCell * cell = nil;
    NSInteger row = indexPath.row;
    
    if (self.current < self.max && (row == _listData.count)) {
        cell = [tableView dequeueReusableCellWithIdentifier:LOAD_MORE_CELL];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LOAD_MORE_CELL];
            [cell.contentView setBackgroundColor:GRAY_CELL_COLOR];
            [cell setBackgroundColor:GRAY_CELL_COLOR];
            
            UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            activityIndicator.center = cell.center;
            activityIndicator.tag = kLoadingCellTag;
            
            [cell addSubview:activityIndicator];
            
            [activityIndicator startAnimating];
            cell.userInteractionEnabled = NO;
        }else{
            UIActivityIndicatorView * activityIndicator = (UIActivityIndicatorView * )[cell viewWithTag:kLoadingCellTag];
            [activityIndicator startAnimating];
        }
    }else if(self.current == self.max && (row == _listData.count)){
        cell = [tableView dequeueReusableCellWithIdentifier:LOAD_EMPTY_CELL];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LOAD_EMPTY_CELL];
            [cell.contentView setBackgroundColor:GRAY_CELL_COLOR];
            [cell setBackgroundColor:GRAY_CELL_COLOR];

            UILabel *emptyLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenW/2 +20, 30)];
            emptyLbl.textAlignment = NSTextAlignmentRight;
            emptyLbl.backgroundColor = [UIColor clearColor];
            emptyLbl.font = [UIFont systemFontOfSize:12.0];
            emptyLbl.textColor = RGB(153, 153, 153);
            
            emptyLbl.text = @"还有更多好货等您来选";
            [cell addSubview:emptyLbl];
            
            UIButton *emptyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            emptyBtn.frame = CGRectMake(ScreenW/2+30, 5, 60, 20);
            [emptyBtn setBackgroundImage:[UIImage imageNamed:@"btn_goToOther"] forState:UIControlStateNormal];
            [emptyBtn addTarget:self action:@selector(goToOtherBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:emptyBtn];
            
            if (self.isLamahui) {
                emptyBtn.hidden = YES;
                
                emptyLbl.text = @"已经到底了";
                emptyLbl.frame = CGRectMake(0, 0, ScreenW, 30);
                emptyLbl.textAlignment = NSTextAlignmentCenter;
            }
        }
        
        return cell;
    }
    
    return cell;
}
- (void)goToOtherBtnClick
{
    CategoryDetailVC *lmhVC = [[CategoryDetailVC alloc] initWithAdvData:nil andFlag:@"get_special_list"];
    lmhVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:lmhVC animated:YES];
}

//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    if (!decelerate){
//        [self scrollViewDidEndDecelerating:scrollView];
//    }
//}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    if ((self.tableView.contentOffset.y + CGRectGetHeight(self.tableView.frame)) + 10 >= self.tableView.contentSize.height && self.statefulState == FTStatefulTableViewControllerStateIdle && [self canLoadMore]) {
//        [self performSelectorInBackground:@selector(loadNextPage) withObject:nil];
//    }
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.tableView.contentOffset.y > 500) {
        [_scrollToTopBtn setHidden:NO];
        [_layoutBtn setHidden:NO];
        [labelImage setHidden:NO];
    } else {
        [_scrollToTopBtn setHidden:YES];
        [_layoutBtn setHidden:YES];
        [labelImage setHidden:YES];
    }
//    NSLog(@"y = %f , yyy = %f h = %f",self.tableView.contentOffset.y, self.tableView.contentSize.height,CGRectGetHeight(self.tableView.frame));
    if ((self.tableView.contentOffset.y + 5*CGRectGetHeight(self.tableView.frame)) >= self.tableView.contentSize.height && self.statefulState == FTStatefulTableViewControllerStateIdle && [self canLoadMore]) {
        [self performSelectorInBackground:@selector(loadNextPage) withObject:nil];
    }
}

- (void)changeCell{

}

- (void)setIs_Type:(NSInteger)is_Type
{
    if (is_Type == 1) {
        UIImage *image = [UIImage imageNamed:@"icon_BigShow"];
        [_layoutBtn setImage:image forState:UIControlStateNormal];
    } else {
        UIImage *image = [UIImage imageNamed:@"icon_SmallShow"];
        [_layoutBtn setImage:image forState:UIControlStateNormal];
    }
}

@end
