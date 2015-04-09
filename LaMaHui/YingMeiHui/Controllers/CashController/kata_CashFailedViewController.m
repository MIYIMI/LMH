//
//  kata_CashFailedViewController.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-8-17.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "kata_CashFailedViewController.h"
#import "kata_UserManager.h"
#import "kata_CartManager.h"
#import "KTPaymentDataGetRequest.h"
#import "PaymentListVO.h"
#import "kata_UserManager.h"
#import "KTOrderpayDataGetRequest.h"
#import "KTCartOperateRequest.h"
#import "CartInfo.h"
#import "WXPayInfo.h"
#import "KTWXpayRequest.h"
#import "KTOtherProductListviewTableViewCell.h"
#import "kata_ProductDetailViewController.h"
#import "LikeProductVO.h"
#import <AlipaySDK/AlipaySDK.h>
#define TABLEVIEWCOLOR      [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1]
#define BOTTOMHEIGHT        45

@interface kata_CashFailedViewController ()<KTOtherProductListviewTableViewCellDelegate>
{
    UIView *_bottomView;
    UIButton *_payBtn;
    UILabel *_totalLbl;
    UILabel *timeLbl;
    UIView *sectionHeadView;
    CGRect tabBarFrame;
    
    BOOL _isPaymentLoaded;
    BOOL _isPayed;
    BOOL currentVC;
    NSTimer *backTimer;
    NSInteger backTime;
    
    UIView *_payTitleView;
    NSMutableArray *_paymentArr;
    NSString *_orderID;
    NSNumber *_orderFee;
    BOOL _type;
    //商品类型
    NSInteger _productType;
    NSInteger _seckillID;
    NSInteger _productid;
    NSMutableArray *likeArray;
}

@property (nonatomic) NSInteger paymentID;

@end

@implementation kata_CashFailedViewController

- (id)initWithOrderInfo:(NSDictionary *)orderInfo andPay:(BOOL)paytype andType:(BOOL)type
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // Custom initialization
        self.ifShowTableSeparator = NO;
        self.ifAddPullToRefreshControl = NO;
        self.navigationController.ifPopToRootView = YES;
        
        _isPaymentLoaded = NO;
        _isPayed = paytype;
        _paymentID = -1;
        _type = type;
        currentVC = YES;
        backTime = 5;
        
        likeArray = [NSMutableArray array];
        
        _orderID = nil;
        if ([orderInfo objectForKey:@"orderid"]) {
            _orderID = [orderInfo objectForKey:@"orderid"];
        }
        
        _orderFee = nil;
        if ([orderInfo objectForKey:@"money"]) {
            _orderFee = [orderInfo objectForKey:@"money"];
        }
        
        _productid = [orderInfo[@"product_id"] integerValue];
        
        _paymentArr = [[NSMutableArray alloc] initWithObjects:@"WAITTING", nil];
        
        if (type) {
            self.title = @"支付结果";
        }else{
            self.title = @"收银台";
        }
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payResult:) name:@"PAY_RESULT" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WXPayResult:) name:@"WXPAY" object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    if (!_isPayed) {
        [self loadPayment];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PAY_RESULT" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WXPAY" object:nil];
    currentVC = NO;
//    self.tabBarController.tabBar.frame = tabBarFrame;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    currentVC = YES;
    _payBtn.enabled = YES;
//    tabBarFrame = self.tabBarController.tabBar.frame;
//    self.tabBarController.tabBar.frame = CGRectNull;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[(kata_AppDelegate *)[[UIApplication sharedApplication] delegate] deckController] setPanningMode:IIViewDeckNoPanning];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI
{
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.contentView setBackgroundColor:TABLEVIEWCOLOR];
    [self.tableView setDelaysContentTouches:NO];
    [self.tableView setBounces:NO];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    [self layoutBottomView];
}

