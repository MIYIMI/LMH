//
//  FTStatefulTableViewController.h
//  FantooApp
//
//  Created by hark2046 on 13-7-9.
//  Copyright (c) 2013年 Fantoo. All rights reserved.
//

#import "FTBaseViewController.h"
#import "KTBaseRequest.h"
#import "KTProxy.h"
#import <SSPullToRefresh.h>
#import "Loading.h"

typedef enum {
    FTStatefulTableViewControllerStateIdle = 0,
	FTStatefulTableViewControllerStateInitialLoading = 1,
	FTStatefulTableViewControllerStateLoadingFromPullToRefresh = 2,
	FTStatefulTableViewControllerStateLoadingNextPage = 3,
	FTStatefulTableViewControllerStateEmpty = 4,
	FTStatefulTableViewControllerError = 5,
} FTStatefulTableViewControllerState;

@interface FTStatefulTableViewController : FTBaseViewController <UITableViewDataSource, UITableViewDelegate, SSPullToRefreshViewDelegate>
{
    KTProxy * table_proxy;
}

@property (nonatomic, strong)   UITableView             *       tableView;
@property (nonatomic, strong)   SSPullToRefreshView     *       pullToRefreshView;
@property (nonatomic, strong)   NSMutableArray          *       listData;
@property (strong, nonatomic)   NSIndexPath             *       selectedIndexPath;
@property (strong, nonatomic)   UIView      *       idleView;
@property (strong, nonatomic)   UIView      *       emptyView;
@property (strong, nonatomic)   UIView      *       loadingView;


//@property (nonatomic, strong)   Loading     *       loading;
@property (strong, nonatomic)   UIView      *       errorView;

@property (nonatomic)           FTStatefulTableViewControllerState   statefulState;
@property (nonatomic)           BOOL ifrespErr;

@property (assign, nonatomic)   BOOL    ifAddPullToRefreshControl;
@property (assign, nonatomic)   BOOL    ifShowTableSeparator;
@property (assign, nonatomic)   BOOL    isCountingRows;
@property (assign, nonatomic)   BOOL    ifScrollToTop;
@property (assign, nonatomic)   BOOL    ifShowUserCenterBtn;
@property (assign, nonatomic)   BOOL    ifShowScrollToTopBtn;
@property (assign, nonatomic)   BOOL    ifShowBtnHigher;
@property (assign, nonatomic)   BOOL    ifRemoveLoadNoState;
@property (assign, nonatomic)   BOOL    ifShowToTop;
@property (nonatomic)           NSInteger     current;
@property (nonatomic)           NSInteger     max;
@property (nonatomic)           BOOL    is_home;
@property (nonatomic)           NSInteger  is_Type;
@property (nonatomic)           BOOL    isLamahui;

- (id) initWithStyle:(UITableViewStyle)style;

- (void)loadNewer;
- (void)loadNoState;
- (void)changeView;

- (void)loadFromPullToRefresh;

- (void)loadNextPage;

- (void)changeCell;

- (KTBaseRequest *)request;

- (BOOL)canLoadMore;

- (NSArray *)parseResponse:(NSString *)resp;

@end
