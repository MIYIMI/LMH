//
//  kata_OrderDetailViewController.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-18.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "kata_OrderDetailViewController.h"
#import "KTOrderItemGetRequest.h"
#import "kata_UserManager.h"
#import "OrderDetailVO.h"
#import "KTOrderDetailProductTableViewCell.h"
#import "kata_CashFailedViewController.h"
#import "LMHTrackViewController.h"
#import "KTOrderCheckTableViewCell.h"
#import "kata_ProductDetailViewController.h"
#import "KTOrderCancelRequest.h"
#import "kata_ReturnViewController.h"
#import "kata_ReturnOrderDetailViewController.h"
#import "EvaluationTableViewController.h"
#import "HTCopyableLabel.h"
#import "Loading.h"

#define TABLEVIEWCOLOR      [UIColor colorWithRed:0.89 green:0.89 blue:0.9 alpha:1]
#define BOTTOMHEIGHT        50

@interface kata_OrderDetailViewController ()<KTOrderDetailProductTableViewCellDelegate>
{
    NSNumber *_price;
    NSInteger _productcount;
    BOOL _isPayed;
    NSInteger _orderType;
    NSInteger _partid;
    NSString *_orderID;
    NSInteger _itemcout;
    OrderDetailVO *detailVO;
    detailAddressVO *_addressVO;
    NSMutableArray *_detailArr;
    NSIndexPath *_indexPath;
    
    UILabel *_adressNameLbl;
    UILabel *_adressPhoneLbl;
    UILabel *_adressDetailLbl;
    UIView *_headView;
    UILabel *_addressLbl;
    UIImageView *_adressImgView;
    UIButton *_payBtn;
    UILabel *_totalLbl;
    UIView *_bottomView;
    UIActivityIndicatorView *_waittingIndicator;
    UIView *addressInfoView;
    UILabel *contentLabel;
    UIImageView *_headImgView;
    UIView *trackView;
    UIImageView *_rightView;
    UIImageView *timgView;
    UILabel *trackLbl;
    UIImageView *lineView;
    UILabel *lineLbl;
    UILabel *timeLbl;
    UIBarButtonItem *_menuItem;
    UIButton *toHomeBtn;
    
    HTCopyableLabel *_orderidLabel;
    Loading *loading;
}

@end

@implementation kata_OrderDetailViewController

- (id)initWithOrderID:(NSString *)orderid andType:(NSInteger)orderType antPartnerID:(NSInteger)partid
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // Custom initialization
        self.ifShowTableSeparator = NO;
        self.ifAddPullToRefreshControl = NO;
        
        _itemcout = -1;
        _orderID = orderid;
        _orderType = orderType;
        _partid = partid;
        _detailArr = [[NSMutableArray alloc] init];
        
        self.title = @"订单详情";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadOrderDetail];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI
{
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:TABLEVIEWCOLOR];
    [self.contentView setBackgroundColor:TABLEVIEWCOLOR];
    [self.tableView setDelaysContentTouches:NO];
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _headView = [[UIView alloc] initWithFrame:CGRectZero];
    [_headView setBackgroundColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1]];
    
    _headImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _headImgView.image = [UIImage imageNamed:@"order_w"];
    [_headView addSubview:_headImgView];
    
    trackView = [[UIView alloc] initWithFrame:CGRectZero];
    trackView.backgroundColor = [UIColor whiteColor];
    [_headView addSubview:trackView];
}

