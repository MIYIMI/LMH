//
//  kata_CategoryViewController.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-3-30.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "kata_CategoryViewController.h"
#import "kata_ProductListViewController.h"
#import "kata_ProductDetailViewController.h"
#import "kata_WebViewController.h"
#import "KTAdverDataGetRequest.h"
#import "AdvListVO.h"
#import "kata_MyViewController.h"
#import "kata_ShopCartViewController.h"
#import "kata_UserManager.h"
#import "KTHomeListRequst.h"
#import "HomeVO.h"
#import <QuartzCore/QuartzCore.h>
#import "CategoryDetailVC.h"
#import "kata_AppDelegate.h"
#import "LMHUIManager.h"
#import "Home_styleGoodsCell.h"
#import <UIImageView+WebCache.h>
#import "LMH_GeXinAPNSTool.h"

#import "AloneProductCellTableViewCell.h"
#import "kata_ActivityViewController.h"
#import "kata_UpdateManager.h"
#import "LimitedSeckillViewController.h"
#import "kata_WebViewController.h"
#import "kata_SignInViewController.h"
#import "DMQRCodeViewController.h"
#import "EGOCache.h"
#import "kata_RegisterViewController.h"
#import "LMHContectServiceViewController.h"
#import "HomeVO.h"
#import "Home_styleGoodsCell.h"
#import <QuartzCore/QuartzCore.h>
#import "kata_LoginViewController.h"
#import "LMHRefundApplyController.h"
#import "LMH_CategoryViewController.h"
#import "LMHHome_eightCircleCell.h"
#import "LMHWebRequest.h"
#import <UIButton+WebCache.h>

#import "kata_ProductListViewController.h"
#import "LMH_BullTableViewCell.h"

#import "LMH_EventViewController.h"
#import "LMH_ToolTableViewCell.h"

#define PAGERSIZE           20
#define TABLE_COLOR         [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1]

@interface kata_CategoryViewController ()<AloneProductCellTableViewCellDelgate,HomeSeckillCellDelegate,Home_styleGoodsCellDelegate,LoginDelegate,kata_UpdateManagerDelegate,LMHHome_eightCircleCellDelegate,LMH_BullTableViewCellDelegate,LMH_ToolTableViewCellDelegate>
{
    NSInteger _menuid;
    NSInteger _parentid;
    UIBarButtonItem *_menuItem;
    UIView *_headerView;
    DMQRCodeViewController *QRCodeViewController;
    NSArray *_advArr;
    XLCycleScrollView *cycleScrollView;
    UIView *_listEmptyView;
    UIView *halfview;
    
    NSMutableArray *timeLblArray;
    NSMutableArray *actvityArray;
    HomeVO *homeListVO;
    NSMutableArray *eventArray;
    
    //各种数据占用cell数
    NSInteger seckillNum;
    NSInteger activityNum;
    NSInteger eventNum;
    NSInteger eventGoodsNum;
    NSInteger hotNum;
    NSInteger newNum;
    
    //倒计时
    NSTimer *backTimer;
    NSTimeInterval startTime;
    NSTimeInterval curTime;
    
    NSArray *listHotVO;
    NSArray *listNewVO;
    AdvVO *sheetVO;
    AdvVO *_message;
    
    NSInteger select;
    BOOL changeFlag;
    CGFloat _htmlH;
    NSDictionary *changeDict;
    
    UIButton *emptyBtn;
}

@end

@implementation kata_CategoryViewController
/**
 *  初始化
 *
 *  @param menuid   本身ID
 *  @param parentid 父类ID
 *  @param title    标题
 *
 *  @return  self
 */
- (id)initWithMenuID:(NSInteger)menuid
         andParentID:(NSInteger)parentid
            andTitle:(NSString *)title
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // Custom initialization
        self.ifShowTableSeparator = NO;
        self.ifShowScrollToTopBtn = NO;
        self.ifShowToTop = YES;
        self.ifShowBtnHigher = YES;
        self.hasTabHeight = YES;
        self.ifAddPullToRefreshControl = YES;
        self.ifScrollToTop = YES;
        self.is_home = YES;
        
        _menuid = menuid;
        _parentid = parentid;
        self.title = title;
        changeFlag = NO;
        timeLblArray = [[NSMutableArray alloc] init];
        actvityArray = [[NSMutableArray alloc] init];
        eventArray = [[NSMutableArray alloc] init];
        
        seckillNum = 0;
        activityNum = 0;
        eventNum = 0;
        eventGoodsNum = 0;
        hotNum = 0;
        newNum = 0;
        _htmlH = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Do any additional setup after loading the view.
    [self createUI];
    
    //自定义首页标题 logo
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"new_logo"]];
    [self.navigationItem setTitleView:logo];
    
    CGRect tableFrame =  self.tableView.frame;
    tableFrame.size.height -= 49;    //tableBar 的默认高度为49
    self.tableView.frame=tableFrame;
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    select = [userDefaultes integerForKey:@"myInteger"];
    if (select == 0) {
        select = 2;
    }
    [self cacheInformation];
    [self loadNewer];
    [self sheetRequest];
    
    [[LMH_GeXinAPNSTool sharedAPNSTool] pushVC];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(favChange:) name:@"CHANGE" object:nil];
}

