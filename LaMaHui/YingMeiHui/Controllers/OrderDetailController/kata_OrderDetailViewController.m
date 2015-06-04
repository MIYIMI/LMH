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
#import "KTOrderTableViewCell.h"

#define TABLEVIEWCOLOR      [UIColor colorWithRed:0.89 green:0.89 blue:0.9 alpha:1]
#define BOTTOMHEIGHT        50

@interface kata_OrderDetailViewController ()<KTOrderDetailProductTableViewCellDelegate,KTOrderTableViewCellDelegate>
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
    OrderGoodsVO *_goodVO;
    
    UILabel *_adressNameLbl;
    UILabel *_adressPhoneLbl;
    UILabel *_adressDetailLbl;
    UIView *_headView;
    UILabel *_addressLbl;
    UIImageView *_adressImgView;
    UIButton *_payBtn;
    UIButton *_cancelBtn;
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
    
    UIView *stateView;
    UIImageView *stateimage;
    UILabel *typeLbl;
    UILabel *payLbl;
    UILabel *freightLbl;
    UILabel *jindouLbl;
    UILabel *CouponLbl;
    
    HTCopyableLabel *_orderidLabel;
    Loading *loading;
    
    NSString *freight;
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
    [self loadOrderDetail];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 只执行1次的代码(这里面默认是线程安全的)
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(flashView) name:@"flashDetail" object:nil];
    });
}

#pragma mark - 刷新当前页面
- (void)flashView{
    [self loadOrderDetail];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI
{
    [self.tableView setBackgroundColor:TABLEVIEWCOLOR];
    [self.contentView setBackgroundColor:TABLEVIEWCOLOR];
    [self.tableView setDelaysContentTouches:NO];
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _headView = [[UIView alloc] initWithFrame:CGRectZero];
    [_headView setBackgroundColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1]];
    
    _headImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _headImgView.backgroundColor = [UIColor whiteColor];
    [_headView addSubview:_headImgView];
    
    trackView = [[UIView alloc] initWithFrame:CGRectZero];
    trackView.backgroundColor = [UIColor whiteColor];
    [_headView addSubview:trackView];
}