- (void)layoutBottomView
{
    [self.tableView setScrollEnabled:NO];
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), 190)];
    if (_type && _isPayed) {
        header.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), 190+ScreenW/1242*241 + 10);
    }
    [header setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *msgLbl = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, ScreenW - 60, 40)];
    [msgLbl setBackgroundColor:[UIColor clearColor]];
    [msgLbl setTextColor:LMH_COLOR_SKIN];
    [msgLbl setFont:[UIFont systemFontOfSize:24.0]];
    [msgLbl setTextAlignment:NSTextAlignmentCenter];
    [msgLbl setText:@"付款没有成功哦！"];
    [header addSubview:msgLbl];
    
    UILabel *getJifenLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, ScreenW - 20, 0)];
    getJifenLabel.hidden = YES;
    
    if(_type && _isPayed){ //成功
        getJifenLabel.frame = CGRectMake(10, 50, ScreenW - 20, 40);
        getJifenLabel.backgroundColor = [UIColor clearColor];
        getJifenLabel.textAlignment = NSTextAlignmentCenter;
        getJifenLabel.text = [NSString stringWithFormat:@"本次购物已获得%@金豆",self.get_creditStr];
        getJifenLabel.font = FONT(20);
        getJifenLabel.textColor = [UIColor grayColor];
        [header addSubview:getJifenLabel];
    }
    CGFloat jifenHight = CGRectGetMaxY(getJifenLabel.frame) +10;
    
    UIImageView *failedImage = [[UIImageView alloc]initWithFrame:CGRectMake(50, jifenHight, 80*ScreenW/320, 110*ScreenW/320)];
    failedImage.image = [UIImage imageNamed:@"payFailed_cryChilden"];
    [header addSubview:failedImage];
    
    UILabel *promissionLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, jifenHight, ScreenW/2, 20)];
    promissionLabel.text = @"辣妈汇承诺所有商品：";
    promissionLabel.font = [UIFont systemFontOfSize:13];
    promissionLabel.textColor = [UIColor grayColor];
    promissionLabel.backgroundColor = [UIColor clearColor];
    [header addSubview:promissionLabel];
    
    //图标
    UIImageView *qualityGoodsImage= [[UIImageView alloc]initWithFrame:CGRectMake(160, jifenHight +30, 18, 18)];
    qualityGoodsImage.image = [UIImage imageNamed:@"payFailed_qualityGoods"];
    [header addSubview:qualityGoodsImage];
    
    UIImageView *refundGoodsImage= [[UIImageView alloc]initWithFrame:CGRectMake(160, jifenHight +60, 18, 18)];
    refundGoodsImage.image = [UIImage imageNamed:@"payFailed_refundGoods"];
    [header addSubview:refundGoodsImage];
    
    UIImageView *shipmentTimeImage= [[UIImageView alloc]initWithFrame:CGRectMake(160, jifenHight +90, 18, 18)];
    shipmentTimeImage.image = [UIImage imageNamed:@"payFailed_shipmentTime"];
    [header addSubview:shipmentTimeImage];
    
    
    //文字说明
    UILabel *qualityGoodsLabel = [[UILabel alloc]initWithFrame:CGRectMake(190, jifenHight +30, 100, 20)];
    qualityGoodsLabel.backgroundColor = [UIColor clearColor];
    qualityGoodsLabel.text = @"100%正品";
    qualityGoodsLabel.font = [UIFont systemFontOfSize:10];
    qualityGoodsLabel.textColor = [UIColor grayColor];
    [header addSubview:qualityGoodsLabel];
    
    UILabel *refundGoodsLabel = [[UILabel alloc]initWithFrame:CGRectMake(190, jifenHight +60, 100, 20)];
    refundGoodsLabel.backgroundColor = [UIColor clearColor];
    refundGoodsLabel.text = @"7天无理由退款";
    refundGoodsLabel.font = [UIFont systemFontOfSize:10];
    refundGoodsLabel.textColor = [UIColor grayColor];
    [header addSubview:refundGoodsLabel];
    
    UILabel *shipmentTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(190, jifenHight +90, 100, 20)];
    shipmentTimeLabel.backgroundColor = [UIColor clearColor];
    shipmentTimeLabel.text = @"48小时内发货";
    shipmentTimeLabel.font = [UIFont systemFontOfSize:10];
    shipmentTimeLabel.textColor = [UIColor grayColor];
    [header addSubview:shipmentTimeLabel];
    
    //分隔线
    UIView *sepratelineView = [[UIView alloc]initWithFrame:CGRectMake(0, jifenHight + 130, ScreenW, 1)];
    sepratelineView.backgroundColor = [UIColor colorWithRed:0.87 green:0.83 blue:0.84 alpha:1];
    [header addSubview:sepratelineView];
    [sepratelineView setHidden:NO];
    
    [header setFrame:CGRectMake(0, 0, ScreenW, CGRectGetMaxY(sepratelineView.frame)+5)];
    
    if(_type && !_isPayed){
        self.navigationController.ifPopToOrderView = YES;
        self.navigationController.ifPopToRootView = NO;
        [self.tableView setTableHeaderView:header];
    }else if(_type && _isPayed){
        [self.tableView setScrollEnabled:YES];
        [_bottomView setHidden:YES];
        [sepratelineView setHidden:YES];
        msgLbl.text = @"付款成功";
        getJifenLabel.hidden = NO;
        failedImage.image = [UIImage imageNamed:@"payVictory_smileChilden"];
        [header setFrame:CGRectMake(0, 0, ScreenW, CGRectGetMaxY(sepratelineView.frame)+15 + ScreenW/1242*241)];
        UIImageView *reminder = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(failedImage.frame) + 15, ScreenW, ScreenW/1242*241)];
        reminder.image = [UIImage imageNamed:@"paySuccess"];
        [header addSubview:reminder];
        
        self.navigationController.ifPaySucess = YES;
        self.navigationController.ifPopToOrderView = YES;
        self.navigationController.ifPopToRootView = NO;
        self.title = @"支付结果";
        [self.tableView setTableHeaderView:header];
        return;
    }
    
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.contentView.frame) - BOTTOMHEIGHT, CGRectGetWidth(self.contentView.frame), BOTTOMHEIGHT)];
        [_bottomView setBackgroundColor:[UIColor clearColor]];
        
        UIView *subview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), BOTTOMHEIGHT)];
        [subview setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.90]];
        
        UILabel *lineLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(subview.frame), 0.5)];
        [lineLbl setBackgroundColor:[UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1]];
        [subview addSubview:lineLbl];
        
        UILabel *priceTipLbl = [[UILabel alloc] initWithFrame:CGRectMake(9, 0, 45, CGRectGetHeight(subview.frame))];
        [priceTipLbl setBackgroundColor:[UIColor clearColor]];
        [priceTipLbl setFont:[UIFont systemFontOfSize:14.0]];
        [priceTipLbl setTextAlignment:NSTextAlignmentCenter];
        [priceTipLbl setText:@"总计:"];
        priceTipLbl.backgroundColor = [UIColor clearColor];
        [subview addSubview:priceTipLbl];
        if (!_totalLbl) {
            _totalLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(priceTipLbl.frame), 0, 70, CGRectGetHeight(subview.frame))];
            [_totalLbl setBackgroundColor:[UIColor clearColor]];
            [_totalLbl setFont:[UIFont systemFontOfSize:14.0]];
            [_totalLbl setTextAlignment:NSTextAlignmentLeft];
            [_totalLbl setTextColor:[UIColor colorWithRed:0.98 green:0.3 blue:0.4 alpha:1]];
            [subview addSubview:_totalLbl];
        }
        [_bottomView addSubview:subview];
        
        if (_orderFee) {
            [_totalLbl setText:[NSString stringWithFormat:@"¥%0.2f",[_orderFee floatValue]]];
        }
        
        UIButton *payBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 84, 8, 73, 30)];
        UIImage *image = [UIImage imageNamed:@"red_btn_small"];
        image = [image stretchableImageWithLeftCapWidth:10.0f topCapHeight:10.0f];
        [payBtn setBackgroundImage:image forState:UIControlStateNormal];
        image = [UIImage imageNamed:@"red_btn_small"];
        [payBtn setBackgroundImage:image forState:UIControlStateHighlighted];
        [payBtn setBackgroundImage:image forState:UIControlStateSelected];
        [payBtn setTitle:@"付款" forState:UIControlStateNormal];
        [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [[payBtn titleLabel] setFont:[UIFont boldSystemFontOfSize:14.0f]];
        [payBtn addTarget:self action:@selector(goToPay) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:payBtn];
        _payBtn = payBtn;
        [_payBtn setEnabled:NO];
        [self.contentView addSubview:_bottomView];
    }
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), BOTTOMHEIGHT + 10)];
    [footer setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableFooterView:footer];
}

