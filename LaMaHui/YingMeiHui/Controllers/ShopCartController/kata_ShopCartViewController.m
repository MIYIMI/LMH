//
//  kata_ShopCartViewController.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-8-3.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "kata_ShopCartViewController.h"
#import "KTCartOperateRequest.h"
#import "kata_UserManager.h"
#import "kata_CartManager.h"
#import "KTNavigationController.h"
#import "CartGoodVO.h"
#import "CartInfo.h"
#import "SSCheckBoxView.h"
#import "BOKUNoActionTextField.h"
#import "kata_ProductDetailViewController.h"
#import "UIWindow+KT51Additions.h"
#import "kata_PayCheckViewController.h"
#import "CartNumVO.h"
#import "kata_AppDelegate.h"
#import "kata_WebViewController.h"

#define HEADERHEIGHT            45
#define FOOTERHEIGHT            45
#define NORMALTAG               1000000
#define EDITTAG                 1000001
#define NUMBERSS                @"0123456789"
#define NUMBERSSS               @"123456789"

@interface kata_ShopCartViewController ()
{
    UIButton *_editBtn;
    UIBarButtonItem *_editItem;
    UIBarButtonItem *_backItem;
    UILabel *_headerTitleLbl;
    UILabel *_headerPriceLbl;
    UILabel *_shipFeeLbl;
    UIButton *_cashBtn;
    SSCheckBoxView *_allCB;
    NSMutableArray *_selectedArr;
    BOOL _editAble;
    UIButton *_cbBtn;
    UIView *_headerView;
    UIButton *_deleteBtn;
    UIButton *_favBtn;
    NSTimer *_cartNumTimer;
    UIButton *_cartMask;
    UITextField *_edittingTF;
    UIButton *toHomeBtn;
    UIView *discView;
    
    NSInteger _edittingCount;
    BOOL _keyboardIsShowing;
    CGFloat keyboard_yOffset;
    BOOL _isModal;
    id _modalVC;
    NSArray *_outstoreArr;
    UIView *_footView;
    UIView *_emptyInfoView;
    UIView *_huiview;
    
    NSNumber *_deleteItemID;
    NSString *_deleteSkuID;
    NSNumber *_freightFee;
    CartInfo *_cartInfo;
    UIView *_headView;
    UIView *_taobaoView;
    NSArray *_cashArr;
    NSInteger cart_num;
    NSMutableArray *dataArray;
    NSMutableArray *selectBtnArray;
    NSArray *couponArray;
    BOOL currentVC;
    BOOL is_loading;
    BOOL resetUpdate;
    BOOL stockFlag;
    
    NSString *_taobaourl;
    Loading *loading;
}

@end

@implementation kata_ShopCartViewController
@synthesize isRoot;

+ (void)showInViewController:(id)mainVC
{
    kata_ShopCartViewController *shopCartVC = [[kata_ShopCartViewController alloc] initWithStyle:UITableViewStylePlain];
    
    [shopCartVC setModalVC:mainVC];
    [shopCartVC setIsModal:YES];
    [shopCartVC showLoginBoardWithAnimated:YES];
}

- (void)setIsModal:(BOOL)ismodal
{
    _isModal = ismodal;
}

- (void)setModalVC:(id)vc
{
    _modalVC = vc;
}