- (void)layoutDetailView
{
    CGFloat w = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    CGFloat _headViewH = 0;
    OrderInfoVO *ovo = [_detailArr objectAtIndex:_detailArr.count-1];
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
        //详细地址
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
        [_adressImgView setFrame:CGRectMake(12, CGRectGetMinY(_adressNameLbl.frame), 20, 25)];
        
        if (!stateView) {
            stateView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headImgView.frame), ScreenW, 55)];
            stateView.backgroundColor = LMH_COLOR_SKIN;
            [_headView addSubview:stateView];
        }
        
        if (!stateimage) {
            stateimage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 20, 20)];
            [stateView addSubview:stateimage];
            stateimage.image = [UIImage imageNamed:@"order_p"];
        }
        if (!typeLbl) {
            typeLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(stateimage.frame) + 10, 5, 150, 20)];
            [stateView addSubview:typeLbl];
            typeLbl.textColor = [UIColor whiteColor];
            typeLbl.text = @"   ";
            typeLbl.font = LMH_FONT_15;
        }
        typeLbl.text = ovo.pay_status_name;
        
        if (!payLbl) {
            payLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(stateimage.frame) + 10, CGRectGetMaxY(typeLbl.frame), 150, 12)];
            [stateView addSubview:payLbl];
            payLbl.textColor = [UIColor whiteColor];
            payLbl.text = @"实付金额：";
            payLbl.font = LMH_FONT_11;
        }
        payLbl.text = ovo.detail_info[1];
        
        if (!freightLbl) {
            freightLbl = [[UILabel alloc] initWithFrame:CGRectMake(ScreenW / 2, CGRectGetMinY(payLbl.frame), 150, 12)];
            [stateView addSubview:freightLbl];
            freightLbl.textColor = [UIColor whiteColor];
            freightLbl.text = @"运费：";
            freightLbl.font = LMH_FONT_11;
        }
        freightLbl.text = ovo.detail_info[0];

        if (!jindouLbl) {
            jindouLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(stateimage.frame) + 10, CGRectGetMaxY(payLbl.frame), 150, 12)];
            [stateView addSubview:jindouLbl];
            jindouLbl.textColor = [UIColor whiteColor];
            jindouLbl.text = @"使用金豆：";
            jindouLbl.font = LMH_FONT_11;
        }
        jindouLbl.text = ovo.detail_info[2];

        if (!CouponLbl) {
            CouponLbl = [[UILabel alloc] initWithFrame:CGRectMake(ScreenW / 2, CGRectGetMaxY(payLbl.frame), 150, 12)];
            [stateView addSubview:CouponLbl];
            CouponLbl.textColor = [UIColor whiteColor];
            CouponLbl.text = @"优惠券：";
            CouponLbl.font = LMH_FONT_11;
        }
        CouponLbl.text = ovo.detail_info[3];
        [_headView setFrame:CGRectMake(0, 0, w, _headViewH+10 + 55)];
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
        
        UILabel *priceTipLbl = [[UILabel alloc] initWithFrame:CGRectMake(9, 0, 40, CGRectGetHeight(subview.frame))];
        [priceTipLbl setBackgroundColor:[UIColor clearColor]];
        [priceTipLbl setFont:LMH_FONT_14];
        [priceTipLbl setTextAlignment:NSTextAlignmentLeft];
        [priceTipLbl setText:@"总计:"];
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
        
        if (!_cancelBtn) {
            _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 165, 12, 73, 30)];
            [_cancelBtn setTitleColor:LMH_COLOR_GRAY forState:UIControlStateNormal];
            [[_cancelBtn titleLabel] setFont:LMH_FONT_14];
            _cancelBtn.layer.borderColor = LMH_COLOR_LIGHTGRAY.CGColor;
            _cancelBtn.layer.borderWidth = 0.3;
            _cancelBtn.layer.cornerRadius = 5.0;
            [_bottomView addSubview:_cancelBtn];
            [_cancelBtn setHidden:YES];
        }
    }
    [self.contentView addSubview:_bottomView];
    
    _payBtn.hidden = YES;
    _cancelBtn.hidden = YES;
    if ([detailVO.order_info.pay_status integerValue] == 1) {//待付款订单
        _payBtn.hidden = NO;
        [_payBtn addTarget:self action:@selector(orderBtnTag:) forControlEvents:UIControlEventTouchUpInside];
        [_payBtn setTitle:@"立即付款" forState:UIControlStateNormal];
        _payBtn.tag = 1001;
        
        _cancelBtn.hidden = NO;
        [_cancelBtn addTarget:self action:@selector(orderBtnTag:) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.tag = 1003;
        [_cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
    }else if ([detailVO.order_info.pay_status integerValue] == 3){//确认收货订单
        _payBtn.hidden = NO;
        _payBtn.tag = 1002;
        [_payBtn addTarget:self action:@selector(orderBtnTag:) forControlEvents:UIControlEventTouchUpInside];
        [_payBtn setTitle:@"确认收货" forState:UIControlStateNormal];
    }else if ([detailVO.order_info.pay_status integerValue] == 4){//删除订单
        _payBtn.hidden = NO;
        _payBtn.tag = 1004;
        [_payBtn addTarget:self action:@selector(orderBtnTag:) forControlEvents:UIControlEventTouchUpInside];
        [_payBtn setTitle:@"删除订单" forState:UIControlStateNormal];
    }
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), BOTTOMHEIGHT + 10)];
    [footer setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableFooterView:footer];
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

