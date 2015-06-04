//
//  kata_ProductDetailViewController.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-7.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "kata_ProductDetailViewController.h"
#import "KTProductDetailGetRequest.h"
#import "KTProductSkunumGetRequest.h"
#import "ProductDetailVO.h"
#import "KTPropButton.h"
#import "KTExtraInfoTableViewCell.h"
#import "kata_UserManager.h"
#import "kata_FavManager.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "kata_GlobalConst.h"
#import "SkuListVO.h"
#import "KTFavOperateRequest.h"
#import "kata_MyViewController.h"
#import "KTCartOperateRequest.h"
#import "kata_CartManager.h"
#import "kata_ShopCartViewController.h"
#import "SDWebImagePrefetcher.h"
#import "DetailViewVO.h"
#import "KTDetailViewRequest.h"
#import "kata_ProductListViewController.h"
#import "UIImageView+WebCache.h"
#import "kata_PayCheckViewController.h"
#import "CartGoodVO.h"
#import "CartInfo.h"
#import "KTProductNumRequest.h"
#import "KTNavigationController.h"
#import "LMHCellView.h"
#import "CommentsViewCell.h"
#import "LMHContectServiceViewController.h"
#import "kata_WebViewController.h"
#import "LMH_ImageTableViewCell.h"
#import "LMH_ReviewTableViewCell.h"
#import "LMH_KeyBoradView.h"
#import "LMH_EvaluateViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "WCAlertView.h"
#import "LikeProductVO.h"
#define TABLEVIEWCOLOR      [UIColor whiteColor]
#define BOTTOMHEIGHT        45

@interface kata_ProductDetailViewController ()<LMHCellViewDelegate,UMSocialUIDelegate,XLCycleScrollViewDatasource,XLCycleScrollViewDelegate, LMH_ReviewTableViewCellDelegate,UITextFieldDelegate,LMH_KeyBoradViewDelegate>
{
    NSInteger _productid;
    NSInteger _seckillID;
    NSInteger _colorid;
    NSInteger _sizeid;
    NSString *_skuid;
    UIBarButtonItem *_shareItem;
    BOOL _isFaved;
    NSInteger _loginActionID;
    NSInteger _skuQuantity;
    NSInteger _skuNum;
    
    XLCycleScrollView *_bannerFV;
    UILabel *_goodTitleLbl;
    UIView *_priceView;
    UILabel *__ourPriceLbl;
    UILabel *__marketPriceLbl;
    UILabel *__saleTipLbl;
    UIView *_colorPropView;
    UIView *_sizePropView;
    UIView *_bottomView;
    UIButton *_buyBtn;
    UIButton *_cartBtn;
    UIImageView *_addFavView;
    UIImage *_spImg;
    EGOImageView *_goodImg;
    NSString *_skuLoadFlag;
    NSArray *_skuArray;
    NSArray *_sizeSkuArr;
    UIActivityIndicatorView *_detailIndicator;
    BOOL _selectColor;
    BOOL _selectSize;
    UILabel *_cartCtLbl;
    UIView *_cartCtBgView;
    UIView *_goToCartView;
    NSTimer *_successTimer;
    NSMutableArray *_cartSkuArr;
    NSInteger cart_num;
    NSString *productURL;
    NSString *shareContent;
    NSInteger _skuCartNum;
    NSInteger _skuOrderNum;

    // 下面两个只是用来做 秒杀活动的倒计时.
    NSTimer *numberTimer;
    double changeTimerValue;
    UILabel *countDownLabel;//倒记时lable

    UIButton *topBtn;
    UILabel *timeLbl;
    NSTimer *limitTimer;
    //是否点击了立刻购买按钮
    BOOL fastFlag;
    //是否退出当前页面
    BOOL currentVC;
    BOOL restFlag;
    NSNumber *cartGoodsID;
    
    ProductInfoVO *productDict;
    BrandInfoVO *brandDict;
    NSMutableArray *likeArray;
    CartInfo *_cartInfo;
    DetailViewVO *allVO;
    
    PopSkuView *popSkuTableView;
    UIView *popResultView;
    NSInteger sectioNum;
    UIView *_errorView;
    LMH_KeyBoradView *keyView;
    
    CommentsVO *commentVO;
    NSMutableArray *btnArray;
    NSMutableArray *sizeArray;
    NSMutableDictionary *imageHeightDict;
    NSArray *eveluateArray;
    NSArray *favimgArray;
    
    UIView *sectionView;
    UILabel *lineLbl;
    UILabel *commentLbl;
    UILabel *sroceLbl;
    UIView *srocrView;
    UIView *halfView;
    UITextField *textField;
    UIButton *eveluateBtn;
    UIButton *reverBtn;
    
    //秒杀类型
    NSInteger _productType;
    
    //新人专享价   is_exclusive    exclusive_price
    UILabel *_newPersonPriceLabel;
    
    BOOL is_exclusive; //是否享受新人专享价 0是不享受 1是享受
    NSString *exclusive_price; //新人专享价
    UIButton *collectionBtn;
    NSInteger  jifen;
    
    NSNumber *eveluateUserid;//被回复用户的id
    NSNumber *eveluatesmsID;          //被回复的内容id
    NSString *eveluateTent;
    NSString *userid;
    NSString *usertoken;
    
    CGRect vFrame;
}

@end

@implementation kata_ProductDetailViewController

- (id)initWithProductID:(NSInteger)productid andType:(NSNumber *)productType andSeckillID:(NSInteger)seckillID
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // Custom initialization
        self.ifShowTableSeparator = NO;
        self.ifShowScrollToTopBtn = NO;
//        self.ifShowToTop = YES;
        self.ifAddPullToRefreshControl = NO;
        self.ifShowBtnHigher = YES;
        
        _productid = productid;
        _seckillID = seckillID;
        _colorid = -1;
        _sizeid = -1;
        _skuid = nil;
        _skuQuantity = 1;
        _loginActionID = -1;
        _isFaved = NO;
        _skuCartNum = 0;
        _skuOrderNum = 0;
        _skuNum = 0;
        _spImg = [UIImage imageNamed:@"Icon"];
        
        self.title = @"商品详情";
        
        _selectColor = NO;
        _selectSize = NO;
        
        _productType = [productType integerValue];//商品类型
        
        
        _cartSkuArr = [[NSMutableArray alloc] init];
        btnArray = [[NSMutableArray alloc] init];
        sizeArray = [[NSMutableArray alloc] init];
        imageHeightDict = [[NSMutableDictionary alloc] init];
        
        fastFlag = NO;
        currentVC = YES;
        sectioNum = 0;
        restFlag = NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self layoutCartCt];
    if(!limitTimer){
        limitTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(compareCurrentTime) userInfo:nil repeats:YES];
    }
    currentVC = YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self loadNewer];
    
    //返回按钮
    UIButton * backBarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 27)];
    [backBarButton setImage:[UIImage imageNamed:@"icon_goback_gray"] forState:UIControlStateNormal];
    [backBarButton setImage:[UIImage imageNamed:@"icon_goback_gray"] forState:UIControlStateHighlighted];
    
    [backBarButton addTarget:self action:@selector(popToViewController) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBarButton];
    backBarButtonItem.style = UIBarButtonItemStylePlain;
    
    [self.navigationController addLeftBarButtonItem:backBarButtonItem animation:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShow:) name:UIKeyboardDidChangeFrameNotification object:nil];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
//    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    keyView = [[LMH_KeyBoradView alloc] initWithFrame:CGRectMake(0, ScreenH-94, ScreenW, 40)];
    keyView.backgroundColor = [UIColor whiteColor];
    keyView.keyDelegate = self;
    [self.view addSubview:keyView];
    keyView.hidden = YES;
}

- (void)popToViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [limitTimer invalidate];
    limitTimer = nil;
    
    currentVC = NO;
    
    [[SDWebImagePrefetcher sharedImagePrefetcher] cancelPrefetching];
    
    keyView.hidden = YES;
    [keyView.textField resignFirstResponder];
    [textField resignFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushToUserCenter
{
    kata_MyViewController *myVC = [[kata_MyViewController alloc] initWithIsRoot:NO];
    myVC.navigationController = self.navigationController;
    myVC.hideNavigationBarWhenPush = YES;
    [self.navigationController pushViewController:myVC animated:YES];
}

- (void)createUI
{
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:TABLEVIEWCOLOR];
    [self.contentView setBackgroundColor:TABLEVIEWCOLOR];
    [self.tableView setDelaysContentTouches:NO];
    
    popResultView = [[UIView alloc] initWithFrame:CGRectZero];
    popResultView.layer.masksToBounds = NO;
    popResultView.layer.cornerRadius = 8;
    [popResultView setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(30, 20, 30, 30)];
    [imageview setImage:[UIImage imageNamed:@"addcart"]];
    [popResultView addSubview:imageview];
    UILabel *descriLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageview.frame) + 10, 20, 200, 30)];
    [descriLbl setText:@"商品已添加到购物车"];
    [descriLbl setTextColor:[UIColor colorWithRed:1 green:0.04 blue:0.36 alpha:1]];
    [popResultView addSubview:descriLbl];
     
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"insert_shopcart"] forState:UIControlStateNormal];
    [backBtn setTitle:@"继续购物" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [popResultView addSubview:backBtn];
    
    UIButton *buyBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    UIImage *bimage = [UIImage imageNamed:@"red_btn_small"];
    bimage = [bimage stretchableImageWithLeftCapWidth:14.0f topCapHeight:14.0f];
    [buyBtn setBackgroundImage:bimage forState:UIControlStateNormal];
    bimage = [UIImage imageNamed:@"red_btn_small"];
    bimage = [bimage stretchableImageWithLeftCapWidth:14.0f topCapHeight:14.0f];
    [buyBtn setBackgroundImage:bimage forState:UIControlStateHighlighted];
    [buyBtn setBackgroundImage:bimage forState:UIControlStateSelected];
    [buyBtn setTitle:@"去结算" forState:UIControlStateNormal];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [[buyBtn titleLabel] setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [buyBtn addTarget:self action:@selector(cartBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [popResultView addSubview:buyBtn];
    [popResultView setBackgroundColor:[UIColor whiteColor]];
    popResultView.frame = CGRectMake(20, (ScreenH-150)/2, ScreenW-40, 150);
    
    backBtn.frame = CGRectMake((CGRectGetWidth(popResultView.frame) - 180)/ 3, CGRectGetMaxY(imageview.frame) + 30, 90, 30);
    buyBtn.frame = CGRectMake(CGRectGetMaxX(backBtn.frame) + (CGRectGetWidth(popResultView.frame) - 180)/ 3,CGRectGetMinY(backBtn.frame), 90, 30);
    if (!sectionView) {
        sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 40)];
        NSArray *titleArry = [NSArray arrayWithObjects:@"详情",@"尺码", @"评价", @"推荐", nil];
        for (NSInteger i = 0; btnArray.count < 4; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
            btn.frame = CGRectMake(i*ScreenW/4, 0, ScreenW/4, 38);
            [btn.titleLabel setFont:FONT(15.0)];
            [btn.titleLabel setText:titleArry[i]];
            [btn setTitle:titleArry[i] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(cellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitleColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1] forState:UIControlStateNormal];
            if (i == 0) {
                btn.selected = YES;
                [btn setTitleColor:LMH_COLOR_SKIN forState:UIControlStateNormal];
            }else if (i == 2){
                [btn setTitle:[NSString stringWithFormat:@"评价(%@)", commentVO.comments_count] forState:UIControlStateNormal];
            }
            [btnArray addObject:btn];
            [sectionView addSubview:btn];
        }
        lineLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 38, ScreenW/4-20, 2)];
        [lineLbl setBackgroundColor:LMH_COLOR_SKIN];
        [sectionView addSubview:lineLbl];
    }
    [sectionView setBackgroundColor:[UIColor whiteColor]];
}

-(void)backBtnClick
{
    [self popViewdiss:popResultView];
    [_buyBtn setEnabled:YES];
    [_cartBtn setEnabled:YES];
}