- (void)showLoginBoardWithAnimated:(BOOL)animated
{
    if (!self.view.superview) {
        KTNavigationController *nav = [[KTNavigationController alloc] initWithRootViewController:self];
        
        [_modalVC presentViewController:nav animated:animated completion:^{
            if (self.cartDelegate && [self.cartDelegate respondsToSelector:@selector(loginViewPresented)]) {
                [[self cartDelegate] cartViewViewPresented];
            }
            UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [backBtn setFrame:CGRectMake(0, 0, 40, 30)];
            [backBtn setTitle:@"返回" forState:UIControlStateNormal];
            [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [backBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
            UIImage *image = [UIImage imageNamed:@"right_but"];
            image = [image stretchableImageWithLeftCapWidth:10.0f topCapHeight:10.0f];
            [backBtn setBackgroundImage:image forState:UIControlStateNormal];
            [backBtn addTarget:self action:@selector(backBtnPressed) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
            [self.navigationController addLeftBarButtonItem:nil animation:NO];
            [self.navigationController addLeftBarButtonItem:backItem animation:NO];
            _backItem = backItem;
        }];
    }
}

- (void)backBtnPressed
{
    if (self.cartDelegate && [self.cartDelegate respondsToSelector:@selector(loginCancel)]) {
        [self.cartDelegate cartCancel];
    }
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _keyboardIsShowing = NO;
        _isModal = NO;
        _deleteItemID = nil;
        _freightFee = nil;
        _cartInfo = nil;
        self.ifAddPullToRefreshControl = NO;
        self.ifRemoveLoadNoState = NO;
        self.ifAddPullToRefreshControl = YES;
        dataArray = [[NSMutableArray alloc] init];
        selectBtnArray = [[NSMutableArray alloc] init];
        currentVC = YES;
        is_loading = YES;
        resetUpdate = NO;
        stockFlag = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createUI];
    self.navigationItem.title=@"我的购物车";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    is_loading = YES;
    [self loadNewer];
    if (_isModal) {
        if (_backItem) {
            [self.navigationController addLeftBarButtonItem:nil animation:NO];
            [self.navigationController addLeftBarButtonItem:_backItem animation:NO];
        }
    } else {
        [self.navigationController addRightBarButtonItem:nil animation:NO];
    }
    
    [toHomeBtn removeFromSuperview];
    [_taobaoView removeFromSuperview];
    //购物车数量更新
    [self performSelectorOnMainThread:@selector(updateCartNum) withObject:nil waitUntilDone:YES];
    
    UITabBar *tabBar = self.tabBarController.tabBar;
    UITabBarItem *tabBarItem4 = [tabBar.items objectAtIndex:4];
    //未支付订单数量更新
    NSNumber *wntValue = [[kata_UserManager sharedUserManager] userWaitPayCnt];
    if ([wntValue intValue]>0) {
        [tabBarItem4 setBadgeValue:[[[kata_UserManager sharedUserManager] userWaitPayCnt] stringValue]];
    }else{
        [tabBarItem4 setBadgeValue:0];
    }

    currentVC = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    currentVC = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[(kata_AppDelegate *)[[UIApplication sharedApplication] delegate] deckController] setPanningMode:IIViewDeckNoPanning];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)createUI
{
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1]];
    [self.contentView setBackgroundColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1]];
    
    if (self.isRoot) {
        CGRect tableFrame =  self.tableView.frame;
        tableFrame.size.height -= 49;
        self.tableView.frame=tableFrame;
    }
    CGFloat w = CGRectGetWidth(self.tableView.frame);
    CGFloat h = CGRectGetHeight(self.tableView.frame);
    
    _footView = [[UIView alloc] initWithFrame:CGRectMake(0, h - HEADERHEIGHT, CGRectGetWidth(self.contentView.frame), HEADERHEIGHT)];

    [_footView setBackgroundColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1]];
    UILabel *lineLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), 1)];
    [lineLbl setBackgroundColor:[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1]];
    [_footView addSubview:lineLbl];

    _allCB = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(2, 7, 56, 30) style:kSSCheckBoxViewStyleCustom4 checked:YES];
    [_allCB setText:@"全选"];
    [_cashBtn.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
    [_allCB setUserInteractionEnabled:NO];
    [_footView addSubview:_allCB];

    
    _cbBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cbBtn setFrame:CGRectMake(0, 0, CGRectGetWidth(_allCB.frame), HEADERHEIGHT)];
    [_cbBtn setBackgroundColor:[UIColor clearColor]];
    [_cbBtn addTarget:self action:@selector(setSelectAll:) forControlEvents:UIControlEventTouchUpInside];
    [_footView addSubview:_cbBtn];

    
    _headerTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(ScreenW - 217, 7.5, 50, 15)];
    [_headerTitleLbl setText:@"总计:"];
    [_headerTitleLbl setFont:LMH_FONT_15];
    [_headerTitleLbl setTextAlignment:NSTextAlignmentRight];
    [_headerTitleLbl setTextColor:[UIColor colorWithRed:255/255.0 green:74/255.0 blue:155/255.0 alpha:1]];
    [_headerTitleLbl setBackgroundColor:[UIColor clearColor]];
    [_footView addSubview:_headerTitleLbl];


    _headerPriceLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headerTitleLbl.frame)+3, 7.5, 130, 15)];
    [_headerPriceLbl setText:@"￥0.00"];
    [_headerPriceLbl setFont:LMH_FONT_14];
    [_headerPriceLbl setTextAlignment:NSTextAlignmentLeft];
    [_headerPriceLbl setTextColor:[UIColor colorWithRed:255/255.0 green:74/255.0 blue:155/255.0 alpha:1]];
    [_headerPriceLbl setBackgroundColor:[UIColor clearColor]];
    [_footView addSubview:_headerPriceLbl];

    
    _shipFeeLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_headerTitleLbl.frame), CGRectGetMaxY(_headerTitleLbl.frame) + 3, 105, 15)];
    [_shipFeeLbl setText:@"邮费0.00元"];
    [_shipFeeLbl setFont:[UIFont systemFontOfSize:13.0]];
    [_shipFeeLbl setTextAlignment:NSTextAlignmentRight];
    [_shipFeeLbl setTextColor:[UIColor colorWithRed:0.55 green:0.55 blue:0.55 alpha:1]];
    [_shipFeeLbl setBackgroundColor:[UIColor clearColor]];
    [_footView addSubview:_shipFeeLbl];

    
    _cashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"buynowbtn"];
    image = [image stretchableImageWithLeftCapWidth:14.0f topCapHeight:14.0f];
    [_cashBtn setBackgroundImage:image forState:UIControlStateNormal];
    image = [UIImage imageNamed:@"red_btn_small"];
    image = [image stretchableImageWithLeftCapWidth:14.0f topCapHeight:14.0f];
    [_cashBtn setBackgroundImage:image forState:UIControlStateHighlighted];
    [_cashBtn setBackgroundImage:image forState:UIControlStateSelected];
    [_cashBtn setBackgroundImage:image forState:UIControlStateNormal];
    [_cashBtn setTitle:@"结算" forState:UIControlStateNormal];
    [_cashBtn setFrame:CGRectMake(ScreenW - 100, (HEADERHEIGHT - 26)/2 - 4, 92, 34)];
    [_cashBtn.titleLabel setFont:LMH_FONT_16];
    [_footView addSubview:_cashBtn];
    [_cashBtn addTarget:self action:@selector(cashBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [_cashBtn setEnabled:NO];

    [self.contentView addSubview:_footView];
    [self.tableView setFrame:CGRectMake(0, 0, w, h - CGRectGetHeight(_footView.frame))];

    _headView = [[UIView alloc] initWithFrame:CGRectZero];
//    [_headView setBackgroundColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1]];
    //淘宝购物车
    _taobaoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    [_taobaoView setBackgroundColor:[UIColor whiteColor]];
    UITapGestureRecognizer *tapClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushTBcart)];
    tapClick.numberOfTapsRequired = 1;
    [_taobaoView addGestureRecognizer:tapClick];
    
    UIImageView *taobaoImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 40, 40)];
    [taobaoImg setImage:[UIImage imageNamed:@"taobao"]];
    [_taobaoView addSubview:taobaoImg];
    
    UILabel *taobaoLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(taobaoImg.frame)+10, CGRectGetMinY(taobaoImg.frame), 150, 40)];
    taobaoLbl.numberOfLines = 0;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"淘宝订单\n点击查看淘宝订单"];
    [str addAttribute:NSForegroundColorAttributeName value:LMH_COLOR_ORANGE range:NSMakeRange(0,4)];
    [str addAttribute:NSForegroundColorAttributeName value:LMH_COLOR_LIGHTGRAY range:NSMakeRange(4,9)];
    [str addAttribute:NSFontAttributeName value:LMH_FONT_16 range:NSMakeRange(0, 4)];
    [str addAttribute:NSFontAttributeName value:LMH_FONT_12 range:NSMakeRange(4, 9)];
    taobaoLbl.attributedText = str;
    [_taobaoView addSubview:taobaoLbl];
    
    UIImageView *rightView= [[UIImageView alloc] initWithFrame:CGRectMake(ScreenW-20, (CGRectGetHeight(_taobaoView.frame)-15)/2, 10, 15)];
    [rightView setImage:[UIImage imageNamed:@"right_arrow"]];
    [_taobaoView addSubview:rightView];
    
    //汇特卖购物车
    _huiview = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_taobaoView.frame)+10, ScreenW, 50)];
    [_huiview setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *huiImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 40, 40)];
    huiImgView.image = [UIImage imageNamed:@"huitemai"];
    [_huiview addSubview:huiImgView];
    
    UILabel *huiLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(huiImgView.frame)+10, CGRectGetMinY(huiImgView.frame), 150, 40)];
    huiLbl.numberOfLines = 0;
    NSMutableAttributedString *huistr = [[NSMutableAttributedString alloc] initWithString:@"汇特卖订单\n更懂辣妈的特卖网站"];
    [huistr addAttribute:NSForegroundColorAttributeName value:LMH_COLOR_SKIN range:NSMakeRange(0,5)];
    [huistr addAttribute:NSForegroundColorAttributeName value:LMH_COLOR_LIGHTGRAY range:NSMakeRange(5,10)];
    [huistr addAttribute:NSFontAttributeName value:LMH_FONT_16 range:NSMakeRange(0, 5)];
    [huistr addAttribute:NSFontAttributeName value:LMH_FONT_12 range:NSMakeRange(5, 10)];
    huiLbl.attributedText = huistr;
    [_huiview addSubview:huiLbl];
    [_huiview setHidden:YES];
    
    discView = [[UIView alloc] init];
    [discView setBackgroundColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1]];
    [discView setHidden:YES];
}

//跳转到淘宝购物车
- (void)pushTBcart{
    kata_WebViewController *cartWebVC = [[kata_WebViewController alloc] initWithUrl:_taobaourl?_taobaourl:@"http://h5.m.taobao.com/awp/base/bag.htm" title:@"淘宝购物车" andType:@"taobao"];
    cartWebVC.navigationController = self.navigationController;
    cartWebVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cartWebVC animated:YES];
}

- (UIView *)emptyView
{
    UIView *view = [super emptyView];
    
    CGFloat w = view.frame.size.width;
    CGFloat h = view.center.y;
    [view setBackgroundColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1]];
    if ([self.view viewWithTag:1010]){
        [[self.view viewWithTag:1010] removeFromSuperview];
    }
    if([view viewWithTag:1012]){
        for (UIView *itemV in view.subviews) {
            [itemV removeFromSuperview];
        }
    }
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cart_empty_icon"]];
    [image setFrame:CGRectMake((w - CGRectGetWidth(image.frame))/2-10, h - CGRectGetHeight(image.frame), CGRectGetWidth(image.frame), CGRectGetHeight(image.frame))];
    [view addSubview:image];
    image.tag=1012;
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(image.frame)+10, w, 15)];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setTextColor:[UIColor colorWithRed:0.52 green:0.52 blue:0.52 alpha:1]];
    [lbl setFont:[UIFont systemFontOfSize:14.0]];
    [lbl setText:@"购物车还是空的，挑选点宝贝吧"];
    [view addSubview:lbl];
    
    toHomeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [toHomeBtn setFrame:CGRectMake((w-w/3)/2, CGRectGetMaxY(lbl.frame)+20, w/3 , w/300 * 33)];