#pragma mark - 加载详情页数据
- (void)loadOrderDetail
{
    [self loadHUD];
    
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
        [self hideHUD];
        [self performSelectorOnMainThread:@selector(loadOrderDetailParseResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        [self hideHUD];
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
                            for (OrderEventVO *evo in detailVO.order_info.part_orders) {
                                [_detailArr addObject:evo];
                                [_detailArr addObjectsFromArray:evo.goods];
                            }
                        }
                        if (detailVO.order_info.pay_amount) {
                            NSString *tmpstr = [NSString stringWithFormat:@"¥%0.2f",[detailVO.order_info.total_money floatValue]];
                            [_detailArr addObject:[NSArray arrayWithObjects:@"总计(不含运费) :", tmpstr, nil]];
                        }
                        freight = [detailVO.order_info.pay_freight doubleValue] > 0?[NSString stringWithFormat:@"¥%0.2f",[detailVO.order_info.pay_freight floatValue]]:@"全国包邮";
                        
                        [_detailArr addObject:detailVO.order_info];
                        
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
}

- (void)layoutViewWithOrderInfo:(OrderDetailVO *)vo
{
    [self performSelectorOnMainThread:@selector(layoutDetailView) withObject:nil waitUntilDone:YES];
    [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0];
    
    if (vo.order_info.pay_amount) {
        [self performSelector:@selector(layoutTotalLbl:) withObject:vo.order_info.pay_amount afterDelay:0];
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
        return _detailArr.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *OTHER = @"other";
    static NSString *TIME = @"time";
    static NSString *GOOD_IDENTIFI = @"GOOD_CELL";
    static NSString *BRAND_IDENTIFI = @"BRAND_CELL";
    
    NSInteger row = indexPath.row;
    
    if (row < _detailArr.count) {
        id datavo = [_detailArr objectAtIndex:row];
        if ([datavo isKindOfClass:[OrderEventVO class]]) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BRAND_IDENTIFI];
            if (!cell) {
                cell = [[KTOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BRAND_IDENTIFI];
            }
            [(KTOrderTableViewCell *)cell layoutUI:datavo andIndex:indexPath];
            [(KTOrderTableViewCell *)cell setDelegate:self];
            
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }else if([datavo isKindOfClass:[OrderGoodsVO class]]){//商品信息
            OrderGoodsVO *gvo = datavo;
            OrderListVO *lvo = [_detailArr objectAtIndex:_detailArr.count-1];
            gvo.order_id = lvo.order_id;
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GOOD_IDENTIFI];
            if (!cell) {
                cell = [[KTOrderDetailProductTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GOOD_IDENTIFI];
            }
            [(KTOrderDetailProductTableViewCell*)cell setItemData:gvo andReturnData:nil andType:0];
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
            UILabel *fLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, -2, 30, 15)];
            [cell addSubview:fLbl];
            [fLbl setTextColor:[UIColor colorWithRed:0.49 green:0.49 blue:0.49 alpha:1]];
            fLbl.font = LMH_FONT_11;
            fLbl.text = @"运费:";
            UILabel *fLbl_ = [[UILabel alloc] initWithFrame:CGRectMake(ScreenW - 90, -2, 80, 15)];
            [cell addSubview:fLbl_];
            fLbl_.textAlignment = 2;
            [fLbl_ setTextColor:[UIColor colorWithRed:0.49 green:0.49 blue:0.49 alpha:1]];
            fLbl_.font = LMH_FONT_11;
            fLbl_.text = freight;
            
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if([datavo isKindOfClass:[OrderInfoVO class]]){
            OrderInfoVO *ovo = [_detailArr objectAtIndex:_detailArr.count-1];
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TIME];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TIME];
                
                NSDate *dt = [NSDate dateWithTimeIntervalSince1970:[ovo.create_at longLongValue]];
                NSDateFormatter * df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *regStr = [df stringFromDate:dt];
                UILabel *createTimeLbl = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, ScreenW-22, 20)];
                [createTimeLbl setText:[NSString stringWithFormat:@"下单时间:   %@", regStr]];
                [createTimeLbl setFont:LMH_FONT_12];
                [createTimeLbl setTextColor:LMH_COLOR_LIGHTGRAY];
                createTimeLbl.backgroundColor = [UIColor clearColor];
                [cell addSubview:createTimeLbl];
                
                UILabel *_orderTextLbl = [[UILabel alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(createTimeLbl.frame)+5, 60, 20)];
                [_orderTextLbl setText:@"订单编号:"];
                [_orderTextLbl setFont:LMH_FONT_12];
                [_orderTextLbl setTextColor:LMH_COLOR_LIGHTGRAY];
                _orderTextLbl.backgroundColor = [UIColor clearColor];
                [cell addSubview:_orderTextLbl];
                
                _orderidLabel = [[HTCopyableLabel alloc] initWithFrame:CGRectNull];
                //            _orderidLabel.delegate = self;
                //            _orderidLabel.alwaysBounceHorizontal = NO;
                //            _orderidLabel.scrollEnabled = NO;
                //            [_orderidLabel setEditable:false];
                [_orderidLabel setText:ovo.order_id];
                CGSize frame = [ovo.order_id sizeWithFont:FONT(13) constrainedToSize:CGSizeMake(200, 20) lineBreakMode:NSLineBreakByWordWrapping];
                _orderidLabel.frame = CGRectMake(CGRectGetMaxX(_orderTextLbl.frame), CGRectGetMaxY(createTimeLbl.frame)+5, frame.width, 20);
                _orderidLabel.font = LMH_FONT_12;
                [_orderidLabel setTextColor:LMH_COLOR_LIGHTGRAY];
                _orderidLabel.backgroundColor = [UIColor clearColor];
                [cell addSubview:_orderidLabel];
            }
            cell.backgroundColor = [UIColor whiteColor];
            
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else{
        
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row < _detailArr.count) {
        id datavo = [_detailArr objectAtIndex:row];
        if([datavo isKindOfClass:[OrderEventVO class]]){
            return 30;
        }else if ([datavo isKindOfClass:[OrderGoodsVO class]]){
            return ScreenW*0.25 + 10;
        }else if ([datavo isKindOfClass:[NSArray class]]){
            return 40;
        }else if([datavo isKindOfClass:[OrderInfoVO class]]){
            return 70;
        }
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

#pragma mark - 取消订单
- (void)cancelOrderOperation
{
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
        [self hideHUD];
        [self performSelectorOnMainThread:@selector(cancelOrderParseResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        [self hideHUD];
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (void)cancelOrderParseResponse:(NSString *)resp
{
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            if (nil != respDict[@"data"] && ![respDict[@"data"] isEqual:[NSNull null]] && [respDict[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *dataObj = (NSDictionary *)[respDict objectForKey:@"data"];
                if ([[dataObj objectForKey:@"code"] integerValue] == 0) {
                    [self textStateHUD:@"订单取消成功"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"flashOrder" object:nil];
                    [self loadOrderDetail];
                } else {
                    [self textStateHUD:dataObj[@"msg"]?dataObj[@"msg"]:@"订单取消失败"];
                    
                    if ([[dataObj objectForKey:@"code"] integerValue] == -102) {
                        [[kata_UserManager sharedUserManager] logout];
                        [self performSelectorOnMainThread:@selector(checkLogin) withObject:nil waitUntilDone:YES];
                    }
                }
            }
        } else {
            NSDictionary *dataObj = (NSDictionary *)[respDict objectForKey:@"data"];
            [self textStateHUD:dataObj[@"msg"]?dataObj[@"msg"]:@"订单取消失败"];
        }
    } else {
        [self textStateHUD:@"订单取消失败"];
    }
}

#pragma mark - 确认收货
- (void)checkOrderOperation
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
        [self hideHUD];
        [self performSelectorOnMainThread:@selector(checkOrderParseResponse:) withObject:resp waitUntilDone:YES];
    } failed:^(NSError *error) {
        [self hideHUD];
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
            [[NSNotificationCenter defaultCenter] postNotificationName:@"flashOrder" object:nil];
            [self loadOrderDetail];
        }else if(code == 308){
            [self textStateHUD:[respDict objectForKey:@"msg"]];
        }else{
            [self textStateHUD:@"确认收货失败，请稍后重试"];
        }
    }else{
        [self textStateHUD:@"确认收货失败，请稍后重试"];
    }
}

#pragma mark - 取消退款申请
- (void)cancelRefundOperation
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
    
    NSMutableDictionary *paramsDict = [req params];
    NSMutableDictionary *subParams = [[NSMutableDictionary alloc] init];
    if (userid) {
        [subParams setObject:[NSNumber numberWithLong:[userid integerValue]] forKey:@"user_id"];
    }
    
    if (usertoken) {
        [subParams setObject:usertoken forKey:@"user_token"];
    }
    
    if (_goodVO.order_part_id) {
        [subParams setObject:_goodVO.order_part_id forKey:@"order_part_id"];
    }
    
    if (_goodVO.order_id) {
        [subParams setObject:_goodVO.order_id forKey:@"order_id"];
    }
    
    [paramsDict setObject:subParams forKey:@"params"];
    [paramsDict setObject:@"cancel_refund_order" forKey:@"method"];
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        [self hideHUD];
        [self performSelectorOnMainThread:@selector(cancelRefundResponse:) withObject:resp waitUntilDone:YES];
    } failed:^(NSError *error) {
        [self hideHUD];
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (void)cancelRefundResponse:(NSString *)resp
{
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        if ([statusStr isEqualToString:@"OK"] && [statusStr isEqualToString:@"code"] == 0) {
            [self textStateHUD:@"取消退款已成功"];
            [self loadOrderDetail];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"flashOrder" object:nil];
        }else{
            [self textStateHUD:[respDict objectForKey:@"msg"]];
        }
    }else {
        [self textStateHUD:@"取消退款失败"];
    }
}