- (void)addRightBarButtonItem
{
    //返回首页按钮
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 44)];
    
    UIButton *returnHomeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [returnHomeBtn setImage:[UIImage imageNamed:@"Icon_goHome_gray"] forState:UIControlStateNormal];
    returnHomeBtn.frame = CGRectMake(0, 7, 30, 30);
    [returnHomeBtn addTarget:self action:@selector(returnHomeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:returnHomeBtn];
    
    UIButton *shareBtn = [[UIButton alloc] init];
    shareBtn.frame = CGRectMake(CGRectGetMaxX(returnHomeBtn.frame)+10, 12, 20, 20);
    [shareBtn setBackgroundImage:LOCAL_IMG(@"new_share") forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:shareBtn];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    
    [self.navigationController addRightBarButtonItem:rightItem animation:NO];

}
- (void)returnHomeBtnClick
{
    self.tabBarController.selectedIndex=0;
    if (self.tabBarController.selectedIndex == 0) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)layoutBottomView
{
    CGRect frame = self.tableView.frame;
    frame.size.height -= BOTTOMHEIGHT;
    self.tableView.frame = frame;
    
    vFrame = frame;
    
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.contentView.frame) - BOTTOMHEIGHT, CGRectGetWidth(self.contentView.frame), BOTTOMHEIGHT)];
        [_bottomView setBackgroundColor:TABLEVIEWCOLOR];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_bottomView.frame), 0.5)];
        [line setBackgroundColor:[UIColor colorWithRed:0.82 green:0.82 blue:0.82 alpha:1]];
        [_bottomView addSubview:line];
        
        UIButton *cartBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW-190, 8, 90, 29)];
        UIImage *cimage = [UIImage imageNamed:@"insert_shopcart"];
        cimage = [cimage stretchableImageWithLeftCapWidth:14.0f topCapHeight:14.0f];
        [cartBtn setBackgroundImage:cimage forState:UIControlStateNormal];
        cimage = [UIImage imageNamed:@"insert_shopcart"];
        cimage = [cimage stretchableImageWithLeftCapWidth:14.0f topCapHeight:14.0f];
        [cartBtn setBackgroundImage:cimage forState:UIControlStateHighlighted];
        [cartBtn setBackgroundImage:cimage forState:UIControlStateSelected];
        [cartBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
        [cartBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [cartBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [[cartBtn titleLabel] setFont:[UIFont boldSystemFontOfSize:13.0f]];
        [cartBtn addTarget:self action:@selector(buyNowBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:cartBtn];
        _cartBtn = cartBtn;
//        if (_productType > 0) {
//            [_cartBtn setHidden:YES];
//        }else{
//            [_cartBtn setHidden:NO];
//        }
        
        UIButton *buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cartBtn.frame)+2, 8, 90, 29)];
        UIImage *bimage = [UIImage imageNamed:@"red_btn_small"];
        bimage = [bimage stretchableImageWithLeftCapWidth:14.0f topCapHeight:14.0f];
        [buyBtn setBackgroundImage:bimage forState:UIControlStateNormal];
        
        [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [[buyBtn titleLabel] setFont:[UIFont boldSystemFontOfSize:13.0f]];
        [buyBtn addTarget:self action:@selector(buyNowBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:buyBtn];
        
        _buyBtn = buyBtn;
        _buyBtn.tag = 10001;
        if (_productType == 1) {
            [buyBtn setTitle:@"立即抢购" forState:UIControlStateNormal];
        }else if (_productType == 2){
            [buyBtn setTitle:@"即将开始" forState:UIControlStateNormal];
            [buyBtn setBackgroundImage:[UIImage imageNamed:@"willStartBtn"] forState:UIControlStateNormal];
            [buyBtn setUserInteractionEnabled:YES];
        }else if(_productType == 3){
            [buyBtn setTitle:@"已抢光" forState:UIControlStateNormal];
            [buyBtn setBackgroundImage:[UIImage imageNamed:@"outOfStockBtnBg"] forState:UIControlStateNormal];
            [buyBtn setUserInteractionEnabled:YES];
        }else{
            [buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
        }
        
        UIButton *goCartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [goCartBtn setFrame:CGRectMake(0 , 0, CGRectGetHeight(_bottomView.frame), CGRectGetHeight(_bottomView.frame))];
        [goCartBtn setImage:[UIImage imageNamed:@"BarItemNormal4"] forState:UIControlStateNormal];
        [goCartBtn setImage:[UIImage imageNamed:@"BarItemNormal4"] forState:UIControlStateSelected];
        [goCartBtn setImage:[UIImage imageNamed:@"BarItemNormal4"] forState:UIControlStateDisabled];
        [goCartBtn setContentMode:UIViewContentModeCenter];
        [goCartBtn addTarget:self action:@selector(cartBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:goCartBtn];
        
        
        _cartCtLbl = [[UILabel alloc] initWithFrame:CGRectMake(28, 8, 0, 15)];
        [_cartCtLbl setBackgroundColor:[UIColor clearColor]];
        [_cartCtLbl setFont:[UIFont boldSystemFontOfSize:9]];
        [_cartCtLbl setTextAlignment:NSTextAlignmentCenter];
        [_cartCtLbl setTextColor:[UIColor whiteColor]];
        
        _cartCtBgView = [[UIView alloc] initWithFrame:_cartCtLbl.frame];
        [_cartCtBgView setBackgroundColor:[UIColor colorWithRed:0.95 green:0.3 blue:0.41 alpha:1]];
        [_cartCtBgView.layer setCornerRadius:7.5];
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cartBtnPressed)];
        [_cartCtBgView addGestureRecognizer:tapGR];
        
        [goCartBtn addSubview:_cartCtBgView];
        [goCartBtn addSubview:_cartCtLbl];
        
        [self layoutCartCt];
    }
    
    [self.view addSubview:_bottomView];
    [self addRightBarButtonItem];
    
    halfView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    halfView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [[(kata_AppDelegate *)[[UIApplication sharedApplication] delegate] window] addSubview:halfView];
    
    UITapGestureRecognizer *halfTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popViewdiss:)];
    [halfView addGestureRecognizer:halfTap];
    [halfView setHidden:YES];
    
    popSkuTableView = [[PopSkuView alloc] initWithFrame:CGRectMake(0, ScreenH - ScreenH/3*2, ScreenW, ScreenH/3*2)];
}

- (void)callBtnClick
{
    LMHContectServiceViewController *contect = [[LMHContectServiceViewController alloc]init];
    contect.navigationController = self.navigationController;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:contect animated:YES];
}

- (void)layoutCartCt
{
    if ([[kata_CartManager sharedCartManager] cartCounter]) {
        NSNumber *cnt = [[kata_CartManager sharedCartManager] cartCounter];
        if (cnt && [cnt integerValue] > 0) {
            [_cartCtLbl setText:[NSString stringWithFormat:@"%@", cnt]];
            CGSize size = [_cartCtLbl.text sizeWithFont:_cartCtLbl.font];
            [_cartCtLbl setFrame:CGRectMake(CGRectGetMinX(_cartCtLbl.frame), CGRectGetMinY(_cartCtLbl.frame), size.width + 9, CGRectGetHeight(_cartCtLbl.frame))];
            [_cartCtBgView setFrame:_cartCtLbl.frame];
            [_cartCtLbl setHidden:NO];
            [_cartCtBgView setHidden:NO];
        } else {
            [[kata_CartManager sharedCartManager] updateCartCounter:[NSNumber numberWithInteger:0]];
            [_cartCtLbl setHidden:YES];
            [_cartCtBgView setHidden:YES];
        }
    }
}

- (void)cartBtnPressed
{
    if (![[kata_UserManager sharedUserManager] isLogin]) {
        [kata_LoginViewController showInViewController:self];
        return;
    }
    [self popViewdiss:popResultView];
    _loginActionID = 104;
    BOOL backFlag = NO;
    
    for (UIViewController *temp in self.navigationController.viewControllers)
    {
        if ([temp isKindOfClass:[kata_ShopCartViewController class]])
        {
            backFlag = YES;
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        else
        {
            backFlag = NO;
        }
    }
    if (!backFlag) {
        kata_ShopCartViewController *cartVC = [[kata_ShopCartViewController alloc] initWithStyle:UITableViewStylePlain];
        cartVC.navigationController = self.navigationController;
        [self.navigationController pushViewController:cartVC animated:YES];
    }
}

#pragma mark - UpdateCartRequest
- (void)updateCartOperation
{
    //[self loadWithHud];
    NSString *cartid = nil;
    
    if ([[kata_CartManager sharedCartManager] hasCartID]) {
        cartid = [[kata_CartManager sharedCartManager] cartID];
    }
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isEqualToString:@""]) {
        userid = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"];
    }
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isEqualToString:@""]) {
        usertoken = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"];
    }
    
    NSMutableArray *productArr = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *pDict = [NSMutableDictionary new];
    [pDict setObject:cartGoodsID forKey:@"cart_goods_id"];
    [pDict setObject:[NSNumber numberWithInteger:_skuQuantity] forKey:@"quantity"];
    [productArr addObject:pDict];
    
    KTCartOperateRequest *req = [[KTCartOperateRequest alloc] initWithCartID:cartid
                                                                   andUserID:userid
                                                                andUserToken:usertoken
                                                                     andType:@"ajax_get_cart_sales"
                                                                  andProduct:productArr
                                                                   andGoodID:nil
                                                                andAddressID:-1
                                                                 andCouponNO:nil
                                                              andCoponUserID:-1
                                                                   andCredit:-1
                                                                andSeckillID:_seckillID];
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(updateCartParseResponse:) withObject:resp waitUntilDone:YES];
    } failed:^(NSError *error) {
        [self hideHUDView];
        [self performSelectorOnMainThread:@selector(btnShow) withObject:nil waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (void)updateCartParseResponse:(NSString *)resp
{
    NSString * hudPrefixStr = @"获取优惠信息";
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            if (nil != [respDict objectForKey:@"data"] && ![[respDict objectForKey:@"data"] isEqual:[NSNull null]] && [[respDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *dataObj = (NSDictionary *)[respDict objectForKey:@"data"];
                if ([[dataObj objectForKey:@"code"] integerValue] == 0) {
                    
                    if (nil != [dataObj objectForKey:@"cart"] && ![[dataObj objectForKey:@"cart"] isEqual:[NSNull null]] && [[dataObj objectForKey:@"cart"] isKindOfClass:[NSDictionary class]]) {
                        _cartInfo = [CartInfo CartInfoWithDictionary:[dataObj objectForKey:@"cart"]];
                        [self performSelectorOnMainThread:@selector(gotoPay) withObject:nil waitUntilDone:YES];
                    }
                    return;
                } else {
                    id messageObj = [dataObj objectForKey:@"msg"];
                    if (messageObj) {
                        if ([messageObj isKindOfClass:[NSString class]] && ![messageObj isEqualToString:@""]) {
                            [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:messageObj waitUntilDone:YES];
                        } else {
                            [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[hudPrefixStr stringByAppendingString:@"失败"] waitUntilDone:YES];
                        }
                    } else {
                        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[hudPrefixStr stringByAppendingString:@"失败"] waitUntilDone:YES];
                    }
                }
            } else {
                [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[hudPrefixStr stringByAppendingString:@"失败"] waitUntilDone:YES];
            }
        } else {
            id messageObj = [respDict objectForKey:@"msg"];
            if (messageObj) {
                if ([messageObj isKindOfClass:[NSString class]] && ![messageObj isEqualToString:@""]) {
                    [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:messageObj waitUntilDone:YES];
                } else {
                    [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[hudPrefixStr stringByAppendingString:@"失败"] waitUntilDone:YES];
                }
            } else {
                [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[hudPrefixStr stringByAppendingString:@"失败"] waitUntilDone:YES];
            }
        }
    } else {
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[hudPrefixStr stringByAppendingString:@"失败"] waitUntilDone:YES];
    }
    [self performSelectorOnMainThread:@selector(btnShow) withObject:nil waitUntilDone:YES];
    [self hideHUDView];
}

-(void)gotoPay{ //立刻购买
    if (![[kata_UserManager sharedUserManager] isLogin]) {
        [kata_LoginViewController showInViewController:self];
        return;
    }
    
    [self performSelectorOnMainThread:@selector(btnShow) withObject:nil waitUntilDone:YES];

    NSDictionary *brand_dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              brandDict.brandTitle.length>0?brandDict.brandTitle:@"其他专场", @"event_title",
                              [brandDict.brandID integerValue]>0?brandDict.brandID:[NSNull null], @"brand_id",
                              brandDict.brandlogo.length>0?brandDict.brandlogo:[NSNull null], @"logo_url",
                              nil];
    
    CartBrandVO *brandvo = [CartBrandVO CartBrandVOWithDictionary:brand_dict];
    
    NSMutableArray *options = [[NSMutableArray alloc] init];
    NSString *imgUrl = productDict.Pics.count>0?productDict.Pics[0]:@"";
    for (id obj in _skuArray) {
        if ([obj isKindOfClass:[SkuListVO class]]) {
            SkuListVO *vo = (SkuListVO *)obj;
            if ([vo.SkuID isEqual:_skuid]) {
                NSDictionary *dict;
                if (vo.ColorName.length > 0) {
                    dict = [NSDictionary dictionaryWithObjectsAndKeys:@"颜色", @"label", vo.ColorName, @"value", nil];
                    [options addObject:dict];
                }
                dict = [NSDictionary dictionaryWithObjectsAndKeys:@"尺寸", @"label", vo.SizeName, @"value", nil];
                [options addObject:dict];
                imgUrl = vo.imageUrl;
                break;
            }
        }
    }
    
    NSDictionary *product_dict = [NSDictionary dictionaryWithObjectsAndKeys:
                               productDict.Title, @"product_name",
                               [NSNumber numberWithInteger:_skuQuantity], @"qty",
                               [NSNumber numberWithInteger:_productid], @"product_id",
                               _skuid, @"sku",
                               productDict.MarketPrice, @"original_price",
                               productDict.OurPrice, @"sell_price",
                               options, @"options",
                               cartGoodsID, @"item_id",
                               imgUrl, @"product_image",
                               brandDict.brandTitle, @"brand_name",
                               nil];
    CartProductVO *productvo = [CartProductVO CartProductVOWithDictionary:product_dict];
    
    NSArray *calcArray = [NSArray arrayWithObjects:brandvo,productvo, nil];
    
    NSDictionary *moneyDict = [NSDictionary dictionaryWithObjectsAndKeys:_cartInfo.CartMoney, @"money", _cartInfo.Freight, @"shipfee", [NSNumber numberWithInteger:_seckillID>=0?_seckillID:-1], @"seckill", nil];
    kata_PayCheckViewController *payVC = [[kata_PayCheckViewController alloc] initWithProductData:calcArray andMoneyInfo:moneyDict];
    payVC.navigationController = self.navigationController;
    [self.navigationController pushViewController:payVC animated:YES];
    [self performSelectorOnMainThread:@selector(btnShow) withObject:nil waitUntilDone:YES];
    [self hideHUDView];
}

-(void)popSkuView
{
    [halfView addSubview:popSkuTableView];
    [halfView setHidden:NO];
    popSkuTableView._productVO = productDict;
    popSkuTableView._proid = [NSNumber numberWithInteger:_productid];
    [popSkuTableView.skuTabeView reloadData];
    popSkuTableView.popSkuViewDelegate = self;
}

#pragma mark - 
#pragma mark  buy acton
- (void)buyNowBtnPressed:(UIButton *)sender
{
    if (![[kata_UserManager sharedUserManager] isLogin]) {
        [kata_LoginViewController showInViewController:self];
        _loginActionID = 101;
        return;
    }
    [_buyBtn setEnabled:NO];
    [_cartBtn setEnabled:NO];
    
    if (sender.tag == 10001) {
        fastFlag = YES;
    }else{
        fastFlag = NO;
    }
    
    NSInteger colorNum = productDict.ColorInfo.count;
    NSInteger sizeNum = productDict.SizeInfo.count;
    
    if ((colorNum <= 1) && (sizeNum <= 1)) {
        if (productDict.ColorInfo.count > 0) {
            ColorInfoVO *vo = productDict.ColorInfo[0];
            _colorid = [vo.ColorID intValue];
        }
        if (productDict.SizeInfo.count > 0) {
            SizeInfoVO *vo = productDict.SizeInfo[0];
            _sizeid = [vo.SizeID intValue];
        }
        [self performSelectorOnMainThread:@selector(loadSkuNum) withObject:nil waitUntilDone:YES];
    }else{
        [self popSkuView];
    }
}