- (void)favChange:(NSNotification *)notif{
    changeDict = [notif userInfo];
    NSInteger favnum = [changeDict[@"fav_num"] integerValue];
    NSInteger eventid = [changeDict[@"eventid"] integerValue];
    NSInteger evenum = [changeDict[@"eve_num"] integerValue];;
    
    for (NSArray *arr in self.listData) {
        for (id vo in arr) {
            if ([vo isKindOfClass:[CampaignVO class]]) {
                CampaignVO *cvo = vo;
                if ([cvo.campaign_id integerValue] == eventid) {
                    if (favnum > 0) {
                        cvo.like_count = [NSNumber numberWithInteger:favnum];
                    }else if (evenum > 0){
                        cvo.comment_count = [NSNumber numberWithInteger:evenum];
                    }
                }
            }
        }
    }
    [self.tableView reloadData];
}

/**
 *  布局  UI
 */
- (void)createUI
{
    [self.tableView setBackgroundColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1]];
    [[kata_UpdateManager sharedUpdateManager] setUpdateDelegate:self];
    [[kata_UpdateManager sharedUpdateManager] updateApp];

    [self setupRightMenuButton];
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 20, 20)];
    [imageview setImage:[UIImage imageNamed:@"sao_icon"]];
    
    UITapGestureRecognizer *tapClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanCode)];
    tapClick.numberOfTapsRequired = 1;
    [imageview addGestureRecognizer:tapClick];
    
    UIBarButtonItem *homeLeftBtn = [[UIBarButtonItem alloc] initWithCustomView:imageview];
    [self.navigationController addLeftBarButtonItem:homeLeftBtn animation:NO];
}

/**
 *  读取缓存数据
 */
- (void)cacheInformation
{
    //读取缓存数据
    if ([[kata_UserManager sharedUserManager] getHomeData]) {
        homeListVO = [HomeVO HomeVOWithDictionary:[[kata_UserManager sharedUserManager] getHomeData]];
        
        NSMutableArray *muArray = [[NSMutableArray alloc] init];
        
        for (CampaignVO *camvo in homeListVO.campaign_list) {
            NSMutableArray *uArray = [[NSMutableArray alloc] init];
            [uArray addObject:camvo];
            for (NSInteger i = 0; i < ceil((CGFloat)camvo.campaign_goods_list.count / 2.0); i++) {
                NSMutableArray *cellArr = [[NSMutableArray alloc] init];
                if ([camvo.campaign_goods_list objectAtIndex:i * 2] && [[camvo.campaign_goods_list objectAtIndex:i * 2] isKindOfClass:[HomeProductVO class]]) {
                    [cellArr addObject:[camvo.campaign_goods_list objectAtIndex:i * 2]];
                }
                
                if (camvo.campaign_goods_list.count > i * 2 + 1) {
                    if ([camvo.campaign_goods_list objectAtIndex:i * 2 + 1] && [[camvo.campaign_goods_list objectAtIndex:i * 2 + 1] isKindOfClass:[HomeProductVO class]]) {
                        [cellArr addObject:[camvo.campaign_goods_list objectAtIndex:i * 2 + 1]];
                    }
                }
                
                [uArray addObject:cellArr];
            }
            
            [muArray addObject:uArray];
        }
        
        self.listData = muArray;
        
        [self performSelectorOnMainThread:@selector(changeCellNum) withObject:nil waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(setTbHeaderView:) withObject:nil waitUntilDone:YES];
    }else{
        self.statefulState = FTStatefulTableViewControllerError;
    }
}

/**
 *  扫一扫 功能
 */
-(void)scanCode
{
    QRCodeViewController = [[DMQRCodeViewController alloc] init];
    QRCodeViewController.hidesBottomBarWhenPushed = YES;
    QRCodeViewController.navigationController = self.navigationController;
    [self.navigationController pushViewController:QRCodeViewController animated:YES];
}
/**
 *  导航栏 右按钮
 */
-(void)setupRightMenuButton{
    if (!_menuItem) {
        UIButton * menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuBtn setFrame:CGRectMake(0, 0, 20, 27)];
        UIImage *image = [UIImage imageNamed:@"category"];
        [menuBtn setImage:image forState:UIControlStateNormal];
        [menuBtn addTarget:self action:@selector(menuBtnClick) forControlEvents:UIControlEventTouchUpInside];
        //[menuBtn addTarget:self.viewDeckController action:@selector(toggleRightView) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem * menuItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
        _menuItem = menuItem;
    }
    [self.navigationController addRightBarButtonItem:_menuItem animation:NO];
}
/**
 *  导航栏右按钮点击事件 -- 进入分类页面
 */