- (void)setPaymentID:(NSInteger)paymentID
{
    _paymentID = paymentID;
    if (_paymentID != -1) {
        if (_orderID && _orderFee) {
            [_payBtn setEnabled:YES];
        } else {
            [_payBtn setEnabled:NO];
        }
    } else {
        [_payBtn setEnabled:NO];
    }
}

- (void)goToPay
{
    if (![[kata_UserManager sharedUserManager] isLogin]) {
        [kata_LoginViewController showInViewController:self];
        return;
    }
    
    switch (_paymentID) {
        case 1:         //钱包支付
        {
            //            kata_InputPayPwdViewController *payPwdVC = [[kata_InputPayPwdViewController alloc] initWithOrderID:_orderid andTotal:((CGFloat)_productcount) * [_price floatValue] + [_shipFee floatValue]];
            //            payPwdVC.navigationController = self.navigationController;
            //            [self.navigationController pushViewController:payPwdVC animated:YES];
        }
            break;
            
        case 2:         //支付宝支付
        {
            [self loadOrderPayData];
        }
            break;
            
        case 3:         //微信支付
        {
            if (!WXApi.isWXAppInstalled) {
                [self textStateHUD:@"您未安装微信，请安装后使用"];
                return;
            }
            [self loadWXPay];
        }
            break;
            
        case 4:         //银联支付
        {
            [self loadOrderPayData];
        }
            break;
            
        default:
            break;
    }

}