- (void)layoutDetailView
{
    CGFloat w = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    CGFloat _headViewH = 0;
    
    //订单详情地址信息
    if (!_adressImgView) {
        _adressImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_adressImgView setImage:[UIImage imageNamed:@"address"]];
        [_headImgView addSubview:_adressImgView];
    }
    
    if (_addressVO) {
        if (!_adressNameLbl) {
            _adressNameLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            [_adressNameLbl setTextColor:LMH_COLOR_BLACK];
            [_adressNameLbl setFont:LMH_FONT_12];
            _adressNameLbl.numberOfLines = 0;// 不可少Label属性之一
            _adressNameLbl.lineBreakMode = NSLineBreakByCharWrapping;// 不可少Label属性之二
            [_headImgView addSubview:_adressNameLbl];
        }
        NSString *nameStr = [NSString stringWithFormat:@"收货人 : %@", _addressVO.name];
        [_adressNameLbl setText:nameStr];
        CGSize nameSize = [nameStr sizeWithFont:_adressNameLbl.font constrainedToSize:CGSizeMake(w - 60, 100000) lineBreakMode:NSLineBreakByCharWrapping];
        [_adressNameLbl setFrame:CGRectMake(45, 5, nameSize.width, nameSize.height)];
        
        if (!_adressPhoneLbl) {
            _adressPhoneLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            [_adressPhoneLbl setTextColor:LMH_COLOR_BLACK];
            [_adressPhoneLbl setFont:LMH_FONT_12];
            _adressPhoneLbl.numberOfLines = 0;// 不可少Label属性之一
            _adressPhoneLbl.lineBreakMode = NSLineBreakByCharWrapping;// 不可少Label属性之二
            _adressPhoneLbl.textAlignment = NSTextAlignmentRight;
            [_headImgView addSubview:_adressPhoneLbl];
        }
        NSString *phoneStr = [NSString stringWithFormat:@"手机 : %@", _addressVO.mobile];
        [_adressPhoneLbl setText:phoneStr];
        CGSize phoneSize = [phoneStr sizeWithFont:_adressPhoneLbl.font constrainedToSize:CGSizeMake(w - 60, 100000) lineBreakMode:NSLineBreakByCharWrapping];
        if (CGRectGetMaxX(_adressNameLbl.frame) + 15 + phoneSize.width > (w - 60)) {
            [_adressPhoneLbl setFrame:CGRectMake(45, CGRectGetMaxY(_adressNameLbl.frame) + 10, phoneSize.width, phoneSize.height)];
        }else{
            [_adressPhoneLbl setFrame:CGRectMake(w - (phoneSize.width+18), 5, phoneSize.width, phoneSize.height)];
        }
        
        if (!_adressDetailLbl) {
            _adressDetailLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            [_adressDetailLbl setTextColor:LMH_COLOR_BLACK];
            [_adressDetailLbl setFont:LMH_FONT_12];
            _adressDetailLbl.numberOfLines = 0;// 不可少Label属性之一
            _adressDetailLbl.lineBreakMode = NSLineBreakByCharWrapping;// 不可少Label属性之二
            [_headImgView addSubview:_adressDetailLbl];
        }
        NSString *addrStr = [NSString stringWithFormat:@"地址 : %@", _addressVO.address];
        [_adressDetailLbl setText:addrStr];
        CGSize addrSize = [addrStr sizeWithFont:_adressDetailLbl.font constrainedToSize:CGSizeMake(w - 60, 100000) lineBreakMode:NSLineBreakByCharWrapping];
        [_adressDetailLbl setFrame:CGRectMake(45, CGRectGetMaxY(_adressPhoneLbl.frame) + 10, addrSize.width, addrSize.height)];
        
        _headViewH += CGRectGetMaxY(_adressDetailLbl.frame)+10;
        [_headImgView setFrame:CGRectMake(0, 0, w, _headViewH)];
        [_adressImgView setFrame:CGRectMake(12, (_headViewH - 25)/2, 20, 25)];
        
        //订单详情物流信息
        if (!_rightView) {
            _rightView = [[UIImageView alloc] initWithFrame:CGRectMake( w - 20, 45, 10, 15)];
            [_rightView setImage:[UIImage imageNamed:@"right"]];
        }
        
        if (!timgView) {
            timgView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 10, 30, 20)];
            [timgView setImage:[UIImage imageNamed:@"icon_trackcart"]];
        }
        
        if (!trackLbl) {
            trackLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(timgView.frame)+5, 10, ScreenW-50, 20)];
            [trackLbl setText:detailVO.express_info.express_name];
            [trackLbl setTextColor:LMH_COLOR_BLACK];
            [trackLbl setFont:LMH_FONT_14];
        }
        
        if (!lineView) {
            lineView = [[UIImageView alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(timgView.frame)+2, 20, 70)];
            [lineView setImage:[UIImage imageNamed:@"icon_trackTwo"]];
        }
        
        if (!lineLbl) {
            lineLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(timgView.frame)+5, CGRectGetMaxY(trackLbl.frame)+15, ScreenW-50, 20)];
        }
        TranckVO *trackvo;
        if (detailVO.express_info.express_detail.count > 0) {
            trackvo = [detailVO.express_info.express_detail objectAtIndex:detailVO.express_info.express_detail.count-1];
        }
        [lineLbl setText:trackvo.context];
        [lineLbl setTextColor:LMH_COLOR_SKIN];
        [lineLbl setFont:LMH_FONT_14];
        
        if (!timeLbl) {
            timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(timgView.frame)+5, CGRectGetMaxY(lineLbl.frame)+5, ScreenW-50, 20)];
            [timeLbl setText:trackvo.ftime];
            [timeLbl setTextColor:LMH_COLOR_SKIN];
            [timeLbl setFont:LMH_FONT_14];
            
            if (detailVO.express_info.express_detail.count > 0) {
                [trackView setFrame:CGRectMake(0, _headViewH + 10, ScreenW, 100)];
                UITapGestureRecognizer *trackGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(trackButtonClick)];
                [trackView addGestureRecognizer:trackGest];
                [trackView addSubview:_rightView];
                [trackView addSubview:trackLbl];
                [trackView addSubview:lineLbl];
                [trackView addSubview:timeLbl];
                [trackView addSubview:lineView];
                [trackView addSubview:timgView];
            }
        }
        
        if (detailVO.express_info.express_detail.count > 0) {
            _headViewH = CGRectGetMaxY(trackView.frame);
        }
    
        [_headView setFrame:CGRectMake(0, 0, w, _headViewH+10)];
    }
    [self.tableView setTableHeaderView:_headView];
    
    //订单详情底部
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.contentView.frame) - BOTTOMHEIGHT, CGRectGetWidth(self.contentView.frame), BOTTOMHEIGHT)];
        [_bottomView setBackgroundColor:[UIColor clearColor]];
        
        UIView *subview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), BOTTOMHEIGHT)];
        [subview setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.90]];
        
        UILabel *blineLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(subview.frame), 0.5)];
        [blineLbl setBackgroundColor:[UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1]];
        [subview addSubview:blineLbl];
        
        UILabel *priceTipLbl = [[UILabel alloc] initWithFrame:CGRectMake(9, 0, 60, CGRectGetHeight(subview.frame))];
        [priceTipLbl setBackgroundColor:[UIColor clearColor]];
        [priceTipLbl setFont:LMH_FONT_14];
        [priceTipLbl setTextAlignment:NSTextAlignmentLeft];
        [priceTipLbl setText:@"总金额:"];
        [subview addSubview:priceTipLbl];
        if (!_totalLbl) {
            _totalLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(priceTipLbl.frame), 0, 110, CGRectGetHeight(subview.frame))];
            [_totalLbl setBackgroundColor:[UIColor clearColor]];
            [_totalLbl setFont:LMH_FONT_14];
            [_totalLbl setTextAlignment:NSTextAlignmentLeft];
            [_totalLbl setTextColor:LMH_COLOR_SKIN];
            NSString *pay_amount;
            CGFloat payAmount = [detailVO.order_info.pay_amount doubleValue];
            if ((payAmount * 10) - (int)(payAmount * 10) > 0) {
                pay_amount = [NSString stringWithFormat:@"¥%0.2f",[detailVO.order_info.pay_amount doubleValue]];
            } else if(payAmount - (int)payAmount > 0) {
                pay_amount = [NSString stringWithFormat:@"¥%0.1f",[detailVO.order_info.pay_amount doubleValue]];
            } else {
                pay_amount = [NSString stringWithFormat:@"¥%0.0f",[detailVO.order_info.pay_amount doubleValue]];
            }
            [_totalLbl setText:pay_amount];
            [subview addSubview:_totalLbl];
        }
        [_bottomView addSubview:subview];
        
        if (!_payBtn) {
            _payBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 84, 12, 73, 30)];
            UIImage *image = [UIImage imageNamed:@"red_btn_small"];
            image = [image stretchableImageWithLeftCapWidth:10.0f topCapHeight:10.0f];
            [_payBtn setBackgroundImage:image forState:UIControlStateNormal];
            image = [UIImage imageNamed:@"red_btn_small"];
            [_payBtn setBackgroundImage:image forState:UIControlStateHighlighted];
            [_payBtn setBackgroundImage:image forState:UIControlStateSelected];
            [_payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [[_payBtn titleLabel] setFont:LMH_FONT_14];
            [_bottomView addSubview:_payBtn];
            [_payBtn setHidden:YES];
        }
    }
    [self.contentView addSubview:_bottomView];
    
    _payBtn.hidden = NO;
    if ([detailVO.order_info.pay_status integerValue] == 4) {//待付款订单
        [self setupRightMenuButton];
        [_payBtn addTarget:self action:@selector(goToPay) forControlEvents:UIControlEventTouchUpInside];
        [_payBtn setTitle:@"立即付款" forState:UIControlStateNormal];
    }else if([detailVO.order_info.pay_status integerValue] == 1 && _orderType < 9){//提醒发货订单
        [_payBtn addTarget:self action:@selector(warningSend) forControlEvents:UIControlEventTouchUpInside];
        [_payBtn setTitle:@"提醒发货" forState:UIControlStateNormal];
    }else if ([detailVO.order_info.pay_status integerValue] == 2 && _orderType < 9){//确认收货订单
        [_payBtn addTarget:self action:@selector(checkOrder) forControlEvents:UIControlEventTouchUpInside];
        [_payBtn setTitle:@"确认收货" forState:UIControlStateNormal];
    }else if (_orderType >= 8 || _orderType == 5){
        _payBtn.hidden = YES;
    }