-(void) btnShow{
    NSInteger kcnum = 0;
    NSArray *array = nil;
    if (_skuArray) {
        array = _skuArray;
    }else{
        array = productDict.PropTable;
    }
    for (SkuListVO *vo in array) {
        kcnum += [vo.SkuNum intValue];
    }
    if (kcnum <= 0) {
        [_cartBtn setHidden:YES];
        [_buyBtn setTitle:@"已抢光" forState:UIControlStateNormal];
        [_buyBtn setBackgroundImage:[UIImage imageNamed:@"outOfStockBtnBg"] forState:UIControlStateNormal];
        [_buyBtn setUserInteractionEnabled:NO];
    }else{
        if (_productType == 1) {
            [_buyBtn setEnabled:YES];
            [_cartBtn setEnabled:YES];
            [_cartBtn setHidden:NO];
        }else if (_productType == 2){
            [_buyBtn setUserInteractionEnabled:NO];
            //[_cartBtn setUserInteractionEnabled:NO];
            [_cartBtn setHidden:YES];
        }else if(_productType == 3){
            [_buyBtn setUserInteractionEnabled:NO];
            //[_cartBtn setUserInteractionEnabled:NO];
            [_cartBtn setHidden:YES];
        }else{
            [_buyBtn setEnabled:YES];
            [_cartBtn setEnabled:YES];
            [_cartBtn setHidden:NO];
        }
    }
}

#pragma mark 加入购物车
-(void)addToCartRequst
{
    [_cartBtn setEnabled:NO];
    [_buyBtn setEnabled:NO];
    NSString *cartid = nil;
    
    if ([[kata_CartManager sharedCartManager] hasCartID]) {
        cartid = [[kata_CartManager sharedCartManager] cartID];
    }
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isEqualToString:@""]) {
        userid = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"];
    }
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isEqualToString:@""]) {
        usertoken = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"];
    }
    
    NSMutableDictionary *product = [NSMutableDictionary new];
    if (_productid != -1) {
        [product setObject:[NSNumber numberWithInteger:_productid] forKey:@"product_id"];
    }
    if (_skuQuantity != -1) {
        [product setObject:[NSNumber numberWithInteger:_skuQuantity] forKey:@"quantity"];
    }
    if (_skuid) {
        [product setObject:_skuid forKey:@"product_sku"];
    }
    NSArray *productArr = @[product];
    
    KTCartOperateRequest *req = [[KTCartOperateRequest alloc] initWithCartID:cartid
                                                                   andUserID:userid
                                                                andUserToken:usertoken
                                                                     andType:@"add"
                                                                  andProduct:productArr
                                                                   andGoodID:nil
                                                                andAddressID:-1
                                                                 andCouponNO:nil
                                                              andCoponUserID:-1
                                                                   andCredit:-1
                                                                andSeckillID:-1];
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(addToCartParseResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
        [_cartBtn setEnabled:YES];
        [_buyBtn setEnabled:YES];
    }];
    
    [proxy start];
}

- (void)addToCartParseResponse:(NSString *)resp
{
    NSString * hudPrefixStr = @"";
    if (fastFlag) {
        hudPrefixStr = @"购买";
    }else{
        hudPrefixStr = @"加入购物车";
    }
    
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            if (nil != [respDict objectForKey:@"data"] && ![[respDict objectForKey:@"data"] isEqual:[NSNull null]] && [[respDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *dataObj = (NSDictionary *)[respDict objectForKey:@"data"];
                if ([[dataObj objectForKey:@"code"] integerValue] == 0) {
                    
                    if ([dataObj objectForKey:@"cart_id"]) {
                        if (![[kata_CartManager sharedCartManager] hasCartID]) {
                            [[kata_CartManager sharedCartManager] updateCartID:[dataObj objectForKey:@"cart_id"]];
                        } else if (![[[kata_CartManager sharedCartManager] cartID] isEqualToString:[dataObj objectForKey:@"cart_id"]]) {
                            [[kata_CartManager sharedCartManager] updateCartID:[dataObj objectForKey:@"cart_id"]];
                        }
                    }
                    if ([dataObj objectForKey:@"cart_goods_id"]) {
                        cartGoodsID = [dataObj objectForKey:@"cart_goods_id"];
                    }
                    
                    [self cartAddSuccess];
                    return;
                    
                } else {
                    [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[hudPrefixStr stringByAppendingString:@"失败"] waitUntilDone:YES];
                }
            } else {
                [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[hudPrefixStr stringByAppendingString:@"失败"] waitUntilDone:YES];
            }
        } else {
            id messageObj = [respDict objectForKey:@"msg"];
            if (messageObj) {
                if ([messageObj isKindOfClass:[NSString class]] && ![messageObj isEqualToString:@""]) {
                    [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:messageObj waitUntilDone:YES];
                } else {
                    [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[hudPrefixStr stringByAppendingString:@"失败"] waitUntilDone:YES];
                }
            } else {
                [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[hudPrefixStr stringByAppendingString:@"失败"] waitUntilDone:YES];
            }
        }
    } else {
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[hudPrefixStr stringByAppendingString:@"失败"] waitUntilDone:YES];
    }
    [_cartBtn setEnabled:YES];
    [_buyBtn setEnabled:YES];
}

- (void)cartAddSuccess
{
    BOOL addSameFlag = true;
    if (_cartSkuArr.count <= 0) {
        _cartSkuArr = [[kata_CartManager sharedCartManager] cartSkuID];
    }
    
    NSNumber *cnt = [[kata_CartManager sharedCartManager] cartCounter];
    cart_num = cnt.intValue;
    
    for (NSInteger i = 0; i < _cartSkuArr.count; i++) {
        if (_skuid.longLongValue == [_cartSkuArr[i] longLongValue]) {
            addSameFlag = false;
            break;
        }
        else
        {
            addSameFlag = true;
        }
    }
    
    if (addSameFlag) {
        [_cartSkuArr addObject:_skuid];
        cart_num ++;
    }
    
    [[kata_CartManager sharedCartManager] updateCartCounter:[NSNumber numberWithInteger:cart_num]];
    [[kata_CartManager sharedCartManager] updateCartSku:_cartSkuArr];
    [self layoutCartCt];
    
    if(currentVC){
        if (fastFlag) {
            [self performSelectorOnMainThread:@selector(updateCartOperation) withObject:nil waitUntilDone:YES];
        }else{
            [self hideHUDView];
            [self performSelectorOnMainThread:@selector(btnShow) withObject:nil waitUntilDone:YES];
            [halfView addSubview:popResultView];
            [halfView setHidden:NO];
        }
    }else{
        [self hideHUDView];
    }
}

- (void)shareButtonPressed
{
    keyView.hidden = YES;
    [keyView.textField resignFirstResponder];
    [textField resignFirstResponder];
    
    NSString *shareURL = productURL;
    
    [UMSocialData defaultData].extConfig.title = productDict.share_title;
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    [UMSocialData defaultData].extConfig.qqData.url = shareURL;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = shareURL;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareURL;
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMENG_APPKEY
                                      shareText:shareContent
                                     shareImage:nil
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToSina,UMShareToSms,nil]
                                       delegate:self];
}

- (void)favIconTaped
{
    if (![[kata_UserManager sharedUserManager] isLogin]) {
        [kata_LoginViewController showInViewController:self];
        _loginActionID = 102;
        return;
    }
    
    //收藏过后就不再收藏
    if ([productDict.IsFaved boolValue]) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3] animated:YES scrollPosition:UITableViewScrollPositionTop];
        return;
    }
    [self favProductOperation];
}

- (void)processSkuID
{
    if (_colorid != -1 && _sizeid != -1) {
        for (id obj in _skuArray) {
            if ([obj isKindOfClass:[SkuListVO class]]) {
                SkuListVO *skuVO = (SkuListVO *)obj;
                if (skuVO.ColorID && skuVO.SizeID) {
                    if ([skuVO.ColorID integerValue] == _colorid && [skuVO.SizeID integerValue] == _sizeid) {
                        _skuid = skuVO.SkuID;
                        _skuNum = [skuVO.SkuNum integerValue];
                        break;
                    }
                }
            }
        }
    } else if (_colorid != -1) {
        for (id obj in _skuArray) {
            if ([obj isKindOfClass:[SkuListVO class]]) {
                SkuListVO *skuVO = (SkuListVO *)obj;
                if (skuVO.ColorID && skuVO.SizeID) {
                    if ([skuVO.ColorID integerValue] == _colorid && [skuVO.SizeID integerValue] == 0) {
                        _skuid = skuVO.SkuID;
                        _skuNum = [skuVO.SkuNum integerValue];
                        break;
                    }
                }
            }
        }
    } else if (_sizeid != -1) {
        for (id obj in _skuArray) {
            if ([obj isKindOfClass:[SkuListVO class]]) {
                SkuListVO *skuVO = (SkuListVO *)obj;
                if (skuVO.ColorID && skuVO.SizeID) {
                    if ([skuVO.ColorID integerValue] == 0 && [skuVO.SizeID integerValue] == _sizeid) {
                        _skuid = skuVO.SkuID;
                        _skuNum = [skuVO.SkuNum integerValue];
                        break;
                    }
                }
            }
        }
    } else {
        for (id obj in _skuArray) {
            if ([obj isKindOfClass:[SkuListVO class]]) {
                SkuListVO *skuVO = (SkuListVO *)obj;
                if (skuVO.ColorID && skuVO.SizeID) {
                    if ([skuVO.ColorID integerValue] == 0 && [skuVO.SizeID integerValue] == 0) {
                        _skuid = skuVO.SkuID;
                        _skuNum = [skuVO.SkuNum integerValue];
                        break;
                    }
                }
            }
        }
    }
    
    for (id obj in _skuArray) {
        if ([obj isKindOfClass:[SkuListVO class]]) {
            SkuListVO *vo = (SkuListVO *)obj;
            if ([vo.SkuID isEqual:_skuid]) {
                if ([vo.SkuNum integerValue] == 0) {
                    [self textStateHUD:@"该商品库存不足"];
                    return;
                }
                break;
            }
        }
    }
    [self performSelectorOnMainThread:@selector(checkProuductRequst) withObject:nil waitUntilDone:YES];
    //[self performSelectorOnMainThread:@selector(addToCartRequst) withObject:nil waitUntilDone:YES];
}

#pragma mark - Load SkuNum Data
- (void)loadSkuNum
{
    [self loadWithHud];
    
    KTProductSkunumGetRequest *req = [[KTProductSkunumGetRequest alloc] initWithProductID:_productid];
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(loadSkuNumParseResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络异常，请检查网络设置" waitUntilDone:YES];
        [_cartBtn setEnabled:YES];
        [_buyBtn setEnabled:YES];
    }];
    
    [proxy start];
}

- (void)loadSkuNumParseResponse:(NSString *)resp
{
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            if ([respDict objectForKey:@"data"] != nil && ![[respDict objectForKey:@"data"] isEqual:[NSNull null]]) {
                id dataObj = [respDict objectForKey:@"data"];
                
                if ([dataObj isKindOfClass:[NSDictionary class]]) {
                    if ([dataObj objectForKey:@"sku_list"] && [[dataObj objectForKey:@"sku_list"] isKindOfClass:[NSArray class]]) {
                        
                        _skuArray = [SkuListVO SkuListVOListWithArray:[dataObj objectForKey:@"sku_list"]];
                        productDict.PropTable = _skuArray;
                        [self processSkuID];
                        return;
                    }
                }
            }
        }
    }
    if(!_skuArray){
        [self performSelectorOnMainThread:@selector(btnShow) withObject:nil waitUntilDone:YES];
    }
}

#pragma mark - KTFavOperateRequest
- (void)favProductOperation
{
    if (!stateHud) {
        stateHud = [[MBProgressHUD alloc] initWithView:self.contentView];
        stateHud.delegate = self;
        [self.contentView addSubview:stateHud];
    }
    stateHud.mode = MBProgressHUDModeIndeterminate;
    stateHud.labelFont = [UIFont systemFontOfSize:14.0f];
    [stateHud show:YES];
    
    KTBaseRequest *req = [[KTBaseRequest alloc] init];
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isEqualToString:@""]) {
        userid = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"];
    }
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isEqualToString:@""]) {
        usertoken = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"];
    }
    
    if (userid && usertoken) {
        req = [[KTFavOperateRequest alloc] initWithUserID:[userid integerValue]
                                             andUserToken:usertoken
                                             andProductID:_productid
                                                  andType:@"add"];
    }
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        [stateHud hide:YES];
        [self performSelectorOnMainThread:@selector(favProductParseResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        [stateHud hide:YES];
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxy start];

}

- (void)favProductParseResponse:(NSString *)resp
{
    NSString *hudPrefixStr = @"喜欢成功";
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            if (nil != [respDict objectForKey:@"data"] && ![[respDict objectForKey:@"data"] isEqual:[NSNull null]] && [[respDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *dataObj = [respDict objectForKey:@"data"];
                if ([[dataObj objectForKey:@"code"] integerValue] == 0) {
                    [self textStateHUD:hudPrefixStr];
                    if ([dataObj[@"fav_data"][@"fav_img"] isKindOfClass:[NSArray class]]) {
                        favimgArray = dataObj[@"fav_data"][@"fav_img"];
                        allVO.fav_count = dataObj[@"fav_data"][@"fav_count"];
                        
                        productDict.IsFaved = @YES;
                        //一个section刷新
                        [self.tableView reloadData];
                        
                        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3] animated:YES scrollPosition:UITableViewScrollPositionTop];
                    }
                    [self performSelectorOnMainThread:@selector(favOpSuccess) withObject:nil waitUntilDone:YES];
                    return;
                }
            }
        }
    }
    
    hudPrefixStr = @"喜欢失败";
    [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:hudPrefixStr waitUntilDone:YES];
}

