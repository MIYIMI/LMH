//
//  kata_PaymentViewController.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-13.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "kata_PaymentViewController.h"
#import "KTPaymentDataGetRequest.h"
#import "KTOrderPostageGetRequest.h"
#import "KTOrderpayDataGetRequest.h"
#import "PaymentListVO.h"
#import "kata_UserManager.h"
#import "AlixLibService.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "PartnerConfig.h"
#import "kata_UserManager.h"
#import "kata_OrderDetailViewController.h"
#import "kata_InputPayPwdViewController.h"
#import "KTWXpayRequest.h"
#import "WXPayInfo.h"
#import <CommonCrypto/CommonDigest.h>
#import "KTAddressListGetRequest.h"
#import "AddressListVO.h"
#import "KTOrderSubmitAddressTableViewCell.h"
#import "kata_AddressEditViewController.h"
#import "KTOrderCheckTableViewCell.h"
#import "kata_CashFailedViewController.h"
#import "KTOrderRequest.h"
#import "KTCheckCouponRequest.h"
#import "KTCouponGetRequest.h"
#import "CouponListVO.h"
#import "CheckCouponVO.h"

#import "OrderVO.h"
#import "OrderMoneyVO.h"

#define TABLEVIEWCOLOR      [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1]
#define BOTTOMHEIGHT        50

@interface kata_PaymentViewController ()
{
    UILabel *_adressNameLbl;
    UILabel *_adressPhoneLbl;
    UILabel *_adressDetailLbl;
    UIView *_headView;
    UILabel *_addressLbl;
    UIImageView *_imgView;
    UIImageView *_rightView;
    
    NSString *_orderid;
    NSInteger _productid;
    int _productcount;
    NSInteger _addressid;
    NSNumber *_price;
    NSNumber *_couponSale;
    NSNumber *_shipFee;
    BOOL _isPaymentLoaded;
    BOOL _isShipFeeLoaded;
    BOOL _isPayed;
    
    UIView *_payTitleView;
    UIView *_priceTitleView;
    UIButton *_payBtn;
    UILabel *_shipFeeLbl;
    UILabel *_couponLbl;
    UILabel *_totalLbl;
    UIActivityIndicatorView *_waittingIndicator;
    UIView *_bottomView;
    
    NSMutableArray *_paymentArr;
    
    NSMutableArray *_addressArr;
    BOOL _isAddressErr;
    BOOL _isAddressLoaded;
    UIView *_addressTitleView;
    BOOL _addressTableUnflod;
    BOOL _isPriceShipFeeLoaded;
    UILabel *_priceLabel;
    
    KTCoupview *couponView;
    NSArray *couponArry;
    NSString *_couponid;
    NSString *_userconpoid;
    BOOL _hasorder;
    
    NSMutableArray *_otherData;
}

@property (nonatomic) NSInteger paymentID;

@end

@implementation kata_PaymentViewController