//    else if ([detailVO.order_info.pay_status integerValue] == 15){//待评价订单
//        [_payBtn addTarget:self action:@selector(eventOrder) forControlEvents:UIControlEventTouchUpInside];
//        [_payBtn setTitle:@"立即评价" forState:UIControlStateNormal];
//    }
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), BOTTOMHEIGHT + 10)];
    [footer setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableFooterView:footer];
}

- (void)warningSend{
    [self textStateHUD:@"已提醒卖家发货"];
}

- (void)checkOrder{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
    alert.title = @"确认收货";
    alert.tag = 3010;
    
    [alert show];
}
//#pragma mark - HTCopyableLabelDelegate label 复制代理
//
//- (NSString *)stringToCopyForCopyableLabel:(HTCopyableLabel *)copyableLabel
//{
//    NSString *stringToCopy = @"";
//    
//    if (copyableLabel == _orderidLbl)
//    {
//        stringToCopy = _orderidLbl.text;
//    }
//    
//    return stringToCopy;
//}
#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger tag = alertView.tag;
    if (tag == 1010) {
        if (buttonIndex == 0) {
            [self cancelOrderOperation];
        }
    }else if (tag == 3010){
        if (buttonIndex == 0) {
            [self checkOrderOperation];
        }
    }
}

