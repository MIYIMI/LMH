//
//  kata_HomeViewController.m
//  YingMeiHui
//
//  Created by work on 14-9-17.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTAdverDataGetRequest.h"
#import "KTHomeListRequst.h"
#import "AdvListVO.h"
#import "ProductListVO.h"
#import "kata_ProductDetailViewController.h"
#import "kata_ProductListViewController.h"
#import "kata_WebViewController.h"
#import "BOKUBannerImageButton.h"
#import "kata_FavListViewController.h"
#import "kata_UserManager.h"
#import "kata_CartManager.h"
#import "kata_CouponViewController.h"
#import "LimitedSeckillViewController.h"
#import "LimitedSeckillVO.h"
#import "LMHLimitedSeckillRequest.h"
#import "LimitedSeckillCell.h"
#import "kata_ProductDetailViewController.h"
#import "kata_DescribeViewController.h"
#import "LMHClickRemindRequest.h"
#import "KTProxy.h"

#define PAGERSIZE           20
#define TABLE_COLOR         [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1]
#define ADVFOCUSHEIGHT      140
#define MENUHEIGHT          50

@interface LimitedSeckillViewController ()
{
    kata_IndexAdvFocusViewController *_bannerFV;
    UIView *_bannerView;
    UIImageView *_menuView;
    UIView *_headerView;
    
    //功能条
    UIScrollView *_scrollView;
    UIButton *_oneButton;
    UIButton *_twoButton;
    UIButton *_threeButton;
    UIButton *_fourButton;
    UIButton *_fiveButton;
    NSMutableArray *btnArray;
    NSString *indexNum;
    
    UILabel *oneLabel;
    UILabel *twoLabel;
    UILabel *threeLabel;
    UILabel *fourLabel;
    UILabel *fiveLabel;
    NSMutableArray *lblArray;
    
    UIView *underLineView;
    
    UILabel *nullCountLabel;
    UIView *timeView;
    UIView *_errorView;
    
    
    BOOL _isAdvLoaded;
    BOOL _isDataLoad;
    NSArray *_advArr;
    NSMutableArray *_productDictArr;
    
    LimitedSeckillVO *_modell;
    
    //倒计时
    NSTimer *backTimer;
    NSNumber *_outTimeNO;
    NSMutableArray *_timeMutableArr;
    NSNumber *_beginningOrEndingTime;
    UILabel *endTimeLabel;
    NSNumber *remindTime; //提醒秒杀的时间
//    NSNumber *isStartSale; //第一场开售状态
    NSMutableArray *remindTimeMutableArr; //存放所有提醒时间
    
    NSTimeInterval curTime;
    NSMutableArray *timeLblArray;
    NSMutableArray *dictArray;
    NSMutableArray *dataArray;
    
    CGFloat outOfTimeHight;
    UIView *remindView;
    
    LimitedSeckillVO *modelss;
    UILocalNotification*notification;//本地推送
}

@property(nonatomic,strong)NSMutableArray *dataArrayOne;
@property(nonatomic,strong)NSMutableArray *dataArrayTwo;
@property(nonatomic,strong)NSMutableArray *dataArrayThree;

@end

@implementation LimitedSeckillViewController