- (id)initWithPayOrder:(NSMutableDictionary *)orderdict
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // Custom initialization
        self.ifShowTableSeparator = NO;
        self.ifAddPullToRefreshControl = NO;
        
        _isPaymentLoaded = NO;
        _isShipFeeLoaded = NO;
        _isPayed = NO;
        _paymentID = -1;
        _addressid = -1;
        if ([orderdict objectForKeyedSubscript:@"orderid"]) {
            _orderid = [orderdict objectForKeyedSubscript:@"orderid"];
        } else {
            _orderid = @"";
        }
        
        if ([orderdict objectForKeyedSubscript:@"productid"]) {
            _productid = [[orderdict objectForKeyedSubscript:@"productid"] integerValue];
        } else {
            _productid = -1;
        }
        
        if ([orderdict objectForKeyedSubscript:@"productcount"]) {
            _productcount = [[orderdict objectForKeyedSubscript:@"productcount"] intValue];
        } else {
            _productcount = 0;
        }
        
        if ([orderdict objectForKeyedSubscript:@"addressid"]) {
            _addressid = [[orderdict objectForKeyedSubscript:@"addressid"] intValue];
            _addressid = _addressid == 0 ? -1: _addressid;
        } else {
            _addressid = -1;
        }
        
        if ([orderdict objectForKeyedSubscript:@"price"]) {
            _price = [orderdict objectForKeyedSubscript:@"price"];
        }
        
        if ([orderdict objectForKeyedSubscript:@"couponsale"]) {
            _couponSale = [orderdict objectForKeyedSubscript:@"couponsale"];
        }
        
        if ([orderdict objectForKeyedSubscript:@"freight"]) {
            _shipFee = [orderdict objectForKeyedSubscript:@"freight"];
        }
        
        self.listData = [[NSMutableArray alloc] initWithObjects:@"TITLE", nil];
        NSMutableArray *addressArr = [[NSMutableArray alloc] initWithCapacity:1];
        [addressArr addObject:@"WAITTING"];
        [self.listData addObject:addressArr];
        
        _paymentArr = [[NSMutableArray alloc] initWithObjects:@"WAITTING", nil];
        
        self.title = @"结算";
        
        _otherData = [NSMutableArray arrayWithObjects:
                      [NSArray arrayWithObjects:@"商品金额 :", @"23.00", nil],
                      [NSArray arrayWithObjects:@"运费 :", _shipFee, nil],
                      [NSArray arrayWithObjects:@"活动 :", @"¥0.00", nil],
                      [NSArray arrayWithObjects:@"优惠券 :", @"使用优惠券",nil],
                      [NSArray arrayWithObjects:@"金豆 :", @"可使用金豆 0",nil],
                      nil];
        self.hideNavigationBarWhenPush = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    [self loadOrderRequst];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WXPayResult:) name:@"WXPAY" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payResult:) name:@"PAY_RESULT" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WXPAY" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PAY_RESULT" object:nil];
}

- (void)createUI
{
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:TABLEVIEWCOLOR];
    [self.contentView setBackgroundColor:TABLEVIEWCOLOR];
    [self.tableView setDelaysContentTouches:NO];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), 8)];
    [header setBackgroundColor:[UIColor clearColor]];
    //[self.tableView setTableHeaderView:header];
    [self layoutBottomView];
    
    _headView = [[UIView alloc] initWithFrame:CGRectZero];
    [_headView setBackgroundColor:[UIColor whiteColor]];
}