//- (void)eventOrder{
//    EvaluationTableViewController * eventVC = [[EvaluationTableViewController alloc] initWithOrderEventVO:detailVO.order_info];
//    eventVC.navigationController = self.navigationController;
//    eventVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:eventVC animated:YES];
//}

-(void)setupRightMenuButton
{
    if (!_menuItem) {
        UIButton * menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuBtn setFrame:CGRectMake(0, 0, 60, 27)];
        [menuBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [menuBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [menuBtn addTarget:self action:@selector(deleteOrder) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem * menuItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
        _menuItem = menuItem;
    }
    [self.navigationController addRightBarButtonItem:_menuItem animation:NO];
}

- (void)deleteOrder{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"取消订单" message:nil delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
    alert.tag = 1010;
    [alert show];
}

- (void)goToPay
{
    if (![[kata_UserManager sharedUserManager] isLogin]) {
        [kata_LoginViewController showInViewController:self];
        return;
    }
    
    OrderGoodsVO *gvo = detailVO.order_info.part_orders[0];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:detailVO.order_info.pay_amount, @"money", detailVO.order_info.order_id, @"orderid", gvo.goods_id, @"product_id", nil];
    kata_CashFailedViewController *payVC = [[kata_CashFailedViewController alloc] initWithOrderInfo:dict andPay:NO andType:NO];
    payVC.navigationController = self.navigationController;
    [self.navigationController pushViewController:payVC animated:YES];
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

- (void)layoutTotalLbl:(NSNumber *)total
{
    [_totalLbl setText:[NSString stringWithFormat:@"¥%0.2f",[total doubleValue]]];
}

- (void)layoutPayBtn:(NSNumber *)status
{
    if ((status.intValue == 4 || status.intValue == 1 || status.intValue == 2) && _orderType < 8) {
        [_payBtn setHidden:NO];
    }else{
        [_payBtn setHidden:YES];
    }
}

#pragma mark - Load OrderDetail Data
- (void)loadOrderDetail
{
//    if (!stateHud) {
//        stateHud = [[MBProgressHUD alloc] initWithView:self.contentView];
//        stateHud.delegate = self;
//        [self.contentView addSubview:stateHud];
//    }
//    stateHud.mode = MBProgressHUDModeIndeterminate;
//    stateHud.labelFont = [UIFont systemFontOfSize:14.0f];
//    [stateHud show:YES];
    if (!loading) {
        loading = [[Loading alloc] initWithFrame:CGRectMake(0, 0, 180, 100) andName:[NSString stringWithFormat:@"loading.gif"]];
        loading.center = self.contentView.center;
        [loading.layer setCornerRadius:10.0];
        [self.view addSubview:loading];
    }
    [loading start];
    
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
        req = [[KTOrderItemGetRequest alloc] initWithUserID:[userid integerValue]
                                               andUserToken:usertoken
                                                 andOrderID:_orderID
                                                  andPartID:_partid
                                             andOrderStates:_orderType];
    }
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(loadOrderDetailParseResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
//        [stateHud hide:YES];
        [loading stop];
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (void)loadOrderDetailParseResponse:(NSString *)resp
{
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            if ([respDict objectForKey:@"data"] != nil && ![[respDict objectForKey:@"data"] isEqual:[NSNull null]]) {
                id dataObj = [respDict objectForKey:@"data"];
                
                if ([dataObj isKindOfClass:[NSDictionary class]]) {
                    detailVO = [OrderDetailVO OrderDetailVOWithDictionary:dataObj];
                    
                    if ([detailVO.Code intValue] == 0) {
                        
                        if (detailVO.user_info) {
                            _addressVO = detailVO.user_info;
                        }
                        
                        [_detailArr removeAllObjects];
                        
                        if(detailVO.order_info){
                            [_detailArr addObject:detailVO.order_info];
                            [_detailArr addObjectsFromArray:detailVO.order_info.part_orders];
                        }
                        if (detailVO.order_info.pay_amount) {

                            NSString *tmpstr = [NSString stringWithFormat:@"¥%0.2f",[detailVO.order_info.total_money floatValue]];
                            [_detailArr addObject:[NSArray arrayWithObjects:@"商品总价 :", tmpstr, nil]];
                        }
                        
                        NSString *freight = [detailVO.order_info.pay_freight doubleValue] > 0?[NSString stringWithFormat:@"¥%0.2f",[detailVO.order_info.pay_freight floatValue]]:@"全国包邮";
                        [_detailArr addObject:[NSArray arrayWithObjects:@"运费 :", freight, nil]];
                        
                        NSString *coupon = detailVO.order_info.coupon_title?detailVO.order_info.coupon_title:@"未使用优惠券";
                        [_detailArr addObject:[NSArray arrayWithObjects:@"优惠券 :", coupon, nil]];
                        
                        [_detailArr addObject:[NSArray arrayWithObjects:@"活动 :", [NSString stringWithFormat:@"¥%0.2f",[detailVO.order_info.discount_money floatValue]], nil]];
                        
                        [_detailArr addObject:[NSArray arrayWithObjects:@"金豆 :", [NSString stringWithFormat:@"%zi金豆",[detailVO.order_info.pay_credit integerValue]], nil]];
                        
                        [self performSelectorOnMainThread:@selector(layoutViewWithOrderInfo:) withObject:detailVO waitUntilDone:YES];
                    } else {
                        //listVO.Msg
                        self.statefulState = FTStatefulTableViewControllerStateIdle;
                        if ([detailVO.Code intValue] == -102) {
                            [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:detailVO.Msg waitUntilDone:YES];
                            [[kata_UserManager sharedUserManager] logout];
                            [self performSelectorOnMainThread:@selector(checkLogin) withObject:nil waitUntilDone:YES];
                        }
                    }
                } else {
                    self.statefulState = FTStatefulTableViewControllerStateEmpty;
                }
            } else {
                self.statefulState = FTStatefulTableViewControllerStateEmpty;
            }
        } else {
            self.statefulState = FTStatefulTableViewControllerStateEmpty;
        }
    } else {
        self.statefulState = FTStatefulTableViewControllerStateEmpty;
    }
//    [stateHud hide:YES];
    [loading stop];
}

- (void)layoutViewWithOrderInfo:(OrderDetailVO *)vo
{
    [self performSelectorOnMainThread:@selector(layoutDetailView) withObject:nil waitUntilDone:YES];
    [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.2];
    
    if (vo.order_info.pay_amount) {
        [self performSelector:@selector(layoutTotalLbl:) withObject:vo.order_info.pay_amount afterDelay:0.2];
    }
    
    if (vo.order_info.pay_status) {
        [self performSelector:@selector(layoutPayBtn:) withObject:vo.order_info.pay_status afterDelay:0.2];
    }
}

#pragma mark -
#pragma tableView delegate && datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_detailArr.count > 0) {
        return _detailArr.count + 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *STATE = @"state";
    static NSString *GOODS = @"goods";
    static NSString *OTHER = @"other";
    static NSString *TIME = @"time";
    
    NSInteger row = indexPath.row;
    
    if (row< _detailArr.count) {
        id datavo = [_detailArr objectAtIndex:row];
        if ([datavo isKindOfClass:[OrderInfoVO class]]) {
            OrderInfoVO *ovo = datavo;
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:STATE];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:STATE];
                
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW-70, 10, 60, 20)];
                [btn setTitle:@"退款" forState:UIControlStateNormal];
                [btn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
                btn.layer.borderColor = [[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1] CGColor];
                btn.layer.borderWidth = 0.5;
                [btn setTitleColor:[UIColor colorWithRed:0.49 green:0.49 blue:0.49 alpha:1] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
                //[cell addSubview:btn];
                
//                UILabel *clineLbl = [[UILabel alloc] initWithFrame:CGRectMake(12, 39.5, ScreenW-12, 0.5)];
//                clineLbl.backgroundColor = [UIColor colorWithRed:0.89 green:0.89 blue:0.9 alpha:1];
//                [cell addSubview:clineLbl];
            }
            [cell.imageView setImage:[UIImage imageNamed:@"order_l"]];
            NSString *textStr = [NSString stringWithFormat:@"订单状态 : %@", ovo.pay_status_name];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:textStr];
            [str addAttribute:NSForegroundColorAttributeName value:LMH_COLOR_BLACK range:NSMakeRange(0,7)];
            [str addAttribute:NSForegroundColorAttributeName value:LMH_COLOR_SKIN range:NSMakeRange(7,textStr.length-7)];
            [str addAttribute:NSFontAttributeName value:LMH_FONT_14 range:NSMakeRange(0, textStr.length)];
            cell.textLabel.attributedText = str;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
            
            return cell;
        }else if([datavo isKindOfClass:[OrderGoodsVO class]]){
            OrderGoodsVO *gvo = datavo;
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GOODS];
            if (!cell) {
                cell = [[KTOrderDetailProductTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GOODS];
            }
            [(KTOrderDetailProductTableViewCell*)cell setItemData:gvo andReturnData:nil andType:1];
            [(KTOrderDetailProductTableViewCell*)cell setDelegate:self];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
            
            return cell;
        }else if ([datavo isKindOfClass:[NSArray class]]){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:OTHER];
            if (!cell) {
                cell = [[KTOrderCheckTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OTHER];
                
                UILabel *lineGray = [[UILabel alloc] initWithFrame:CGRectMake(10, 39, ScreenW-20, 0.5)];
                lineGray.backgroundColor = LMH_COLOR_LIGHTLINE;
                [cell addSubview:lineGray];
            }
            
            [(KTOrderCheckTableViewCell*)cell setCheckArray:_detailArr[row]];
            cell.backgroundColor = [UIColor whiteColor];
            
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else{
        OrderInfoVO *ovo = [_detailArr objectAtIndex:0];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TIME];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TIME];
            
            NSDate *dt = [NSDate dateWithTimeIntervalSince1970:[ovo.create_at longLongValue]];
            NSDateFormatter * df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *regStr = [df stringFromDate:dt];
            UILabel *createTimeLbl = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, ScreenW-22, 20)];
            [createTimeLbl setText:[NSString stringWithFormat:@"下单时间: %@", regStr]];
            [createTimeLbl setFont:[UIFont systemFontOfSize:13.0]];
            [createTimeLbl setTextColor:[UIColor colorWithRed:0.49 green:0.49 blue:0.49 alpha:1]];
            createTimeLbl.backgroundColor = [UIColor clearColor];
            [cell addSubview:createTimeLbl];
            
            UILabel *_orderTextLbl = [[UILabel alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(createTimeLbl.frame)+10, 60, 20)];
            [_orderTextLbl setText:@"订单编号:"];
            [_orderTextLbl setFont:[UIFont systemFontOfSize:13.0]];
            [_orderTextLbl setTextColor:[UIColor colorWithRed:0.49 green:0.49 blue:0.49 alpha:1]];
            _orderTextLbl.backgroundColor = [UIColor clearColor];
            [cell addSubview:_orderTextLbl];
            
            _orderidLabel = [[HTCopyableLabel alloc] initWithFrame:CGRectMake(12+60, CGRectGetMaxY(createTimeLbl.frame)+8, ScreenW- CGRectGetMaxX(_orderTextLbl.frame) - 20, 25)];