- (void)menuBtnClick{
    LMH_CategoryViewController *rightVC = [[LMH_CategoryViewController alloc] initWithNibName:nil bundle:nil];
    rightVC.navigationController = self.navigationController;
    rightVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:rightVC animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if(self.listData.count > 0){
        NSInteger type = [[[NSUserDefaults standardUserDefaults] objectForKey:@"myInteger"] integerValue];
        self.is_Type = type;
        if (type != select) {
            [self changeCell];
        }
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//app更新结果
-(void) updateAppResult:(UpdateState)State
{
    
}
/**
 *  首页网络数据请求
 *
 *  @return 请求包包体体对象
 */
- (KTBaseRequest *)request
{
    KTBaseRequest *req;

    NSString *userid ;
    NSString *usertoken ;
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isEqualToString:@""]) {
        userid = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"];
    }
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isEqualToString:@""]) {
        usertoken = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"];
    }
    req = [[KTHomeListRequst alloc] initWithUserID:[userid integerValue]
                                  andUserToken:usertoken
                                   andPageSize:PAGERSIZE
                                    andPageNum:self.current];
    self.is_home = YES;
    return req;
}
/**
 *  网络解析
 *
 *  @param resp 返回的数据
 *
 *  @return 列表需要的数据
 */
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
                    homeListVO = [HomeVO HomeVOWithDictionary:dataObj];
                    
                    HomeVO *homeVO = [HomeVO HomeVOWithDictionary:[[kata_UserManager sharedUserManager] getHomeData]];
                    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                    if ([[def objectForKey:@"home_secret"] isEqualToString:homeListVO.app_cache_secret]) {
                        homeListVO.banner = homeVO.banner;
                        homeListVO.category_list = homeVO.category_list;
                        homeListVO.activity = homeVO.activity;
                        homeListVO.seckill_list = homeVO.seckill_list;
                        homeListVO.wap_ad_list = homeVO.wap_ad_list;
                        homeListVO.event_list = homeVO.event_list;
                        homeListVO.event_goods = homeVO.event_goods;
                    }else{//缓存首页数据
                        [[kata_UserManager sharedUserManager] updateHomeData:dataObj];
                        [def setObject:homeListVO.app_cache_secret?homeListVO.app_cache_secret:@"1234567890" forKey:@"home_secret"];
                        [def synchronize];
                    }
                    
                    NSMutableArray *muArray = [[NSMutableArray alloc] init];
                    
                    for (CampaignVO *camvo in homeListVO.campaign_list) {
                        NSMutableArray *uArray = [[NSMutableArray alloc] init];
                        [uArray addObject:camvo];
                        for (NSInteger i = 0; i < ceil((CGFloat)camvo.campaign_goods_list.count / 2.0); i++) {
                            NSMutableArray *cellArr = [[NSMutableArray alloc] init];
                            if ([camvo.campaign_goods_list objectAtIndex:i * 2] && [[camvo.campaign_goods_list objectAtIndex:i * 2] isKindOfClass:[HomeProductVO class]]) {
                                [cellArr addObject:[camvo.campaign_goods_list objectAtIndex:i * 2]];
                            }
                            
                            if (camvo.campaign_goods_list.count > i * 2 + 1) {
                                if ([camvo.campaign_goods_list objectAtIndex:i * 2 + 1] && [[camvo.campaign_goods_list objectAtIndex:i * 2 + 1] isKindOfClass:[HomeProductVO class]]) {
                                    [cellArr addObject:[camvo.campaign_goods_list objectAtIndex:i * 2 + 1]];
                                }
                            }
                            
                            [uArray addObject:cellArr];
                        }
                        
                        [muArray addObject:uArray];
                    }
                    
                    objArr = muArray;
                    
                    self.max = ceil([homeListVO.total_count floatValue] / (CGFloat)PAGERSIZE);
                    
                    [self changeCellNum];
                    [self performSelectorOnMainThread:@selector(setTbHeaderView:) withObject:nil waitUntilDone:YES];
                    
                    //清除缓存
                    if(self.statefulState == FTStatefulTableViewControllerStateLoadingFromPullToRefresh){
                        [[SDImageCache sharedImageCache] clearDisk];
                        [[SDImageCache sharedImageCache] clearMemory];
                        [[SDImageCache sharedImageCache] cleanDisk];
                        [[EGOCache currentCache] clearCache];
                    }
                    
                    return objArr;
                }else{
                    //self.statefulState = FTStatefulTableViewControllerError;
                }
            }else{
                //self.statefulState = FTStatefulTableViewControllerError;
            }
        }else{
            //self.statefulState = FTStatefulTableViewControllerError;
        }
    } else {
        //self.statefulState = FTStatefulTableViewControllerError;
    }
    
    
    [self cacheInformation];
    objArr = listNewVO;
    
    return objArr;
}
/**
 *  计算数据占用cell数
 */
- (void)changeCellNum{
    //秒杀行数
    seckillNum = homeListVO.seckill_list.count>0?2:1;
    
    //秒杀右面 四块活动
    activityNum = homeListVO.activity.count>0?homeListVO.activity.count/homeListVO.activity.count:1;
    eventNum = 0;
    [eventArray removeAllObjects];
    for (HomeBrandVO *brand in homeListVO.event_list) {
        [eventArray addObject:brand.Title];
        [eventArray addObjectsFromArray:brand.brandArray];
        eventNum += (brand.brandArray.count + 1);
    }
    
    //横排展示  （点击进入wap活动页）
    eventNum = eventNum>0?eventNum:1;
    
    //左大右小/左小右大 模块展示
    eventGoodsNum = homeListVO.event_goods.count?homeListVO.event_goods.count+1:1;
    
    //最热商品
    hotNum = homeListVO.product_hot_list.count>0?homeListVO.product_hot_list.count+1:1;
    
    //最新商品
    newNum = homeListVO.productlist.count>0?homeListVO.productlist.count+1:1;
}
/**
 *  布局tableView 头部 （banner 条）
 */