//    [toHomeBtn.layer setMasksToBounds:YES];
//    [toHomeBtn.layer setCornerRadius:6.0];
    
//    CGFloat top = 10; // 顶端盖高度
//    CGFloat bottom = 10 ; // 底端盖高度
//    CGFloat left = 20; // 左端盖宽度
//    CGFloat right = 20; // 右端盖宽度
//    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
//    UIImage *aImage = [[UIImage imageNamed:@"return_home"] resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
//    [toHomeBtn setBackgroundImage:aImage forState:UIControlStateNormal];
//    [toHomeBtn setBackgroundImage:aImage forState:UIControlStateSelected];
//    [toHomeBtn setBackgroundImage:aImage forState:UIControlStateHighlighted];
    [toHomeBtn setTitle:@"去首页逛逛" forState:UIControlStateNormal];
    [toHomeBtn setTitleColor:LMH_COLOR_SKIN forState:UIControlStateNormal];
    [toHomeBtn addTarget:self action:@selector(toHomeBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [toHomeBtn.layer setCornerRadius:4];
    toHomeBtn.layer.borderWidth = 1.0;
    toHomeBtn.layer.borderColor = LMH_COLOR_SKIN.CGColor;
    [toHomeBtn setTag:1010];
    
    UILabel *toHomeLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(toHomeBtn.frame), CGRectGetHeight(toHomeBtn.frame))];
    [toHomeLbl setTextColor:[UIColor whiteColor]];
    [toHomeLbl setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0]];
    [toHomeLbl setTextAlignment:NSTextAlignmentCenter];
    [toHomeLbl setText:@"去首页逛逛"];
    [toHomeLbl setFont:[UIFont fontWithName:@"Helvetica-BoldOblique" size:15]];
    [toHomeLbl setTag:1011];
    
//    [toHomeBtn addSubview:toHomeLbl];
    [self.view addSubview:toHomeBtn];
    [self.view addSubview:_taobaoView];

    return view;
}

- (void)toHomeBtnPressed
{
    if (self.isRoot) {
        NSArray *viewControllers =[[[self.tabBarController childViewControllers] objectAtIndex:0] childViewControllers];
        for (UIViewController *vc in viewControllers) {
            if ([vc isKindOfClass:[KTChannelViewController class]]) {
                [(KTChannelViewController *)vc selectedTabIndex:0];
            }
        }
        self.tabBarController.selectedIndex=0;
    }else{
        [[kata_CartManager sharedCartManager] setGoToHomePage:YES];
        if (_isModal) {
            [self backBtnPressed];
        } else {
            NSArray *viewControllers =[[[self.tabBarController childViewControllers] objectAtIndex:0] childViewControllers];
            for (UIViewController *vc in viewControllers) {
                if ([vc isKindOfClass:[KTChannelViewController class]]) {
                    [(KTChannelViewController *)vc selectedTabIndex:0];
                }
            }
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

- (void)editBtnPressed:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    if (btn.tag == NORMALTAG) {
        _editAble = YES;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationDuration:0.30];
        [_headerTitleLbl setText:@"全选"];
        [_headerPriceLbl setAlpha:0.0];
        [_cashBtn setAlpha:0.0];
        [_headerView setFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame)-FOOTERHEIGHT, CGRectGetWidth(self.contentView.frame), FOOTERHEIGHT)];
        [UIView commitAnimations];
        
        btn.tag = EDITTAG;
        [btn setTitle:@"完成" forState:UIControlStateNormal];
    } else {
        _editAble = NO;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationDuration:0.30];
        [_headerTitleLbl setText:@"总计 :"];
        [_headerPriceLbl setAlpha:1.0];
        [_cashBtn setAlpha:1.0];
        [_headerView setFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), CGRectGetWidth(self.contentView.frame), FOOTERHEIGHT)];
        [UIView commitAnimations];
        
        btn.tag = NORMALTAG;
        [btn setTitle:@"编辑" forState:UIControlStateNormal];
        
        [self loadNoState];
    }
    [self.tableView reloadData];
}

- (void)setSelectAll:(id)sender
{
    if ([sender isKindOfClass:[UIButton class]]) {
        [_allCB setChecked:!_allCB.checked];
        for (NSInteger i = 0; i < _selectedArr.count; i++) {
            for (NSInteger j = 0; j < [(NSArray*)_selectedArr[i] count]; j++) {
                id vo = [dataArray[i] objectAtIndex:j];
                if ([vo isKindOfClass:[CartBrandVO class]]) {
                    NSInteger brandNum = 0;
                    for (CartProductVO *prouctvo in [(CartBrandVO*)vo product_arr]) {
                        brandNum += [prouctvo.stock integerValue];
                    }
                    if (brandNum > 0) {
                        [_selectedArr[i] setObject:[NSNumber numberWithBool:_allCB.checked] atIndexedSubscript:0];
                    }else{
                        [_selectedArr[i] setObject:[NSNumber numberWithBool:NO] atIndexedSubscript:0];
                    }
                }else if([vo isKindOfClass:[CartProductVO class]]){
                    CartProductVO *productvo = vo;
                    if ([productvo.stock integerValue] > 0) {
                        [_selectedArr[i] setObject:[NSNumber numberWithBool:_allCB.checked] atIndexedSubscript:j];
                    }else{
                        [_selectedArr[i] setObject:[NSNumber numberWithBool:NO] atIndexedSubscript:j];
                    }
                }
            }
        }
        
        [self calTotal:dataArray];
        
        [self.tableView reloadData];
        [self updateCartOperation:dataArray];
    }
}

- (void)cashBtnPressed
{
    [_cashBtn setEnabled:NO];
    
    BOOL select = NO;
    for (id num in _selectedArr) {
        for (NSNumber *Flag in num) {
            if ([Flag boolValue]) {
                select = YES;
                break;
            }
        }
    }
    
    if (!select || _cashArr.count <= 0) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"请至少选中一件商品！"
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert show];
        [_cashBtn setEnabled:YES];
        return;
    }
    
//    if (!stateHud) {
//        stateHud = [[MBProgressHUD alloc] initWithView:self.contentView];
//        stateHud.delegate = self;
//        [self.contentView addSubview:stateHud];
//    }
//    stateHud.mode = MBProgressHUDModeIndeterminate;
//    stateHud.labelFont = [UIFont systemFontOfSize:14.0f];
//    [stateHud show:YES];
    
    [self updateCartNumOperation];
}