//            _orderidLabel.delegate = self;
//            _orderidLabel.alwaysBounceHorizontal = NO;
//            _orderidLabel.scrollEnabled = NO;
//            [_orderidLabel setEditable:false];
            [_orderidLabel setText:ovo.order_id];
            CGSize frame = [ovo.order_id sizeWithFont:FONT(13) constrainedToSize:CGSizeMake(200, 25) lineBreakMode:NSLineBreakByWordWrapping];
            _orderidLabel.frame = CGRectMake(12+60, CGRectGetMaxY(createTimeLbl.frame)+8, frame.width, 25);
            _orderidLabel.font = FONT(13);
            [_orderidLabel setTextColor:[UIColor colorWithRed:0.49 green:0.49 blue:0.49 alpha:1]];
            _orderidLabel.backgroundColor = [UIColor clearColor];
            [cell addSubview:_orderidLabel];
        }
        cell.backgroundColor = [UIColor whiteColor];
        
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row < _detailArr.count) {
        id datavo = [_detailArr objectAtIndex:row];
        if ([datavo isKindOfClass:[OrderInfoVO class]]){
            return 40;
        }else if ([datavo isKindOfClass:[OrderGoodsVO class]]){
            return ScreenW*0.25;
        }else if ([datavo isKindOfClass:[NSArray class]]){
            return 40;
        }
    }else{
        return 70;
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    if (row < _detailArr.count) {
        id datavo = [_detailArr objectAtIndex:row];
        if ([datavo isKindOfClass:[OrderGoodsVO class]]){
            OrderGoodsVO *gvo = datavo;
            kata_ProductDetailViewController *detailVC = [[kata_ProductDetailViewController alloc] initWithProductID:[gvo.goods_id integerValue] andType:nil andSeckillID:-1];
            detailVC.navigationController = self.navigationController;
            detailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
}

#pragma mark - KTOrderCancelRequest
- (void)cancelOrderOperation
{
//    if (!stateHud) {
//        stateHud = [[MBProgressHUD alloc] initWithView:self.contentView];
//        stateHud.delegate = self;
//        [self.contentView addSubview:stateHud];
//    }
//    stateHud.mode = MBProgressHUDModeIndeterminate;
//    stateHud.labelFont = [UIFont systemFontOfSize:14.0f];
//    [stateHud show:YES];
    if (!loading) {
        loading = [[Loading alloc] initWithFrame:CGRectMake(0, 0, 180, 100) andName:[NSString stringWithFormat:@"loading.gif"]];
        loading.center = self.contentView.center;
        [loading.layer setCornerRadius:10.0];
        [self.view addSubview:loading];
    }
    [loading start];
    
    KTBaseRequest *req = [[KTBaseRequest alloc] init];
    
    if (_orderID != nil && ![_orderID isEqualToString:@""]) {
        NSString *userid = nil;
        NSString *usertoken = nil;
        
        if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isEqualToString:@""]) {
            userid = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"];
        }
        
        if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isEqualToString:@""]) {
            usertoken = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"];
        }
        
        if (userid && usertoken) {
            req = [[KTOrderCancelRequest alloc] initWithUserID:[userid integerValue]
                                                  andUserToken:usertoken
                                                    andOrderID:_orderID];
        }
    }
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(cancelOrderParseResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (void)cancelOrderParseResponse:(NSString *)resp
{
    NSString *hudPrefixStr = @"订单取消";
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            if (nil != [respDict objectForKey:@"data"] && ![[respDict objectForKey:@"data"] isEqual:[NSNull null]] && [[respDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *dataObj = (NSDictionary *)[respDict objectForKey:@"data"];
                if ([[dataObj objectForKey:@"code"] integerValue] == 0) {
                    
                    id messageObj = [dataObj objectForKey:@"msg"];
                    if (messageObj) {
                        if ([messageObj isKindOfClass:[NSString class]] && ![messageObj isEqualToString:@""]) {
                            [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:messageObj waitUntilDone:YES];
                        } else {
                            [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[hudPrefixStr stringByAppendingString:@"成功"] waitUntilDone:YES];
                        }
                    } else {
                        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[hudPrefixStr stringByAppendingString:@"成功"] waitUntilDone:YES];
                    }
                    [self performSelectorOnMainThread:@selector(updateWaitPayNum) withObject:nil waitUntilDone:YES];
                    [self performSelector:@selector(flashOrderList) withObject:nil afterDelay:0.0];
                    [self.navigationController popViewControllerAnimated:YES];
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
                    
                    if ([[dataObj objectForKey:@"code"] integerValue] == -102) {
                        [[kata_UserManager sharedUserManager] logout];
                        [self performSelectorOnMainThread:@selector(checkLogin) withObject:nil waitUntilDone:YES];
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
}

#pragma mark - KTOrderCancelRequest
- (void)checkOrderOperation
{
//    if (!stateHud) {
//        stateHud = [[MBProgressHUD alloc] initWithView:self.contentView];
//        stateHud.delegate = self;
//        [self.contentView addSubview:stateHud];
//    }
//    stateHud.mode = MBProgressHUDModeIndeterminate;
//    stateHud.labelFont = [UIFont systemFontOfSize:14.0f];
//    [stateHud show:YES];
    if (!loading) {
        loading = [[Loading alloc] initWithFrame:CGRectMake(0, 0, 180, 100) andName:[NSString stringWithFormat:@"loading.gif"]];
        loading.center = self.contentView.center;
        [loading.layer setCornerRadius:10.0];
        [self.view addSubview:loading];
    }
    [loading start];
    
    KTBaseRequest *req = [[KTBaseRequest alloc] init];
    
    NSString *userid = nil;
    NSString *usertoken = nil;
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isEqualToString:@""]) {
        userid = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"];
    }
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isEqualToString:@""]) {
        usertoken = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"];
    }
    
    NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:3];
    if (userid) {
        [subParams setObject:[NSNumber numberWithInteger:[userid integerValue]] forKey:@"user_id"];
    }
    
    if (usertoken) {
        [subParams setObject:usertoken forKey:@"user_token"];
    }
    
    if (_orderID) {
        [subParams setObject:_orderID forKey:@"order_id"];
    }
    
    if (_partid >= 0) {
        [subParams setObject:[NSNumber numberWithInteger:_partid] forKey:@"partner_id"];
    }
    
    NSMutableDictionary *paramsDict = [req params];
    [paramsDict setObject:@"confirm_receive_goods" forKey:@"method"];
    [paramsDict setObject:subParams forKey:@"params"];
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(checkOrderParseResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (void)checkOrderParseResponse:(NSString *)resp
{
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSInteger code = [[respDict objectForKey:@"code"] integerValue];
        
        if (code == 0) {
            [self textStateHUD:@"确认收货成功"];
            [self performSelector:@selector(flashOrderList) withObject:nil afterDelay:0.0];
            [self.navigationController popViewControllerAnimated:YES];
        }else if(code == 308){
            [self textStateHUD:[respDict objectForKey:@"msg"]];
        }else{
            [self textStateHUD:@"确认收货失败，请稍后重试"];
        }
    }else{
        [self textStateHUD:@"确认收货失败，请稍后重试"];
    }
}

- (void)flashOrderList{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"flashOrder" object:nil];
}