- (id) initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // Custom initialization
        self.ifShowTableSeparator = NO;
        self.ifShowScrollToTopBtn = NO;
        self.ifShowBtnHigher = YES;
        self.ifAddPullToRefreshControl = YES;
        _isAdvLoaded = NO;
        _isDataLoad = NO;
        outOfTimeHight = 28;
        
        
        timeLblArray   = [[NSMutableArray alloc] init];
        dictArray      = [[NSMutableArray alloc] init];
        btnArray       = [[NSMutableArray alloc] init];
        lblArray       = [[NSMutableArray alloc] init];
        dataArray      = [[NSMutableArray alloc] init];
        _timeMutableArr= [[NSMutableArray alloc] init];
        remindTimeMutableArr = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
    
    //自定义 title
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 46)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"掌上秒杀";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithRed:0.96 green:0.3 blue:0.4 alpha:1];
    titleLabel.font = FONT(18);
    self.navigationItem.titleView = titleLabel;
    
    self.dataArrayOne    = [NSMutableArray arrayWithCapacity:0];
    self.dataArrayTwo    = [NSMutableArray arrayWithCapacity:0];
    self.dataArrayThree  = [NSMutableArray arrayWithCapacity:0];

    [super viewDidLoad];
    [self createUI];
    [self loadNewer];
    
    //返回按钮
    UIButton * backBarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 27)];
    [backBarButton setImage:[UIImage imageNamed:@"icon_goback_red"]
                   forState:UIControlStateNormal];
    [backBarButton setImage:[UIImage imageNamed:@"icon_goback_red"]
                   forState:UIControlStateHighlighted];
    
    [backBarButton addTarget:self
                      action:@selector(popToViewController)
            forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBarButton];
    backBarButtonItem.style = UIBarButtonItemStylePlain;
    
    [self.navigationController addLeftBarButtonItem:backBarButtonItem animation:NO];
}
- (void)popToViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!_isAdvLoaded) {
        [self loadADDataOperation];
    }
    
    //更换导航条
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg_lightGray"] forBarMetrics:UIBarMetricsDefault];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(backTimer){
        [backTimer invalidate];
        backTimer = nil;
        curTime = [[NSDate date] timeIntervalSince1970];
        
        backTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(compareCurrentTime) userInfo:nil repeats:YES];
    }
    
    [[(kata_AppDelegate *)[[UIApplication sharedApplication] delegate] deckController] setPanningMode:IIViewDeckNoPanning];
}
- (void)buyBtnClick:(LimitedSeckillVO *)model
{
    _modell = model;
    
    if ([model.is_start_sale integerValue] == 0) {
        //提醒时间
        [remindTimeMutableArr removeAllObjects];
        for (int i = 0; i<_timeMutableArr.count; i++) {
            NSNumber *remindNUM = [NSNumber numberWithLongLong:[_timeMutableArr[i] longLongValue] - 300];
            [remindTimeMutableArr addObject:remindNUM];
        }
        for (int i = 0; i<remindTimeMutableArr.count;i++) {
            if ([indexNum isEqualToString:[NSString stringWithFormat:@"%d",i]]) {
                remindTime = remindTimeMutableArr[i];
            }
        }
        
        [self request_saveRemindClickState];
    }else{
        [self skipNextVC:_modell];
    }
}
- (void)removeRemindView
{
    remindView.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg_red"] forBarMetrics:UIBarMetricsDefault];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark -- 倒计时
-(void)compareCurrentTime
{
    NSTimeInterval difftime = [_beginningOrEndingTime longLongValue] - 1;
    _beginningOrEndingTime = [NSNumber numberWithLongLong:difftime];
    
    for (int i = 1; i < _timeMutableArr.count; i++) {
        _timeMutableArr[i] = [NSNumber numberWithLongLong:[_timeMutableArr[i] longLongValue] - 1];
    }
    _outTimeNO = [NSNumber numberWithLongLong:[_outTimeNO longLongValue] -1];
    if (difftime < 0) {
        [backTimer invalidate];
        backTimer = nil;
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
        
        [timeLblArray[i] setText:[NSString stringWithFormat:@"%02zi", temptime]];
    }
}
-(void)createUI
{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectZero];
        _headerView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
//        _headerView.backgroundColor = [UIColor blueColor];
        [_headerView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), ADVFOCUSHEIGHT + MENUHEIGHT +outOfTimeHight )];
    }
    
    //广告活动页视图
    if (!_bannerView) {
        _bannerView = [[UIView alloc] initWithFrame:CGRectZero];
        [_bannerView setFrame:CGRectMake(0, 1, CGRectGetWidth(self.view.frame), ADVFOCUSHEIGHT)];
    }
    
    //功能列表视图
    if (!_menuView) {

        _menuView = [[UIImageView alloc] initWithFrame:CGRectMake(0, ADVFOCUSHEIGHT - 5 , ScreenW , MENUHEIGHT)];
        _menuView.backgroundColor = [UIColor clearColor];
//        _menuView.image = [UIImage imageNamed:@"wave"];
        _menuView.userInteractionEnabled = YES;
        
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
        _scrollView.contentSize = CGSizeMake(ScreenW/4*5, 50);
//        _scrollView.backgroundColor = [UIColor greenColor];
        _scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BigWhite_wave"]];
        _scrollView.bounces = YES;
        _scrollView.scrollEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [_menuView addSubview:_scrollView];

        _oneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _oneButton.backgroundColor = [UIColor whiteColor];
        _oneButton.frame = CGRectMake(0, 5, ScreenW/4, 45);
//        [_oneButton setTitle:@"上午场" forState:UIControlStateNormal];
        [_oneButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_oneButton setTitleEdgeInsets:UIEdgeInsetsMake(+10, 0, -10, 0)];
        [_oneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _oneButton.selected = YES;
        _oneButton.titleLabel.font = FONT(13);
        
        oneLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, _oneButton.frame.size.width-20, 20)];
        oneLabel.backgroundColor = [UIColor clearColor];
//        oneLabel.text = @"9:00-11:00";
        oneLabel.textColor = [UIColor whiteColor];
        oneLabel.font = FONT(14);
        oneLabel.textAlignment = NSTextAlignmentCenter;
        [_oneButton addSubview:oneLabel];
        [_scrollView addSubview:_oneButton];
        [btnArray addObject:_oneButton];
        [lblArray addObject:oneLabel];
    
        _twoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _twoButton.backgroundColor = [UIColor whiteColor];
        _twoButton.frame = CGRectMake(ScreenW/4, 5, ScreenW/4, 45);