-(void)layoutView
{
    [self hideHUDView];
    _adressNameLbl.text = nil;
    _adressPhoneLbl.text = nil;
    _adressDetailLbl.text = nil;
    _addressLbl.text = nil;
    
    CGFloat w = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    float _headViewH = 0;
    
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_imgView setImage:[UIImage imageNamed:@"address"]];
        [_headView addSubview:_imgView];
    }
    
    if (!_rightView) {
        _rightView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_rightView setImage:[UIImage imageNamed:@"right"]];
        [_headView addSubview:_rightView];
    }
    
    if (_addressArr.count > 0) {
        AddressVO *adrvo = _addressArr[0];
        if (!_adressNameLbl) {
            _adressNameLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            [_adressNameLbl setTextColor:[UIColor colorWithRed:0.35 green:0.35 blue:0.35 alpha:1]];
            [_adressNameLbl setFont:[UIFont systemFontOfSize:13.0]];
            _adressNameLbl.numberOfLines = 0;// 不可少Label属性之一
            _adressNameLbl.lineBreakMode = NSLineBreakByCharWrapping;// 不可少Label属性之二
            [_headView addSubview:_adressNameLbl];
        }
        NSString *nameStr = [NSString stringWithFormat:@"收货人 : %@", adrvo.Name];
        [_adressNameLbl setText:nameStr];
        CGSize nameSize = [nameStr sizeWithFont:_adressNameLbl.font constrainedToSize:CGSizeMake(w - 75, 100000) lineBreakMode:NSLineBreakByCharWrapping];
        [_adressNameLbl setFrame:CGRectMake(45, 5, nameSize.width, nameSize.height)];
        
        if (!_adressPhoneLbl) {
            _adressPhoneLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            [_adressPhoneLbl setTextColor:[UIColor colorWithRed:0.22 green:0.22 blue:0.22 alpha:1]];
            [_adressPhoneLbl setFont:[UIFont systemFontOfSize:13.0]];
            _adressPhoneLbl.numberOfLines = 0;// 不可少Label属性之一
            _adressPhoneLbl.lineBreakMode = NSLineBreakByCharWrapping;// 不可少Label属性之二
            [_headView addSubview:_adressPhoneLbl];
        }
        NSString *phoneStr = [NSString stringWithFormat:@"手机 : %@", adrvo.Mobile];
        [_adressPhoneLbl setText:phoneStr];
        CGSize phoneSize = [phoneStr sizeWithFont:_adressPhoneLbl.font constrainedToSize:CGSizeMake(w - 75, 100000) lineBreakMode:NSLineBreakByCharWrapping];
        if (CGRectGetMaxX(_adressNameLbl.frame) + 15 + phoneSize.width > (w - 75)) {
            [_adressPhoneLbl setFrame:CGRectMake(45, CGRectGetMaxY(_adressNameLbl.frame) + 5, phoneSize.width, phoneSize.height)];
        }else{
            [_adressPhoneLbl setFrame:CGRectMake(CGRectGetMaxX(_adressNameLbl.frame) + 15, 5, phoneSize.width, phoneSize.height)];
        }
        
        if (!_adressDetailLbl) {
            _adressDetailLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            [_adressDetailLbl setTextColor:[UIColor colorWithRed:0.35 green:0.35 blue:0.35 alpha:1]];
            [_adressDetailLbl setFont:[UIFont systemFontOfSize:13.0]];
            _adressDetailLbl.numberOfLines = 0;// 不可少Label属性之一
            _adressDetailLbl.lineBreakMode = NSLineBreakByCharWrapping;// 不可少Label属性之二
            [_headView addSubview:_adressDetailLbl];
        }
        NSString *addrStr = [NSString stringWithFormat:@"地址 : %@%@%@%@", adrvo.Province, adrvo.City, adrvo.Region, adrvo.Detail];
        [_adressDetailLbl setText:addrStr];
        CGSize addrSize = [addrStr sizeWithFont:_adressDetailLbl.font constrainedToSize:CGSizeMake(w - 75, 100000) lineBreakMode:NSLineBreakByCharWrapping];
        [_adressDetailLbl setFrame:CGRectMake(45, CGRectGetMaxY(_adressPhoneLbl.frame) + 5, addrSize.width, addrSize.height)];
        
        _headViewH += CGRectGetMaxY(_adressDetailLbl.frame)+5;
        [_headView setFrame:CGRectMake(0, 0, w, _headViewH)];
        [_imgView setFrame:CGRectMake(12, (_headViewH - 25)/2, 20, 25)];
        [_rightView setFrame:CGRectMake( w - 20, (_headViewH - 10)/2, 10, 15)];
    }
    
    [self.tableView setTableHeaderView:_headView];
}

- (void)layoutBottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.contentView.frame) - BOTTOMHEIGHT, CGRectGetWidth(self.contentView.frame), BOTTOMHEIGHT)];
        [_bottomView setBackgroundColor:[UIColor clearColor]];
        
        UIView *subview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), BOTTOMHEIGHT)];
        [subview setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.90]];
        
        UILabel *lineLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(subview.frame), 0.5)];
        [lineLbl setBackgroundColor:[UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1]];
        [subview addSubview:lineLbl];
        
        UILabel *priceTipLbl = [[UILabel alloc] initWithFrame:CGRectMake(9, 0, 75, CGRectGetHeight(subview.frame))];
        [priceTipLbl setBackgroundColor:[UIColor clearColor]];
        [priceTipLbl setFont:[UIFont systemFontOfSize:14.0]];
        [priceTipLbl setTextAlignment:NSTextAlignmentLeft];
        [priceTipLbl setText:@"订单总金额:"];
        [subview addSubview:priceTipLbl];
        if (!_priceLabel) {
            _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(priceTipLbl.frame), 0, 110, CGRectGetHeight(subview.frame))];
            [_priceLabel setBackgroundColor:[UIColor clearColor]];
            [_priceLabel setFont:[UIFont systemFontOfSize:14.0]];
            [_priceLabel setTextAlignment:NSTextAlignmentLeft];
            [_priceLabel setTextColor:[UIColor colorWithRed:0.98 green:0.3 blue:0.4 alpha:1]];
            [subview addSubview:_priceLabel];
        }
            [_priceLabel setText:[NSString stringWithFormat:@"￥%.2f", [_price floatValue] - [_couponSale floatValue]]];
        [_bottomView addSubview:subview];
        
        UIButton *payBtn = [[UIButton alloc] initWithFrame:CGRectMake(236, 8, 73, 30)];
        UIImage *image = [UIImage imageNamed:@"submit_btn"];
        image = [image stretchableImageWithLeftCapWidth:10.0f topCapHeight:10.0f];
        [payBtn setBackgroundImage:image forState:UIControlStateNormal];
        image = [UIImage imageNamed:@"submit_btn_selected"];
        [payBtn setBackgroundImage:image forState:UIControlStateHighlighted];
        [payBtn setBackgroundImage:image forState:UIControlStateSelected];
        [payBtn setTitle:@"支付订单" forState:UIControlStateNormal];
        [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [[payBtn titleLabel] setFont:[UIFont boldSystemFontOfSize:14.0f]];
        [payBtn addTarget:self action:@selector(goToPay) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:payBtn];
        _payBtn = payBtn;
        [_payBtn setEnabled:NO];
    }
    [self.contentView addSubview:_bottomView];
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), BOTTOMHEIGHT + 10)];
    [footer setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableFooterView:footer];
}