- (void)favOpSuccess
{
    _isFaved = !_isFaved;
    if (_isFaved) {
        [collectionBtn setImage:[UIImage imageNamed:@"nav_myColection_select"] forState:UIControlStateNormal];
    } else {
        [collectionBtn setImage:[UIImage imageNamed:@"icon_collection"] forState:UIControlStateNormal];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FavList" object:nil];
    [stateHud hide:YES afterDelay:1.0];
}

- (void)hideHUDView
{
    [stateHud hide:YES afterDelay:0.5];
}

#pragma mark -- 网络请求

////////////////////////////////////////////////////////////////////////////////

- (KTBaseRequest *)request
{
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isEqualToString:@""]) {
        userid = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"];
    }
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isEqualToString:@""]) {
        usertoken = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"];
    }
    
    KTDetailViewRequest *req = [[KTDetailViewRequest alloc] initWithProductID:_productid andUserID:[userid intValue] andUserToken:usertoken andSeckillID:_seckillID];
    return req;
}

- (NSArray *)parseResponse:(NSString *)resp
{
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        NSInteger code = [[respDict objectForKey:@"code"] intValue];
        
        if ([statusStr isEqualToString:@"OK"]) {
            if (code == 0) {
                if ([respDict objectForKey:@"data"] != nil && ![[respDict objectForKey:@"data"] isEqual:[NSNull null]]) {
                    id dataObj = [respDict objectForKey:@"data"];
                    
                    if ([dataObj isKindOfClass:[NSDictionary class]]) {
                        DetailViewVO *vo = [DetailViewVO DetailViewVOWithDictionary:dataObj];
                        
                        allVO = vo;
                        
                        NSMutableArray *objArr = [[NSMutableArray alloc] init];
                        
                        [_cartSkuArr removeAllObjects];
                        if (vo.productDict) {
                            [objArr setObject:vo.productDict atIndexedSubscript:0];
                            productDict = vo.productDict;
                            productURL = productDict.productURL;
                            shareContent = productDict.share_content;
                            for (NSDictionary *cartsku in productDict.cartSku) {
                                [_cartSkuArr addObject:[cartsku objectForKey:@"sku_id"]];
                            }
                            if (productDict.Pics.count > 0) {
                                UIImageView *shareView = [[UIImageView alloc] initWithFrame:CGRectZero];
                                [shareView sd_setImageWithURL:[NSURL  URLWithString:[productDict.Pics objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"Icon"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    _spImg = image;
                                }];
                            }
                            if(_productType <= 0){
                                _productType = [productDict.is_start_buy integerValue];
                            }
                            _seckillID = [productDict.seckill_id  integerValue];
                            if (_seckillID == 0) {
                                _seckillID = -1;
                            }
                            _skuQuantity = [vo.productDict.buy_min integerValue]>1?[vo.productDict.buy_min integerValue]:1;
                        }
                        
                        if (vo.brandDict && objArr.count > 0) {
                            brandDict = vo.brandDict;
                            [objArr setObject:brandDict atIndexedSubscript:1];
                        }
                        
                        NSMutableArray *picsArray = [[NSMutableArray alloc] init];
                        
                        NSMutableArray *cellDataArr_new = [[NSMutableArray alloc] init];
                        if (vo.likeArray.count > 0) {
                            HomeProductVO *likeVo;
                            for (NSInteger i = 0; i < ceil((CGFloat)vo.likeArray.count / 2.0); i++) {
                                NSMutableArray *cellArr = [[NSMutableArray alloc] init];
                                if ([vo.likeArray objectAtIndex:i * 2] && [[vo.likeArray objectAtIndex:i * 2] isKindOfClass:[HomeProductVO class]]) {
                                    [cellArr addObject:[vo.likeArray objectAtIndex:i * 2]];
                                    likeVo = [vo.likeArray objectAtIndex:i * 2];
                                    if (likeVo.pic.length > 0 && !likeVo.pic) {
                                        [picsArray addObject:likeVo.pic];
                                    }
                                }
                                
                                if (vo.likeArray.count > i * 2 + 1) {
                                    if ([vo.likeArray objectAtIndex:i * 2 + 1] && [[vo.likeArray objectAtIndex:i * 2 + 1] isKindOfClass:[HomeProductVO class]]) {
                                        [cellArr addObject:[vo.likeArray objectAtIndex:i * 2 + 1]];
                                        likeVo = [vo.likeArray objectAtIndex:i * 2 + 1];
                                        if (likeVo.pic.length > 0 && !likeVo.pic) {
                                            [picsArray addObject:likeVo.pic];
                                        }
                                    }
                                }
                                [cellDataArr_new addObject:cellArr];
                            }
                            
                            likeArray = cellDataArr_new;
                        }

                        [picsArray addObject:brandDict.brandlogo?brandDict.brandlogo:@""];
                        [picsArray addObjectsFromArray:productDict.Pics];
                        NSMutableArray *picarry = [[NSMutableArray alloc] init];
                        for (NSString *urlStr in productDict.detailArray) {
                            [picarry addObject:[NSString stringWithFormat:@"%@",urlStr]];
                        }
                        productDict.detailArray = picarry;
                        [picsArray addObjectsFromArray:picarry];
                        commentVO = vo.comments;
                        if (currentVC && productDict) {
                            [self performSelectorOnMainThread:@selector(loadImage:) withObject:picsArray waitUntilDone:YES];
                            [self performSelectorOnMainThread:@selector(layoutBottomView) withObject:nil waitUntilDone:YES];
                            [self performSelectorOnMainThread:@selector(btnShow) withObject:nil waitUntilDone:YES];
                        }else{
                            objArr = nil;
                            self.statefulState = FTStatefulTableViewControllerStateEmpty;
                        }
                        
                        if (vo.evaluate_list.count > 0) {
                            eveluateArray = vo.evaluate_list;
                        }
                        
                        if (vo.fav_img.count > 0) {
                            favimgArray = vo.fav_img;
                        }
                        
                        sectioNum = 5;
                        
                        return objArr;
                    }
                }else{
                    //self.statefulState = FTStatefulTableViewControllerStateEmpty;
                }
            }else{
                //self.statefulState = FTStatefulTableViewControllerError;
            }
        }else{
            //self.statefulState = FTStatefulTableViewControllerError;
        }
    }else{
        //self.statefulState = FTStatefulTableViewControllerError;
    }
    [self performSelectorOnMainThread:@selector(errView) withObject:nil waitUntilDone:YES];
    return nil;
}

#pragma mark 验证商品是否在购物车或已购买
-(void)checkProuductRequst
{
    NSString *cartid = nil;
    
    if ([[kata_CartManager sharedCartManager] hasCartID]) {
        cartid = [[kata_CartManager sharedCartManager] cartID];
    }
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isEqualToString:@""]) {
        userid = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"];
    }
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isEqualToString:@""]) {
        usertoken = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"];
    }
    
    KTProductNumRequest *req = [[KTProductNumRequest alloc] initWithUserID:[userid integerValue] andUserToken:usertoken andProductID:_productid andCartID:cartid];
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(checkProuductParseResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络异常，请稍后重试" waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (void)checkProuductParseResponse:(NSString *)resp
{
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            if (nil != [respDict objectForKey:@"data"] && ![[respDict objectForKey:@"data"] isEqual:[NSNull null]] && [[respDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *dataObj = (NSDictionary *)[respDict objectForKey:@"data"];
                _skuCartNum = [[dataObj objectForKey:@"cart_num"] integerValue];
                _skuOrderNum = [[dataObj objectForKey:@"order_num"] integerValue];
                if(_skuOrderNum >= [productDict.buy_max integerValue] && [productDict.buy_max integerValue] != 0){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"该商品最多可购买%@件,您已购买过该商品", productDict.buy_max] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                    [alert show];
                    alert.tag = 10001;
                }else if ((_skuCartNum >= [productDict.buy_max integerValue] || _skuCartNum >= _skuNum) && !fastFlag  && [productDict.buy_max integerValue] != 0) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"该商品最多可购买%zi件,将替换之前加入购物车的同类商品", [productDict.buy_max integerValue]>=_skuNum?_skuNum:[productDict.buy_max integerValue]] delegate:self cancelButtonTitle:@"替换" otherButtonTitles:@"取消", nil];
                    [alert show];
                    alert.tag = 10002;
                }else{
                    [_cartBtn setEnabled:NO];
                    [_buyBtn setEnabled:NO];
                    [self addToCartRequst];
                }
                return;
            } else {
            }
        } else {
        }
    } else {
    }
    [self hideHUDView];
    [_cartBtn setEnabled:YES];
    [_buyBtn setEnabled:YES];
    [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络异常，请稍后重试" waitUntilDone:YES];
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1 && alertView.tag == 88888888) {
        NSString *telStr = [NSString stringWithFormat:@"tel://%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"service_phone"]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telStr]];
    }

    if (buttonIndex == 0 && alertView.tag == 10002) {
        [self performSelector:@selector(addToCartRequst) withObject:nil afterDelay:0.3];
        [_cartBtn setEnabled:NO];
        [_buyBtn setEnabled:NO];
        [self hideHUDView];
    }else{
        [_cartBtn setEnabled:YES];
        [_buyBtn setEnabled:YES];
        [self hideHUDView];
    }
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
}

#pragma mark 预加载详情图片
-(void)loadImage:(NSArray *)array
{
    if (btnArray.count > 0) {
        [(UIButton*)btnArray[2] setTitle:[NSString stringWithFormat:@"评价(%@)", commentVO.comments_count] forState:UIControlStateNormal];
    }
    [self hideHUDView];
    [[SDWebImagePrefetcher sharedImagePrefetcher] setDelegate:self];
    [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:array];
}

-(void) chaneCellHegith:(NSMutableDictionary *)heightDict
{
    NSString *imgurl = [heightDict objectForKey:@"url"];
    CGFloat hight = [[heightDict objectForKey:@"hight"] floatValue];
    if ([imageHeightDict objectForKey:imgurl] == nil) {
        [imageHeightDict setObject:[NSNumber numberWithFloat:hight] forKey:imgurl];
        [self.tableView reloadData];
    }
}

#pragma mark SDWebImagePrefetcher 委托方法
- (void)imagePrefetcher:(SDWebImagePrefetcher *)imagePrefetcher didFinishWithTotalCount:(NSUInteger)totalCount skippedCount:(NSUInteger)skippedCount
{
    ;
}

#pragma mark SDWebImagePrefetcher 委托方法
- (void)imagePrefetcher:(SDWebImagePrefetcher *)imagePrefetcher didPrefetchURL:(NSURL *)imageURL finishedCount:(NSUInteger)finishedCount totalCount:(NSUInteger)totalCount
{
    NSString *urlStr = [NSString stringWithFormat:@"%@", imageURL];
    UIImage *image = [[SDImageCache  sharedImageCache] imageFromMemoryCacheForKey:urlStr];
    if (image) {
        CGFloat hight = ScreenW/image.size.width*image.size.height;
        [imageHeightDict setObject:[NSNumber numberWithFloat:hight] forKey:urlStr];
        [self.tableView reloadData];
    }
}

#pragma mark -
#pragma tableView delegate && datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (productDict) {
        if (!((UIButton *)btnArray[0]).selected) {
            return sectioNum - 2;
        }
    }
    return sectioNum;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return 3 + productDict.eventArray.count;
        }
            break;
        case 1:
        {
            if (brandDict.brandID) {
                return 1;
            }
            return 0;
        }
            break;
        case 2:
        {
            if (productDict) {
                if (((UIButton *)btnArray[0]).selected) {
                    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                    return productDict.detailArray.count;
                }else if (((UIButton *)btnArray[1]).selected){
                    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                    NSInteger cellRow = 0;
                    if (productDict.ColorInfo.count > 0) {
                        cellRow += 1;
                        [sizeArray addObject:productDict.ColorInfo];
                    }
                    
                    if (productDict.SizeInfo.count > 0) {
                        cellRow += 1;
                        [sizeArray addObject:productDict.SizeInfo];
                    }
                    
                    if (brandDict.brandTitle) {
                        cellRow += 1;
                        [sizeArray addObject:brandDict.brandTitle];
                    }
                    
                    if (productDict.ExtraInfo.count > 0) {
                        cellRow += productDict.ExtraInfo.count;
                        for (ExtraInfoVO *vo in productDict.ExtraInfo) {
                            [sizeArray addObject:vo];
                        }
                    }
                    return cellRow;
                }else if (((UIButton *)btnArray[2]).selected){
                    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                    if (commentVO) {
                        return commentVO.comments.count + 1;
                    }
                    return 0;
                }else if (((UIButton *)btnArray[3]).selected){
                    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                    return likeArray.count;
                }
            }
            return 0;
        }
            break;
        case 3:
            if (favimgArray.count > 0) {
                return 2;
            }else{
                return 0;
            }
            break;
        case 4:
            if (eveluateArray.count > 3) {
                return 6;
            }
            return eveluateArray.count + 3;
        default:
            break;
    }
    
    return 0;
}

-(void)cellBtnClick:(UIButton *)sender{
    for (NSInteger i = 0; i < btnArray.count; i++) {
        UIButton *btn = btnArray[i];
        if (btn == sender) {
            btn.selected = YES;
            [self.tableView reloadData];
            lineLbl.frame = CGRectMake(i*ScreenW/4+10, 38, ScreenW/4-20, 2);
            [btn setTitleColor:LMH_COLOR_SKIN forState:UIControlStateNormal];
        }else{
            btn.selected = NO;
            [btn setTitleColor:LMH_COLOR_BLACK forState:UIControlStateNormal];
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return sectionView;
    }
    return nil;
}

- (NSInteger)numberOfPages
{
    NSInteger bannerCount = productDict.Pics.count;
    return bannerCount;
}

- (UIView *)pageAtIndex:(NSInteger)index
{
    if (index < productDict.Pics.count) {
        NSString *imageName = productDict.Pics[index];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenW)];
        imageView.backgroundColor = LMH_COLOR_LIGHTLINE;
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:nil];
        return imageView;
    }
    return nil;
}