//        [_twoButton setTitle:@"下午场" forState:UIControlStateNormal];
        [_twoButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_twoButton setTitleEdgeInsets:UIEdgeInsetsMake(+10, 0, -10, 0)];
        _twoButton.titleLabel.font = FONT(13);
        
        twoLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, _oneButton.frame.size.width-20, 20)];
        twoLabel.backgroundColor = [UIColor clearColor];
//        twoLabel.text = @"12:00-15:00";
        
        twoLabel.font = FONT(14);
        twoLabel.textAlignment = NSTextAlignmentCenter;
        [_twoButton addSubview:twoLabel];
        [_scrollView addSubview:_twoButton];
        [btnArray addObject:_twoButton];
        [lblArray addObject:twoLabel];
        
        _threeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _threeButton.backgroundColor = [UIColor whiteColor];
        _threeButton.frame = CGRectMake(ScreenW/4*2, 5, ScreenW/4, 45);
        [_threeButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_threeButton setTitleEdgeInsets:UIEdgeInsetsMake(+10, 0, -10, 0)];
        _threeButton.titleLabel.font = FONT(13);
        
        threeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, _oneButton.frame.size.width-20, 20)];
        threeLabel.backgroundColor = [UIColor clearColor];
//        threeLabel.text = @"16:00-22:00";
        threeLabel.font = FONT(14);
        threeLabel.textAlignment = NSTextAlignmentCenter;
        [_threeButton addSubview:threeLabel];
        [_scrollView addSubview:_threeButton];
        [btnArray addObject:_threeButton];
        [lblArray addObject:threeLabel];
        
        _fourButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _fourButton.backgroundColor = [UIColor whiteColor];
        _fourButton.frame = CGRectMake(ScreenW/4*3, 5, ScreenW/4, 45);
        [_fourButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_fourButton setTitleEdgeInsets:UIEdgeInsetsMake(+10, 0, -10, 0)];
        [_fourButton setTitleColor:RGB(123, 123, 123) forState:UIControlStateNormal];
//        [_fourButton setTitle:@"14:00" forState:UIControlStateNormal];
        _fourButton.titleLabel.font = FONT(13);
        
        fourLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, _oneButton.frame.size.width-20, 20)];
        fourLabel.backgroundColor = [UIColor clearColor];
//        fourLabel.text = @"贵人抢";
        fourLabel.font = FONT(14);
        fourLabel.textColor = RGB(123, 123, 123);
        fourLabel.textAlignment = NSTextAlignmentCenter;
        [_fourButton addSubview:fourLabel];
        [_scrollView addSubview:_fourButton];
        [btnArray addObject:_fourButton];
        [lblArray addObject:fourLabel];
        
        _fiveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _fiveButton.backgroundColor = [UIColor whiteColor];
        _fiveButton.frame = CGRectMake(ScreenW/4*4, 5, ScreenW/4, 45);
        [_fiveButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_fiveButton setTitleEdgeInsets:UIEdgeInsetsMake(+10, 0, -10, 0)];
        [_fiveButton setTitleColor:RGB(123, 123, 123) forState:UIControlStateNormal];
//        [_fiveButton setTitle:@"22:00" forState:UIControlStateNormal];
        _fiveButton.titleLabel.font = FONT(13);
        
        fiveLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, _oneButton.frame.size.width-20, 20)];
        fiveLabel.backgroundColor = [UIColor clearColor];
//        fiveLabel.text = @"嫔妃抢";
        fiveLabel.textColor = RGB(123, 123, 123);
        fiveLabel.font = FONT(14);
        fiveLabel.textAlignment = NSTextAlignmentCenter;
        [_fiveButton addSubview:fiveLabel];
        [_scrollView addSubview:_fiveButton];
        [btnArray addObject:_fiveButton];
        [lblArray addObject:fiveLabel];
        
        //下划线
        underLineView = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetHeight(_scrollView.frame), CGRectGetWidth(_oneButton.frame) - 40, 1)];
        underLineView.backgroundColor = [UIColor colorWithRed:0.96 green:0.3 blue:0.4 alpha:1];
        [_scrollView addSubview:underLineView];
        
        //分隔线
        UIView *seprateLine1View = [[UIView alloc]initWithFrame:CGRectMake(ScreenW/4 -1, 12, 0.5, _oneButton.frame.size.height - 20)];
        seprateLine1View.backgroundColor = GRAY_LINE_COLOR;
        [_oneButton addSubview:seprateLine1View];
        
        UIView *seprateLine2View = [[UIView alloc]initWithFrame:CGRectMake(ScreenW/4 -1, 12, 0.5, _oneButton.frame.size.height - 20)];
        seprateLine2View.backgroundColor = GRAY_LINE_COLOR;
        [_twoButton addSubview:seprateLine2View];
        
        UIView *seprateLine3View = [[UIView alloc]initWithFrame:CGRectMake(ScreenW/4 -1, 12, 0.5, _oneButton.frame.size.height - 20)];
        seprateLine3View.backgroundColor = GRAY_LINE_COLOR;
        [_threeButton addSubview:seprateLine3View];
        
        UIView *seprateLine4View = [[UIView alloc]initWithFrame:CGRectMake(ScreenW/4 -1, 12, 0.5, _oneButton.frame.size.height - 20)];
        seprateLine4View.backgroundColor = GRAY_LINE_COLOR;
        [_fourButton addSubview:seprateLine4View];
        
    }
    
    //开售时间
    UILabel *startTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, ADVFOCUSHEIGHT + MENUHEIGHT+28, 80, 20)];
    startTimeLabel.backgroundColor = [UIColor clearColor];
    startTimeLabel.text = @"每天9:00开抢";
    startTimeLabel.font = FONT(13);
    startTimeLabel.textColor = [UIColor grayColor];
    
    if (!timeView) {
        timeView = [[UIView alloc] initWithFrame:CGRectMake(100, ADVFOCUSHEIGHT + MENUHEIGHT - 5, ScreenW-110, outOfTimeHight)];
//        timeView.backgroundColor = [UIColor orangeColor];
        [_headerView addSubview:timeView];
        
        //结束倒计时
        UIImageView *timeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 12.5, 15, 15)];
        [timeImgView setImage:LOCAL_IMG(@"clock")];
        timeImgView.backgroundColor = [UIColor clearColor];
