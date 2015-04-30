//
//  kata_CategoryViewController.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-3-30.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "kata_CategoryViewController.h"
#import "BrandListVO.h"
#import "kata_ProductListViewController.h"
#import "kata_ProductDetailViewController.h"
#import "kata_WebViewController.h"
#import "KTAdverDataGetRequest.h"
#import "AdvListVO.h"
#import "BOKUBannerImageButton.h"
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
#import "kata_DescribeViewController.h"
#import "HomeVO.h"
#import "Home_styleGoodsCell.h"
#import <QuartzCore/QuartzCore.h>
#import "kata_LoginViewController.h"
#import "LMHRefundApplyController.h"
#import "LMH_CategoryViewController.h"
#import "LMHHome_eightCircleCell.h"
#import "LMHWebRequest.h"

#import "kata_ProductListViewController.h"
#define PAGERSIZE           20
#define TABLE_COLOR         [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1]

@interface kata_CategoryViewController ()<AloneProductCellTableViewCellDelgate,HomeSeckillCellDelegate,Home_styleGoodsCellDelegate,LoginDelegate,kata_UpdateManagerDelegate,LMHHome_eightCircleCellDelegate>
{
    NSInteger _menuid;
    NSInteger _parentid;
    UIBarButtonItem *_menuItem;
    UIView *_headerView;
    DMQRCodeViewController *QRCodeViewController;
    NSArray *_advArr;
    kata_IndexAdvFocusViewController *_bannerFV;
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
    BOOL pageFlag;
    
    UIButton *emptyBtn;
}

@end

@implementation kata_CategoryViewController
- (id)initWithMenuID:(NSInteger)menuid
         andParentID:(NSInteger)parentid
            andTitle:(NSString *)title
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // Custom initialization
        self.ifShowTableSeparator = NO;
        self.ifShowScrollToTopBtn = YES;
        self.ifShowToTop = NO;
        self.ifShowBtnHigher = YES;
        self.hasTabHeight = YES;
        self.ifAddPullToRefreshControl = YES;
        self.ifScrollToTop = YES;
        
        _menuid = menuid;
        _parentid = parentid;
        self.title = title;
        changeFlag = NO;
        pageFlag = NO;
        timeLblArray = [[NSMutableArray alloc] init];
        actvityArray = [[NSMutableArray alloc] init];
        eventArray = [[NSMutableArray alloc] init];
        
        seckillNum = 0;
        activityNum = 0;
        eventNum = 0;
        eventGoodsNum = 0;
        hotNum = 0;
        newNum = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Do any additional setup after loading the view.
    [self createUI];
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"new_logo"]];
    [self.navigationItem setTitleView:logo];
    
    CGRect tableFrame =  self.tableView.frame;
    tableFrame.size.height -= 49;
    self.tableView.frame=tableFrame;
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    select = [userDefaultes integerForKey:@"myInteger"];
    if (select == 0) {
        select = 2;
    }
    [self cacheInformation];
    [self loadNewer];
    [self sheetRequest];
    
    [[LMH_GeXinAPNSTool sharedAPNSTool] skipVC];
}

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

- (void)cacheInformation
{
    //读取缓存数据
    if ([[kata_UserManager sharedUserManager] getHomeData]) {
        homeListVO = [HomeVO HomeVOWithDictionary:[[kata_UserManager sharedUserManager] getHomeData]];
        
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        select = [userDefaultes integerForKey:@"myInteger"];
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
            
            NSMutableArray *cellDataArr_new = [[NSMutableArray alloc] init];
            if (homeListVO.productlist.count > 0) {
                for (NSInteger i = 0; i < homeListVO.productlist.count; i++) {
                    if ([homeListVO.productlist objectAtIndex:i] && [[homeListVO.productlist objectAtIndex:i] isKindOfClass:[HomeProductVO class]]) {
                        [cellDataArr_new addObject:[NSArray arrayWithObject:[homeListVO.productlist objectAtIndex:i]]];
                    }
                }
            }
            listNewVO = cellDataArr_new;
            
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
            
            NSMutableArray *cellDataArr_new = [[NSMutableArray alloc] init];
            if (homeListVO.productlist.count > 0) {
                for (NSInteger i = 0; i < ceil((CGFloat)homeListVO.productlist.count / 2.0); i++) {
                    NSMutableArray *cellArr = [[NSMutableArray alloc] init];
                    if ([homeListVO.productlist objectAtIndex:i * 2] && [[homeListVO.productlist objectAtIndex:i * 2] isKindOfClass:[HomeProductVO class]]) {
                        [cellArr addObject:[homeListVO.productlist objectAtIndex:i * 2]];
                    }
                    
                    if (homeListVO.productlist.count > i * 2 + 1) {
                        if ([homeListVO.productlist objectAtIndex:i * 2 + 1] && [[homeListVO.productlist objectAtIndex:i * 2 + 1] isKindOfClass:[HomeProductVO class]]) {
                            [cellArr addObject:[homeListVO.productlist objectAtIndex:i * 2 + 1]];
                        }
                    }
                    [cellDataArr_new addObject:cellArr];
                }
                
                listNewVO = cellDataArr_new;
            }
        }
        
//        objArr = listNewVO;
        [self performSelectorOnMainThread:@selector(changeCellNum) withObject:nil waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(setTbHeaderView:) withObject:nil waitUntilDone:YES];
    }else{
        self.statefulState = FTStatefulTableViewControllerError;
    }
}