- (void)setTbHeaderView:(NSString *)title
{
    if (_headerView ) {
        [_headerView removeFromSuperview];
        _headerView = nil;
    }
    
    if (!_headerView && homeListVO.banner.count>0) {
        _headerView = [[UIView alloc] initWithFrame:CGRectZero];
    }else{
        [self.tableView setTableHeaderView:_headerView];
        return;
    }
    
    [self performSelectorOnMainThread:@selector(layoutAdverView) withObject:nil waitUntilDone:YES];
}
/**
 *  调用布局 banner 条
 */
- (void)layoutAdverView
{
    if (cycleScrollView) {
        [cycleScrollView removeFromSuperview];
        [cycleScrollView.animationTimer invalidate];
        cycleScrollView.animationTimer = nil;
        cycleScrollView = nil;
    }
    
    if (!cycleScrollView) {
            cycleScrollView = [[XLCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenW*290/720) animationDuration:8];
    }
    [_headerView setFrame:cycleScrollView.frame];
    cycleScrollView.xldelegate = self;
    cycleScrollView.xldatasource = self;

    [_headerView addSubview:cycleScrollView];
    [self.tableView setTableHeaderView:_headerView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)numberOfPages
{
    NSInteger bannerCount = homeListVO.banner.count;
    return bannerCount;
}

- (UIView *)pageAtIndex:(NSInteger)index
{
    CGRect rect = _headerView.bounds;
    if (index < homeListVO.banner.count) {
        AdvVO *adv = homeListVO.banner[index];
        NSString *imageName = adv.Pic;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(rect), ScreenW*290/720)];
        imageView.backgroundColor = [UIColor whiteColor];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:nil];
        return imageView;
    }
    return nil;
}

- (void)didClickPage:(XLCycleScrollView *)csView atIndex:(NSInteger)index
{
    if(index < homeListVO.banner.count){
        AdvVO *adv = homeListVO.banner[index];
        [self nextView:adv];
    }
}

- (void)sheetRequest
{
    KTBaseRequest *req = [[KTBaseRequest alloc] init];
    
    NSMutableDictionary *paramsDict = [req params];
    
    [paramsDict setObject:@"get_jump_info" forKey:@"method"];
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(sheetParseResponse:) withObject:resp waitUntilDone:YES];
    } failed:^(NSError *error) {
        //[self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (void)sheetParseResponse:(NSString *)resp
{
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            if ([respDict objectForKey:@"data"] != nil && ![[respDict objectForKey:@"data"] isEqual:[NSNull null]]) {
                id dataObj = [respDict objectForKey:@"data"];
                
                if ([dataObj isKindOfClass:[NSDictionary class]]) {
                    if ([[dataObj objectForKey:@"brand"] isKindOfClass:[NSArray class]]) {
                        if ([[dataObj objectForKey:@"brand"] count] > 0) {
                            sheetVO = [AdvVO AdvVOWithDictionary:[[dataObj objectForKey:@"brand"] objectAtIndex:0]];
                            [self performSelector:@selector(viewSheet) withObject:nil afterDelay:0.0];
                        }
                    }
                    return;
                }
                return;
            }
        }
    }
}

//活动弹出窗
-(void)viewSheet{
    if (!halfview) {
        halfview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
        [self.view addSubview:halfview];
        halfview.hidden = YES;
    }
    CGFloat h = CGRectGetHeight(self.view.frame);
    
    UIView *sheetView = [[UIView alloc] initWithFrame:CGRectMake(ScreenW/8, (h-ScreenW/4*3/1.6)/2, ScreenW/4*3, ScreenW/4*3/1.6)];
    sheetView.layer.masksToBounds = YES;
    sheetView.layer.cornerRadius = 10.0;
    UITapGestureRecognizer *sheetTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sheetPushView)];
    [sheetView addGestureRecognizer:sheetTap];
    [halfview addSubview:sheetView];
    
    UIImageView *sheetImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(sheetView.frame), CGRectGetHeight(sheetView.frame))];
    sheetView.layer.masksToBounds = YES;
    sheetImg.layer.cornerRadius = 10.0;
    [sheetView addSubview:sheetImg];
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(sheetView.frame)-10, CGRectGetMinY(sheetView.frame)-10, 20, 20)];
    [cancelBtn setBackgroundImage:LOCAL_IMG(@"icon_close") forState:UIControlStateNormal];
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.layer.cornerRadius = 10.0;
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setBackgroundColor:[UIColor colorWithRed:0.98 green:0.33 blue:0.43 alpha:1]];
    [halfview addSubview:cancelBtn];
    
    [sheetImg sd_setImageWithURL:[NSURL URLWithString:sheetVO.Pic] placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (![[kata_UserManager sharedUserManager] isLogin] && image) {
            halfview.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
            halfview.hidden = NO;
        }
    }];
}

- (void)cancelClick{
    [halfview setHidden:YES];
}

-(void)sheetPushView{
    if(![[kata_UserManager sharedUserManager] isLogin]){
        [self nextView:sheetVO];
    }
    [halfview setHidden:YES];
}