#pragma mark - Orderpay Data Get
- (void)loadOrderPayData
{
    [_payBtn setEnabled:NO];
    if (!stateHud) {
        stateHud = [[MBProgressHUD alloc] initWithView:self.contentView];
        stateHud.delegate = self;
        [self.contentView addSubview:stateHud];
    }
    stateHud.mode = MBProgressHUDModeIndeterminate;
    stateHud.labelFont = [UIFont systemFontOfSize:14.0f];
    [stateHud show:YES];
    
    KTBaseRequest *req = [[KTBaseRequest alloc] init];
    
    NSString *userid = nil;
    NSString *usertoken = nil;
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isEqualToString:@""]) {
        userid = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"];
    }
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isEqualToString:@""]) {
        usertoken = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"];
    }
    
    if (userid && usertoken) {
        req = [[KTOrderpayDataGetRequest alloc] initWithUserID:[userid integerValue]
                                                  andUserToken:usertoken
                                                    andOrderID:_orderID
                                                      andPayID:_paymentID andAddressID:-1 andUserCopID:nil];
        
    }
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(loadOrderPayDataParseResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (void)loadOrderPayDataParseResponse:(NSString *)resp
{
    NSString *hudPrefixStr = @"支付信息获取";
    
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            if ([respDict objectForKey:@"data"] != nil && ![[respDict objectForKey:@"data"] isEqual:[NSNull null]]) {
                id dataObj = [respDict objectForKey:@"data"];
                
                if ([dataObj isKindOfClass:[NSDictionary class]]) {
                    if ([respDict objectForKey:@"code"] && [[respDict objectForKey:@"code"] intValue] == 0) {
                        //                    if ([statusStr objectForKey:@"code"] && [[statusStr objectForKey:@"code"] intValue] == 0) {
                        if ([dataObj objectForKey:@"paymsg"] && [[dataObj objectForKey:@"paymsg"] isKindOfClass:[NSString class]]) {
                            
                            switch (_paymentID) {
                                case 1:
                                {
                                    
                                }
                                    break;
                                    
                                case 2:         //支付宝支付
                                {
                                    NSString *appScheme = @"YingMeiHuiStoreApp";
                                    NSString *orderString = [dataObj objectForKey:@"paymsg"];
                                    
                                    if (currentVC) {
                                        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                                            [self processResult:resultDic];
                                        }];
                                    }
                                    [self hideHUDView];
                                }
                                    break;
                                    
                                case 3:
                                {
                                    
                                }
                                    break;
                                    
                                case 4:         //银联支付
                                {
                                    NSString *tradenumStr = [dataObj objectForKey:@"paymsg"];
                                    if (![tradenumStr isEqual:[NSNull null]] && tradenumStr.length > 0) {
                                        [UPPayPlugin startPay:tradenumStr
                                                         mode:@"00"
                                               viewController:self
                                                     delegate:self];
                                        [self hideHUDView];
                                    } else {
                                        [self textStateHUD:@"获取支付流水号失败"];
                                    }
                                    
                                    
                                }
                                    break;
                                    
                                default:
                                    break;
                            }
                        } else {
                            [self textStateHUD:@"支付信息获取失败"];
                        }
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
                        
                        if ([dataObj objectForKey:@"code"] && [[dataObj objectForKey:@"code"] integerValue] == -102) {
                            [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[dataObj objectForKey:@"msg"] waitUntilDone:YES];
                            [[kata_UserManager sharedUserManager] logout];
                            [self performSelector:@selector(goToPay) withObject:nil afterDelay:0.1];
                        }
                    }
                }
            }
        }
    }
}

- (void)hideHUDView
{
    [stateHud hide:YES afterDelay:0.3];
}

