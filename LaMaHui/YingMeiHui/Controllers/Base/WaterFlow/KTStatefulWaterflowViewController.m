//
//  KTStatefulWaterflowViewController.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-3-31.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTStatefulWaterflowViewController.h"

@interface KTStatefulWaterflowViewController ()

@property (assign, nonatomic)   BOOL    isCountingRows;
@property (assign, nonatomic)   BOOL    hasAddedPullToRefreshControl;

//- (void)setExtraCellLineHidden:(UITableView *)tableView;
//loading
- (void)loadFirstPage;
- (void)loadNextPage;
- (void)loadFromPullToRefresh;

@end

@implementation KTStatefulWaterflowViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _current = 1;
        _max = -1;
        _statefulState = MJStatefulTableViewControllerStateIdle;
        table_proxy = nil;
        _listData = [NSMutableArray arrayWithCapacity:20];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    _waterflowView = [[PSCollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame))];
    [_waterflowView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [_waterflowView setCollectionViewDelegate:self];
    [_waterflowView setCollectionViewDataSource:self];
    [_waterflowView setDelegate:self];
    [_waterflowView setNumColsPortrait:3];
    [_waterflowView setBackgroundColor:[UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f]];
    [self.contentView addSubview:_waterflowView];
    
    _pullToRefreshView = [[SSPullToRefreshView alloc] initWithScrollView:_waterflowView delegate:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView * v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 32.0)];
    [v setBackgroundColor:[UIColor clearColor]];
    UIActivityIndicatorView * loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loadingView.center = v.center;
    [v addSubview:loadingView];
    [loadingView startAnimating];
    
    [_waterflowView setFooterView:v];
    
    if ([self hidesBottomBarWhenPushed]) {
        [self.contentView setFrame:CGRectMake(0, 44.0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 44.0)];
    } else {
        [self.contentView setFrame:CGRectMake(0, 44.0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 44.0 - 49.0f)];
    }
    
    [self.contentView setAutoresizingMask:UIViewAutoresizingNone];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - state info view
//所有的状态信息提示视图
//////////////////////////////////////////////////////////////////////////////////

- (UIView *)loadingView
{
    if (!_loadingView) {
        _loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.contentView.frame), CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame))];
        [_loadingView setBackgroundColor:[UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f]];
        UIActivityIndicatorView * activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicatorView.center = CGPointMake(_loadingView.center.x, _loadingView.center.y - CGRectGetMinY(self.contentView.frame));
        [activityIndicatorView startAnimating];
        
        [_loadingView addSubview:activityIndicatorView];
    }
    
    return _loadingView;
}

- (UIView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.contentView.frame), CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame))];
        [_emptyView setBackgroundColor:[UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f]];
    }
    return _emptyView;
}

- (UIView *)errorView
{
    if (_errorView) {
        _errorView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.contentView.frame), CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame))];
        [_errorView setBackgroundColor:[UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f]];
        
        
        UILabel * lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), 50.0f)];
        [lbl setBackgroundColor:[UIColor clearColor]];
        
        [lbl setText:@"内容加载出错，请稍后重试"];
        [lbl setFont:[UIFont boldSystemFontOfSize:14.0f]];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [lbl setTextColor:[UIColor grayColor]];
        
        [_errorView addSubview:lbl];
    }
    return _errorView;
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - start to load
//所有的加载数据相关方法
//////////////////////////////////////////////////////////////////////////////////

- (void)loadNewer
{
    //    [self loadFirstPage];
    if (self.statefulState == MJStatefulTableViewControllerStateInitialLoading) {
        return;
    }
    
    [self.listData removeAllObjects];
    _current = 1;
    _max = -1;
    
    self.statefulState = MJStatefulTableViewControllerStateInitialLoading;
    
    [self.waterflowView reloadData];
    
    [self performSelector:@selector(loadFirstPage) withObject:nil afterDelay:0.5];
}

//////////////////////////////////////////////////////////////////////////////////
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
                [_listData addObjectsFromArray:items];
                [self.waterflowView reloadData];
            });
            self.statefulState = MJStatefulTableViewControllerStateIdle;
        }else{
            if (![_listData count]) {
                self.statefulState = MJStatefulTableViewControllerStateEmpty;
            }else{
                self.statefulState = MJStatefulTableViewControllerStateIdle;
            }
        }
    } failed:^(NSError *error) {
        self.statefulState = MJStatefulTableViewControllerError;
    }];
    
    [table_proxy start];
}