- (void)setPaymentID:(NSInteger)paymentID
{
    _paymentID = paymentID;
    if (_paymentID != -1) {
        if (_isShipFeeLoaded) {
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
    
    if (_isPriceShipFeeLoaded && _addressid != -1 && _paymentID != -1) {
        switch (_paymentID) {
            case 1:         //钱包支付
            {
                kata_InputPayPwdViewController *payPwdVC = [[kata_InputPayPwdViewController alloc] initWithOrderID:_orderid andTotal:((float)_productcount) * [_price floatValue] + [_shipFee floatValue]];
                payPwdVC.navigationController = self.navigationController;
                [self.navigationController pushViewController:payPwdVC animated:YES];
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
    } else if (_paymentID == -1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请先选择支付方式！"
                                                       delegate:self
                                              cancelButtonTitle:@"好"
                                              otherButtonTitles:nil];
        [alert show];
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
                                                    andOrderID:_orderid
                                                      andPayID:_paymentID
                                                  andAddressID:_addressid
                                                  andUserCopID:_userconpoid];
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
                                    [AlixLibService payOrder:orderString AndScheme:appScheme seletor:@selector(paymentResult:) target:self];
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
                            [self performSelector:@selector(goToPay) withObject:nil afterDelay:0.2];
                        }
                    }
                }
            }
        }
    }
}


- (void)hideHUDView
{
    if (_userconpoid) {
        _hasorder = YES;
    }
    
    [stateHud hide:YES afterDelay:0.3];
}

- (void)checkLogin
{
    if (![[kata_UserManager sharedUserManager] isLogin]) {
        [self performSelector:@selector(showLoginView) withObject:nil afterDelay:0.2];
    }
}

- (void)showLoginView
{
    [kata_LoginViewController showInViewController:self];
}

#pragma mark - Load Payment Data
- (void)loadOrderRequst
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
        req = [[KTOrderRequest alloc] initWithUserID:[userid integerValue]
                                                 andUserToken:usertoken andOrderID:_orderid];
    }
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(loadOrderParseResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (void)loadOrderParseResponse:(NSString *)resp
{
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            if ([respDict objectForKey:@"data"] != nil && ![[respDict objectForKey:@"data"] isEqual:[NSNull null]]) {
                id dataObj = [respDict objectForKey:@"data"];
                
                if ([dataObj isKindOfClass:[NSDictionary class]]) {
                    OrderVO *orderData = [OrderVO OrderVOWithDictionary:dataObj];
                    
                    AddressVO *adsVo = [AddressVO AddressVOWithDictionary:orderData.address];
                    
                    _addressArr = [NSMutableArray arrayWithObject:adsVo];
                    if (adsVo) {
                        [self layoutView];
                    }
                    
                    OrderMoneyVO *moneyVo = [OrderMoneyVO OrderMoneyVOWithDictionary:orderData.order];
                    [_otherData setObject:[NSArray arrayWithObjects:@"商品金额 :", [NSString stringWithFormat:@"¥%0.2f", [moneyVo.pay_money floatValue]], nil] atIndexedSubscript:0];
                    [_otherData setObject:[NSArray arrayWithObjects:@"运费 :", [NSString stringWithFormat:@"-¥%0.2f", [moneyVo.pay_freight floatValue]], nil] atIndexedSubscript:1];
                    
//                    if ([listVO.Code intValue] == 0) {
//                        if (listVO.PaymentList) {
//                            _paymentArr = [NSMutableArray arrayWithArray:listVO.PaymentList];
//                            if (_paymentArr.count > 0) {
//                                _isPaymentLoaded = YES;
//                            }
//                        }
//                    } else if ([listVO.Code intValue] == -102) {
//                        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:listVO.Msg waitUntilDone:YES];
//                        [[kata_UserManager sharedUserManager] logout];
//                        [self performSelectorOnMainThread:@selector(checkLogin) withObject:nil waitUntilDone:YES];
//                    }
                }
            }
        }
    }
}