#pragma mark - Load Payment Data
- (void)loadPayment
{
    KTBaseRequest *req = [[KTBaseRequest alloc] init];
    
    NSString *userid = nil;
    NSString *usertoken = nil;
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isEqualToString:@""]) {
        userid = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"];
    }
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isEqualToString:@""]) {
        usertoken = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"];
    }
    
    if (userid && usertoken) {
        req = [[KTPaymentDataGetRequest alloc] initWithUserID:[userid integerValue]
                                                 andUserToken:usertoken andOrderID:_orderID];
    }
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(loadPaymentParseResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (void)loadPaymentParseResponse:(NSString *)resp
{
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            if ([respDict objectForKey:@"data"] != nil && ![[respDict objectForKey:@"data"] isEqual:[NSNull null]]) {
                id dataObj = [respDict objectForKey:@"data"];
                
                if ([dataObj isKindOfClass:[NSDictionary class]]) {
                    PaymentListVO *listVO = [PaymentListVO PaymentListVOWithDictionary:dataObj];
                    
                    self.get_creditStr = [dataObj objectForKey:@"order_credit"];  //本次购物获得金豆
                   
                    if ([listVO.Code intValue] == 0) {
                        if (listVO.PaymentList) {
                            _paymentArr = [NSMutableArray arrayWithArray:listVO.PaymentList];
                            if (_paymentArr.count > 0) {
                                _isPaymentLoaded = YES;
                            }
                            [self performSelector:@selector(tableViewReloadPay) withObject:nil afterDelay:0.3];
                        }
                    } else if ([listVO.Code intValue] == -102) {
                        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:listVO.Msg waitUntilDone:YES];
                        [[kata_UserManager sharedUserManager] logout];
                        [self performSelectorOnMainThread:@selector(checkLogin) withObject:nil waitUntilDone:YES];
                    }
                }
            }
        }
    }
}

- (void)likeRequest{
    [self loadHUD];
    KTBaseRequest *req = [[KTBaseRequest alloc] init];
    NSMutableDictionary *paramsDict = [req params];
    [paramsDict setObject:@"get_recommend_goods" forKey:@"method"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSNumber numberWithInteger:_productid] forKey:@"product_id"];
    
    [paramsDict setObject:dict forKey:@"params"];
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        [self performSelector:@selector(likeRespone:) withObject:resp withObject:nil];
    } failed:^(NSError *error) {
        [self hideHUD];
    }];
    [proxy start];
}

- (void)likeRespone:(NSString *)resp{
    [self hideHUD];
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            if ([respDict objectForKey:@"data"] != nil && [[respDict objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                NSArray *lkArray = [LikeProductVO LikeProductVOWithArray:[respDict objectForKey:@"data"]];
                
                if (lkArray.count > 0) {
                    NSMutableArray *cellDataArr = [[NSMutableArray alloc] init];
                    
                    for (NSInteger i = 0; i < ceil((CGFloat)lkArray.count / 3.0); i++) {
                        NSMutableArray *cellArr = [[NSMutableArray alloc] init];
                        if ([lkArray objectAtIndex:i * 3] && [[lkArray objectAtIndex:i * 3] isKindOfClass:[LikeProductVO class]]) {
                            [cellArr addObject:[lkArray objectAtIndex:i * 3]];
                        }
                        
                        if (lkArray.count > i * 3 + 1) {
                            if ([lkArray objectAtIndex:i * 3 + 1] && [[lkArray objectAtIndex:i * 3 + 1] isKindOfClass:[LikeProductVO class]]) {
                                [cellArr addObject:[lkArray objectAtIndex:i * 3 + 1]];
                            }
                        }
                        
                        if (lkArray.count > i * 3 + 2) {
                            if ([lkArray objectAtIndex:i * 3 + 2] && [[lkArray objectAtIndex:i * 3 + 2] isKindOfClass:[LikeProductVO class]]) {
                                [cellArr addObject:[lkArray objectAtIndex:i * 3 + 2]];
                            }
                        }
                        [cellDataArr addObject:cellArr];
                    }
                    
                    likeArray = [NSMutableArray arrayWithArray:cellDataArr];
                    [self.tableView reloadData];
                }
            }
        }
    }
}