//        [timeView addSubview:timeImgView];
        endTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 100, 20)];
        endTimeLabel.backgroundColor = [UIColor clearColor];
        endTimeLabel.text = @"距本场结束时间";
        endTimeLabel.textAlignment = NSTextAlignmentRight;
        endTimeLabel.font = FONT(13);
        endTimeLabel.textColor = [UIColor grayColor];
        [timeView addSubview:endTimeLabel];
        
        [timeLblArray removeAllObjects];
        CGFloat xoffset = CGRectGetMaxX(endTimeLabel.frame)+2;
        for (NSInteger i = 0; i < 3; i ++) {
            UILabel *timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(xoffset, 12.5, 20, 15)];
            [timeLblArray addObject:timeLbl];
            [timeLbl setBackgroundColor:[UIColor colorWithRed:0.61 green:0.61 blue:0.61 alpha:1]];
            timeLbl.layer.masksToBounds = YES;
            timeLbl.layer.cornerRadius = 3.0f;
            [timeLbl setText:@"00"];
            [timeLbl setFont:FONT(15.0)];
            [timeLbl setTextAlignment:NSTextAlignmentCenter];
            [timeLbl setTextColor:[UIColor whiteColor]];
            [timeView addSubview:timeLbl];
            xoffset += CGRectGetWidth(timeLbl.frame)+1;
            if (i < 2) {
                UILabel *pointLbl = [[UILabel alloc] initWithFrame:CGRectMake(xoffset+2, 12.5, 10, 15)];
                [pointLbl setText:@":"];
                pointLbl.backgroundColor = [UIColor clearColor];
                [timeView addSubview:pointLbl];
                xoffset += CGRectGetWidth(pointLbl.frame)+1;
            }
        }
    }
    
//    [_headerView addSubview:startTimeLabel];
    [_headerView addSubview:_bannerView];
    [_headerView addSubview:_menuView];
    
    [self.tableView setTableHeaderView:_headerView];
}

#pragma mark -- 按钮点击事件
- (void)btnClick:(UIButton *)sender{

    for (NSInteger i = 0; i < btnArray.count; i++) {
        UIButton *btn = btnArray[i];
        UILabel *lbl = lblArray[i];
    
        if (sender == btn) {
            btn.selected = YES;
            
            if (i != 4) {
                _scrollView.contentOffset = CGPointMake(80/3*i, 0);
            }

            underLineView.frame = CGRectMake(20+i*CGRectGetWidth(_oneButton.frame), CGRectGetHeight(_oneButton.frame)+2, CGRectGetWidth(_oneButton.frame) - 40, 2);
            [btn setTitleColor:[UIColor colorWithRed:0.96 green:0.3 blue:0.4 alpha:1] forState:UIControlStateSelected];
            [lbl setTextColor:[UIColor colorWithRed:0.96 green:0.3 blue:0.4 alpha:1]];
            if (i < dataArray.count) {
                self.listData = dataArray[i];
            }
            if (i==0 && _timeMutableArr.count>0) {
                if ([_timeMutableArr[0] integerValue] == 0) {
                    endTimeLabel.text = @"距本场结束时间";
                    _beginningOrEndingTime = _outTimeNO;
                }else{
                    endTimeLabel.text = @"距本场开始时间";
                    _beginningOrEndingTime = _timeMutableArr[0];
                    indexNum = @"0";
                }
            }else{
                endTimeLabel.text = @"距本场开始时间";
                
                if (i == 1 && _timeMutableArr.count >= 2) {
                    _beginningOrEndingTime = _timeMutableArr[1];
                    indexNum = @"1";
                }
                if (i == 2 && _timeMutableArr.count >= 3) {
                    _beginningOrEndingTime = _timeMutableArr[2];
                    indexNum = @"2";
                }
                if (i == 3 && _timeMutableArr.count >= 4) {
                    _beginningOrEndingTime = _timeMutableArr[3];
                    indexNum = @"3";
                }
                if (i == 4 && _timeMutableArr.count >= 5) {
                    _beginningOrEndingTime = _timeMutableArr[4];
                    indexNum = @"4";
                }
            }
        }else{
            btn.selected = NO;
            [btn setTitleColor:RGB(123, 123, 123) forState:UIControlStateNormal];
            lbl.textColor = RGB(123, 123, 123);
        }
    }
    if (!backTimer) {
        backTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(compareCurrentTime) userInfo:nil repeats:YES];
    }
    [self performSelectorOnMainThread:@selector(judgeGoodslistCount) withObject:nil waitUntilDone:YES];
}