//扫一扫
-(void)scanCode
{
    QRCodeViewController = [[DMQRCodeViewController alloc] init];
    QRCodeViewController.hidesBottomBarWhenPushed = YES;
    QRCodeViewController.navigationController = self.navigationController;
    [self.navigationController pushViewController:QRCodeViewController animated:YES];
}

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
        self.is_Type = [[[NSUserDefaults standardUserDefaults] objectForKey:@"myInteger"] integerValue];
        [self changeCell];
    }
    
    [[(kata_AppDelegate *)[[UIApplication sharedApplication] delegate] deckController] setPanningMode:IIViewDeckFullViewPanning];
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
                    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
                    select = [userDefaultes integerForKey:@"myInteger"];
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
                        
                        NSMutableArray *cellDataArr_new = [[NSMutableArray alloc] init];
                        if (homeListVO.productlist.count > 0) {
                            for (NSInteger i = 0; i < homeListVO.productlist.count; i++) {
                                if ([homeListVO.productlist objectAtIndex:i] && [[homeListVO.productlist objectAtIndex:i] isKindOfClass:[HomeProductVO class]]) {
                                    [cellDataArr_new addObject:[NSArray arrayWithObject:[homeListVO.productlist objectAtIndex:i]]];
                                }
                            }
                        }
                        listNewVO = cellDataArr_new;
                        
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
                        
                        NSMutableArray *cellDataArr_new = [[NSMutableArray alloc] init];
                        if (homeListVO.productlist.count > 0) {
                            for (NSInteger i = 0; i < ceil((CGFloat)homeListVO.productlist.count / 2.0); i++) {
                                NSMutableArray *cellArr = [[NSMutableArray alloc] init];
                                if ([homeListVO.productlist objectAtIndex:i * 2] && [[homeListVO.productlist objectAtIndex:i * 2] isKindOfClass:[HomeProductVO class]]) {
                                    [cellArr addObject:[homeListVO.productlist objectAtIndex:i * 2]];
                                }
                                
                                if (homeListVO.productlist.count > i * 2 + 1) {
                                    if ([homeListVO.productlist objectAtIndex:i * 2 + 1] && [[homeListVO.productlist objectAtIndex:i * 2 + 1] isKindOfClass:[HomeProductVO class]]) {
                                        [cellArr addObject:[homeListVO.productlist objectAtIndex:i * 2 + 1]];
                                    }
                                }
                                [cellDataArr_new addObject:cellArr];
                            }
                            
                            listNewVO = cellDataArr_new;
                        }
                    }
                    
                    objArr = listNewVO;
                    if([respDict objectForKey:@"data"] && !pageFlag){
                        [[kata_UserManager sharedUserManager] updateHomeData:dataObj];
                        pageFlag = YES;
                    }
                    self.max = ceil([homeListVO.total_count floatValue] / (CGFloat)PAGERSIZE);
                    
                    [self changeCellNum];
                    [self performSelectorOnMainThread:@selector(setTbHeaderView:) withObject:nil waitUntilDone:YES];
                    
                    //清除缓存
                    [[SDImageCache sharedImageCache] clearDisk];
                    [[SDImageCache sharedImageCache] clearMemory];
                    [[SDImageCache sharedImageCache] cleanDisk];
                    [[EGOCache currentCache] clearCache];
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