- (void)tableViewReloadPay
{
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
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

#pragma mark -
#pragma tableView delegate && datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(_isPayed){
        return 1;
    }
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            if(_isPayed){
                return likeArray.count;
            }
            return 1;
        }
            break;
            
        case 1:
        {
            return [_paymentArr count];
        }
            break;
            
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_isPayed) {
        return 35;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (_isPayed) {
        if (!sectionHeadView) {
            sectionHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 30)];
            [sectionHeadView setBackgroundColor:[UIColor whiteColor]];
            
            UILabel *grayLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 10)];
            [grayLbl setBackgroundColor:TABLE_COLOR];
            [sectionHeadView addSubview:grayLbl];
            
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 15, 5, 15)];
            [imgView setImage:[UIImage imageNamed:@"event"]];
            [sectionHeadView addSubview:imgView];
            
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame)+5, 15, ScreenW-CGRectGetMaxX(imgView.frame)-15, 15)];
            [lbl setText:@"辣妈们还看了"];
            [lbl setTextColor:TEXTV_COLOR];
            [lbl setFont:[UIFont systemFontOfSize:13.0]];
            [sectionHeadView addSubview:lbl];
        }
        
        return sectionHeadView;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const TITLEPAY = @"titlepay";
    static NSString *const WAITTINGPAY = @"waittingpay";
    static NSString *const PAYMENT = @"payment";
    static NSString *const LIKE = @"LIKE";
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    CGFloat w = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    if (_isPayed) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LIKE];
        if (!cell) {
            cell = [[KTOtherProductListviewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LIKE];
        }
        
        if (likeArray.count > 0) {
            NSMutableArray *cellArr = likeArray[row];
            
            [(KTOtherProductListviewTableViewCell *)cell setProductDataArr:cellArr];
            [(KTOtherProductListviewTableViewCell *)cell setProductCellDelegate:self];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        if (section == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TITLEPAY];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TITLEPAY];
            }
            
            if (!_payTitleView) {
                _payTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 41)];
                [_payTitleView setBackgroundColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1]];
                _payTitleView.backgroundColor = [UIColor whiteColor];
                
                UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"paymenttitleicon"]];
                [icon setFrame:CGRectMake(9, 14, 13, 12)];
                
                UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 13, 100, 14)];
                if (!_type) {
                    [titleLbl setText:@"支付方式"];
                }else{
                    [titleLbl setText:@"更换支付方式"];
                }
                
                titleLbl.textColor = [UIColor colorWithRed:0.98 green:0.3 blue:0.41 alpha:1];
                [titleLbl setFont:[UIFont systemFontOfSize:13]];
                [titleLbl setBackgroundColor:[UIColor clearColor]];
                [_payTitleView addSubview:titleLbl];
                
                //分隔线
                UIView *twolineView = [[UIView alloc]initWithFrame:CGRectMake(15, 40, ScreenW - 30, 1)];
                twolineView.backgroundColor = [UIColor colorWithRed:0.87 green:0.83 blue:0.84 alpha:1];
                [_payTitleView addSubview:twolineView];
            }
            [cell.contentView addSubview:_payTitleView];
            
            [cell.contentView setBackgroundColor:[UIColor clearColor]];
            [cell setBackgroundColor:[UIColor clearColor]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        } else if (section == 1) {
            id data = [_paymentArr objectAtIndex:row];
            if (data && [data isKindOfClass:[NSString class]]) {
                NSString *str = (NSString *)data;
                
                if ([str isEqualToString:@"WAITTING"]) {
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WAITTINGPAY];
                    if (!cell) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WAITTINGPAY];
                        
                        UIView *waittingView = [[UIView alloc] initWithFrame:CGRectMake(0, -1, w, 45)];
                        [waittingView setBackgroundColor:[UIColor whiteColor]];
                        [waittingView.layer setBorderWidth:0.5];
                        [waittingView.layer setBorderColor:[UIColor colorWithRed:0.87 green:0.83 blue:0.84 alpha:1].CGColor];
                        [cell.contentView addSubview:waittingView];
                        
                        UIActivityIndicatorView *waitting = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                        waitting.tag = 800800;
                        waitting.center = waittingView.center;
                        [waittingView addSubview:waitting];
                        [waitting startAnimating];
                    } else {
                        UIActivityIndicatorView *waitting = (UIActivityIndicatorView * )[cell viewWithTag:800800];
                        [waitting startAnimating];
                    }
                    [cell.contentView setBackgroundColor:[UIColor clearColor]];
                    [cell setBackgroundColor:[UIColor clearColor]];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    return cell;
                }
            } else if (data && [data isKindOfClass:[PaymentVO class]]) {
                //设置默认支付方式为支付宝
                if ([[data PayType] intValue] == 2 && self.paymentID == -1)
                {
                    self.paymentID = [[data PayType] integerValue];
                }
                KTPaymentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PAYMENT];
                if (!cell) {
                    cell = [[KTPaymentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PAYMENT];
                }
                
                for (id obj in cell.subviews)
                {
                    if ([NSStringFromClass([obj class]) isEqualToString:@"UITableViewCellScrollView"])
                    {
                        UIScrollView *scroll = (UIScrollView *) obj;
                        scroll.delaysContentTouches = NO;
                        break;
                    }
                }
                
                [cell setPaymentData:data];
                [cell setPaymentCellDelegate:self];
                if ([[(PaymentVO *)data PayType] intValue] == _paymentID) {
                    [cell setCellState:KTPaymentSelected];
                } else {
                    [cell setCellState:KTPaymentNormal];
                }
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;
            }
        }
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    
    if (section == 0) {
        if (_isPayed) {
            return 170;
        }
        return 40;
    } else if (section == 1) {
        return 45;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    if (section == 1) {
        if (_isPaymentLoaded) {
            if ([_paymentArr objectAtIndex:row] && [[_paymentArr objectAtIndex:row] isKindOfClass:[PaymentVO class]]) {
                PaymentVO *vo = (PaymentVO *)[_paymentArr objectAtIndex:row];
                if ([vo.PayType intValue] == 1) {
                    if (![vo.Bind boolValue]) {
                        if (!stateHud) {
                            stateHud = [[MBProgressHUD alloc] initWithView:self.contentView];
                            stateHud.delegate = self;
                            [self.contentView addSubview:stateHud];
                        }
                        stateHud.mode = MBProgressHUDModeText;
                        stateHud.labelText = @"未绑定钱包，请先绑定";
                        stateHud.labelFont = [UIFont systemFontOfSize:14.0f];
                        [stateHud show:YES];
                        [stateHud hide:YES afterDelay:1.5];
                        return;
                    }
                    
                    if ([vo.Money floatValue] < [_orderFee floatValue]) {
                        if (!stateHud) {
                            stateHud = [[MBProgressHUD alloc] initWithView:self.contentView];
                            stateHud.delegate = self;
                            [self.contentView addSubview:stateHud];
                        }
                        stateHud.mode = MBProgressHUDModeText;
                        stateHud.labelText = @"钱包余额不足，请选择其他支付方式";
                        stateHud.labelFont = [UIFont systemFontOfSize:14.0f];
                        [stateHud show:YES];
                        [stateHud hide:YES afterDelay:1.5];
                        return;
                    }
                    
                }
                self.paymentID = [vo.PayType integerValue];
                [self.tableView reloadData];
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
    [self performSelector:@selector(popView) withObject:nil afterDelay:0.2];
}

- (void)popView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - KTPaymentTableViewCell Delegate
- (void)bindWalletBtnPressed
{
    kata_WalletBindViewController *bindVC = [[kata_WalletBindViewController alloc] initWithNibName:nil bundle:nil];
    bindVC.bindViewDelegate = self;
    bindVC.navigationController = self.navigationController;
    [self.navigationController pushViewController:bindVC animated:YES];
}

#pragma mark - kata_WalletBindViewControllerDelegate
- (void)walletBindSuccess
{
    [self loadPayment];
}

#pragma mark - UPPayPlugin Delegate
- (void)UPPayPluginResult:(NSString *)result
{
    _type = YES;
    if ([result isEqualToString:@"success"]) {
        [self updateWaitPayNum];
        _isPayed = YES;
        [self performSelector:@selector(likeRequest) withObject:nil afterDelay:0];
    } else if ([result isEqualToString:@"fail"]) {
        _isPayed = NO;
//        [self textStateHUD:@"支付失败"];
    } else if ([result isEqualToString:@"cancel"]) {
        _isPayed = NO;
//        [self textStateHUD:@"取消支付"];
    }
    [self performSelector:@selector(layoutBottomView) withObject:nil afterDelay:0.2];
    [_payBtn setEnabled:YES];
}

- (void)processResult:(NSDictionary *)result
{
    _type = YES;
    int statusCode = [result[@"resultStatus"] integerValue];
    switch (statusCode) {
        case 9000:
//            [self textStateHUD:@"支付成功"];
            [self updateWaitPayNum];
            _isPayed = YES;
            [self performSelector:@selector(likeRequest) withObject:nil afterDelay:0];
            break;
        case 8000:
            //正在处理中
//            [self textStateHUD:@"支付正在处理中"];
            _isPayed = NO;
            break;
        case 4000:
            //订单支付失败
//            [self textStateHUD:@"订单支付失败"];
            _isPayed = NO;
            break;
        case 6001:
            //用户中途取消
//            [self textStateHUD:@"支付取消"];
            _isPayed = NO;
            break;
        case 6002:
            //网络连接出错
//            [self textStateHUD:@"支付网络连接出错"];
            _isPayed = NO;
            break;
            
        default:
            //交易失败
//            [self textStateHUD:@"支付失败"];
            _isPayed = NO;
            break;
    }
    
    [self performSelector:@selector(layoutBottomView) withObject:nil afterDelay:0.2];
    [_payBtn setEnabled:YES];
}

/*
 微信支付数据获取
 */
#pragma mark - loadWXPay Data
- (void)loadWXPay
{
    [_payBtn setEnabled:NO];
    if (!stateHud) {
        stateHud = [[MBProgressHUD alloc] initWithView:self.contentView];
        stateHud.delegate = self;
        [self.contentView addSubview:stateHud];
    }
    stateHud.mode = MBProgressHUDModeIndeterminate;
    stateHud.labelFont = [UIFont systemFontOfSize:14.0f];
    [stateHud show:YES];

    KTWXpayRequest *req = [[KTWXpayRequest alloc] initWithOrderID:_orderID];
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(loadWXPayParseResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        [_payBtn setEnabled:YES];
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (void)loadWXPayParseResponse:(NSString *)resp
{
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"ok"]) {
            if ([[respDict objectForKey:@"code"] intValue] == 0) {
                if ([respDict objectForKey:@"data"] != nil && ![[respDict objectForKey:@"data"] isEqual:[NSNull null]]) {
                    [self hideHUDView];
                    [_payBtn setEnabled:YES];
                    
                    WXPayInfo *WXPayData = [WXPayInfo WXPayInfoWithDictionary:[respDict objectForKey:@"data"]];
                    // 调起微信支付
                    PayReq *request   = [[PayReq alloc] init];
                    request.partnerId = WXPayData.PartnerId;
                    request.prepayId = WXPayData.Prepayid;
                    request.package = @"Sign=WXPay";
                    request.nonceStr = WXPayData.NonceStr;
                    request.timeStamp = [WXPayData.Timestamp intValue];
                    request.sign = WXPayData.Sign;
                    
                    // 在支付之前，如果应用没有注册到微信，应该先调用 [WXApi registerApp:appId] 将应用注册到微信
                    [WXApi safeSendReq:request];
                }
            }
            else
            {
                [_payBtn setEnabled:YES];
                [self textStateHUD:@"支付信息获取失败"];
            }
        }
        else
        {
            [_payBtn setEnabled:YES];
            [self textStateHUD:@"支付信息获取失败"];
        }
    }
}

//微信支付结果显示
- (void)WXPayResult:(NSNotification *)sender
{
    NSDictionary *dict = sender.userInfo;
    
    _type = YES;
    switch ([[dict objectForKey:@"errCode"] intValue]) {
        case 0://支付成功
            _isPayed = YES;
            [self updateWaitPayNum];
            [self performSelector:@selector(likeRequest) withObject:nil afterDelay:0];
            break;
        case -1://系统繁忙
            _isPayed = NO;
            break;
        case -2://支付取消
            _isPayed = NO;
            break;
        default://支付失败
            _isPayed = NO;
            break;
    }
    [self performSelector:@selector(layoutBottomView) withObject:nil afterDelay:0.2];
    [_payBtn setEnabled:YES];
}

-(void)updateWaitPayNum
{
    UITabBar *tabBar = self.tabBarController.tabBar;
    UITabBarItem *tabBarItem4 = [tabBar.items objectAtIndex:4];
    //未支付订单数量更新
    NSNumber *wntValue = [[kata_UserManager sharedUserManager] userWaitPayCnt];
    if ([wntValue intValue]>0) {
        [[kata_UserManager sharedUserManager] updateWaitPayCnt:[NSNumber numberWithInteger:[wntValue intValue] - 1]];
        [tabBarItem4 setBadgeValue:[NSString stringWithFormat:@"%zi",[wntValue intValue] - 1]];
    }else{
        [tabBarItem4 setBadgeValue:0];
    }
}

#pragma mark - KTProductListTableViewCell Delegate
- (void)tapAtProduct:(LikeProductVO *)likevo
{
    _productType = 0;
    _seckillID = -1;
    kata_ProductDetailViewController *detailVC = [[kata_ProductDetailViewController alloc] initWithProductID:[likevo.productID integerValue] andType:[NSNumber numberWithInteger:_productType ] andSeckillID:_seckillID];
    detailVC.navigationController = self.navigationController;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