- (void)loadNextPage
{
    if (self.statefulState == MJStatefulTableViewControllerStateLoadingNextPage) return;
    if ([self canLoadMore]) {
        self.statefulState = MJStatefulTableViewControllerStateLoadingNextPage;
        //切换页码到下一页
        _current++;
        KTBaseRequest * req = [self request];
        table_proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
            NSArray * items = [self parseResponse:resp];
            if (items && [items count]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_listData addObjectsFromArray:items];
                    if ([self canLoadMore]) {
                        if (!self.waterflowView.footerView) {
                            UIView * v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 32.0)];
                            [v setBackgroundColor:[UIColor clearColor]];
                            UIActivityIndicatorView * loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                            loadingView.center = v.center;
                            [v addSubview:loadingView];
                            [loadingView startAnimating];
                            [_waterflowView setFooterView:v];
                        }
                    } else {
                        self.waterflowView.footerView = nil;
                    }
                    [self.waterflowView reloadData];
                });
            }
            self.statefulState = MJStatefulTableViewControllerStateIdle;
        } failed:^(NSError *error) {
            self.statefulState = MJStatefulTableViewControllerStateIdle;
        }];
        [table_proxy start];
    }
}

- (void)loadFromPullToRefresh
{
    if  (self.statefulState == MJStatefulTableViewControllerStateLoadingFromPullToRefresh) return;
    self.statefulState = MJStatefulTableViewControllerStateLoadingFromPullToRefresh;
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
                [self.waterflowView reloadData];
            });
            self.statefulState = MJStatefulTableViewControllerStateIdle;
        }else{
            self.statefulState = MJStatefulTableViewControllerStateIdle;
        }
        [_pullToRefreshView finishLoading];
        
    } failed:^(NSError *error) {
        self.statefulState = MJStatefulTableViewControllerError;
        [_pullToRefreshView finishLoading];
    }];
    [table_proxy start];
}

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
#pragma mark - parse response data, need override
//解析返回的数据
//////////////////////////////////////////////////////////////////////////////////

- (NSArray *)parseResponse:(NSString *)resp
{
    _max = 1;
    return nil;
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - change state
//切换状态
//////////////////////////////////////////////////////////////////////////////////

- (void) setStatefulState:(MJStatefulTableViewControllerState)statefulState
{
    _statefulState = statefulState;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (_statefulState) {
            case MJStatefulTableViewControllerStateIdle:
                [self.emptyView removeFromSuperview];
                [self.errorView removeFromSuperview];
                [self.loadingView removeFromSuperview];
                [self.waterflowView setScrollEnabled:YES];
                [self.waterflowView.footerView setHidden:YES];
                [self.waterflowView reloadData];
                break;
            case MJStatefulTableViewControllerStateInitialLoading:
                [self.emptyView removeFromSuperview];
                [self.errorView removeFromSuperview];
                [self.view addSubview:self.loadingView];
                [self.waterflowView setScrollEnabled:NO];
                [self.waterflowView.footerView setHidden:YES];
                [self.waterflowView reloadData];
                break;
            case MJStatefulTableViewControllerStateEmpty:
                [self.loadingView removeFromSuperview];
                [self.errorView removeFromSuperview];
                [self.view addSubview:self.emptyView];
                [self.waterflowView setScrollEnabled:NO];
                [self.waterflowView.footerView setHidden:YES];
                [self.waterflowView reloadData];
                break;
            case MJStatefulTableViewControllerError:
                [self.loadingView removeFromSuperview];
                [self.emptyView removeFromSuperview];
                [self.view addSubview:self.errorView];
                [self.waterflowView setScrollEnabled:NO];
                [self.waterflowView.footerView setHidden:YES];
                [self.waterflowView reloadData];
                break;
            case MJStatefulTableViewControllerStateLoadingNextPage:
                [self.waterflowView.footerView setHidden:NO];
                break;
            case MJStatefulTableViewControllerStateLoadingFromPullToRefresh:
                [self.waterflowView.footerView setHidden:YES];
                break;
            default:
                break;
        }
    });
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - pull to refresh
//下拉刷新
//////////////////////////////////////////////////////////////////////////////////

- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view
{
    [self loadFromPullToRefresh];
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCollectionView datasource && tableview delegate
//瀑布流的数据和委托
//////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfRowsInCollectionView:(PSCollectionView *)collectionView
{
    return [self.listData count];
}

- (CGFloat)collectionView:(PSCollectionView *)collectionView heightForRowAtIndex:(NSInteger)index
{
    return 0;
}

- (PSCollectionViewCell *)collectionView:(PSCollectionView *)collectionView cellForRowAtIndex:(NSInteger)index
{
    return nil;
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - check bounds
//检查是否可以加载更多
//////////////////////////////////////////////////////////////////////////////////

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate){
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (abs(ceil(scrollView.contentSize.height) - ceil(scrollView.contentOffset.y + CGRectGetHeight(scrollView.frame))) < 2 && self.statefulState == MJStatefulTableViewControllerStateIdle && [self canLoadMore]) {
        [self performSelectorInBackground:@selector(loadNextPage) withObject:nil];
    }
}

@end