#pragma mark -
#pragma tableView delegate && datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return _otherData.count;
        }
            break;
            
        case 1:
        {
            return 0;
        }
            break;
            
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CELL_DFER = @"cell_dfer";
    static NSString *OTHER_DFER = @"other_dfer";
    static NSString *WAITTINGPAY = @"waitingpay";
    
    int row = indexPath.row;
    int section = indexPath.section;
    CGFloat w = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    
    if(section == 0){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:OTHER_DFER];
        if (!cell) {
            cell = [[KTOrderCheckTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OTHER_DFER];
        }
        
        [(KTOrderCheckTableViewCell*)cell setCheckArray:_otherData[row]];
        
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    } else if (section == 2) {
        id data = [_paymentArr objectAtIndex:row];
        if (data && [data isKindOfClass:[NSString class]]) {
            NSString *str = (NSString *)data;
            
            if ([str isEqualToString:@"WAITTING"]) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WAITTINGPAY];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WAITTINGPAY];
                    
                    //                    UIView *waittingView = [[UIView alloc] initWithFrame:CGRectMake(10, -1, w - 20, 45)];
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
            KTPaymentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_DFER];
            if (!cell) {
                cell = [[KTPaymentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_DFER];
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
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = (int)indexPath.section;
    int row = (int)indexPath.row;

    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
}

#pragma mark - Login Delegate
- (void)didLogin
{
    [self loadOrderRequst];
}

- (void)loginCancel
{
    [self performSelector:@selector(popView) withObject:nil afterDelay:0.2];
}

- (void)popView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - MBProgressHUD Delegate
- (void)hudWasHidden:(MBProgressHUD *)ahud
{
	[stateHud removeFromSuperview];
	stateHud = nil;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //查看订单详情
        kata_OrderDetailViewController *detailVC = [[kata_OrderDetailViewController alloc] initWithOrderID:_orderid andIsPayed:YES];
        detailVC.navigationController = self.navigationController;
        detailVC.navigationController.ifPopToRootView = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    } else if (buttonIndex == 1) {
        //返回继续购物
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
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
    //[self loadPayment];
}

#pragma mark - UPPayPlugin Delegate
- (void)UPPayPluginResult:(NSString *)result
{
    if ([result isEqualToString:@"success"]) {
        [self performSelector:@selector(showPaySuccess) withObject:nil afterDelay:0.5];
        [self hideHUDView];
    } else if ([result isEqualToString:@"fail"]) {
        [self textStateHUD:@"支付失败"];
    } else if ([result isEqualToString:@"cancel"]) {
        [self textStateHUD:@"取消支付"];
    }
#if PayMent_Address_Logic
        [self performSelector:@selector(goToFailVC) withObject:nil afterDelay:0.2];
#endif
}

- (void)payResult:(NSNotification *)notification
{
    AlixPayResult *result = (AlixPayResult *)[[notification userInfo] objectForKey:@"ali_pay_result"];
    
    [self processResult:result];
}

//wap回调函数
-(void)paymentResult:(NSString *)resultd
{
    //结果处理
#if ! __has_feature(objc_arc)
    AlixPayResult* result = [[[AlixPayResult alloc] initWithString:resultd] autorelease];
#else
    AlixPayResult* result = [[AlixPayResult alloc] initWithString:resultd];
#endif
	
    [self processResult:result];
}

- (void)processResult:(AlixPayResult *)result
{
    if (result)
    {
		
		if (result.statusCode == 9000)
        {
            _isPayed = YES;
			/*
			 *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
			 */
            
            //交易成功
            NSString* key = AlipayPubKey;//签约帐户后获取到的支付宝公钥
			id<DataVerifier> verifier;
            verifier = CreateRSADataVerifier(key);
            
			if ([verifier verifyString:result.resultString withSign:result.signString])
            {
                //验证签名成功，交易结果无篡改
                [self textStateHUD:@"支付成功"];
                return;
			}
            [self textStateHUD:@"支付成功"];
            
            [self performSelector:@selector(showPaySuccess) withObject:nil afterDelay:0.5];
        }
        else if (result.statusCode == 8000)
        {
            //正在处理中
            [self textStateHUD:@"支付正在处理中"];
        }
        else if (result.statusCode == 4000)
        {
            //订单支付失败
            [self textStateHUD:@"订单支付失败"];
        }
        else if (result.statusCode == 6001)
        {
            //用户中途取消
            [self textStateHUD:@"支付取消"];
        }
        else if (result.statusCode == 6002)
        {
            //网络连接出错
            [self textStateHUD:@"支付网络连接出错"];
        }
        else
        {
            //交易失败
            [self textStateHUD:@"支付失败"];
        }
    }
    else
    {
        //失败
        [self textStateHUD:@"支付失败"];
    }
    
    if (_isPayed) {
        [_payBtn setEnabled:NO];
    } else {
        [_payBtn setEnabled:YES];
    }
    [self performSelector:@selector(goToFailVC) withObject:nil afterDelay:0.2];
}

- (void)showPaySuccess
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"订单支付成功"
                                  delegate:self
                                  cancelButtonTitle:nil
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"查看订单",
                                  @"返回继续购物", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [actionSheet showInView:self.view];
    [self updateWaitPayNum];
}