- (void)btnClick{
    
}

- (void)trackButtonClick
{
    //TODO   查看物流界面
    LMHTrackViewController *trackViewController = [[LMHTrackViewController alloc] initWithStyle:UITableViewStylePlain];
    
    trackViewController.productIDStr = [[[detailVO.order_info.part_orders objectAtIndex:0] goods_id] stringValue];
    trackViewController.orderIDStr   = detailVO.order_info.order_id;
    
    [self.navigationController pushViewController:trackViewController animated:YES];
}

#pragma mark - Login Delegate
- (void)didLogin
{
    [self loadOrderDetail];
}

- (void)loginCancel
{
    [self performSelector:@selector(popView) withObject:nil afterDelay:0.1];
}

- (void)popView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (UIView *)emptyView
{
    UIView *view = [super emptyView];
    
    CGFloat w = view.frame.size.width;
    CGFloat h = view.center.y;
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"orderlistempty"]];
    [image setFrame:CGRectMake((w - CGRectGetWidth(image.frame)) / 2, h - CGRectGetHeight(image.frame) - 20, CGRectGetWidth(image.frame), CGRectGetHeight(image.frame))];
    [view addSubview:image];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, h, w, 15)];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setTextColor:[UIColor colorWithRed:0.52 green:0.52 blue:0.52 alpha:1]];
    [lbl setFont:[UIFont systemFontOfSize:14.0]];
    [lbl setText:[NSString stringWithFormat:@"暂无%@", self.title]];
    [view addSubview:lbl];
    
    toHomeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [toHomeBtn setFrame:CGRectMake((w-w/3)/2, h + 60, w/3 , w/3/3)];
    [toHomeBtn.layer setMasksToBounds:YES];
    [toHomeBtn.layer setCornerRadius:9.0];
    
    CGFloat top = 10; // 顶端盖高度
    CGFloat bottom = 10 ; // 底端盖高度
    CGFloat left = 20; // 左端盖宽度
    CGFloat right = 20; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    UIImage *aImage = [[UIImage imageNamed:@"red_btn_small"] resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    [toHomeBtn setBackgroundImage:aImage forState:UIControlStateNormal];
    [toHomeBtn setBackgroundImage:aImage forState:UIControlStateSelected];
    [toHomeBtn setBackgroundImage:aImage forState:UIControlStateHighlighted];
    [toHomeBtn addTarget:self action:@selector(toHomeBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [toHomeBtn.layer setCornerRadius:toHomeBtn.frame.size.height/3];
    [toHomeBtn setTag:1010];
    
    UILabel *toHomeLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(toHomeBtn.frame), CGRectGetHeight(toHomeBtn.frame))];
    [toHomeLbl setTextColor:[UIColor whiteColor]];
    [toHomeLbl setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0]];
    [toHomeLbl setTextAlignment:NSTextAlignmentCenter];
    [toHomeLbl setText:@"去首页逛逛"];
    [toHomeLbl setFont:[UIFont fontWithName:@"Helvetica-BoldOblique" size:15]];
    [toHomeLbl setTag:1011];
    
    [toHomeBtn addSubview:toHomeLbl];
    [self.view addSubview:toHomeBtn];
    view.layer.zPosition=1;
    self.tableView.userInteractionEnabled=YES;
    NSLog(@" view = %zi",view.userInteractionEnabled);
    UITapGestureRecognizer *tapgestrue = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toHomeBtnPressed)];
    tapgestrue.numberOfTapsRequired =1;
    [view addGestureRecognizer:tapgestrue];
    NSLog(@"self.bgview.subiews=%@",self.tableView.backgroundView.subviews);
    
    return view;
}