//计算数据占用cell数
- (void)changeCellNum{
    seckillNum = homeListVO.seckill_list.count>0?2:1;
    activityNum = homeListVO.activity.count>0?homeListVO.activity.count/homeListVO.activity.count:1;
    eventNum = 0;
    [eventArray removeAllObjects];
    for (HomeBrandVO *brand in homeListVO.event_list) {
        [eventArray addObject:brand.Title];
        [eventArray addObjectsFromArray:brand.brandArray];
        eventNum += (brand.brandArray.count + 1);
    }
    eventNum = eventNum>0?eventNum:1;
    eventGoodsNum = homeListVO.event_goods.count?homeListVO.event_goods.count+1:1;
    hotNum = homeListVO.product_hot_list.count>0?homeListVO.product_hot_list.count+1:1;
    newNum = homeListVO.productlist.count>0?homeListVO.productlist.count+1:1;
}

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
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:[UIImage imageNamed:@"place_4"]];
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
    NSInteger secNum = 0;
    if (homeListVO) {
        secNum = 1;
    }
    if (homeListVO.category_list.count>0) {
        secNum += 1;
    }
    if (eventNum > 0) {
        secNum += 1;
    }
    if (eventGoodsNum > 0) {
        secNum += 1;
    }
    if (hotNum > 0) {
        secNum += 1;
    }
    if (self.listData.count > 0) {
        secNum += 1;
    }
    
    return secNum+1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (homeListVO) {
        switch (section) {
            case 0:
                return 1;
                break;
            case 1:
                return 1;
                break;
            case 2:
                return eventNum;
                break;
            case 3:
                return homeListVO.event_goods.count;
                break;
            case 4:
                if (select == 1) {
                    return hotNum;
                }
                return ceil((CGFloat)hotNum / 2);
                break;
            case 5:
                if (self.listData.count > 0) {
                    return self.listData.count+1;
                }
                return self.listData.count;
                break;
            case 6:
                return 1;
            default:
                break;
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
        if (eventArray.count>0) {
            return 0;
        }
        return 0;
    }else if(section == 3){
        if(eventGoodsNum > 1){
            return 10;
        }
        return 0;
    }else if(section == 4){
        if (hotNum > 1) {
            return 10;
        }
        return 0;
    }else if(section == 5){
        if (newNum > 1 && select == 2) {
            return 10;
        }else if(select == 1){
            return 5;
        }
        return 0;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0 ) {
        if (homeListVO.category_list.count == 0){
            return 0;
        }else if (homeListVO.category_list.count>0 && homeListVO.category_list.count<=4) {
            return ScreenW/4*155/180;
        }else{
            return ScreenW/4*155/180*2;
        }
        return 0;
    }else if (section == 1) {
        return ScreenW*305/640;
    }else if (section == 2){
        if (eventArray.count>0) {
            id rowData = eventArray[row];
            if ([rowData isKindOfClass:[NSString class]]) {
                return 40;
            }
            return ScreenW*290/720;
        }
        return 0;
    }else if(section == 3){
        if(eventGoodsNum > 1){
            return ScreenW*363/640+30;
        }
        return 0;
    }else if(section == 4){
        if (hotNum > 1) {
            if (row == 0) {
                return 30;
            }
            
            if (select == 1) {
                return 140;
            }
            return (ScreenW-30)/2+75;
        }
        return 0;
    }else if(section == 5){
        if (newNum > 1) {
            if (row == 0 && homeListVO.productlist_name.length > 0) {
                return 30;
            }else if(row == 0){
                return 0;
            }
            if (select == 1) {
                return 140;
            }
            return (ScreenW-30)/2+75;
        }
        return 0;
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
    static NSString *SECTION1_HEAD = @"SECTION1_HEAD";
    static NSString *SECTION1_TENT = @"SECTION1_TENT";
    static NSString *SECTION2_HEAD = @"SECTION2_HEAD";
    static NSString *SECTION2_TENT = @"SECTION2_TENT";
    static NSString *SECTION3_HEAD = @"SECTION3_HEAD";
    static NSString *SECTION4_HEAD = @"SECTION4_HEAD";
    static NSString *SECTION_MORE = @"SECTION4_MORE";
    NSString *SECTION3_TENT = [NSString stringWithFormat:@"SECTION3_TENT%zi",select];
    NSString *SECTION4_TENT = [NSString stringWithFormat:@"SECTION4_TENT%zi",select];
    
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
    }else if (section == 2){//活动
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
                
                UILabel *grayLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 10)];
                grayLbl.backgroundColor = LMH_COLOR_LIGHTLINE;
                [cell addSubview:grayLbl];
            }
            UIImageView *eventview = (UIImageView *)[cell viewWithTag:9999];
            if (!eventview) {
                eventview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 4, 12)];
                eventview.image = LOCAL_IMG(@"event");
                eventview.tag = 9999;
                [cell addSubview:eventview];
            }
            UILabel *eventlabel = (UILabel *)[cell viewWithTag:10000];
            if (!eventlabel) {
                eventlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 16, ScreenW-30, 20)];
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
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SECTION1_TENT];
                
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
            [brandView sd_setImageWithURL:[NSURL URLWithString:brandVO.Pic] placeholderImage:LOCAL_IMG(@"place_4")];
            
            [cell setBackgroundColor:[UIColor whiteColor]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }else if(section == 3){//活动单品
        if (homeListVO.event_goods.count <= 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SECTION2_HEAD];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SECTION2_HEAD];
            }
            return cell;
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SECTION2_TENT];
            if (!cell) {
                cell = [[Home_styleGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SECTION2_TENT];
            }
            
            [(Home_styleGoodsCell*)cell setDelegate:self];
            [(Home_styleGoodsCell*)cell layoutUI:homeListVO.event_goods[row]];
            
            [cell setBackgroundColor:GRAY_CELL_COLOR];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else if(section == 4){//最热商品
        if(listHotVO.count <= 0){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SECTION3_HEAD];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SECTION3_HEAD];
            }
            return cell;
        }
        if (row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SECTION3_HEAD];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SECTION3_HEAD];
                UILabel *secLbl = [[UILabel alloc] initWithFrame:CGRectMake((ScreenW-60)/2, 10, 60, 20)];
                [secLbl setBackgroundColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1]];
                [secLbl setText:@"爆款折扣"];
                [secLbl setTextAlignment:NSTextAlignmentCenter];
                [secLbl setTextColor:[UIColor colorWithRed:0.98 green:0.34 blue:0.44 alpha:1]];
                [secLbl setFont:FONT(15.0)];
                [cell addSubview:secLbl];
                
                UILabel *frontLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, (ScreenW-CGRectGetWidth(secLbl.frame)-40)/2, 1)];
                [frontLbl setBackgroundColor:[UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1]];
                [cell addSubview:frontLbl];
                
                UILabel *backLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(secLbl.frame)+10, 20, (ScreenW-CGRectGetWidth(secLbl.frame)-40)/2, 1)];
                [backLbl setBackgroundColor:[UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1]];
                [cell addSubview:backLbl];
            }
            [cell setBackgroundColor:[UIColor whiteColor]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SECTION3_TENT];
            if (!cell) {
                cell = [[AloneProductCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SECTION3_TENT];
            }
            [cell setBackgroundColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1]];
            [(AloneProductCellTableViewCell*)cell setCellFrame:self.view.frame];
            [(AloneProductCellTableViewCell*)cell setDelegate:self];
            [(AloneProductCellTableViewCell*)cell layoutUI:listHotVO[row-1] andColnum:select is_act:NO is_type:YES];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }else if (section == 5){//最新商品
        if(self.listData.count <= 0){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SECTION4_HEAD];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SECTION4_HEAD];
            }
            return cell;
        }
        if (row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SECTION4_HEAD];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SECTION4_HEAD];
            }
            UIImageView *eventview = (UIImageView *)[cell viewWithTag:9999];
            if (!eventview) {
                eventview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 4, 12)];
                eventview.image = LOCAL_IMG(@"event");
                eventview.tag = 9999;
                [cell addSubview:eventview];
            }
            UILabel *eventlabel = (UILabel *)[cell viewWithTag:10000];
            if (!eventlabel) {
                eventlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 11, ScreenW-30, 20)];
                eventlabel.backgroundColor = [UIColor clearColor];
                eventlabel.font = FONT(13);
                eventlabel.tag = 10000;
                eventlabel.textColor = [UIColor colorWithRed:0.24 green:0.24 blue:0.24 alpha:1];
                [cell addSubview:eventlabel];
            }
            eventlabel.text = homeListVO.productlist_name;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setBackgroundColor:[UIColor whiteColor]];
            
            return cell;
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SECTION4_TENT];
            if (!cell) {
                cell = [[AloneProductCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SECTION4_TENT];
            }
            [cell setBackgroundColor:[UIColor whiteColor]];
            [(AloneProductCellTableViewCell*)cell setCellFrame:self.view.frame];
            [(AloneProductCellTableViewCell*)cell setDelegate:self];
            [(AloneProductCellTableViewCell*)cell setRow:row-1];
            [(AloneProductCellTableViewCell*)cell layoutUI:self.listData[row - 1] andColnum:select is_act:NO is_type:YES];
            
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
//            activityIndicator.center = cell.center;
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
            }
//            cell.userInteractionEnabled = NO;
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
- (void)goToOtherBtnClick
{
    CategoryDetailVC *lmhVC = [[CategoryDetailVC alloc] initWithAdvData:nil andFlag:@"get_special_list"];
    lmhVC.hidesBottomBarWhenPushed = YES;
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
                CategoryDetailVC *productlistVC = [[CategoryDetailVC alloc] initWithAdvData:nextVO andFlag:@"category"];
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

@end