#pragma mark -- 网络解析 -- 获取秒杀数据
- (KTBaseRequest *)request
{
    KTBaseRequest *req = [[LMHLimitedSeckillRequest alloc]initWithPageSize:20
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
            if ([respDict objectForKey:@"data"] != nil && ![[respDict objectForKey:@"data"] isEqual:[NSNull null]]) {
                id dataObj = [respDict objectForKey:@"data"];
                if ([dataObj isKindOfClass:[NSDictionary class]]) {
                    
                    [dataArray removeAllObjects];
                    [_timeMutableArr removeAllObjects];
                
                    //获取 三个时间段内数据
                    for (NSInteger i = 0; i < [[dataObj objectForKey:@"seckill_list"] count]; i++) {
                        if ([[dataObj objectForKey:@"seckill_list"] objectAtIndex:i] != nil) {
                            dictArray[i] = [[dataObj objectForKey:@"seckill_list"] objectAtIndex:i];
                            NSArray *listArr = [[dictArray[i] objectForKey:@"product_list"] objectForKey:@"product_goods"];
                           
                            //获取倒计时时间
                            _outTimeNO = [dictArray[0] objectForKey:@"diff_time"];
                            [_timeMutableArr addObject:[dictArray[i] objectForKey:@"diff_begin_time"]];
                            
                            NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
                            for (id obj in listArr) {
                                modelss = [[LimitedSeckillVO alloc]init];
                                
                                modelss.product_id       = [obj objectForKey:@"product_id"];
                                modelss.seckill_id       = [obj objectForKey:@"goods_seckill_id"];
                                modelss.product_name     = [obj objectForKey:@"product_name"];
                                modelss.pic              = [obj objectForKey:@"pic"];
                                modelss.our_price        = [obj objectForKey:@"our_price"];
                                modelss.market_price     = [obj objectForKey:@"market_price"];
                                modelss.stock            = [obj objectForKey:@"stock"];
                                modelss.sold_quantity    = [obj objectForKey:@"sold_quantity"];
                                modelss.taobao_price     = [obj objectForKey:@"taobao_price"];
                                modelss.is_start_sale    = [obj objectForKey:@"is_start_sale"];
                                modelss.surplus          = [obj objectForKey:@"surplus"];
                                modelss.brand_id         = [obj objectForKey:@"brand_id"];
                                modelss.brand_title      = [obj objectForKey:@"brand_title"];
                                modelss.taobao_detail_url= [obj objectForKey:@"taobao_detail_url"];
                                modelss.begin_at         = [obj objectForKey:@"begin_at"];
                                modelss.is_seckill_remind= [obj objectForKey:@"is_seckill_remind"];
                                modelss.outTimeNum = _timeMutableArr[i];
                                
                                [tmpArray addObject:modelss];
                            }
                            [dataArray addObject:tmpArray];
                        }
                    }
                    _isDataLoad = YES;
                    [self performSelectorOnMainThread:@selector(setStartTimeAndEndTime) withObject:nil waitUntilDone:YES];
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
#pragma mark -- 网络解析 -- 保存开抢提醒按钮按钮状态
- (void)request_saveRemindClickState
{
    NSNumber *is_flagStr;
    if ([_modell.is_seckill_remind integerValue] == 0) {
        is_flagStr = @1;
    }else{
        is_flagStr = @0;
    }
    KTBaseRequest *req = [[LMHClickRemindRequest alloc] initWithGoods_id:_modell.product_id
                                                             andbegin_at:_modell.begin_at
                                                              andis_flag:is_flagStr];
    
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(parseResponse_saveRemindClickState:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxy start];
}
- (NSArray *)parseResponse_saveRemindClickState:(NSString *)resp
{
    NSArray *objArr = nil;
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            //改变按钮状态
            
            if ([_modell.is_seckill_remind integerValue] == 0  /*没提醒时*/) {

                // UI
                if (!remindView) {
                    remindView = [[UIView alloc]initWithFrame:CGRectMake(50, ScreenH/2-100, ScreenW - 100, 120)];
                    remindView.backgroundColor = RGBA(0, 0, 0, 0.6);
                    remindView.layer.cornerRadius = 8.0;
                    remindView.layer.masksToBounds = YES;
                    remindView.hidden = NO;
                    [self.contentView addSubview:remindView];
                }
                
                if (remindView.hidden) {
                    remindView.hidden = NO;
                }
                
                [self performSelector:@selector(removeRemindView) withObject:nil afterDelay:1.5];
                
                UIImageView *alarmClockView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(remindView.frame)/2 -25/2 , 20, 25, 25)];
                alarmClockView.image = [UIImage imageNamed:@"white_alarmclock"];
                [remindView addSubview:alarmClockView];
                
                UILabel*labelOne = [[UILabel alloc]init];
                labelOne.frame = CGRectMake(20, CGRectGetMaxY(alarmClockView.frame)+15, CGRectGetWidth(remindView.frame) - 40, 20);
                labelOne.layer.cornerRadius = 10;
                labelOne.backgroundColor = [UIColor clearColor];
                labelOne.text = @"秒杀提醒已开启，";
                labelOne.textColor = [UIColor whiteColor];
                labelOne.font = [UIFont systemFontOfSize:14];
                labelOne.textAlignment = NSTextAlignmentCenter;
                [remindView addSubview:labelOne];
                UILabel*labelTwo = [[UILabel alloc]init];
                labelTwo.frame = CGRectMake(20, CGRectGetMaxY(labelOne.frame)+5, CGRectGetWidth(remindView.frame) - 40, 20);
                labelTwo.layer.cornerRadius = 10;
                labelTwo.backgroundColor = [UIColor clearColor];
                labelTwo.text = @"将于秒杀前5分钟提醒您！";
                labelTwo.textColor = [UIColor whiteColor];
                labelTwo.font = [UIFont systemFontOfSize:14];
                labelTwo.textAlignment = NSTextAlignmentCenter;
                [remindView addSubview:labelTwo];
                
//                UIApplication* app=[UIApplication sharedApplication];
                
                //推送代码
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    //本地推送
                    notification = [[UILocalNotification alloc]init];
                    NSDate * pushDate = [NSDate dateWithTimeIntervalSinceNow:[remindTime integerValue]];
                    if (notification != nil) {
                        notification.fireDate = pushDate;
                        notification.timeZone = [NSTimeZone defaultTimeZone];
                        notification.repeatInterval = kCFCalendarUnitDay;
                        notification.soundName = UILocalNotificationDefaultSoundName;
                        notification.alertBody = @"hi 辣妈~还有5分钟秒杀就要开始啦!";
                        notification.applicationIconBadgeNumber = 1;
                        
                        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                        NSNumber* key = [def objectForKey:[_modell.begin_at stringValue]];
                        NSNumber* numcount = [NSNumber numberWithLongLong:0];
                        [def setObject:numcount forKey:[_modell.begin_at stringValue]];
                        [def synchronize];
                        
                        if ([key longLongValue] <= 0) {
                            NSDictionary *info = [[NSDictionary alloc] initWithObjectsAndKeys:numcount, [_modell.begin_at stringValue], nil];
                            notification.userInfo = info;
                            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                        }
                    }
                });
            }else{ //取消提醒
                [self textStateHUD:@"开抢提醒已关闭，您可能会抢不到哦~"];
                UIApplication* app=[UIApplication sharedApplication];
                
                NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                NSNumber* keys = [def objectForKey:[_modell.begin_at stringValue]];
                NSNumber* numcount = [NSNumber numberWithLongLong:[keys longLongValue]-1];
                [def setObject:numcount forKey:[_modell.begin_at stringValue]];
                
                for (UILocalNotification* notif in [app scheduledLocalNotifications]) {
                    NSDictionary* dic = notif.userInfo;
                    NSLog(@"%@",dic);
                    if (dic) {
                        NSNumber* key = [dic objectForKey:[_modell.begin_at stringValue]];
                        if ([key longLongValue] >= 0){
                            //取消推送 （指定一个取消）
                            [app cancelLocalNotification:notif];
                        }  
                    }
                }
            }
            _modell.is_seckill_remind = [NSNumber numberWithInteger:![_modell.is_seckill_remind integerValue]];
            for (NSArray *array in dataArray) {
                for (int i = 0; i < array.count; i++) {
                    LimitedSeckillVO *seckVO = array[i];
                    if ([seckVO.product_id integerValue] == [_modell.product_id integerValue]) {
                        seckVO = _modell;
                    }
                }
            }
            [self.tableView reloadData];
        }else {
            [self textStateHUD:[respDict objectForKey:@"msg"]];
        }
    }
    return objArr;
}