#pragma mark - 删除订单
- (void)deleteOrderOperation
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
    
    NSMutableDictionary *paramsDict = [req params];
    [paramsDict setObject:@"delete_order" forKey:@"method"];
    [paramsDict setObject:subParams forKey:@"params"];
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        [self hideHUD];
        [self performSelectorOnMainThread:@selector(deleteOrderParseResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        [self hideHUD];
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (void)deleteOrderParseResponse:(NSString *)resp
{
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSInteger code = [[respDict objectForKey:@"code"] integerValue];
        
        if (code == 0) {
            [self textStateHUD:@"订单删除成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"flashOrder" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else if(code == 308){
            [self textStateHUD:respDict[@"msg"]];
        }else{
            [self textStateHUD:@"订单删除失败，请稍后重试"];
        }
    }else{
        [self textStateHUD:@"订单删除失败，请稍后重试"];
    }
}

#pragma mark - 弹出选择框
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self loadHUD];
    
    NSInteger tag = alertView.tag;
    if (tag == 3010){//确认收货
        if (buttonIndex == 0) {
            [self checkOrderOperation];
        }
    }else if(tag == 3020){//取消退款
        if (buttonIndex == 0) {
            [self cancelRefundOperation];
        }
    }else if (tag == 3030) {//取消订单
        if (buttonIndex == 0) {
            [self cancelOrderOperation];
        }
    }else if(tag == 3040){//删除订单
        if (buttonIndex == 0) {
            [self deleteOrderOperation];
        }
    }
}