-(void)toHomeBtnPressed
{
//    if (self.tabBarController == nil) {
//        mytabController.selectedIndex = 0;
//    }
    self.tabBarController.selectedIndex = 0;
}

//未支付订单数量更新
-(void)updateWaitPayNum
{
    UITabBar *tabBar = self.tabBarController.tabBar;
    UITabBarItem *tabBarItem4 = [tabBar.items objectAtIndex:4];
    
    NSNumber *wntValue = [[kata_UserManager sharedUserManager] userWaitPayCnt];
    if ([wntValue intValue]>0) {
        [[kata_UserManager sharedUserManager] updateWaitPayCnt:[NSNumber numberWithInteger:[wntValue intValue] - 1]];
        [tabBarItem4 setBadgeValue:[NSString stringWithFormat:@"%zi",[wntValue intValue] - 1]];
    }else{
        [tabBarItem4 setBadgeValue:0];
    }
}

- (void)returnOrder:(OrderGoodsVO *)orderData{
    switch ([orderData.part_order_status integerValue]) {
        case 1:
        case 2:
        case 3:
        case 14:
        case 15:
        {
            kata_ReturnViewController *applyVC = [[kata_ReturnViewController alloc] initWithGoodVO:orderData];
            applyVC.navigationController = self.navigationController;
            applyVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:applyVC animated:YES];
        }
            break;
        default:
        {
            kata_ReturnOrderDetailViewController *detailVC = [[kata_ReturnOrderDetailViewController alloc] initWithGoodVO:orderData andOrderID:_orderID andType:0];
            detailVC.navigationController = self.navigationController;
            detailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
            break;
    }
}

- (void)writeOrder:(ReturnOrderDetailVO *)returnData{

}

@end