-(void)jumpToNext:(CartNumVO *)cart_vo
{
    if (currentVC) {
        //需检查是否已登录 如未登陆则弹出登陆界面
        if (![[kata_UserManager sharedUserManager] isLogin]) {
            [kata_LoginViewController showInViewController:self];
            return;
        }
        resetUpdate = YES;
        NSMutableArray *cartArr = [[NSMutableArray alloc] init];
        [cartArr addObjectsFromArray:cart_vo.product_no_stock];
        [cartArr addObjectsFromArray:cart_vo.product_stock];
        
        stockFlag = NO;
        for (NSInteger i = 0; i < _selectedArr.count; i++) {
            NSInteger brandstock = 0;
            for (NSInteger j = 0; j < [(NSArray *)_selectedArr[i] count]; j++) {
                if ([[dataArray[i] objectAtIndex:j] isKindOfClass:[CartProductVO class]]) {
                    CartProductVO *goodVO = (CartProductVO *)[dataArray[i] objectAtIndex:j];
                    for (CartNumVO *vo in cartArr) {
                        if([goodVO.sku isEqualToString:vo.sku_id]){
                            goodVO.stock = vo.stock;
                            [dataArray[i] setObject:goodVO atIndexedSubscript:j];
                            if ([goodVO.qty integerValue] > [goodVO.stock integerValue]) {
                                stockFlag = YES;
                                goodVO.qty = vo.stock;
                                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:i];
                                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                            }
                            if ([goodVO.stock  integerValue] <= 0) {
                                _selectedArr[i][j] = [NSNumber numberWithBool:NO];
                            }
                        }
                    }
                    brandstock += [goodVO.stock integerValue];
                }
            }
            if (brandstock > 0 && [_selectedArr[i][0] boolValue]) {
                _selectedArr[i][0] = [NSNumber numberWithBool:YES];
            }else{
                _selectedArr[i][0] = [NSNumber numberWithBool:NO];
            }
        }
        
        [self updateCartOperation:dataArray];
    }
}

- (void)cartStateHUD:(NSString *)text
{
    if (!stateHud) {
        stateHud = [[MBProgressHUD alloc] initWithView:self.view];
        stateHud.delegate = self;
        [self.view addSubview:stateHud];
    }
    stateHud.mode = MBProgressHUDModeText;
    stateHud.labelText = text;
    stateHud.labelFont = [UIFont systemFontOfSize:13.0f];
    [stateHud show:YES];
    [stateHud hide:YES afterDelay:1.0];
}

- (void)keyboardWillShow:(NSNotification *)note
{
    if (!_keyboardIsShowing) {
        _keyboardIsShowing = YES;
        NSDictionary *userInfo = [note userInfo];
        NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [aValue CGRectValue];
        
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        UIView *firstResponder = [keyWindow findFirstResponder];
        
        
        if (IOS_7) {
            if ([[[[firstResponder superview] superview] superview] isKindOfClass:[KTShopCartTableViewCell class]]) {
                KTShopCartTableViewCell *cell = (KTShopCartTableViewCell *)[[[firstResponder superview] superview] superview];
                NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
                CGFloat cellOffset = indexPath.row > 0 ? (indexPath.row) * 85 + 40 : 81;
                if (cellOffset < CGRectGetHeight(self.tableView.frame) - CGRectGetHeight(keyboardRect)) {
                    keyboard_yOffset = 0;
                    return;
                }
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationDuration:0.25];
                keyboard_yOffset = CGRectGetHeight(self.tableView.frame) - CGRectGetHeight(keyboardRect) - cellOffset;
                [self.tableView setContentOffset:CGPointMake(0, -keyboard_yOffset)];
                [UIView commitAnimations];
            }
        } else {
            if ([[[firstResponder superview] superview] isKindOfClass:[KTShopCartTableViewCell class]]) {
                KTShopCartTableViewCell *cell = (KTShopCartTableViewCell *)[[firstResponder superview] superview];
                NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
                CGFloat cellOffset = indexPath.row > 0 ? (indexPath.row) * 85 + 32 : 81;
                if (cellOffset < CGRectGetHeight(self.tableView.frame) - CGRectGetHeight(keyboardRect)) {
                    keyboard_yOffset = 0;
                    return;
                }
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationDuration:0.25];
                keyboard_yOffset = CGRectGetHeight(self.tableView.frame) - CGRectGetHeight(keyboardRect) - cellOffset;
                [self.tableView setContentOffset:CGPointMake(0, -keyboard_yOffset)];
                [UIView commitAnimations];
            }
        }
    }
}

//- (void)setStatefulState:(FTStatefulTableViewControllerState)statefulState
//{
//    [super setStatefulState:statefulState];
//    
//    if (statefulState == FTStatefulTableViewControllerStateIdle) {
//        [self performSelectorOnMainThread:@selector(enableCashBtn:) withObject:[NSNumber numberWithBool:YES] waitUntilDone:YES];
//    } else {
//        [self performSelectorOnMainThread:@selector(enableCashBtn:) withObject:[NSNumber numberWithBool:NO] waitUntilDone:YES];
//    }
//}

//- (void)enableCashBtn:(NSNumber *)enable
//{
//    [_cashBtn setEnabled:[enable boolValue]];
//}

//#pragma mark - stateful tableview datasource && stateful tableview delegate
////stateful表格的数据和委托
////////////////////////////////////////////////////////////////////////////////////
- (KTBaseRequest *)request
{
    [self performSelectorOnMainThread:@selector(noGoodLayout) withObject:nil waitUntilDone:YES];
    [_huiview setHidden:YES];
    [discView setHidden:YES];
    
    NSString *cartid = nil;
    NSString *userid = nil;
    NSString *usertoken = nil;
    
    if ([[kata_CartManager sharedCartManager] hasCartID]) {
        cartid = [[kata_CartManager sharedCartManager] cartID];
    }
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isEqualToString:@""]) {
        userid = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"];
    }
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isEqualToString:@""]) {
        usertoken = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"];
    }
    
    KTCartOperateRequest *req = [[KTCartOperateRequest alloc] initWithCartID:cartid
                                             andUserID:userid
                                          andUserToken:usertoken
                                               andType:@"list"
                                            andProduct:nil
                                             andGoodID:nil
                                          andAddressID:-1
                                           andCouponNO:nil
                                        andCoponUserID:-1
                                             andCredit:-1
                                          andSeckillID:-1];
    
    [self noGoodLayout];
    
    return req;
}