#pragma mark 主订单按钮操作
- (void)orderBtnTag:(UIButton *)sender{
    switch (sender.tag - 1000) {
        case 1://支付订单
        {
            if (![[kata_UserManager sharedUserManager] isLogin]) {
                [kata_LoginViewController showInViewController:self];
                return;
            }
            
            //获取第一个商品id用于付款成功页面商品推荐
            OrderEventVO *evo = detailVO.order_info.part_orders[0];
            OrderGoodsVO *gvo = evo.goods[0];
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:detailVO.order_info.pay_amount, @"money", detailVO.order_info.order_id, @"orderid", gvo.goods_id, @"product_id", nil];
            kata_CashFailedViewController *payVC = [[kata_CashFailedViewController alloc] initWithOrderInfo:dict andPay:NO andType:NO];
            payVC.navigationController = self.navigationController;
            [self.navigationController pushViewController:payVC animated:YES];
        }
            break;
        case 2://确认收货
        {
            _orderID = detailVO.order_info.order_id;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            alert.title = @"确认收货";
            alert.message = @"是否确认收货？";
            alert.tag = 3010;
            [alert show];
        }
            break;
        case 3://取消订单
        {
            _orderID = detailVO.order_info.order_id;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            alert.title = @"取消订单";
            alert.message = @"是否确定取消订单？";
            alert.tag = 3030;
            [alert show];
        }
            break;
        case 4://删除订单
        {
            _orderID = detailVO.order_info.order_id;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            alert.title = @"删除订单";
            alert.message = @"是否确定删除订单？";
            alert.tag = 3040;
            [alert show];
        }
            break;
        default:
            break;
    }
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