- (void)goToFailVC
{
    //NSMutableDictionary *orderdict = [NSMutableDictionary new];

//    if (_orderid) {
//        [orderdict setObject:_orderid forKey:@"orderid"];
//    }
//    if (_cartInfo) {
//        [orderdict setObject:_cartInfo forKey:@"cartinfo"];
//    }
//    kata_CashFailedViewController *failVC = [[kata_CashFailedViewController alloc] initWithOrderInfo:orderdict];
//    failVC.navigationController = self.navigationController;
//    failVC.navigationController.ifPopToRootView = YES;
//    [self.navigationController pushViewController:failVC animated:YES];
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
    
    KTWXpayRequest *req = [[KTWXpayRequest alloc] initWithOrderID:_orderid];
                           
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(loadWXPayParseResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
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
    NSString *strMsg;
    
    switch ([[dict objectForKey:@"errCode"] intValue]) {
        case -1:
            strMsg = @"系统繁忙";
            break;
        case -2:
            strMsg = @"支付取消";
            break;
        case 0:
            [self performSelector:@selector(showPaySuccess) withObject:nil afterDelay:0.5];
            return;
        default:
            strMsg = @"支付失败，请重试";
            break;

    }
    [self performSelector:@selector(showHud:) withObject:strMsg afterDelay:1.0];
}

-(void)showHud:(NSString *)Msg
{
    [self textStateHUD:Msg];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)updateWaitPayNum
{
    UITabBar *tabBar = self.tabBarController.tabBar;
    UITabBarItem *tabBarItem4 = [tabBar.items objectAtIndex:3];
    //未支付订单数量更新
    NSNumber *wntValue = [[kata_UserManager sharedUserManager] userWaitPayCnt];
    if ([wntValue intValue]>0) {
        [[kata_UserManager sharedUserManager] updateWaitPayCnt:[NSNumber numberWithInt:[wntValue intValue] - 1]];
        [tabBarItem4 setBadgeValue:[NSString stringWithFormat:@"%d",[wntValue intValue] - 1]];
    }
    else
    {
        [tabBarItem4 setBadgeValue:0];
    }
}

@end