- (void)changeCell{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    select = [userDefaultes integerForKey:@"myInteger"];
    NSMutableArray *array =[[NSMutableArray alloc] init];
    if (select == 1) {
        NSMutableArray *cellDataArr_hot = [[NSMutableArray alloc] init];
        if (homeListVO.product_hot_list.count > 0) {
            for (NSInteger i = 0; i < homeListVO.product_hot_list.count; i++) {
                if ([homeListVO.product_hot_list objectAtIndex:i] && [[homeListVO.product_hot_list objectAtIndex:i] isKindOfClass:[HomeProductVO class]]) {
                    [cellDataArr_hot addObject:[NSArray arrayWithObject:[homeListVO.product_hot_list objectAtIndex:i]]];
                }
            }
        }
        listHotVO = cellDataArr_hot;
        
        for (NSArray *oneArray in self.listData) {
            for (HomeProductVO *vo in oneArray) {
                [array addObject:[NSArray arrayWithObject:vo]];
            }
        }
    } else {
        NSMutableArray *cellDataArr_hot = [[NSMutableArray alloc] init];
        if (homeListVO.product_hot_list.count > 0) {
            for (NSInteger i = 0; i < ceil((CGFloat)homeListVO.product_hot_list.count / 2.0); i++) {
                NSMutableArray *cellArr = [[NSMutableArray alloc] init];
                if ([homeListVO.product_hot_list objectAtIndex:i * 2] && [[homeListVO.product_hot_list objectAtIndex:i * 2] isKindOfClass:[HomeProductVO class]]) {
                    [cellArr addObject:[homeListVO.product_hot_list objectAtIndex:i * 2]];
                }
                
                if (homeListVO.product_hot_list.count > i * 2 + 1) {
                    if ([homeListVO.product_hot_list objectAtIndex:i * 2 + 1] && [[homeListVO.product_hot_list objectAtIndex:i * 2 + 1] isKindOfClass:[HomeProductVO class]]) {
                        [cellArr addObject:[homeListVO.product_hot_list objectAtIndex:i * 2 + 1]];
                    }
                }
                [cellDataArr_hot addObject:cellArr];
            }
            listHotVO = cellDataArr_hot;
        }
        
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (homeListVO) {
        return self.listData.count + 5;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {//分类
        if (homeListVO.category_list.count>0) {
            return 1;
        }
    }else if (section == 1){//秒杀
        if (homeListVO.activity.count>0) {
            return 1;
        }
    }else if (section == 2){//滚动视图
        if (homeListVO.wap_ad_list.count>0) {
            return 1;
        }
    }else if(section == 3){
        if (homeListVO.event_list.count>0) {
            return eventNum;
        }
    }else if (section < self.listData.count + 4){
        NSArray *array = self.listData[section - 4];
        return array.count+1;
    }else{
        if (self.listData.count > 0) {
            return 1;
        }
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    } else if (section == 1) {
        if (homeListVO.category_list.count>0) {
            return 10;
        }
        return 0;
    }else if (section == 2){
        if (homeListVO.wap_ad_list.count>0) {
            return 10;
        }
        return 0;
    }else if (section == 3){
        if (eventNum>1) {
            return 10;
        }
        return 0;
    }else if(section < self.listData.count+4){
        return 10;
    }else{
        return 10;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 10)];
    sectionView.backgroundColor = [UIColor clearColor];
    
    return sectionView;
}

- (void)htmlHeightReload:(CGFloat)htmlH{
    _htmlH = htmlH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0 ) {
        if (homeListVO.category_list.count == 0){
            return 0;
        }else if (homeListVO.category_list.count>0 && homeListVO.category_list.count<=5) {
            return ScreenW/5*155/180;
        }else{
            return ScreenW/5*155/180*2;
        }
        return 0;
    }else if (section == 1) {
        return ScreenW*305/640;
    }else if (section == 2) {  //滚动图标
        if (homeListVO.wap_ad_list.count == 0) {
            return 0;
        }
        return RATIO(214)+RATIO(40);
    }else if (section == 3){
        if (eventNum>1) {
            id rowData = eventArray[row];
            if ([rowData isKindOfClass:[NSString class]]) {
                return 30;
            }
            
            return ScreenW*290/720;
        }
        return 0;
    }else if(section < self.listData.count+4){
        NSArray *array = self.listData[section - 4];
        if (row == 0) {
            if ([array[0] isKindOfClass:[CampaignVO class]]) {
                CampaignVO *camvo = array[0];
                
                NSString *html = camvo.topic_ios;
                NSString *content = [LMH_HtmlParase filterHTML:html];
                if (content.length <= 0) {
                    return ScreenW/8+22;
                }
                CGSize csize = [content sizeWithFont:LMH_FONT_15 constrainedToSize:CGSizeMake(ScreenW - 20, 10000)];
                CGSize usize = [content sizeWithFont:LMH_FONT_15];
                NSInteger h = csize.height+ ((csize.height/usize.height)+1)*(usize.height/4);
                
                return h+ScreenW/8+22;
            }
            
            return ScreenW/8+22;
        }else if (row < array.count){
            return (ScreenW-30)/2+55;
        }
        return 40;
    }else{
        return 30;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    static NSString *SECTION0_HEAD = @"SECTION0_HEAD";
    static NSString *SECTION0_TENT = @"SECTION0_TENT";
    static NSString *SECTION1_SCROLL = @"SECTION1_SCROLL";
    static NSString *SECTION1_HEAD = @"SECTION1_HEAD";
    static NSString *SECTION1_TENT = @"SECTION1_TENT";
    static NSString *SECTION4_HEAD = @"SECTION4_HEAD";
    static NSString *SECTION4_TENT = @"SECTION4_TENT";
    static NSString *SECTION4_END = @"SECTION4_END";
    static NSString *SECTION_MORE = @"SECTION4_MORE";
    
    if (section == 0) {//分类图标
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SECTION0_HEAD];
        if (!cell) {
            cell = [[LMHHome_eightCircleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SECTION0_HEAD];
        }
        
        [(LMHHome_eightCircleCell*)cell layoutUI:homeListVO];
        [(LMHHome_eightCircleCell*)cell setDelegate:self];
        
        [cell setBackgroundColor:[UIColor whiteColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (section == 1) {//秒杀及其他功能
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SECTION0_TENT];
        if (!cell) {
            cell = [[HomeSeckillCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SECTION0_TENT];
        }
        [(HomeSeckillCell*)cell setDelegate:self];
        [(HomeSeckillCell*)cell layoutUI:homeListVO];
        
        [cell setBackgroundColor:[UIColor whiteColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (section == 2) {//滚动图标
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SECTION1_SCROLL];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SECTION1_SCROLL];
        }
        
        UIScrollView *scrollView = (UIScrollView *)[cell viewWithTag:1001];
        if (!scrollView) {
            scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, RATIO(214)+RATIO(40))];
            scrollView.contentSize = CGSizeMake(RATIO(20)+(RATIO(176)+RATIO(20))*(homeListVO.wap_ad_list.count), RATIO(214)+RATIO(20));
            scrollView.backgroundColor = [UIColor whiteColor];
            scrollView.delegate = self;
            scrollView.showsHorizontalScrollIndicator = NO;
            scrollView.showsVerticalScrollIndicator = NO;
            scrollView.tag = 1001;
            
            [cell addSubview:scrollView];
        }
        
        for (UIView *uview in scrollView.subviews) {
            if (uview.tag > 20000) {
                [uview removeFromSuperview];
            }
        }
        
        for (int i = 0; i<homeListVO.wap_ad_list.count; i++) {
            AdvVO *adv = homeListVO.wap_ad_list[i];
            
            UIButton *pictureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            pictureBtn.frame = CGRectMake(RATIO(20)+i*(RATIO(176)+RATIO(20)), RATIO(20), RATIO(176), RATIO(214));
            [pictureBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:adv.Pic] forState:UIControlStateNormal placeholderImage:nil];
            [pictureBtn addTarget:self action:@selector(pictureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            pictureBtn.tag = 20000+i;
            
            [scrollView addSubview:pictureBtn];
        }
        
        [cell setBackgroundColor:[UIColor whiteColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (section == 3){//活动
        if (eventArray.count <= 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SECTION1_HEAD];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SECTION1_HEAD];
            }
            return cell;
        }
        id rowData = eventArray[row];
        if ([rowData isKindOfClass:[NSString class]]) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SECTION1_HEAD];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SECTION1_HEAD];
            }
            UIImageView *eventview = (UIImageView *)[cell viewWithTag:9999];
            if (!eventview) {
                eventview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 9, 4, 12)];
                eventview.image = LOCAL_IMG(@"event");
                eventview.tag = 9999;
                [cell addSubview:eventview];
            }
            UILabel *eventlabel = (UILabel *)[cell viewWithTag:10000];
            if (!eventlabel) {
                eventlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, ScreenW-30, 20)];
                eventlabel.backgroundColor = [UIColor clearColor];
                eventlabel.font = FONT(13);
                eventlabel.tag = 10000;
                eventlabel.textColor = [UIColor colorWithRed:0.24 green:0.24 blue:0.24 alpha:1];
                [cell addSubview:eventlabel];
            }
            eventlabel.text = rowData;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setBackgroundColor:[UIColor whiteColor]];
            
            return cell;
        }else{
            AdvVO *brandVO = rowData;
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SECTION1_TENT];
            if (!cell) {
                cell = [[LMH_BullTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SECTION1_TENT];

                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, ScreenW-20, ScreenW*290/720-10)];
                imgView.tag = 10009;
                [cell addSubview:imgView];
            }
            UIImageView *brandView = (UIImageView*)[cell viewWithTag:10009];
            if (!brandView) {
                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, ScreenW-20, ScreenW*290/720-10)];
                [imgView.layer setBorderColor:[[UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1] CGColor]];
                [imgView.layer setBorderWidth:1.0];
                imgView.tag = 10009;
                [cell addSubview:imgView];
            }
            [brandView sd_setImageWithURL:[NSURL URLWithString:brandVO.Pic] placeholderImage:nil];
            [UIView beginAnimations:@"ToggleViews" context:nil];
            [UIView setAnimationDuration:1.5];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            // Make the animatable changes.
            brandView.alpha = 0.0;
            brandView.alpha = 1.0;
            [UIView commitAnimations];
            
            [cell setBackgroundColor:[UIColor whiteColor]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }else if (section < self.listData.count + 4){
        NSArray *array = self.listData[section - 4];
        if (row < array.count) {
            if ([array[row] isKindOfClass:[CampaignVO class]]) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SECTION4_HEAD];
                if (!cell) {
                    cell = [[LMH_BullTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SECTION4_HEAD];
                }
                [(LMH_BullTableViewCell *)cell layOutUI:YES andVO:array[row]];
                [(LMH_BullTableViewCell *)cell setBullDelegate:self];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;
            }else{
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SECTION4_TENT];
                if (!cell) {
                    cell = [[AloneProductCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SECTION4_TENT];
                }
                
                [(AloneProductCellTableViewCell *)cell setIs_newEvent:YES];
                [(AloneProductCellTableViewCell *)cell layoutUI:array[row] andColnum:2 is_act:NO is_type:YES];
                [(AloneProductCellTableViewCell *)cell setDelegate:self];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;
            }
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SECTION4_END];
            if (!cell) {
                cell = [[LMH_ToolTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SECTION4_END];
            }
            
            [(LMH_ToolTableViewCell *)cell layoutUI:array[0] and_home:YES];
            [(LMH_ToolTableViewCell *)cell setToolDelegate:self];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SECTION_MORE];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SECTION_MORE];
            [cell.contentView setBackgroundColor:[UIColor clearColor]];
            [cell setBackgroundColor:[UIColor clearColor]];
            
            UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            activityIndicator.frame = CGRectMake(ScreenW / 2 - 10, 5, 20, 20);
            activityIndicator.tag = 999;
            
            UILabel *emptyLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenW/2 +20, 30)];
            emptyLbl.textAlignment = NSTextAlignmentRight;
            emptyLbl.font = [UIFont systemFontOfSize:12.0];
            emptyLbl.tag = 1000;
            emptyLbl.textColor = RGB(153, 153, 153);
            emptyLbl.text = @"还有更多好货等您来选";
            emptyLbl.hidden = YES;
            [cell addSubview:emptyLbl];
            
            emptyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            emptyBtn.frame = CGRectMake(ScreenW/2+30, 5, 60, 20);
            [emptyBtn setBackgroundImage:[UIImage imageNamed:@"btn_goToOther"] forState:UIControlStateNormal];
            [emptyBtn addTarget:self action:@selector(goToOtherBtnClick) forControlEvents:UIControlEventTouchUpInside];
            emptyBtn.hidden = YES;
            [cell addSubview:emptyBtn];
            
            [cell addSubview:activityIndicator];
            
            if (self.max > self.current) {
                [activityIndicator startAnimating];
            }else if(self.listData.count >= 3){
                [emptyLbl setHidden:NO];
                [emptyBtn setHidden:NO];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else{
            UILabel *lbl = (UILabel *)[cell viewWithTag:1000];
            UIActivityIndicatorView * activityIndicator = (UIActivityIndicatorView * )[cell viewWithTag:999];
            if (self.max > self.current) {
                [activityIndicator startAnimating];
                [lbl setHidden:YES];
                [emptyBtn setHidden:YES];
            }else{
                [activityIndicator setHidden:YES];
                [lbl setHidden:NO];
                [emptyBtn setHidden:NO];
            }
        }
        return cell;
    }
    return nil;
}
/**
 *  滚动图标  点击事件
 */