- (NSArray *)parseResponse:(NSString *)resp
{
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            if (nil != [respDict objectForKey:@"data"] && ![[respDict objectForKey:@"data"] isEqual:[NSNull null]] && [[respDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *dataObj = (NSDictionary *)[respDict objectForKey:@"data"];
                if ([[dataObj objectForKey:@"code"] integerValue] == 0) {
                    
                    CartGoodVO *dataObj = [CartGoodVO CartGoodVOWithDictionary:[respDict objectForKey:@"data"]];
                    
                    if (dataObj.shipping_fee) {
                        _freightFee = dataObj.shipping_fee;
                    }
                    
                    _taobaourl = dataObj.taobao_cart_url;
                    
                    if (dataObj.discount_info) {
                        couponArray = dataObj.discount_info;
                    }
                    
                    [dataArray removeAllObjects];
                    
                    cart_num = 0;
                    if (dataObj.event_data) {
                        for (CartBrandVO *eventVO in dataObj.event_data) {
                            NSMutableArray *objArr = [[NSMutableArray alloc] init];
                            [objArr addObject:eventVO];
                            [objArr addObjectsFromArray:eventVO.product_arr];
                            [dataArray addObject:objArr];
                            cart_num += eventVO.product_arr.count;
                        }
                    }
                    [[kata_CartManager sharedCartManager] updateCartCounter:[NSNumber numberWithInteger:cart_num]];
                    //购物车数量更新
                    [self performSelectorOnMainThread:@selector(updateCartNum) withObject:nil waitUntilDone:YES];
                    
                    [_selectedArr removeAllObjects];
                    _selectedArr = [[NSMutableArray alloc] initWithCapacity:dataArray.count];
                    
                    for (NSArray *array in dataArray) {
                        NSMutableArray *selectArr = [[NSMutableArray alloc] init];
                        for (NSInteger i = 0; i < array.count; i++) {
                            if ([array[i] isKindOfClass:[CartProductVO class]]) {
                                CartProductVO *vo = array[i];
                                if ([vo.stock  integerValue] > 0) {
                                    [selectArr addObject:[NSNumber numberWithBool:YES]];
                                }else{
                                    [selectArr addObject:[NSNumber numberWithBool:NO]];
                                }
                            }else if ([array[i] isKindOfClass:[CartBrandVO class]]){
                                CartBrandVO *brandVO = array[i];
                                NSInteger brandNum = 0;
                                for (CartProductVO *vo in brandVO.product_arr) {
                                    brandNum += [vo.qty integerValue];
                                }
                                if (brandNum > 0) {
                                    [selectArr addObject:[NSNumber numberWithBool:YES]];
                                }else{
                                    [selectArr addObject:[NSNumber numberWithBool:NO]];
                                }
                            }
                        }
                        [_selectedArr addObject:selectArr];
                    }
                    
                    if (dataArray.count > 0) {
                        [self performSelectorOnMainThread:@selector(layoutSaleView) withObject:nil waitUntilDone:YES];
                        [self performSelectorOnMainThread:@selector(updateCartOperation:) withObject:dataArray waitUntilDone:YES];
                        [_huiview setHidden:NO];
                        [discView setHidden:NO];
                    }else{
                        [self performSelectorOnMainThread:@selector(noGoodLayout) withObject:nil waitUntilDone:YES];
                        [_huiview setHidden:YES];
                        [discView setHidden:YES];
                    }
                    is_loading = NO;
                    
                    return dataArray;
                } else {
                    if (![[kata_CartManager sharedCartManager] cartID] && ![[kata_UserManager sharedUserManager] isLogin]) {
                        return nil;
                    }
                    self.statefulState = FTStatefulTableViewControllerError;
                }
            } else {
                if (![[kata_CartManager sharedCartManager] cartID] && ![[kata_UserManager sharedUserManager] isLogin]) {
                    return nil;
                }
                self.statefulState = FTStatefulTableViewControllerError;
            }
        } else {
            if (![[kata_CartManager sharedCartManager] cartID] && ![[kata_UserManager sharedUserManager] isLogin]) {
                return nil;
            }
            self.statefulState = FTStatefulTableViewControllerError;
        }
    } else {
        if (![[kata_CartManager sharedCartManager] cartID] && ![[kata_UserManager sharedUserManager] isLogin]) {
            return nil;
        }
        self.statefulState = FTStatefulTableViewControllerError;
    }
    is_loading = YES;
    return nil;
}

- (void)hasGoodLayout
{
    if (_cartInfo) {
        [_cashBtn setEnabled:YES];
        [_cbBtn setEnabled:YES];
    }else{
        [_cbBtn setEnabled:NO];
        [_cashBtn setEnabled:NO];
    }
}

- (void)noGoodLayout
{
    [_cbBtn setEnabled:NO];
    [_cashBtn setEnabled:NO];
    [_footView setHidden:YES];
}

- (void)layoutCashBtn:(NSString *)title
{
//    [_cashBtn setFrame:CGRectMake(ScreenW - 95, (HEADERHEIGHT - 26)/2 - 6, 92, 34)];
    if ([title isEqualToString:@"结算"]) {
        [_cashBtn setFrame:CGRectMake(ScreenW - 100, (HEADERHEIGHT - 28)/2, 92, 28)];
        [_cashBtn setTitle:title forState:UIControlStateNormal];
    } else {
//        CGSize btnLastSize = [@"结算(0)" sizeWithFont:_cashBtn.titleLabel.font];
//        CGSize btnTitleSize = [title sizeWithFont:_cashBtn.titleLabel.font];
        [_cashBtn setFrame:CGRectMake(ScreenW - 100, (HEADERHEIGHT - 28)/2, 92, 28)];

//        [_cashBtn setFrame:CGRectMake(ScreenW - 100 - btnTitleSize.width + btnLastSize.width, CGRectGetMinY(_cashBtn.frame), 92+btnTitleSize.width-btnLastSize.width, CGRectGetHeight(_cashBtn.frame))];
        [_cashBtn setTitle:title forState:UIControlStateNormal];
    }
    [_cashBtn setEnabled:YES];
    [_cbBtn setEnabled:YES];
}

- (void)calTotal:(NSArray *)goodArr
{
    if ([_freightFee floatValue] > 0) {

        [_shipFeeLbl performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"邮费%0.2f元", [_freightFee floatValue]] waitUntilDone:YES];
    }else{
       [_shipFeeLbl performSelectorOnMainThread:@selector(setText:) withObject:@"邮费0.00元" waitUntilDone:YES];
    }
    NSString *moneyStr = [NSString stringWithFormat:@"￥%0.2f",[_cartInfo.CartMoney floatValue]];
    [_headerPriceLbl performSelectorOnMainThread:@selector(setText:) withObject:moneyStr waitUntilDone:YES];
    CGSize size = [moneyStr sizeWithFont:_headerPriceLbl.font constrainedToSize:CGSizeMake(MAXFLOAT, _headerPriceLbl.frame.size.height)];
    _headerTitleLbl.frame = CGRectMake(ScreenW - size.width - 162, 7.5, 50, 15);
    _headerPriceLbl.frame = CGRectMake(CGRectGetMaxX(_headerTitleLbl.frame)+3, 7.5, size.width, 15);
    _shipFeeLbl.frame = CGRectMake(CGRectGetMinX(_headerTitleLbl.frame), CGRectGetMaxY(_headerTitleLbl.frame), 53+size.width, 15);
    
    NSInteger totalItem = 0;
    NSInteger selectNum = 0;
    NSInteger allSelectNum = 0;
    for (NSInteger i = 0; i < goodArr.count; i++) {
        for (NSInteger j = 0; j< [(NSArray*)goodArr[i] count]; j++) {
            if ([[goodArr[i] objectAtIndex:j] isKindOfClass:[CartProductVO class]]) {
                if ([[_selectedArr[i] objectAtIndex:j] boolValue]) {
                    CartProductVO *vo = (CartProductVO *)[goodArr[i] objectAtIndex:j];
                    totalItem += [vo.qty integerValue];
                    selectNum ++;
                }
            }
            
            if ([[goodArr[i] objectAtIndex:j] isKindOfClass:[CartProductVO class]]) {
                CartProductVO *vo = (CartProductVO *)[goodArr[i] objectAtIndex:j];
                if ([vo.stock integerValue] > 0) {
                    allSelectNum ++;
                }
            }
        }
    }
    
    if (selectNum < allSelectNum) {
        [_allCB setChecked:NO];
    }else{
        [_allCB setChecked:YES];
    }
    
    NSString *btnStr = nil;
    if (totalItem != 0) {
        btnStr = [NSString stringWithFormat:@"结算(%zi)", selectNum];
    } else {
        btnStr = @"结算";
    }
    
    [self performSelectorOnMainThread:@selector(layoutCashBtn:) withObject:btnStr waitUntilDone:YES];
}