- (void)didClickPage:(XLCycleScrollView *)csView atIndex:(NSInteger)index
{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const IMG = @"IMG0";
    static NSString *const TITLE = @"TITLE";
    static NSString *const TAG = @"TAG";
    static NSString *const ACT = @"ACT";
    static NSString *const BRAND = @"BRAND";
    static NSString *const LIKE = @"LIKE";
    static NSString *const WAITTING = @"waitting";
    static NSString *CELL_SECTION2_0 = @"SECTION2_0";
    static NSString *CELL_SECTION2_1 = @"SECTION2_1";
    static NSString *CELL_SECTION3_0 = @"SECTION3_0";
    static NSString *CELL_SECTION3_1 = @"SECTION3_1";
    static NSString *CELL_SECTION3_2_NONE = @"CELL_SECTION3_2_NONE";
    static NSString *CELL_SECTION3_2 = @"SECTION3_2";
    static NSString *CELL_SECTION3_3 = @"SECTION3_3";
    
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    CGFloat w = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    
    if (allVO) {
        if (section == 0) {
            if (row == 0) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IMG];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IMG];
                    
                    _bannerFV = [[XLCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenW) animationDuration:0];
                    
                    _bannerFV.xldelegate = self;
                    _bannerFV.xldatasource = self;
                    [cell addSubview:_bannerFV];
                    
                    timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, ScreenW-20, ScreenW, 20)];
                    timeLbl.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
                    [timeLbl setFont:LMH_FONT_13];
                    [timeLbl setTextColor:[UIColor whiteColor]];
                    [timeLbl setTag:1001];
                    [_bannerFV addSubview:timeLbl];
                    
                    NSTimeInterval difftime = [productDict.diffTime longLongValue];
                    NSInteger day = difftime/3600/24;
                    NSInteger hours = (long)difftime%(3600*24)/3600;
                    NSInteger minus = (long)difftime%3600/60;
                    NSInteger sec = (long)difftime%60;
                    
                    NSString *timeStr = [NSString stringWithFormat:@"    限时打折:%zi天%zi小时%zi分%zi秒", day, hours, minus, sec];
                    if ([productDict.diffTime longLongValue] <= 0) {
                        timeStr = @"    限量打折即将结束";
                    }
                    
                    if (!limitTimer) {
                        limitTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(compareCurrentTime) userInfo:nil repeats:YES];
                    }
                    [timeLbl setText:timeStr];
                }
   
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;
            } else if (row == 1) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TITLE];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TITLE];
                }
                cell.textLabel.frame = CGRectMake(12, 0, ScreenW-20, 30);
                cell.textLabel.numberOfLines = 2;// 不可少Label属性之一
                cell.textLabel.backgroundColor = [UIColor clearColor];
                cell.textLabel.lineBreakMode = NSLineBreakByTruncatingTail;// 不可少Label属性之二
                [cell.textLabel setText:productDict.Title];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.textLabel setFont:LMH_FONT_15];
                [cell.textLabel setTextColor:LMH_COLOR_BLACK];
                
                return cell;
            } else if (row == 2) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TAG];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TAG];
                    
                    _priceView = [[UIView alloc] initWithFrame:CGRectMake(12, 0, w - 20, 30)];
                    [_priceView setBackgroundColor:[UIColor clearColor]];
                    
                    __ourPriceLbl = [[UILabel alloc] initWithFrame:CGRectZero];
                    __ourPriceLbl.textColor = LMH_COLOR_SKIN;
                    __ourPriceLbl.textAlignment = NSTextAlignmentCenter;
                    __ourPriceLbl.lineBreakMode = NSLineBreakByTruncatingTail;
                    __ourPriceLbl.numberOfLines = 1;
                    __ourPriceLbl.font = LMH_FONT_16;
                    [_priceView addSubview:__ourPriceLbl];
                    
                    if (productDict.OurPrice) {
                        NSString *OurPrice;
                        CGFloat payAmount = [productDict.OurPrice floatValue];
                        if ((payAmount * 10) - (int)(payAmount * 10) > 0) {
                            OurPrice = [NSString stringWithFormat:@"¥%0.2f",[productDict.OurPrice floatValue]];
                        } else if(payAmount - (int)payAmount > 0) {
                            OurPrice = [NSString stringWithFormat:@"¥%0.1f",[productDict.OurPrice floatValue]];
                        } else {
                            OurPrice = [NSString stringWithFormat:@"¥%0.0f",[productDict.OurPrice floatValue]];
                        }
                        [__ourPriceLbl setText:OurPrice];
                    } else {
                        [__ourPriceLbl setText:@"￥"];
                    }
                    CGSize ourSize = [__ourPriceLbl.text sizeWithFont:__ourPriceLbl.font];
                    [__ourPriceLbl setFrame:CGRectMake(4, 0, ourSize.width, 30)];
                    
                    __marketPriceLbl = [[UILabel alloc] initWithFrame:CGRectZero];
                    __marketPriceLbl.font = LMH_FONT_13;
                    __marketPriceLbl.textColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
                    __marketPriceLbl.textAlignment = NSTextAlignmentCenter;
                    __marketPriceLbl.lineBreakMode = NSLineBreakByTruncatingTail;
                    __marketPriceLbl.numberOfLines = 1;
                    [_priceView addSubview:__marketPriceLbl];
                    
                    if (productDict.MarketPrice) {
                        NSString *MarketPrice;
                        CGFloat sive = [productDict.MarketPrice floatValue];
                        if ((sive * 10) - (int)(sive * 10) > 0) {
                            MarketPrice = [NSString stringWithFormat:@"¥%0.2f",[productDict.MarketPrice floatValue]];
                        } else if(sive - (int)sive > 0) {
                            MarketPrice = [NSString stringWithFormat:@"¥%0.1f",[productDict.MarketPrice floatValue]];
                        } else {
                            MarketPrice = [NSString stringWithFormat:@"¥%0.0f",[productDict.MarketPrice floatValue]];
                        }
                        __marketPriceLbl.text = MarketPrice;
                    } else {
                        __marketPriceLbl.text = @"￥";
                    }
                    CGSize marketSize = [__marketPriceLbl.text sizeWithFont:__marketPriceLbl.font];
                    [__marketPriceLbl setFrame:CGRectMake(CGRectGetMaxX(__ourPriceLbl.frame)+5, 3, marketSize.width + 4, 30)];
                    UILabel *marketLine = [[UILabel alloc] initWithFrame:CGRectMake(4, CGRectGetHeight(__marketPriceLbl.frame)/2 - 0.5, marketSize.width, 0.5)];
                    marketLine.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
                    [__marketPriceLbl addSubview:marketLine];
                    
                    __saleTipLbl = [[UILabel alloc] initWithFrame:CGRectZero];
                    __saleTipLbl.textColor = LMH_COLOR_GRAY;
                    __saleTipLbl.textAlignment = NSTextAlignmentCenter;
                    __saleTipLbl.lineBreakMode = NSLineBreakByTruncatingTail;
                    __saleTipLbl.numberOfLines = 1;
                    [__saleTipLbl setFont:[UIFont systemFontOfSize:13]];
                    
                    [_priceView addSubview:__saleTipLbl];
                    
                    //送多少金豆
                    UIImageView *jifenView = [[UIImageView alloc]initWithFrame:CGRectZero];
                    jifenView.image = [UIImage imageNamed:@"border"];
                    [cell addSubview:jifenView];
                    UILabel *jifenLabel = [[UILabel alloc]initWithFrame:CGRectZero];
                    jifenLabel.backgroundColor = [UIColor clearColor];
                    
                    jifenLabel.text = [NSString stringWithFormat:@"送%zi金豆", [productDict.OurPrice integerValue]];
                    jifenLabel.font = FONT(13);
                    jifenLabel.textColor = LMH_COLOR_GRAY;
                    jifenLabel.textAlignment = NSTextAlignmentCenter;
                    
                    CGSize jfSize = [jifenLabel.text sizeWithFont:LMH_FONT_13 constrainedToSize:CGSizeMake((ScreenW-20)/2, 20) lineBreakMode:NSLineBreakByTruncatingTail];
                    [jifenView setFrame:CGRectMake(12, CGRectGetMaxY(_priceView.frame)+5, jfSize.width+10, 20)];
                    [jifenLabel setFrame:CGRectMake(0, 0, jfSize.width+10, 20)];
                    [jifenView addSubview:jifenLabel];
                    if (_productType > 0) {
                        [jifenView removeFromSuperview];
                    }
                    if (productDict.SaleTip && ![productDict.SaleTip isEqualToString:@""]) {
                        __saleTipLbl.text = [productDict.SaleTip stringByAppendingString:@"折"];
                        
                        CGSize tipSize = [__saleTipLbl.text sizeWithFont:__saleTipLbl.font];
                        [__saleTipLbl setFrame:CGRectMake(CGRectGetMaxX(jifenLabel.frame) + 10, CGRectGetMaxY(_priceView.frame)+5, tipSize.width + 8, 20)];
                        
                        if (_productType > 0) {
                            [__saleTipLbl setFrame:CGRectMake(0, CGRectGetMaxY(_priceView.frame)+5, tipSize.width + 8, 20)];
                        }
                        
                        UIImageView *tipBg = [[UIImageView alloc] initWithFrame:__saleTipLbl.frame];
                        tipBg.image = [UIImage imageNamed:@"border"];
                        tipBg.layer.cornerRadius = 1;
                        [_priceView insertSubview:tipBg belowSubview:__saleTipLbl];
                    }
                    //收藏
                    collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    collectionBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                    collectionBtn.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
                    collectionBtn.backgroundColor = [UIColor clearColor];
                    [collectionBtn setFrame:CGRectMake(ScreenW/5*2, CGRectGetMaxY(_priceView.frame), (ScreenW/5*3-10)/2, 25)];
                    collectionBtn.titleLabel.font = FONT(15);
                    [collectionBtn setImage:[UIImage imageNamed:@"icon_collection"] forState:UIControlStateNormal];
                    _isFaved = ![productDict.IsFaved  boolValue];
                    [self performSelectorOnMainThread:@selector(favOpSuccess) withObject:nil waitUntilDone:YES];
                    [collectionBtn addTarget:self action:@selector(favIconTaped) forControlEvents:UIControlEventTouchUpInside];
                    [collectionBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 12)];
                    [collectionBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                    [cell addSubview:collectionBtn];
                    
                    //评论
                    eveluateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    eveluateBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                    eveluateBtn.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
                    [eveluateBtn setFrame:CGRectMake(CGRectGetMaxX(collectionBtn.frame), CGRectGetMaxY(_priceView.frame), (ScreenW/5*3-10)/2, 25)];
                    eveluateBtn.titleLabel.font = FONT(15);
                    [eveluateBtn addTarget:self action:@selector(eveluateClick) forControlEvents:UIControlEventTouchUpInside];
                    [eveluateBtn setImage:LOCAL_IMG(@"new_coment") forState:UIControlStateNormal];
                    [eveluateBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 12)];
                    [eveluateBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                    [cell addSubview:eveluateBtn];
                    
                    //联系客服
                    UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    callBtn.frame = CGRectMake(220, 48, 90, 25);
                    callBtn.backgroundColor = [UIColor clearColor];
                    [callBtn setTitle:@"联系客服" forState:UIControlStateNormal];
                    [callBtn setImage:[UIImage imageNamed:@"icon_callPhone"] forState:UIControlStateNormal];
                    [callBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 12)];
                    [callBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                    callBtn.titleLabel.font = FONT(15);
                    [callBtn addTarget:self action:@selector(callBtnClick) forControlEvents:UIControlEventTouchUpInside];
                    //[cell addSubview:callBtn];
                    
                    UILabel *celllineLbl = [[UILabel alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(eveluateBtn.frame)+15, ScreenW - 24, 0.5)];
                    [celllineLbl setBackgroundColor:LMH_COLOR_LIGHTLINE];
                    [cell addSubview:celllineLbl];
                    
                    [cell.contentView addSubview:_priceView];
                }
                
                [collectionBtn setTitle:[NSString stringWithFormat:@"喜欢(%d)",[allVO.fav_count intValue]] forState:UIControlStateNormal];
                [eveluateBtn setTitle:[NSString stringWithFormat:@"评论(%d)",[allVO.evaluate_count intValue]] forState:UIControlStateNormal];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;
            } else {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ACT];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ACT];
                }
                [cell.textLabel setText:productDict.eventArray[row - 3]];
                [cell.textLabel setTextColor:[UIColor colorWithRed:0.27 green:0.27 blue:0.27 alpha:1]];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell setBackgroundColor:[UIColor whiteColor]];
                [cell.textLabel setFont:LMH_FONT_15];
                
                return cell;
            }
        }else if (section == 1){//品牌专场
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BRAND];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BRAND];
                
                UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 101*ScreenW/360)];
                [imageview setImage:[UIImage imageNamed:@"slogin.jpg"]];
                [cell addSubview:imageview];
                
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = GRAY_CELL_COLOR;
            
            return cell;
        }else if (section == 2){
            if (((UIButton *)btnArray[0]).selected) {
                static NSString *CellIdentifierText = @"CellIdentifierImage";
                UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifierText];
                
                if (cell == nil) {
                    cell = [[LMHCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierText];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                NSURL *url = [NSURL URLWithString:productDict.detailArray[indexPath.row]];
                
                [(LMHCellView*)cell setImageURL:url];
                [(LMHCellView*)cell setDetailDelegate:self];
                
                return cell;
            }else if (((UIButton *)btnArray[1]).selected){
                static NSString *ROW1 = @"ROW1";
                static NSString *ROW2 = @"ROW2";
                static NSString *ROWOTHER = @"ROWOTHER";
                if (row == 0) {
                    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:ROW1];
                    if (cell == nil) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ROW1];
                        if (productDict.ColorInfo.count > 0) {
                            [cell.textLabel setTextColor:LMH_COLOR_GRAY];
                            [cell.textLabel setTextAlignment:NSTextAlignmentLeft];
                            [cell.textLabel setFont:LMH_FONT_15];
                            [cell.textLabel setNumberOfLines:1];
                            [cell.textLabel setLineBreakMode:NSLineBreakByTruncatingTail];
                            [cell.textLabel setText:[NSString stringWithFormat:@"%@", productDict.ColorPropName]];
                            CGSize nameSize = [cell.textLabel.text sizeWithFont:cell.textLabel.font];
                            [cell.textLabel setFrame:CGRectMake(12, 0, nameSize.width, 50)];
                            
                            CGFloat xOffset = CGRectGetMaxX(cell.textLabel.frame) + 20;
                            CGFloat yOffset = 0;
                            for (NSInteger i = 0; i < productDict.ColorInfo.count; i++) {
                                ColorInfoVO *colorVO = (ColorInfoVO *)[productDict.ColorInfo objectAtIndex:i];
                                
                                NSString *itemTitle = colorVO.Name;
                                CGSize titleSize = [itemTitle sizeWithFont:LMH_FONT_15];
                                CGFloat targetWidth = titleSize.width + 20;
                                if (targetWidth < 46) {
                                    targetWidth = 46;
                                }
                                
                                if (xOffset + targetWidth + 5 > w) {
                                    xOffset = CGRectGetMaxX(cell.textLabel.frame) + 20;
                                    yOffset += 50;
                                }
                                UILabel *propLbl = [[UILabel alloc] initWithFrame:CGRectMake(xOffset, yOffset, targetWidth, 50)];
                                [propLbl setText:itemTitle];
                                [propLbl setTextColor:LMH_COLOR_SKIN];
                                [propLbl setFont:LMH_FONT_15];
                                [cell addSubview:propLbl];
                                
                                xOffset = xOffset + targetWidth + 5;
                            }
                        }else if (productDict.SizeInfo.count > 0) {
                            [cell.textLabel setTextColor:LMH_COLOR_GRAY];
                            [cell.textLabel setTextAlignment:NSTextAlignmentLeft];
                            [cell.textLabel setFont:LMH_FONT_15];
                            [cell.textLabel setNumberOfLines:1];
                            [cell.textLabel setLineBreakMode:NSLineBreakByTruncatingTail];
                            [cell.textLabel setText:[NSString stringWithFormat:@"%@", productDict.SizePropName]];
                            CGSize nameSize = [cell.textLabel.text sizeWithFont:cell.textLabel.font];
                            [cell.textLabel setFrame:CGRectMake(12, 0, nameSize.width, 50)];
                            
                            CGFloat xOffset = CGRectGetMaxX(cell.textLabel.frame) + 20;
                            CGFloat yOffset = 0;
                            for (NSInteger i = 0; i < productDict.SizeInfo.count; i++) {
                                SizeInfoVO *sizeVO = (SizeInfoVO *)[productDict.SizeInfo objectAtIndex:i];
                                
                                NSString *itemTitle = sizeVO.Name;
                                CGSize titleSize = [itemTitle sizeWithFont:LMH_FONT_15];
                                CGFloat targetWidth = titleSize.width + 20;
                                if (targetWidth < 46) {
                                    targetWidth = 46;
                                }
                                
                                if (xOffset + targetWidth + 5 > w) {
                                    xOffset = CGRectGetMaxX(cell.textLabel.frame) + 20;
                                    yOffset += 50;
                                }
                                UILabel *propLbl = [[UILabel alloc] initWithFrame:CGRectMake(xOffset, yOffset, targetWidth, 50)];
                                [propLbl setText:itemTitle];
                                [propLbl setTextColor:LMH_COLOR_SKIN];
                                [propLbl setFont:LMH_FONT_15];
                                [cell addSubview:propLbl];
                                
                                xOffset = xOffset + targetWidth + 5;
                            }
                        }else if ([[sizeArray objectAtIndex:row] isKindOfClass:[ExtraInfoVO class]]) {
                            ExtraInfoVO *exvo = [sizeArray objectAtIndex:row];
                            if (!cell) {
                                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ROW1];
                                
                                [cell.textLabel setTextColor:LMH_COLOR_GRAY];
                                [cell.textLabel setTextAlignment:NSTextAlignmentLeft];
                                [cell.textLabel setFont:LMH_FONT_15];
                                [cell.textLabel setNumberOfLines:1];
                                [cell.textLabel setLineBreakMode:NSLineBreakByTruncatingTail];
                                [cell.textLabel setText:[NSString stringWithFormat:@"%@", exvo.Title]];
                                CGSize nameSize = [cell.textLabel.text sizeWithFont:cell.textLabel.font];
                                [cell.textLabel setFrame:CGRectMake(12, 0, nameSize.width, 50)];
                                
                                CGSize infoSize = [exvo.Info sizeWithFont:LMH_FONT_15];
                                if (infoSize.height > 50) {
                                    infoSize.height += 10;
                                }else{
                                    infoSize.height = 50;
                                }
                                UILabel *infoLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cell.textLabel.frame) + 20, 0, infoSize.width, infoSize.height)];
                                [infoLbl setText:exvo.Info];
                                [infoLbl setTextAlignment:NSTextAlignmentLeft];
                                [infoLbl setFont:LMH_FONT_15];
                                [infoLbl setNumberOfLines:0];
                                [infoLbl setLineBreakMode:NSLineBreakByCharWrapping];
                                [infoLbl setTextColor:LMH_COLOR_SKIN];
                                
                                [cell addSubview:infoLbl];
                            }
                        }else if([[sizeArray objectAtIndex:row] isKindOfClass:[NSString class]]){
                            [cell.textLabel setTextColor:LMH_COLOR_GRAY];
                            [cell.textLabel setTextAlignment:NSTextAlignmentLeft];
                            [cell.textLabel setFont:LMH_FONT_15];
                            [cell.textLabel setNumberOfLines:1];
                            [cell.textLabel setLineBreakMode:NSLineBreakByTruncatingTail];
                            [cell.textLabel setText:@"品牌"];
                            CGSize nameSize = [cell.textLabel.text sizeWithFont:cell.textLabel.font];
                            [cell.textLabel setFrame:CGRectMake(12, 0, nameSize.width, 50)];
                            
                            CGSize infoSize = [[sizeArray objectAtIndex:row] sizeWithFont:LMH_FONT_15];
                            if (infoSize.height > 50) {
                                infoSize.height += 10;
                            }else{
                                infoSize.height = 50;
                            }
                            UILabel *infoLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cell.textLabel.frame) + 20, 0, infoSize.width, infoSize.height)];
                            [infoLbl setText:[sizeArray objectAtIndex:row]];
                            [infoLbl setTextAlignment:NSTextAlignmentLeft];
                            [infoLbl setFont:LMH_FONT_15];
                            [infoLbl setNumberOfLines:0];
                            [infoLbl setLineBreakMode:NSLineBreakByCharWrapping];
                            [infoLbl setTextColor:LMH_COLOR_SKIN];
                            
                            [cell addSubview:infoLbl];
                        }
                    }
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }else if(row == 1){
                    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:ROW2];
                    if (cell == nil) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ROW2];
                        if (productDict.SizeInfo.count > 0 && productDict.ColorInfo.count > 0) {
                            [cell.textLabel setTextColor:LMH_COLOR_GRAY];
                            [cell.textLabel setTextAlignment:NSTextAlignmentLeft];
                            [cell.textLabel setFont:LMH_FONT_15];
                            [cell.textLabel setNumberOfLines:1];
                            [cell.textLabel setLineBreakMode:NSLineBreakByTruncatingTail];
                            [cell.textLabel setText:[NSString stringWithFormat:@"%@", productDict.SizePropName]];
                            CGSize nameSize = [cell.textLabel.text sizeWithFont:cell.textLabel.font];
                            [cell.textLabel setFrame:CGRectMake(12, 0, nameSize.width, 50)];
                            
                            CGFloat xOffset = CGRectGetMaxX(cell.textLabel.frame) + 20;
                            CGFloat yOffset = 0;
                            for (NSInteger i = 0; i < productDict.SizeInfo.count; i++) {
                                SizeInfoVO *sizeVO = (SizeInfoVO *)[productDict.SizeInfo objectAtIndex:i];
                                
                                NSString *itemTitle = sizeVO.Name;
                                CGSize titleSize = [itemTitle sizeWithFont:LMH_FONT_15];
                                CGFloat targetWidth = titleSize.width + 20;
                                if (targetWidth < 46) {
                                    targetWidth = 46;
                                }
                                
                                if (xOffset + targetWidth + 5 > w) {
                                    xOffset = CGRectGetMaxX(cell.textLabel.frame) + 20;
                                    yOffset += 50;
                                }
                                UILabel *propLbl = [[UILabel alloc] initWithFrame:CGRectMake(xOffset, yOffset, targetWidth, 50)];
                                [propLbl setText:itemTitle];
                                [propLbl setTextColor:LMH_COLOR_SKIN];
                                [propLbl setFont:LMH_FONT_15];
                                [cell addSubview:propLbl];
                                
                                xOffset = xOffset + targetWidth + 5;
                            }
                        }else if ([[sizeArray objectAtIndex:row] isKindOfClass:[ExtraInfoVO class]]) {
                            ExtraInfoVO *exvo = [sizeArray objectAtIndex:row];
                            
                            [cell.textLabel setTextColor:LMH_COLOR_GRAY];
                            [cell.textLabel setTextAlignment:NSTextAlignmentLeft];
                            [cell.textLabel setFont:LMH_FONT_15];
                            [cell.textLabel setNumberOfLines:1];
                            [cell.textLabel setLineBreakMode:NSLineBreakByTruncatingTail];
                            [cell.textLabel setText:[NSString stringWithFormat:@"%@", exvo.Title]];
                            CGSize nameSize = [cell.textLabel.text sizeWithFont:cell.textLabel.font];
                            [cell.textLabel setFrame:CGRectMake(12, 0, nameSize.width, 50)];
                            
                            CGSize infoSize = [exvo.Info sizeWithFont:LMH_FONT_15];
                            if (infoSize.height > 50) {
                                infoSize.height += 10;
                            }else{
                                infoSize.height = 50;
                            }
                            UILabel *infoLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cell.textLabel.frame) + 20, 0, infoSize.width, infoSize.height)];
                            [infoLbl setText:exvo.Info];
                            [infoLbl setTextAlignment:NSTextAlignmentLeft];
                            [infoLbl setFont:LMH_FONT_15];
                            [infoLbl setNumberOfLines:0];
                            [infoLbl setLineBreakMode:NSLineBreakByCharWrapping];
                            [infoLbl setTextColor:LMH_COLOR_SKIN];
                            
                            [cell addSubview:infoLbl];
                        }else if([[sizeArray objectAtIndex:row] isKindOfClass:[NSString class]]){
                            [cell.textLabel setTextColor:LMH_COLOR_GRAY];
                            [cell.textLabel setTextAlignment:NSTextAlignmentLeft];
                            [cell.textLabel setFont:LMH_FONT_15];
                            [cell.textLabel setNumberOfLines:1];
                            [cell.textLabel setLineBreakMode:NSLineBreakByTruncatingTail];
                            [cell.textLabel setText:@"品牌"];
                            CGSize nameSize = [cell.textLabel.text sizeWithFont:cell.textLabel.font];
                            [cell.textLabel setFrame:CGRectMake(12, 0, nameSize.width, 50)];
                            
                            CGSize infoSize = [[sizeArray objectAtIndex:row] sizeWithFont:LMH_FONT_15];
                            if (infoSize.height > 50) {
                                infoSize.height += 10;
                            }else{
                                infoSize.height = 50;
                            }
                            UILabel *infoLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cell.textLabel.frame) + 20, 0, infoSize.width, infoSize.height)];
                            [infoLbl setText:[sizeArray objectAtIndex:row]];
                            [infoLbl setTextAlignment:NSTextAlignmentLeft];
                            [infoLbl setFont:LMH_FONT_15];
                            [infoLbl setNumberOfLines:0];
                            [infoLbl setLineBreakMode:NSLineBreakByCharWrapping];
                            [infoLbl setTextColor:LMH_COLOR_SKIN];
                            
                            [cell addSubview:infoLbl];
                        }
                    }
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }else{
                    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:ROWOTHER];
                    if (!cell) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ROWOTHER];
                        if ([[sizeArray objectAtIndex:row] isKindOfClass:[ExtraInfoVO class]]) {
                            ExtraInfoVO *exvo = [sizeArray objectAtIndex:row];
                            
                            [cell.textLabel setTextColor:LMH_COLOR_GRAY];
                            [cell.textLabel setTextAlignment:NSTextAlignmentLeft];
                            [cell.textLabel setFont:LMH_FONT_15];
                            [cell.textLabel setNumberOfLines:1];
                            [cell.textLabel setLineBreakMode:NSLineBreakByTruncatingTail];
                            [cell.textLabel setText:[NSString stringWithFormat:@"%@", exvo.Title]];
                            CGSize nameSize = [cell.textLabel.text sizeWithFont:cell.textLabel.font];
                            [cell.textLabel setFrame:CGRectMake(12, 0, nameSize.width, 50)];
                            
                            CGSize infoSize = [exvo.Info sizeWithFont:LMH_FONT_15];
                            if (infoSize.height > 50) {
                                infoSize.height += 10;
                            }else{
                                infoSize.height = 50;
                            }
                            UILabel *infoLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cell.textLabel.frame) + 20, 0, infoSize.width, infoSize.height)];
                            [infoLbl setText:exvo.Info];
                            [infoLbl setTextAlignment:NSTextAlignmentLeft];
                            [infoLbl setFont:LMH_FONT_15];
                            [infoLbl setNumberOfLines:0];
                            [infoLbl setLineBreakMode:NSLineBreakByCharWrapping];
                            [infoLbl setTextColor:LMH_COLOR_SKIN];
                            
                            [cell addSubview:infoLbl];
                        }else if([[sizeArray objectAtIndex:row] isKindOfClass:[NSString class]]){
                            [cell.textLabel setTextColor:LMH_COLOR_GRAY];
                            [cell.textLabel setTextAlignment:NSTextAlignmentLeft];
                            [cell.textLabel setFont:LMH_FONT_15];
                            [cell.textLabel setNumberOfLines:1];
                            [cell.textLabel setLineBreakMode:NSLineBreakByTruncatingTail];
                            [cell.textLabel setText:@"品牌"];
                            CGSize nameSize = [cell.textLabel.text sizeWithFont:cell.textLabel.font];
                            [cell.textLabel setFrame:CGRectMake(12, 0, nameSize.width, 50)];
                            
                            CGSize infoSize = [[sizeArray objectAtIndex:row] sizeWithFont:LMH_FONT_15];
                            if (infoSize.height > 50) {
                                infoSize.height += 10;
                            }else{
                                infoSize.height = 50;
                            }
                            UILabel *infoLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cell.textLabel.frame) + 20, 0, infoSize.width, infoSize.height)];
                            [infoLbl setText:[sizeArray objectAtIndex:row]];
                            [infoLbl setTextAlignment:NSTextAlignmentLeft];
                            [infoLbl setFont:LMH_FONT_15];
                            [infoLbl setNumberOfLines:0];
                            [infoLbl setLineBreakMode:NSLineBreakByCharWrapping];
                            [infoLbl setTextColor:LMH_COLOR_SKIN];
                            [cell addSubview:infoLbl];
                        }
                    }
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
            }else if (((UIButton *)btnArray[2]).selected){
                static NSString *CellIdentifier0 = @"CellIdentifier0";
                static NSString *CellIdentifierOther = @"CellIdentifier";
                
                if (row == 0 && [commentVO.comments_count integerValue] > 0) {
                    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier0];
                    
                    if (cell == nil) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier0];
                        commentLbl = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 80, 40)];
                        [commentLbl setText:@"综合评分"];
                        [commentLbl setTextColor:[UIColor colorWithRed:0.54 green:0.54 blue:0.54 alpha:1]];
                        [cell addSubview:commentLbl];
                        
                        sroceLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(commentLbl.frame)+5, 0, 30, 40)];
                        [sroceLbl setText:[commentVO.comments_sroce stringValue]];
                        [sroceLbl setTextColor:[UIColor colorWithRed:0.99 green:0.31 blue:0.41 alpha:1]];
                        [cell addSubview:sroceLbl];
                        
                        srocrView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(sroceLbl.frame) + 20, 0, CGRectGetWidth(cell.frame)-CGRectGetMaxX(sroceLbl.frame) - 10, 40)];
                        [cell addSubview:srocrView];
                    }
                    CGFloat offx = 0;
                    NSInteger stratAll = ceilf([commentVO.comments_sroce floatValue]);
                    NSInteger startNum = [commentVO.comments_sroce intValue];
                    for (NSInteger i = 0; i < 5; i++) {
                        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(offx, 10, 20, 20)];
                        if (i < startNum) {
                            [imgView setImage:[UIImage imageNamed:@"start"]];
                        }else if (i < stratAll) {
                            [imgView setImage:[UIImage imageNamed:@"starthalf"]];
                        }else{
                            [imgView setImage:[UIImage imageNamed:@"startgray"]];
                        }
                        
                        offx += 25;
                        [srocrView addSubview:imgView];
                    }
                    
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }else if([commentVO.comments_count integerValue] > 0){
                    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifierOther];
                    
                    if (cell == nil) {
                        cell = [[CommentsViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierOther];
                    }
                    
                    if ([commentVO.comments[row - 1] isKindOfClass:[CommentsVO class]]) {
                        [(CommentsViewCell *)cell setComments:commentVO.comments[row - 1]];
                    }
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }else{
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierOther];
                    if (!cell) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierOther];
                        
                        UILabel *noLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 40)];
                        noLbl.backgroundColor = [UIColor clearColor];
                        [noLbl setText:@"暂无评论"];
                        [noLbl setFont:FONT(16.0)];
                        [noLbl setTextAlignment:NSTextAlignmentCenter];
                        [noLbl setTextColor:[UIColor grayColor]];
                        [cell addSubview:noLbl];
                    }
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
            }else if (((UIButton *)btnArray[3]).selected){
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LIKE];
                if (!cell) {
                    cell = [[AloneProductCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LIKE];
                }
                
                if (likeArray.count > 0) {
                    
                    [(AloneProductCellTableViewCell*)cell setCellFrame:self.view.frame];
                    [(AloneProductCellTableViewCell*)cell setDelegate:self];
                    [(AloneProductCellTableViewCell*)cell setRow:row];
                    
                    [(AloneProductCellTableViewCell*)cell layoutUI:likeArray[row] andColnum:2 is_act:NO is_type:NO];
                }
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            return nil;
        }else if(section == 3){
            if (row == 0) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_SECTION2_0];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_SECTION2_0];
                    
                    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 39.5, ScreenW-20,0.5)];
                    lineLabel.backgroundColor = LMH_COLOR_LINE;
                    [cell.contentView addSubview:lineLabel];
                }
                
                UIImageView *imgView = (UIImageView*)[cell.contentView viewWithTag:3001];
                if (!imgView) {
                    imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 11, 20, 18)];
                    imgView.image = LOCAL_IMG(@"new_fav");
                    imgView.tag = 3001;
                    
                    [cell.contentView addSubview:imgView];
                }
                
                UILabel *textLabel = (UILabel *)[cell.contentView viewWithTag:3002];
                if (!textLabel) {
                    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame)+5, 0, ScreenW-CGRectGetMaxX(imgView.frame)-10, 40)];
                    textLabel.font = LMH_FONT_15;
                    textLabel.textColor = LMH_COLOR_BLACK;
                    textLabel.tag = 3002;
                    
                    [cell.contentView addSubview:textLabel];
                }
                textLabel.text = [NSString stringWithFormat:@"%zi人喜欢了",[allVO.fav_count integerValue]];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;
            }else{
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_SECTION2_1];
                if (!cell) {
                    cell = [[LMH_ImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_SECTION2_1];
                }
                [(LMH_ImageTableViewCell *)cell layoutUI:favimgArray];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;
            }
        }else if(section == 4){
            if (row == 0) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_SECTION3_0];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_SECTION3_0];
                    
                    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 11, 20, 18)];
                    imgView.image = LOCAL_IMG(@"new_coment");
                    [cell.contentView addSubview:imgView];
                    
                    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 39.5, ScreenW-20,0.5)];
                    lineLabel.backgroundColor = LMH_COLOR_LINE;
                    [cell.contentView addSubview:lineLabel];
                }
                
                UILabel *textLabel = (UILabel *)[cell.contentView viewWithTag:3002];
                if (!textLabel) {
                    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(33, 0, ScreenW-33, 40)];
                    textLabel.font = LMH_FONT_15;
                    textLabel.textColor = LMH_COLOR_BLACK;
                    textLabel.tag = 3002;
                    
                    [cell.contentView addSubview:textLabel];
                }
                textLabel.text = [NSString stringWithFormat:@"评论(%zi)",[allVO.evaluate_count integerValue]];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;
            }else if(row <= (eveluateArray.count>3?3:eveluateArray.count)){
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_SECTION3_1];
                if (!cell) {
                    cell = [[LMH_ReviewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_SECTION3_1];
                }
                if (row <= eveluateArray.count) {
                    [(LMH_ReviewTableViewCell *)cell layoutUI:eveluateArray[row-1]];
                    [(LMH_ReviewTableViewCell *)cell setReviewDelegate:self];
                }
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;
            }else if(row == (eveluateArray.count>3?4:eveluateArray.count+1)){
                if (eveluateArray.count <= 3) {
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_SECTION3_2_NONE];
                    if (!cell) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_SECTION3_2_NONE];
                    }
                    
                    return cell;
                }
                
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_SECTION3_2];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_SECTION3_2];
                    
                    UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 40)];
                    [moreBtn setTitle:@"更多评论" forState:UIControlStateNormal];
                    [moreBtn.titleLabel setFont:LMH_FONT_15];
                    [moreBtn setTitleColor:LMH_COLOR_BLACK forState:UIControlStateNormal];
                    [moreBtn setImage:LOCAL_IMG(@"new_rightrow") forState:UIControlStateNormal];
                    moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                    moreBtn.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
                    [moreBtn addTarget:self action:@selector(pushMoreVC) forControlEvents:UIControlEventTouchUpInside];
                    
                    //UIEdgeInsetsMake (CGFloat top, CGFloat left, CGFloat bottom, CGFloat right);
                    [moreBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -120)];
                    [moreBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -50, 0, 0)];
                    
                    [cell.contentView addSubview:moreBtn];
                    
                    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 39.5, ScreenW-20,0.5)];
                    lineLabel.backgroundColor = LMH_COLOR_LINE;
                    [cell.contentView addSubview:lineLabel];
                }
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;
            }else{
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_SECTION3_3];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_SECTION3_3];
                    
                    textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, ScreenW-80, 30)];
                    textField.placeholder = @"说点儿什么吧~";
                    textField.backgroundColor = LMH_COLOR_LIGHTLINE;
                    textField.font = LMH_FONT_15;
                    textField.delegate = self;
                    [cell.contentView addSubview:textField];
                    
                    reverBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW-60, 10, 50, 30)];
                    [reverBtn setTitle:@"发表" forState:UIControlStateNormal];
                    [reverBtn.titleLabel setFont:LMH_FONT_15];
                    [reverBtn setTitleColor:LMH_COLOR_GRAY forState:UIControlStateNormal];
                    reverBtn.layer.borderColor = LMH_COLOR_LINE.CGColor;
                    reverBtn.layer.borderWidth = 0.5;
                    [reverBtn addTarget:self action:@selector(currentClick) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:reverBtn];
                    
                    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(reverBtn.frame)+9.5, ScreenW-20, 0.5)];
                    lineLabel.backgroundColor = LMH_COLOR_LINE;
                    [cell.contentView addSubview:lineLabel];
                }
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;
            }
        }
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WAITTING];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WAITTING];
            UIActivityIndicatorView *waitting = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            waitting.center = CGPointMake(CGRectGetWidth(cell.bounds) / 2, 280/2);
            [cell.contentView addSubview:waitting];
            [waitting startAnimating];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }else if (section == 2){
        return 40;
    }else if(section == 3){
        if (favimgArray.count > 0) {
            return 10;
        }
        return 0;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    CGFloat w = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    
    if (section == 0) {
        if (row == 0) {
            return ScreenW;
        } else if(row == 1){
            if (productDict) {
                CGSize size = [productDict.Title sizeWithFont:LMH_FONT_15 constrainedToSize:CGSizeMake(w-20, 100000) lineBreakMode:NSLineBreakByCharWrapping];
                
                return size.height+10;
            }
            return 40;
        } else if(row == 2){
            return 70;
        }else{
            return 30;
        }
    } else if (section == 1){
        return 101*ScreenW/360;
    }else if(section == 2){
        if (((UIButton *)btnArray[0]).selected) {
            NSInteger row = indexPath.row;
            
            NSNumber *numberHeight = [imageHeightDict objectForKey:productDict.detailArray[row]];
            CGFloat height = [numberHeight floatValue];
            
            if (height==0) {
                height = 150;// default is 300;
            }
            return height;
        }else if (((UIButton *)btnArray[1]).selected){
            CGFloat w = CGRectGetWidth([[UIScreen mainScreen] bounds]);
            
            if (row == 0) {
                if (productDict.ColorInfo.count > 0) {
                    CGSize nameSize = [productDict.ColorPropName sizeWithFont:LMH_FONT_15];
                    CGFloat xOffset = nameSize.width + 32;
                    CGFloat yOffset = 0;
                    for (NSInteger i = 0; i < productDict.ColorInfo.count; i++) {
                        ColorInfoVO *colorVO = (ColorInfoVO *)[productDict.ColorInfo objectAtIndex:i];
                        
                        NSString *itemTitle = colorVO.Name;
                        CGSize titleSize = [itemTitle sizeWithFont:LMH_FONT_15];
                        CGFloat targetWidth = titleSize.width + 20;
                        if (targetWidth < 46) {
                            targetWidth = 46;
                        }
                        
                        if (xOffset + targetWidth + 5 > w) {
                            xOffset = nameSize.width + 32;
                            yOffset += 50;
                        }
                        
                        xOffset = xOffset + targetWidth + 5;
                    }
                    return yOffset += 50;
                }
                if (productDict.SizeInfo.count > 0) {
                    CGSize nameSize = [productDict.SizePropName sizeWithFont:LMH_FONT_15];
                    CGFloat xOffset = nameSize.width + 32;
                    CGFloat yOffset = 0;
                    for (NSInteger i = 0; i < productDict.SizeInfo.count; i++) {
                        SizeInfoVO *sizeVO = (SizeInfoVO *)[productDict.SizeInfo objectAtIndex:i];
                        
                        NSString *itemTitle = sizeVO.Name;
                        CGSize titleSize = [itemTitle sizeWithFont:LMH_FONT_15];
                        CGFloat targetWidth = titleSize.width + 20;
                        if (targetWidth < 46) {
                            targetWidth = 46;
                        }
                        if (xOffset + targetWidth + 5 > w) {
                            xOffset = 32 + nameSize.width;
                            yOffset += 50;
                        }
                        xOffset = xOffset + targetWidth + 5;
                    }
                    return yOffset + 50;
                }
                
                if ([[sizeArray objectAtIndex:row] isKindOfClass:[ExtraInfoVO class]]) {
                    
                    ExtraInfoVO *vo = (ExtraInfoVO *)[sizeArray objectAtIndex:row];
                    if (vo.Info) {
                        CGSize infosize = [vo.Info sizeWithFont:LMH_FONT_15 constrainedToSize:CGSizeMake(235, 100000) lineBreakMode:NSLineBreakByCharWrapping];
                        return infosize.height;
                    } else if (vo.Title) {
                        return 50;
                    }
                }
                
                if ([sizeArray[row] isKindOfClass:[NSString class]]) {
                    CGSize infoSize = [[sizeArray objectAtIndex:row] sizeWithFont:LMH_FONT_15];
                    if (infoSize.height > 50) {
                        infoSize.height += 10;
                    }else{
                        infoSize.height = 50;
                    }
                    return infoSize.height;
                }
                
            }else if(row == 1){
                if (productDict.SizeInfo.count > 0) {
                    CGSize nameSize = [productDict.SizePropName sizeWithFont:LMH_FONT_15];
                    CGFloat xOffset = nameSize.width + 32;
                    CGFloat yOffset = 0;
                    for (NSInteger i = 0; i < productDict.SizeInfo.count; i++) {
                        SizeInfoVO *sizeVO = (SizeInfoVO *)[productDict.SizeInfo objectAtIndex:i];
                        
                        NSString *itemTitle = sizeVO.Name;
                        CGSize titleSize = [itemTitle sizeWithFont:LMH_FONT_15];
                        CGFloat targetWidth = titleSize.width + 20;
                        if (targetWidth < 46) {
                            targetWidth = 46;
                        }
                        if (xOffset + targetWidth + 5 > w) {
                            xOffset = 20 + nameSize.width;
                            yOffset += 50;
                        }
                        xOffset = xOffset + targetWidth + 5;
                    }
                    return yOffset + 50;
                }
                
                if ([[sizeArray objectAtIndex:row] isKindOfClass:[ExtraInfoVO class]]) {
                    ExtraInfoVO *vo = (ExtraInfoVO *)[sizeArray objectAtIndex:row];
                    if (vo.Info) {
                        CGSize infosize = [vo.Info sizeWithFont:LMH_FONT_15 constrainedToSize:CGSizeMake(235, 100000) lineBreakMode:NSLineBreakByCharWrapping];
                        if (infosize.height > 50) {
                            return infosize.height + 10;
                        }
                        return 50;
                    } else if (vo.Title) {
                        return 50;
                    }
                }
                
                if ([sizeArray[row] isKindOfClass:[NSString class]]) {
                    CGSize infoSize = [[sizeArray objectAtIndex:row] sizeWithFont:LMH_FONT_15];
                    if (infoSize.height > 50) {
                        infoSize.height += 10;
                    }else{
                        infoSize.height = 50;
                    }
                    return infoSize.height;
                }
            }else{
                if ([[sizeArray objectAtIndex:row] isKindOfClass:[ExtraInfoVO class]]) {
                    ExtraInfoVO *vo = (ExtraInfoVO *)[sizeArray objectAtIndex:row];
                    if (vo.Info) {
                        CGSize infosize = [vo.Info sizeWithFont:LMH_FONT_15 constrainedToSize:CGSizeMake(235, 100000) lineBreakMode:NSLineBreakByCharWrapping];
                        if (infosize.height > 50) {
                            return infosize.height + 10;
                        }
                        return 50;
                    } else if (vo.Title) {
                        return 50;
                    }
                }
                
                if ([sizeArray[row] isKindOfClass:[NSString class]]) {
                    CGSize infoSize = [[sizeArray objectAtIndex:row] sizeWithFont:LMH_FONT_15];
                    if (infoSize.height > 50) {
                        infoSize.height += 10;
                    }else{
                        infoSize.height = 50;
                    }
                    return infoSize.height;
                }
            }
            return 0;
        }else if (((UIButton *)btnArray[2]).selected){
            if (row > 0) {
                if([commentVO.comments[row - 1] isKindOfClass:[CommentsVO class]]){
                    CommentsVO *vo = commentVO.comments[row -1];
                    CGSize contentSize = [vo.content sizeWithFont:LMH_FONT_15 constrainedToSize:CGSizeMake(CGRectGetWidth(self.tableView.frame)-74, 1000) lineBreakMode:NSLineBreakByCharWrapping];
                    return contentSize.height + 60;
                }
                
                return 60;
            }
            return 40;
        }else if (((UIButton *)btnArray[3]).selected){
            return (ScreenW-30)/2+75;
        }
    }else if(section == 3){
        if (row == 0) {
            return 40;
        }else{
            CGFloat offsetX = (ScreenW-20)/27;//7(图像个数)*3(占比)+6(间隔个数)=27(除去两边的空白的份数)
            CGFloat imgX = offsetX*3;
            NSInteger imgcount = favimgArray.count + 1;
            CGFloat imgH = 10+ceilf((imgcount>14?14:imgcount)/7.0)*(imgX+offsetX);
            
            return imgH;
        }
    }else if(section == 4){
        if (row == 0) {
            return 40;
        }else if(row <= (eveluateArray.count>3?3:eveluateArray.count)){
            CGFloat imgX = (ScreenW-20)/9;
            
            LMH_EvaluatedVO *vo = eveluateArray[row - 1];
            if (vo.content) {
                CGSize revH = [vo.content sizeWithFont:LMH_FONT_12 constrainedToSize:CGSizeMake(ScreenW-imgX-60, 10000)];
                if (revH.height > 18) {
                    return 80;
                }else{
                    return 45+revH.height;
                }
            }
            return 0;
        }else if(row == (eveluateArray.count>3?4:eveluateArray.count+1)){
            if (eveluateArray.count > 3) {
                return 40;
            }
        }else if(row == eveluateArray.count>3?5:eveluateArray.count+2){
            return 70;
        }
    }
    
    return 0;
}