- (void)pictureBtnClick:(UIButton *)sender{
    
    NSInteger tag = sender.tag - 20000;
    
    if (homeListVO.wap_ad_list.count > tag) {
        [self nextView:homeListVO.wap_ad_list[tag]];
    }
}
// 去 “汇特卖”
- (void)goToOtherBtnClick
{
    CategoryDetailVC *lmhVC = [[CategoryDetailVC alloc] initWithAdvData:nil andFlag:@"get_special_list"];
    lmhVC.hidesBottomBarWhenPushed = YES;
    lmhVC.navigationController = self.navigationController;
    [self.navigationController pushViewController:lmhVC animated:YES];
}

//限量秒杀 红包裂变那块 5个按钮 代理回调
- (void)tapClick:(AdvVO *)vo
{
    [self nextView:vo];
}

//风格 三个不同 imageView 点击事件
- (void)ViewTapClick:(AdvVO *)vo
{
    if ([vo isKindOfClass:[AdvVO class]]) {
        [self nextView:vo];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section == 2){//event_list点击后操作
        id vo = eventArray[row];
        if ([vo isKindOfClass:[AdvVO class]]) {
            AdvVO *brandVO = vo;
            [self nextView:brandVO];
        }
    }else if (section >= 4 && section < self.listData.count + 4){
        NSArray *array = self.listData[section - 4];
        CampaignVO *camvo = array[0];
        LMH_EventViewController *productlistVC = [[LMH_EventViewController alloc] initWithDataVO:nil];
        productlistVC.vcTitle = camvo.title;
        productlistVC.eventID = [camvo.campaign_id integerValue];
        productlistVC.navigationController = self.navigationController;
        productlistVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:productlistVC animated:YES];
    }
}