- (void)layoutSaleView
{
    NSString *titleStr = @"";
    
    for (UIView *rview in _headView.subviews) {
        [rview removeFromSuperview];
    }
    
    for (UIView *dview in discView.subviews) {
        [dview removeFromSuperview];
    }
    
    [_headView addSubview:_taobaoView];
    [_headView addSubview:_huiview];
    CGFloat hight = 5;
    for (NSInteger i = 0; i < couponArray.count && dataArray.count; i++) {
        if ([[couponArray objectAtIndex:i] isKindOfClass:[NSString class]]) {
            titleStr = couponArray[i];
            CGSize lblSize = CGSizeZero;
            UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            [titleLbl setFont:[UIFont boldSystemFontOfSize:15.0]];
            [titleLbl setTextColor:[UIColor colorWithRed:0.35 green:0.35 blue:0.35 alpha:1]];
            [titleLbl setTextAlignment:NSTextAlignmentLeft];
            titleLbl.numberOfLines = 0;// 不可少Label属性之一
            titleLbl.lineBreakMode = NSLineBreakByCharWrapping;// 不可少Label属性之二
            [titleLbl setText:titleStr];
            lblSize = [titleLbl.text sizeWithFont:titleLbl.font constrainedToSize:CGSizeMake(CGRectGetWidth(self.view.frame)-69, 10000) lineBreakMode:NSLineBreakByCharWrapping];
            NSRange foundObj=[titleStr rangeOfString:@"包邮" options:NSCaseInsensitiveSearch];
            if(foundObj.length>0) {
                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
                [imgView setImage:[UIImage imageNamed:@"activity"]];
                [imgView setFrame:CGRectMake(12, hight, 40, lblSize.height)];
                UILabel *shepLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, lblSize.height)];
                shepLbl.backgroundColor = [UIColor clearColor];
                [shepLbl setText:@"包邮"];
                [shepLbl setTextColor:[UIColor whiteColor]];
                [shepLbl setFont:[UIFont systemFontOfSize:15.0]];
                [imgView addSubview:shepLbl];
                [discView addSubview:imgView];
                [titleLbl setFrame:CGRectMake(57, hight, CGRectGetWidth(self.view.frame)-69, lblSize.height)];
            } else {
                [titleLbl setFrame:CGRectMake(12, hight, CGRectGetWidth(self.view.frame)-12, lblSize.height)];
            }
            [discView addSubview:titleLbl];
            hight += (lblSize.height + 5);
        }
    }
    [discView setFrame:CGRectMake(0, CGRectGetMaxY(_huiview.frame), ScreenW, hight)];
//    [_headView addSubview:discView];
//    [_headView setFrame:CGRectMake(0, 0, ScreenW, CGRectGetMaxY(_huiview.frame)+hight)];
    [_headView setFrame:CGRectMake(0, 0, ScreenW, CGRectGetMaxY(_huiview.frame)+hight - 46)];
    [self.tableView setTableHeaderView:_headView];
    [_footView setHidden:NO];
    [_headView setHidden:NO];
}

#pragma mark - UpdateCartRequest
- (void)updateCartOperation:(NSArray *)arr
{
    [self loadWithHud];
    [_cashBtn setEnabled:NO];
    [_cbBtn setEnabled:NO];

    NSString *cartid = nil;
    NSString *userid = nil;
    NSString *usertoken = nil;
    
    if ([[kata_CartManager sharedCartManager] hasCartID]) {
        cartid = [[kata_CartManager sharedCartManager] cartID];
    }
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isEqualToString:@""]) {
        userid = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"];
    }
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isEqualToString:@""]) {
        usertoken = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"];
    }
    
    if (userid && usertoken) {
        cartid = nil;
    }
    
    NSMutableArray *productArr = [[NSMutableArray alloc] init];
    NSMutableArray *payArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < _selectedArr.count; i++) {
        NSMutableArray *eventArray = [[NSMutableArray alloc] init];
        for (NSInteger j = 0; j <[(NSArray *)_selectedArr[i] count]; j ++) {
            if ([[_selectedArr[i] objectAtIndex:j] boolValue]) {
                if (arr) {
                    if ([[arr[i] objectAtIndex:j] isKindOfClass:[CartProductVO class]]) {
                        CartProductVO *goodVO = (CartProductVO *)[arr[i] objectAtIndex:j];
                        NSMutableDictionary *productDict = [NSMutableDictionary new];
                        [productDict setObject:goodVO.item_id forKey:@"cart_goods_id"];
                        [productDict setObject:goodVO.qty forKey:@"quantity"];
                        [productArr addObject:productDict];
                        [eventArray addObject:[arr[i] objectAtIndex:j]];
                    }else if ([[arr[i] objectAtIndex:j] isKindOfClass:[CartBrandVO class]]){
                        [eventArray addObject:[arr[i] objectAtIndex:j]];
                    }
                }
            }
        }
        [payArray addObjectsFromArray:eventArray];
    }
    _cashArr = payArray;
    
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
                                           andSeckillID:-1];
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(updateCartParseResponse:) withObject:resp waitUntilDone:YES];
    } failed:^(NSError *error) {
        [self hideHUDView];
        [self performSelectorOnMainThread:@selector(cartStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
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
                    }
                    [self cartInfoSuccess];
                    
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
    [_cashBtn setUserInteractionEnabled:YES];
    [self hideHUDView];
}

- (void)cartInfoSuccess
{
    if (_cartInfo) {
        _freightFee = _cartInfo.Freight;
        
        [self calTotal:dataArray];
    }
    if (dataArray.count > 0) {
        [self performSelectorOnMainThread:@selector(hasGoodLayout) withObject:nil waitUntilDone:YES];
    }else{
        [self performSelectorOnMainThread:@selector(noGoodLayout) withObject:nil waitUntilDone:YES];
    }
    
    if (resetUpdate) {
        resetUpdate = NO;
        if (stockFlag) {
            [self textStateHUD:@"商品库存不足，请重新选择商品数量"];
            [_cashBtn setEnabled:YES];
            return;
        }
        
        BOOL select = NO;
        for (id num in _selectedArr) {
            for (NSNumber *Flag in num) {
                if ([Flag boolValue]) {
                    select = YES;
                    break;
                }
            }
        }
        
        if (select && _cashArr && _cashArr.count > 0) {
            //如已登录，check
            NSDictionary *moneyDict = [NSDictionary dictionaryWithObjectsAndKeys:_cartInfo.CartMoney, @"money", _freightFee, @"shipfee",[NSNumber numberWithInteger:-1], @"seckill", nil];
            kata_PayCheckViewController *payCheckVC = [[kata_PayCheckViewController alloc] initWithProductData:_cashArr andMoneyInfo:moneyDict];
            payCheckVC.navigationController = self.navigationController;
            [payCheckVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:payCheckVC animated:YES];
        } else {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"提示"
                                  message:@"请至少选中一件商品！"
                                  delegate:self
                                  cancelButtonTitle:@"确定"
                                  otherButtonTitles:nil];
            [alert show];
            [_cashBtn setEnabled:YES];
            [self hideHUDView];
        }
    }
    [self hideHUDView];
}