#pragma mark - 未支付订单数量更新
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

#pragma mark - 订单按钮操作
- (void)orderBtnClick:(NSInteger)tag andVO:(OrderGoodsVO *)orderData{
    _goodVO = orderData;
    _orderID = _goodVO.order_id;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    switch (tag) {
        case 1://申请退款
        {
            kata_ReturnViewController *applyVC = [[kata_ReturnViewController alloc] initWithGoodVO:orderData];
            applyVC.navigationController = self.navigationController;
            applyVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:applyVC animated:YES];
        }
            break;
        case 2://提醒发货
        {
            [self textStateHUD:@"已提醒卖家发货"];
        }
            break;
        case 3://查看物流
        {
            LMHTrackViewController *trackViewController = [[LMHTrackViewController alloc] initWithStyle:UITableViewStylePlain];
            trackViewController.productIDStr = [orderData.goods_id stringValue];
            trackViewController.orderIDStr   = _orderID;
            trackViewController.navigationController = self.navigationController;
            trackViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:trackViewController animated:YES];
        }
            break;
        case 4://确认收货
        {
            alert.title = @"确认收货";
            alert.message = @"是否确认收货？";
            alert.tag = 3010;
            
            [alert show];
        }
            break;
        case 5://评价订单
        {
            EvaluationTableViewController * eventVC = [[EvaluationTableViewController alloc] initWithOrderGoodsVO:_goodVO];
            eventVC.navigationController = self.navigationController;
            eventVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:eventVC animated:YES];
        }
            break;
        case 6://等待审核
        {
            kata_ReturnOrderDetailViewController *applyVC = [[kata_ReturnOrderDetailViewController alloc] initWithGoodVO:_goodVO andOrderID:_orderID andType:0];
            applyVC.navigationController = self.navigationController;
            applyVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:applyVC animated:YES];
        }
            break;
        case 7://审核通过
        {
            kata_ReturnOrderDetailViewController *applyVC = [[kata_ReturnOrderDetailViewController alloc] initWithGoodVO:_goodVO andOrderID:_orderID andType:0];
            applyVC.navigationController = self.navigationController;
            applyVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:applyVC animated:YES];
        }
            break;
        case 8://取消退款
        {
            alert.title = @"取消退款";
            alert.message = @"确定取消退款?";
            alert.tag = 3020;
            
            [alert show];
        }
            break;
        case 9://退款成功
        {
            kata_ReturnOrderDetailViewController *applyVC = [[kata_ReturnOrderDetailViewController alloc] initWithGoodVO:_goodVO andOrderID:_orderID andType:0];
            applyVC.navigationController = self.navigationController;
            applyVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:applyVC animated:YES];
        }
            break;
        default:
            break;
    }
}

//订单列表使用，该页面不使用
- (void)btnVO:(OrderListVO *)orderVO andTag:(NSInteger)tag{
    
}

//退款订单详情使用，该页面不使用
- (void)writeOrder:(ReturnOrderDetailVO *)returnData{
    
}

@end