//三个时间段时间赋值
- (void)setStartTimeAndEndTime
{
    for (NSInteger i = 0; i < dictArray.count && i<5; i++) {
        UILabel *lbl = lblArray[i];
        UIButton *btn = btnArray[i];
        lbl.text = [dictArray[i] objectForKey:@"event_name"];
        [btnArray[i] setTitle:[dictArray[i] objectForKey:@"begin_time"] forState:UIControlStateNormal];
        if (i == 0) {
            [self performSelectorOnMainThread:@selector(btnClick:) withObject:btn waitUntilDone:YES];
        }
    }
    if (!backTimer) {
        backTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(compareCurrentTime) userInfo:nil repeats:YES];
    }
}

//判断数据个数 是否为空
- (void)judgeGoodslistCount
{
    if (!nullCountLabel && _isDataLoad) {
        nullCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 300, ScreenW - 120, 50)];
        nullCountLabel.text = @"暂无秒杀商品";
        nullCountLabel.backgroundColor = [UIColor clearColor];
        nullCountLabel.textAlignment = NSTextAlignmentCenter;
        nullCountLabel.font = FONT(15);
        nullCountLabel.textColor = [UIColor grayColor];
        [self.view addSubview:nullCountLabel];
    }

    for (NSInteger i = 0; i < dataArray.count; i++) {
        UIButton *btn = btnArray[i];
        if (btn.selected) {
            if ([dataArray[i] count] > 0) {
                [nullCountLabel setHidden:YES];
            }else{
                [nullCountLabel setHidden:NO];
            }
            break;
        }
    }
    [self.tableView reloadData];
}
- (void)checkLogin
{
    if (![[kata_UserManager sharedUserManager] isLogin]) {
        [self performSelector:@selector(showLoginView) withObject:nil afterDelay:0.1];
    }
}