#pragma mark - UpdatenumCartRequest
- (void)updateCartNumOperation
{
    NSString *cartid = nil;
    NSString *userid = nil;
    NSString *usertoken = nil;
    
    if ([[kata_CartManager sharedCartManager] hasCartID]) {
        cartid = [[kata_CartManager sharedCartManager] cartID];
    }
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isEqualToString:@""]) {
        userid = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"];
    }
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isEqualToString:@""]) {
        usertoken = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"];
    }
    
    if (userid && usertoken) {
        cartid = nil;
    }
    
    NSMutableArray *productArr = [NSMutableArray new];
    for (NSInteger i = 0; i < _selectedArr.count; i++) {
        for (NSInteger j = 0; j < [(NSArray *)_selectedArr[i] count]; j++) {
            if ([[dataArray[i] objectAtIndex:j] isKindOfClass:[CartProductVO class]]) {
                if ([_selectedArr[i][j] boolValue]) {
                    CartProductVO *goodVO = (CartProductVO *)[dataArray[i] objectAtIndex:j];
                    NSMutableDictionary *productDict = [NSMutableDictionary new];
                    [productDict setObject:goodVO.item_id forKey:@"cart_goods_id"];
                    [productDict setObject:goodVO.qty forKey:@"quantity"];
                    [productDict setObject:goodVO.sku forKey:@"product_sku"];
                    [productArr addObject:productDict];
                }
            }
        }
    }
    
    KTCartOperateRequest *req = [[KTCartOperateRequest alloc] initWithCartID:cartid
                                                                   andUserID:userid
                                                                andUserToken:usertoken
                                                                     andType:@"update"
                                                                  andProduct:productArr
                                                                   andGoodID:nil
                                                                andAddressID:-1
                                                                 andCouponNO:nil
                                                              andCoponUserID:-1
                                                                   andCredit:-1
                                                                andSeckillID:-1];
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(updateCartNumParseResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        
        [self performSelectorOnMainThread:@selector(cartStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
        [_cashBtn setEnabled:YES];
        [_cbBtn setEnabled:YES];
        [self hideHUDView];
    }];
    
    [proxy start];
}