- (void)pushMoreVC{
    LMH_EvaluateViewController *evaluateVC = [[LMH_EvaluateViewController alloc] initWithEventID:[NSNumber numberWithInteger:_productid] andType:1];
    evaluateVC.navigationController = self.navigationController;
    evaluateVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:evaluateVC animated:YES];
}

- (void)eveluateClick{
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:4] animated:YES scrollPosition:UITableViewScrollPositionTop];
    [textField becomeFirstResponder];
}

#pragma mark - Login Delegate
- (void)didLogin
{
    if (_loginActionID == 101) {
        //[self performSelector:@selector(buyNowBtnPressed:) withObject:nil afterDelay:0.5];
    } else if (_loginActionID == 102) {
        [self performSelector:@selector(favIconTaped) withObject:nil afterDelay:0.2];
    }else if(_loginActionID == 104){
        BOOL backFlag = NO;
        
        for (UIViewController *temp in self.navigationController.viewControllers)
        {
            if ([temp isKindOfClass:[kata_ShopCartViewController class]])
            {
                backFlag = YES;
                [self.navigationController popViewControllerAnimated:YES];
                break;
            }
            else
            {
                backFlag = NO;
            }
        }
        if (!backFlag) {
            kata_ShopCartViewController *cartVC = [[kata_ShopCartViewController alloc] initWithStyle:UITableViewStylePlain];
            cartVC.navigationController = self.navigationController;
            [self.navigationController pushViewController:cartVC animated:YES];
        }
    }
}