//倒计时
-(void)compareCurrentTime
{
    NSTimeInterval difftime = [homeListVO.sell_time longLongValue] - 1;
    homeListVO.sell_time = [NSNumber numberWithLongLong:difftime];
    if (difftime < 0) {
        [backTimer invalidate];
        return;
    }
    
    NSInteger hours = (long)difftime/3600;
    NSInteger minus = (long)difftime%3600/60;
    NSInteger sec = (long)difftime%60;
    
    NSInteger temptime = 0;
    for (NSInteger i = 0; i < timeLblArray.count; i++) {
        if (i == 0) {
            temptime = hours;
        }else if (i==1){
            temptime = minus;
        }else{
            temptime = sec;
        }
        
        [timeLblArray[i] setText:[NSString stringWithFormat:@"%zi", temptime]];
    }
}

-(void)nextView:(AdvVO *)nextVO
{
    NSString *userid;
    NSString *usertoken ;
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isEqualToString:@""]) {
        userid = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"];
    }
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isEqualToString:@""]) {
        usertoken = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"];
    }
    
    NSString *webStr = [NSString stringWithFormat:@"?user=%@&token=%@", userid,usertoken];
    
    if (nextVO.aname.length > 0) {
        KTBaseRequest *req = [[LMHWebRequest alloc] initWithUserID:[userid integerValue] andUserToken:usertoken andUrl:nil andAname:nextVO.aname];
        
        KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
            
        } failed:^(NSError *error) {
            
        }];
        
        [proxy start];
    }
    
    if (nextVO.Type) {
        NSInteger type = [nextVO.Type integerValue];
        switch (type) {
            case 1://商品详情页
            {
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
                CategoryDetailVC *productlistVC = [[CategoryDetailVC alloc] initWithAdvData:nextVO andFlag:nextVO.flag];
                productlistVC.pid = nextVO.Pid;
                productlistVC.cateid = [NSNumber numberWithInteger:[nextVO.Key integerValue]];
                productlistVC.navigationItem.title = nextVO.Title;
                productlistVC.navigationController = self.navigationController;
                productlistVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:productlistVC animated:YES];
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
                    CategoryDetailVC *productlistVC = [[CategoryDetailVC alloc] initWithAdvData:nextVO andFlag:@"get_nine_list"];
                    productlistVC.pid = @0;
                    productlistVC.cateid = [NSNumber numberWithInteger:[nextVO.Key integerValue]];
                    productlistVC.navigationController = self.navigationController;
                    productlistVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:productlistVC animated:YES];
                }
            }
                break;
            case 11:
            {
                // 汇特卖
                if (nextVO.Key && [nextVO.Key integerValue] != -1) {
                    CategoryDetailVC *productlistVC = [[CategoryDetailVC alloc] initWithAdvData:nextVO andFlag:@"get_special_list"];
                    productlistVC.pid = @0;
                    productlistVC.cateid = [NSNumber numberWithInteger:[nextVO.Key integerValue]];
                    productlistVC.navigationController = self.navigationController;
                    productlistVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:productlistVC animated:YES];
                }
            }
                break;
            case 12:
            {
                // 属性分类页
                CategoryDetailVC *productlistVC = [[CategoryDetailVC alloc] initWithAdvData:nextVO andFlag:@"attr"];
                productlistVC.pid = nextVO.Pid;
                productlistVC.cateid = [NSNumber numberWithInteger:[nextVO.Key integerValue]];
                productlistVC.navigationItem.title = nextVO.Title;
                productlistVC.navigationController = self.navigationController;
                productlistVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:productlistVC animated:YES];
            }
                break;
            case 13:
            {
                // 专场页
                LMH_EventViewController *productlistVC = [[LMH_EventViewController alloc] initWithDataVO:nextVO];
                productlistVC.title = nextVO.Title;
                productlistVC.navigationController = self.navigationController;
                productlistVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:productlistVC animated:YES];
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
            case 101://掌上秒杀
            {
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

#pragma mark - AloneProductCellTableViewCell Delegate
- (void)tapAtItem:(HomeProductVO *)vo
{
    if ([vo.is_activity integerValue] == 2) {
        AdvVO *adv = [[AdvVO alloc] init];
        adv.Type = vo.activity_type;
        adv.Key = vo.activity_key;
        adv.platform = vo.source_platform;
        adv.Title = vo.product_name;
        [self nextView:adv];
    }else{
        if(![vo.source_platform isEqualToString:@"lamahui"]){
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
            [lbl setText:@"暂无商品信息"];
            [view addSubview:lbl];
            
            view.center = v.center;
            [v addSubview:view];
        }
        _listEmptyView = v;
    }
    return _listEmptyView;
}

-(void)didLogin{
    
}

- (void)loginCancel{

}

- (void)pushProduct:(NSInteger)productID{
    // 商品详情
    kata_ProductDetailViewController *vc = [[kata_ProductDetailViewController alloc] initWithProductID:productID andType:nil andSeckillID:-1];
    vc.navigationController = self.navigationController;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushUser:(NSString *)user_url{
    kata_WebViewController *webVC = [[kata_WebViewController alloc] initWithUrl:user_url title:nil andType:@"lamahui"];
    webVC.navigationController = self.navigationController;
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)pushWX{
    [self textStateHUD:@"微信号已复制到剪切板,请前往微信添加"];
}

- (void)toolClick:(NSInteger)index andVO:(CampaignVO *)camvo{
    LMH_EventViewController *productlistVC = [[LMH_EventViewController alloc] initWithDataVO:nil];
    productlistVC.navigationItem.title = camvo.title;
    productlistVC.eventID = [camvo.campaign_id integerValue];
    productlistVC.navigationController = self.navigationController;
    productlistVC.hidesBottomBarWhenPushed = YES;
    productlistVC.scrollType = index;
    [self.navigationController pushViewController:productlistVC animated:YES];
}

@end
