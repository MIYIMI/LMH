//
//  KTStatefulWaterflowViewController.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-3-31.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "FTBaseViewController.h"
#import "KTBaseRequest.h"
#import "KTProxy.h"

#import <SSPullToRefresh.h>
#import <PSCollectionView/PSCollectionView.h>

typedef enum {
    MJStatefulTableViewControllerStateIdle = 0,
	MJStatefulTableViewControllerStateInitialLoading = 1,
	MJStatefulTableViewControllerStateLoadingFromPullToRefresh = 2,
	MJStatefulTableViewControllerStateLoadingNextPage = 3,
	MJStatefulTableViewControllerStateEmpty = 4,
	MJStatefulTableViewControllerError = 5,
} MJStatefulTableViewControllerState;

@interface KTStatefulWaterflowViewController : FTBaseViewController<SSPullToRefreshViewDelegate,
                                                                    PSCollectionViewDataSource,
                                                                    PSCollectionViewDelegate,
                                                                    UIScrollViewDelegate>
{
    KTProxy * table_proxy;
}

@property (nonatomic, strong)   PSCollectionView    * waterflowView;
@property (nonatomic, strong)   SSPullToRefreshView * pullToRefreshView;
@property (nonatomic, strong)   NSMutableArray*     listData;

@property (nonatomic)           MJStatefulTableViewControllerState   statefulState;

@property (strong, nonatomic)   UIView      *       emptyView;
@property (strong, nonatomic)   UIView      *       loadingView;
@property (strong, nonatomic)   UIView      *       errorView;

@property (nonatomic)   int current;
@property (nonatomic)   int max;

- (void)loadNewer;

- (KTBaseRequest *)request;

- (BOOL)canLoadMore;

- (NSArray *)parseResponse:(NSString *)resp;

@end