- (void)loginCancel
{
    
}

-(void) compareCurrentTime
{
    NSTimeInterval difftime = [productDict.diffTime longLongValue] - 1;
    productDict.diffTime = [NSNumber numberWithLongLong:difftime];
    if ([productDict.diffTime longLongValue] < 0) {
        [limitTimer invalidate];
        limitTimer = nil;
        
        NSString *timeStr = @"    限时打折即将结束";
        [timeLbl setText:timeStr];
        return;
    }
    
    NSInteger day = difftime/3600/24;
    NSInteger hours = (long)difftime%(3600*24)/3600;
    NSInteger minus = (long)difftime%3600/60;
    NSInteger sec = (long)difftime%60;
    
    NSString *timeStr = [NSString stringWithFormat:@"    限时打折:%zi天%zi小时%zi分%zi秒", day, hours, minus, sec];
    [timeLbl setText:timeStr];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark 商品规格选择delegate
-(void)select_Color:(NSInteger)colorid select_Size:(NSInteger)sizeid total_Num:(NSInteger)qty andSku_id:(NSString *)sku_id
{
    if (colorid >= 0 || sizeid >= 0) {
        _colorid = colorid;
        _sizeid = sizeid;
        _skuQuantity = qty;
        if (currentVC) {
            [self performSelector:@selector(loadSkuNum) withObject:nil afterDelay:0.3];
        }
        
    }else if (colorid < 0 && sizeid < 0){
        [_cartBtn setEnabled:YES];
        [_buyBtn setEnabled:YES];
    }
    [self performSelectorOnMainThread:@selector(popViewdiss:) withObject:popSkuTableView waitUntilDone:YES];
}

-(void)popViewdiss:(UIView *)hiddenView
{
    if ([hiddenView isKindOfClass:[popSkuTableView class]]) {
        [popSkuTableView removeFromSuperview];
        [halfView setHidden:YES];
    }else if ([hiddenView isKindOfClass:[popResultView class]]){
        [popResultView removeFromSuperview];
        [halfView setHidden:YES];
    }
    if (_colorid < 0 && _sizeid < 0){
        [_cartBtn setEnabled:YES];
        [_buyBtn setEnabled:YES];
    }
}

- (void)errView
{
    _errorView = [[UIView alloc] initWithFrame:self.contentView.frame];
    CGFloat w = _errorView.frame.size.width;
    CGFloat h = _errorView.frame.size.height;
    
    [_errorView setBackgroundColor:[UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f]];
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"neterror"]];
    [image setFrame:CGRectMake((w - CGRectGetWidth(image.frame)) / 2, h/2 - CGRectGetHeight(image.frame), CGRectGetWidth(image.frame), CGRectGetHeight(image.frame))];
    [_errorView addSubview:image];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, h/2 + 10, w, 34)];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setNumberOfLines:2];
    [lbl setTextColor:[UIColor colorWithRed:0.52 green:0.52 blue:0.52 alpha:1]];
    [lbl setFont:[UIFont systemFontOfSize:14.0]];
    [lbl setText:@"网络抛锚\r\n请检查网络后点击屏幕重试！"];
    [_errorView addSubview:lbl];
    
    _errorView.center = self.contentView.center;
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScreen)];
    [_errorView addGestureRecognizer:tapGesture];
    
    [self.contentView addSubview:_errorView];
}