- (void)showLoginView
{
    [kata_LoginViewController showInViewController:self];
}

#pragma mark 广告加载
- (void)layoutAdverView:(NSNumber *)Flag
{
    //如果广告页为空或获取失败，显示默认图
    if (![Flag boolValue]) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), ADVFOCUSHEIGHT)];
        [imgView setImage:[UIImage imageNamed:@"place_2"]];
            [_bannerView addSubview:imgView];
    }
    else
    {
        if (_bannerFV) {
            [_bannerFV.view removeFromSuperview];
            _bannerFV = nil;
        }
        
        if (!_bannerFV) {
            kata_IndexAdvFocusViewController *fvc = [[kata_IndexAdvFocusViewController alloc] initWithData:_advArr];
            fvc.focusViewControllerDelegate = self;
            _bannerFV = fvc;
            
            if (!_isAdvLoaded) {
                _bannerFV.view.alpha = 0;
            }
        }
        
        [_bannerView addSubview:_bannerFV.view];
        
        if (!_isAdvLoaded) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3];
            
            _bannerFV.view.alpha = 1;
            [UIView commitAnimations];
            _isAdvLoaded = YES;
        }
    }
}




#pragma mark - Load AD Data
- (void)loadADDataOperation
{
    KTAdverDataGetRequest *req = [[KTAdverDataGetRequest alloc] initWithType:@"limit_"];
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(loadADDataParseResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        [self performSelectorOnMainThread:@selector(layoutAdverView:) withObject:[NSNumber numberWithBool:NO] waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (void)loadADDataParseResponse:(NSString *)resp
{
    BOOL Flag = NO;
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            if ([respDict objectForKey:@"data"] != nil && ![[respDict objectForKey:@"data"] isEqual:[NSNull null]]) {
                id dataObj = [respDict objectForKey:@"data"];
                
                if ([dataObj isKindOfClass:[NSDictionary class]]) {
                    AdvListVO *listVO = [AdvListVO AdvListVOWithDictionary:dataObj];
                    
                    if ([listVO.Code intValue] == 0) {
                        _advArr = listVO.AdvList;
                        
                        if (_advArr && _advArr.count > 0) {
                            Flag = YES;
                        }
                        else
                            Flag = NO;
                    }
                    else
                        Flag = NO;
                }
                else
                    Flag = NO;
            }
            else
                Flag = NO;
        }
        else
            Flag = NO;
    }
    [self performSelectorOnMainThread:@selector(layoutAdverView:) withObject:[NSNumber numberWithBool:Flag] waitUntilDone:YES];
}

#pragma mark -- 商品展示列表的TableView 代理（重写）
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //行
    for (NSInteger i = 0; i < dataArray.count; i++) {
        UIButton *btn = btnArray[i];
        if (btn.selected) {
            return [dataArray[i] count];
        }
    }
    
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!_isDataLoad) {
        return 0;
    }
    return 1;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (section == 0) {
//        return 40;
//    }
//    else
//        return 0;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    NSInteger row = indexPath.row;
    
    LimitedSeckillCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[LimitedSeckillCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.contentView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    LimitedSeckillVO *model = [self.listData objectAtIndex:row];

    [cell configContent:model];
    cell.delegate = self;
    
    return  cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    LimitedSeckillVO *model = [self.listData objectAtIndex:row];
    [self skipNextVC:model];
}

- (void)skipNextVC:(LimitedSeckillVO *)seckillVO{
    NSInteger buyType = 0;
    
    if ([seckillVO.is_start_sale integerValue] == 0) {//即将开始
        buyType = 2;
    }else if ([seckillVO.is_start_sale integerValue] == 1 && [seckillVO.surplus integerValue] != 0){//立即抢购
        buyType = 1;
    }else{//已抢光
        buyType = 3;
    }
    if ([seckillVO.surplus intValue]== 0) {
        if (stringIsEmpty(seckillVO.taobao_detail_url)) {
            // 商品详情
            kata_ProductDetailViewController *vc = [[kata_ProductDetailViewController alloc] initWithProductID:[seckillVO.product_id integerValue] andType:[NSNumber numberWithInteger:buyType] andSeckillID:[seckillVO.seckill_id integerValue]];
            vc.navigationController = self.navigationController;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            // 淘宝/天猫 详情页
            kata_WebViewController *webVC = [[kata_WebViewController alloc] initWithUrl:seckillVO.taobao_detail_url title:nil andType:nil];
            webVC.navigationController = self.navigationController;
            webVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webVC animated:YES];
        }
    } else {
        // 商品详情
        kata_ProductDetailViewController *vc = [[kata_ProductDetailViewController alloc] initWithProductID:[seckillVO.product_id integerValue] andType:[NSNumber numberWithInteger:buyType] andSeckillID:[seckillVO.seckill_id integerValue]];
        vc.navigationController = self.navigationController;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - KATAFocusViewController Delegate
- (void)didClickFocusItemButton:(id)sender
{
    if ([sender isKindOfClass:[BOKUBannerImageButton class]]) {
        //Slider PUSH
        BOKUBannerImageButton *btn = (BOKUBannerImageButton *)sender;
        if (btn.slider && [btn.slider isKindOfClass:[AdvVO class]]) {
            AdvVO *vo = (AdvVO *)btn.slider;
            if (vo.Type) {
                NSInteger type = [vo.Type intValue];
                switch (type) {
                    case 1:
                    {
                        //商品详情页
                        if (vo.Key && [vo.Key intValue] != -1) {
                            kata_ProductDetailViewController *detailVC = [[kata_ProductDetailViewController alloc] initWithProductID:[vo.Key intValue] andType:nil andSeckillID:-1];
                            [detailVC setHidesBottomBarWhenPushed:YES];
                            detailVC.navigationController = self.navigationController;
                            [self.navigationController pushViewController:detailVC animated:YES];
                        }
                    }
                        break;
                        
                    case 2:
                    {
                        //商品列表页
                        if (vo.Key && [vo.Key intValue] != -1) {
                            kata_ProductListViewController *productlistVC = [[kata_ProductListViewController alloc] initWithBrandID:[vo.Key intValue] andTitle:vo.Title andProductID:0 andPlatform:nil isChannel:NO];
                            [productlistVC setHidesBottomBarWhenPushed:YES];
                            productlistVC.navigationController = self.navigationController;
                            [self.navigationController pushViewController:productlistVC animated:YES];
                        }
                    }
                        break;
                        
                    case 3:
                    {
                        //web页
                        if (vo.Key && ![vo.Key isEqualToString:@""]) {
                            NSString *webtitle = nil;
                            if (vo.Title && ![vo.Title isEqualToString:@""]) {
                                webtitle = vo.Title;
                            } else {
                                webtitle = @"辣妈汇活动页";
                            }
                            kata_WebViewController *webVC = [[kata_WebViewController alloc] initWithUrl:vo.Key title:webtitle andType:@"lamahui"];
                            [webVC setHidesBottomBarWhenPushed:YES];
                            webVC.navigationController = self.navigationController;
                            [self.navigationController pushViewController:webVC animated:YES];
                        }
                    }
                        break;
                    case 4:// 频道类.
                    {
//                        if (self.delegate!=nil && [self.delegate respondsToSelector:@selector(kata_HomeViewController)]) {
//                            //[self.delegate kata_HomeViewController:self didSelectedAdV:vo];
//                        }
                    }
                        break;
                    case 5://活动类
                    {
                        if ([vo.Key isEqualToString:@"oneSecKill"]) {// 秒杀活动
//                            [[LMHUIManager sharedUIManager] toSeckillActivityVC];
                        }else if ([vo.Key isEqualToString:@"limit_num"]){
                            //限量抢购
                            if (vo.Key && [vo.Key intValue] != -1) {
                                kata_ProductListViewController *productlistVC = [[kata_ProductListViewController alloc] initWithBrandID:[vo.Key intValue] andTitle:vo.Title andProductID:0 andPlatform:nil isChannel:NO];
                                [productlistVC setHidesBottomBarWhenPushed:YES];
                                productlistVC.navigationController = self.navigationController;
                                [self.navigationController pushViewController:productlistVC animated:YES];
                            }
                        }
                    }
                        break;
                    default:
                        break;
                }
            }
        }
    }
}

#pragma mark - Login Delegate
- (void)didLogin
{
    
}

- (void)loginCancel
{

}

@end