- (void)updateCartNumParseResponse:(NSString *)resp
{
    NSString * hudPrefixStr = @"获取购物车信息";
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            if (nil != [respDict objectForKey:@"data"] && ![[respDict objectForKey:@"data"] isEqual:[NSNull null]] && [[respDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *dataObj = (NSDictionary *)[respDict objectForKey:@"data"];
                if ([[dataObj objectForKey:@"code"] integerValue] == 0) {
                    CartNumVO *cartvo = [CartNumVO CartNumVOWithDictionary:dataObj];
                    [self performSelectorOnMainThread:@selector(jumpToNext:) withObject:cartvo waitUntilDone:YES];
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
    [_cashBtn setEnabled:YES];
    [_cbBtn setEnabled:YES];
}

#pragma mark - DeleteCartRequest
- (void)deleteCartOperation
{
    [_cashBtn setEnabled:NO];
    [_cbBtn setEnabled:NO];
    
//    if (!stateHud) {
//        stateHud = [[MBProgressHUD alloc] initWithView:self.contentView];
//        stateHud.delegate = self;
//        [self.contentView addSubview:stateHud];
//    }
//    stateHud.mode = MBProgressHUDModeIndeterminate;
//    stateHud.labelFont = [UIFont systemFontOfSize:14.0f];
//    [stateHud show:YES];
    
    NSString *cartid = nil;
    NSString *userid = nil;
    NSString *usertoken = nil;
    
    if ([[kata_CartManager sharedCartManager] hasCartID]) {
        cartid = [[kata_CartManager sharedCartManager] cartID];
    }
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isEqualToString:@""]) {
        userid = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"];
    }
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isEqualToString:@""]) {
        usertoken = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"];
    }
    
    if (userid && usertoken) {
        cartid = nil;
    }
    
    KTCartOperateRequest *req = [[KTCartOperateRequest alloc] initWithCartID:cartid
                                             andUserID:userid
                                          andUserToken:usertoken
                                               andType:@"delete"
                                            andProduct:nil
                                             andGoodID:_deleteItemID
                                          andAddressID:-1
                                           andCouponNO:nil
                                        andCoponUserID:-1
                                             andCredit:-1
                                          andSeckillID:-1];
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(deleteCartParseResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        
        [self performSelectorOnMainThread:@selector(cartStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
        [_cashBtn setEnabled:YES];
        [_cbBtn setEnabled:YES];
    }];
    
    [proxy start];
}

- (void)deleteCartParseResponse:(NSString *)resp
{
    NSString * hudPrefixStr = @"商品移除";
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            if (nil != [respDict objectForKey:@"data"] && ![[respDict objectForKey:@"data"] isEqual:[NSNull null]] && [[respDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *dataObj = (NSDictionary *)[respDict objectForKey:@"data"];
                if ([[dataObj objectForKey:@"code"] integerValue] == 0) {
                    [self cartDeleteSuccess];
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
    [_cashBtn setEnabled:YES];
    [_cbBtn setEnabled:YES];
}

- (void)cartDeleteSuccess
{
    if (_deleteItemID) {
        for (NSInteger i = 0; i < dataArray.count; i++) {
            for (NSInteger j = 0; j < [(NSArray *)dataArray[i] count]; j ++) {
                id datavo = dataArray[i];
                if ([datavo[j] isKindOfClass:[CartProductVO class]]) {
                    CartProductVO *vo = (CartProductVO *)datavo[j];
                    if ([vo.item_id isEqual:_deleteItemID]) {
                        [dataArray[i] removeObjectAtIndex:j];
                        CartBrandVO *brandVO = (CartBrandVO *)dataArray[i][0];
                        NSMutableArray *array = [NSMutableArray arrayWithArray:brandVO.product_arr];
                        [array removeObjectAtIndex:j -1];
                        brandVO.product_arr = array;
                        dataArray[i][0] = brandVO;
                        [_selectedArr[i] removeObjectAtIndex:j];
                        break;
                    }
                }
            }
            if ([(NSArray *)dataArray[i] count] == 1) {
                [dataArray removeObjectAtIndex:i];
                [_selectedArr removeObjectAtIndex:i];
            }
        }
    }
    
    [self.tableView reloadData];
    
    if (cart_num > 0) {
        cart_num --;
        [[kata_CartManager sharedCartManager] updateCartCounter:[NSNumber numberWithInteger:cart_num]];
        [self performSelectorOnMainThread:@selector(updateCartNum) withObject:nil waitUntilDone:YES];
    }
    
    NSMutableArray *array = [[kata_CartManager sharedCartManager] cartSkuID];
    [[kata_CartManager sharedCartManager] updateCartSku:array];
    for (NSInteger i = 0; i < array.count; i ++) {
        if ([array[i] isEqualToString:_deleteSkuID]) {
            [array removeObjectAtIndex:i];
        }
    }
    [[kata_CartManager sharedCartManager] updateCartSku:array];
    
    [self hideHUDView];
    [self calTotal:dataArray];
    [self updateCartOperation:dataArray];
    
    if (dataArray.count == 0) {
        self.statefulState = FTStatefulTableViewControllerStateEmpty;
        [self.tableView.tableHeaderView  setHidden:YES];
        [self performSelectorOnMainThread:@selector(noGoodLayout) withObject:nil waitUntilDone:YES];
    }
}

- (void)hideHUDView
{
    [stateHud hide:YES afterDelay:0.3];
    [loading stop];

}

#pragma mark -
#pragma tableView delegate && datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (dataArray.count > 0 && !is_loading) {
        return dataArray.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (dataArray.count > 0) {
        return [(NSArray *)dataArray[section] count];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    static NSString *CELL_IDENTIFI = @"CARTGOOD_CELL";
    static NSString *BRAND_IDENTIFI = @"CARTBRAND_CELL";
    id vo = [dataArray[section] objectAtIndex:row];
    if ([vo isKindOfClass:[CartBrandVO class]]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFI];
        if (!cell) {
            cell = [[KTShopCartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFI delegate:self];
        }
        
        [(KTShopCartTableViewCell *)cell setCartCellDelegate:self];
        [(KTShopCartTableViewCell *)cell setDataVO:vo andSection:section];
        NSArray *arry = _selectedArr[section];
        [(KTShopCartTableViewCell *)cell setSelectState:[[arry objectAtIndex:row] boolValue]];
        cell.backgroundColor = [UIColor whiteColor];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = NO;
        return cell;
    }else if([vo isKindOfClass:[CartProductVO class]]){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BRAND_IDENTIFI];
        if (!cell) {
            cell = [[KTShopCartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BRAND_IDENTIFI delegate:self];
        }
        
        [(KTShopCartTableViewCell *)cell setCartCellDelegate:self];
        [(KTShopCartTableViewCell *)cell setDataVO:vo andSection:section];
        NSArray *arry = _selectedArr[section];
        [(KTShopCartTableViewCell *)cell setSelectState:[[arry objectAtIndex:row] boolValue]];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = NO;
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (dataArray.count > 0) {
        if ([[dataArray[section] objectAtIndex:row] isKindOfClass:[CartBrandVO class]]) {
            return 35;
        }else{
            return 85;
        }
    }else{
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if ([[dataArray[section] objectAtIndex:row] isKindOfClass:[CartProductVO class]]) {
        CartProductVO *vo = (CartProductVO *)[dataArray[section] objectAtIndex:row];
        kata_ProductDetailViewController *detailVC = [[kata_ProductDetailViewController alloc] initWithProductID:[vo.product_id intValue] andType:nil andSeckillID:-1];
        detailVC.navigationController = self.navigationController;
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

#pragma mark - BOKUShopCartListCell Delegate
- (void)selectCheckBoxAtCell:(id)cell andVO:(id)dataVO andCheck:checked andSection:(NSInteger)section
{
    if ([cell isKindOfClass:[KTShopCartTableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        NSInteger row = indexPath.row;
        if ([dataVO isKindOfClass:[CartBrandVO class]]) {
            CartBrandVO *vo = dataVO;
            BOOL brandFlag = [checked boolValue];
            for (NSInteger i = 0; i <= vo.product_arr.count; i++) {
                if (brandFlag) {
                    [_selectedArr[section] setObject:[NSNumber numberWithBool:NO] atIndexedSubscript:i];
                }else{
                    [_selectedArr[section] setObject:[NSNumber numberWithBool:YES] atIndexedSubscript:i];
                }
            
                NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:section];
                [(KTShopCartTableViewCell *)[self.tableView cellForRowAtIndexPath:index] setSelectState:[[_selectedArr[section] objectAtIndex:i] boolValue]];
            }
        }else if([dataVO isKindOfClass:[CartProductVO class]]){
            BOOL rowFlag = [[_selectedArr[section] objectAtIndex:row] boolValue];
            [_selectedArr[section] setObject:[NSNumber numberWithBool:!rowFlag] atIndexedSubscript:row];
            
            if (!rowFlag) {
                for (NSInteger i = 0; i < [(NSArray *)_selectedArr[section] count]; i++) {
                    [_selectedArr[section] setObject:[NSNumber numberWithBool:YES] atIndexedSubscript:0];
                    if (![[_selectedArr[section] objectAtIndex:i] boolValue]) {
                        [_selectedArr[section] setObject:[NSNumber numberWithBool:YES] atIndexedSubscript:0];
                        break;
                    }
                }
            }else{
                [_selectedArr[section] setObject:[NSNumber numberWithBool:NO] atIndexedSubscript:0];
            }
            
            [(KTShopCartTableViewCell *)cell setSelectState:[[_selectedArr[section] objectAtIndex:row] boolValue]];
            NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:section];
            [(KTShopCartTableViewCell *)[self.tableView cellForRowAtIndexPath:index] setSelectState:[[_selectedArr[section] objectAtIndex:0] boolValue]];
        }
        
    }
    
    for (NSArray *array in _selectedArr) {
        for (NSNumber *num in array) {
            [_allCB setChecked:YES];
            if (![num boolValue]) {
                [_allCB setChecked:NO];
                break;
            }
        }
    }
    [self calTotal:dataArray];
    [self updateCartOperation:dataArray];
}

- (void)pressCountBtnAtCell:(NSNumber *)goodid andCount:(NSNumber *)count
{
    for (id obj in dataArray) {
        for (id datavo in obj) {
            if ([datavo isKindOfClass:[CartProductVO class]]) {
                CartProductVO *vo = (CartProductVO *)datavo;
                if ([vo.item_id isEqual:goodid]) {
                    [vo setQty:count];
                    break;
                }
            }
        }
    }
    [self calTotal:dataArray];
    
    if (_cartNumTimer) {
        [_cartNumTimer invalidate];
    }
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:goodid, @"itemid", count, @"count", nil];
    _cartNumTimer = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(handleNumChange:) userInfo:dict repeats:NO];
}

- (void)handleNumChange:(NSTimer *)timer
{
    if ([[timer userInfo] isKindOfClass:[NSDictionary class]]) {
        NSDictionary *goodDict = [timer userInfo];
        for (NSInteger i = 0; i < dataArray.count; i++) {
            for (NSInteger j = 0; j < [(NSArray *)dataArray[i] count]; j++) {
                if ([[dataArray[i] objectAtIndex:j] isKindOfClass:[CartProductVO class]]) {
                    CartProductVO *vo = (CartProductVO *)[dataArray[i] objectAtIndex:j];
                    if ([vo.item_id isEqual:[goodDict objectForKey:@"itemid"]]) {
                        if ([[_selectedArr[i] objectAtIndex:j] boolValue]) {
                            [self updateCartOperation:dataArray];
                        }
                        break;
                    }
                }
            }
        }
    }
    
    if (_cartNumTimer) {
        [_cartNumTimer invalidate];
    }
}

- (void)pressDeleteAtCell:(CartProductVO *)productvo
{
    _deleteItemID = productvo.item_id;
    _deleteSkuID = productvo.sku;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除商品"
                                                    message:@"是否确认从购物车中移除该商品？"
                                                   delegate:self
                                          cancelButtonTitle:@"移除"
                                          otherButtonTitles:@"取消", nil];
    alert.tag = 20003;
    [alert show];
}

#pragma mark - UIAlert Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger tag = alertView.tag;
    if (tag == 20003) {
        if (buttonIndex == 0) {
            if (_deleteItemID) {
                [self deleteCartOperation];
            }
        }
    }
}

#pragma mark - Login Delegate
- (void)didLogin
{
    [_cashBtn setEnabled:NO];
    [self loadNoState];
}

- (void)loginCancel
{
    [self loadNoState];
}

-(void)updateCartNum
{
    //购物车数量更新
    UITabBar *tabBar = self.tabBarController.tabBar;
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:3];
    
    NSNumber *countValue = [[kata_CartManager sharedCartManager] cartCounter];
    if ([countValue intValue]>0) {
        [tabBarItem3 setBadgeValue:[[[kata_CartManager sharedCartManager] cartCounter] stringValue]];
    }
    else
    {
        [tabBarItem3 setBadgeValue:0];
    }
}

- (void)loadWithHud
{
//    if (!stateHud) {
//        stateHud = [[MBProgressHUD alloc] initWithView:self.contentView];
//        stateHud.delegate = self;
//        [self.contentView addSubview:stateHud];
//    }
//    stateHud.mode = MBProgressHUDModeIndeterminate;
//    [stateHud show:YES];
    if (!loading) {
        loading = [[Loading alloc] initWithFrame:CGRectMake(0, 0, 180, 100) andName:[NSString stringWithFormat:@"loading.gif"]];
        loading.center = self.contentView.center;
        [loading.layer setCornerRadius:10.0];
        [self.view addSubview:loading];
    }
    [loading start];
}


@end