- (void)tapScreen
{
    [_errorView removeFromSuperview];
    [self loadNewer];
}

- (BOOL)checkLogin{
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isEqualToString:@""]) {
        userid = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"];
    }
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isEqualToString:@""]) {
        usertoken = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"];
    }
    
    if (userid.length <= 0) {
        [kata_LoginViewController showInViewController:self];
        return NO;
    }
    
    return YES;
}

//评论
- (void )evaluateRequest
{
    if (![self checkLogin]) {
        return;
    }
    
    [self loadHUD];
    KTBaseRequest *req = [[KTBaseRequest alloc] init];
    
    NSMutableDictionary *paramsDict = [req params];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSNumber numberWithInteger:_productid] forKey:@"id"];
    [dict setObject:@"goods" forKey:@"type"];
    [dict setObject:eveluateTent forKey:@"content"];
    [dict setObject:eveluatesmsID forKey:@"reply_id"];
    [dict setObject:eveluateUserid forKey:@"reply_user_id"];
    [dict setObject:userid forKey:@"user_id"];
    [dict setObject:usertoken forKey:@"user_token"];
    
    [paramsDict setObject:dict forKey:@"params"];
    [paramsDict setObject:@"add_evaluate" forKey:@"method"];
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        [self hideHUD];
        [self performSelectorOnMainThread:@selector(evaluateResponse:) withObject:resp waitUntilDone:YES];
    } failed:^(NSError *error) {
        [self hideHUD];
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (void)evaluateResponse:(NSString *)resp
{
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            if (respDict[@"data"] != nil && ![respDict[@"data"] isEqual:[NSNull null]] && [respDict[@"data"] isKindOfClass:[NSDictionary class]]) {
                LMH_EventVO *eVO = [LMH_EventVO LMH_EventVOWithDictionary:respDict[@"data"]];
                allVO.evaluate_count = eVO.evaluate_count;
                eveluateArray = eVO.evaluate_list;
                
                keyView.textField.text = @"";
                textField.text = @"";
                
                //一个section刷新
                [self.tableView reloadData];
                [self textStateHUD:@"评论成功"];
                return;
            }
        }
    }
    [self textStateHUD:@"网络问题，请稍后重试"];
}

//发送评论
- (void)currentClick{
    [textField resignFirstResponder];
    [keyView.textField resignFirstResponder];
    
    eveluateTent = textField.text;
    eveluateTent =[eveluateTent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //过滤中间空格
    eveluateTent = [eveluateTent stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (eveluateTent.length > 0) {
        eveluateTent = textField.text;
    }else{
        return;
    }
    eveluateUserid = @0;
    eveluatesmsID = @0;
    
    [self evaluateRequest];
}

#pragma mark - 回复按钮点击后的代理
- (void)sendSms:(LMH_EvaluatedVO *)evaVO{
    textField.text = @"";
    keyView.hidden = NO;
    [keyView.textField becomeFirstResponder];
    
    eveluateUserid = evaVO.reply_user_id?evaVO.reply_user_id:@0;
    eveluatesmsID = evaVO.evaluaid?evaVO.evaluaid:@0;
}

#pragma mark - 信息发送按钮点击后的代理
- (void)keySendSms:(NSString *)smsInfo{
    keyView.hidden = YES;
    [keyView.textField resignFirstResponder];
    [textField resignFirstResponder];
    
    eveluateTent = keyView.textField.text;
    eveluateTent =[eveluateTent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //过滤中间空格
    eveluateTent = [eveluateTent stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (eveluateTent.length > 0) {
        eveluateTent = keyView.textField.text;
    }else{
        return;
    }
    [self evaluateRequest];
}

- (void)keyHeight:(CGFloat)height{
    CGRect frame = vFrame;
    if (keyView.textField.isFirstResponder || textField.isFirstResponder) {
        frame.size.height -= height - BOTTOMHEIGHT +10;
    }
    self.tableView.frame = frame;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    keyView.textField.text = @"";
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (textField.isFirstResponder) {
        return;
    }
    keyView.hidden = YES;
    [keyView.textField resignFirstResponder];
    
    self.tableView.frame = vFrame;
}

- (void) keyboardWasShow:(NSNotification *) notif{
    NSDictionary *info = [notif userInfo];
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat hOffset = endKeyboardRect.size.height;
    
    [self keyHeight:hOffset];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    keyView.hidden = YES;
    [keyView.textField resignFirstResponder];
    [textField resignFirstResponder];
    
    self.tableView.frame = vFrame;
}

#pragma mark - KTProductListTableViewCell Delegate
- (void)tapAtItem:(HomeProductVO *)pvo
{
    _productType = 0;
    _seckillID = -1;
    // 商品详情
    kata_ProductDetailViewController *vc = [[kata_ProductDetailViewController alloc] initWithProductID:[pvo.product_id integerValue] andType:[NSNumber numberWithInteger:_productType] andSeckillID:_seckillID];
    vc.navigationController = self.navigationController;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
