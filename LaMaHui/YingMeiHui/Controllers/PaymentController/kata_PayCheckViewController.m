//
//  kata_PayCheckViewController.m
//  YingMeiHui
//
//  Created by work on 14-10-23.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "kata_PayCheckViewController.h"
#import "KTAddressListGetRequest.h"
#import "kata_UserManager.h"
#import "KTProxy.h"
#import "AddressListVO.h"
#import "kata_AddressListViewController.h"
#import "KTShopCartTableViewCell.h"
#import "CartBrandVO.h"
#import "KTOrderCheckTableViewCell.h"
#import "OrderCheckVO.h"
#import "KTPayCheckRequest.h"
#import "KTCartOperateRequest.h"
#import "kata_CartManager.h"
#import "KTCheckCouponRequest.h"
#import "KTCouponGetRequest.h"
#import "CouponListVO.h"
#import "CheckCouponVO.h"
#import "CreditVO.h"
#import "kata_CashFailedViewController.h"
#import "DetailViewVO.h"
#import "kata_AddressEditViewController.h"

#define BOTTOMHIGHT 50.0f

@interface kata_PayCheckViewController ()
{
    UITableView *paytableView;
    UILabel *_adressNameLbl;
    UILabel *_adressPhoneLbl;
    UILabel *_adressDetailLbl;
    UIView *_headView;
    UILabel *_addressLbl;
    UIImageView *_imgView;
    UIImageView *_rightView;
    UIView *_errorView;
    
    UIView *_bottomView;
    UILabel *_totalLbl;
    UILabel *_totalFeeLbl;
    UILabel *_couponFeeLbl;
    UIButton *_payButton;
    
    KTCoupview *couponView;
    UIView *creditView;
    UITextField *creditField;
    UILabel *tsLbl;
    UIView *halfView;
    
    NSArray *_addressArr;
    NSArray *_couponArr;
    CreditVO *_creditDict;
    NSArray *_cashGoodsArr;
    NSString *_orderID;
    NSString *_get_creditStr;
    NSString *_get_creditRMB;
    
    NSString *_couponNo;
    NSInteger couponRecordId;
    NSInteger creditNum;
    
    BOOL is_loading;
    BOOL currentVC;
    
    NSInteger _addressID;
    NSInteger _addressNO;
    NSInteger _seckillID;
    
    NSArray *_productData;
    NSMutableArray *_productidArray;
    NSMutableArray *_otherData;
    NSDecimalNumber *_totalMoney;
    NSDecimalNumber * _shipFee;
    NSDecimalNumber * _endMoney;
    NSDecimalNumber * _couponMoney;
    NSDecimalNumber * _creditMoney;
    NSDecimalNumber * _activityMoney;
    NSDecimalNumber *_allMarkMoney;
    NSDecimalNumber * _diffMoney;
}

@end

@implementation kata_PayCheckViewController

-(id)initWithProductData:(NSArray *)productData andMoneyInfo:(NSDictionary *)moneyDict;
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.title = @"确认订单";
        _productData = productData;
        _productidArray = [[NSMutableArray alloc] init];
        
        _totalMoney = [[NSDecimalNumber alloc] initWithDouble:[[moneyDict objectForKey:@"money"] doubleValue]];
        _shipFee = [[NSDecimalNumber alloc] initWithDouble:[[moneyDict objectForKey:@"shipfee"] doubleValue]];
        _seckillID = [[moneyDict objectForKey:@"seckill"] integerValue];
        _endMoney = [[NSDecimalNumber alloc] initWithDouble:0.0];
        _endMoney = [_totalMoney decimalNumberBySubtracting:_shipFee];
        _couponMoney = [[NSDecimalNumber alloc] initWithDouble:0.0];
        _activityMoney = [[NSDecimalNumber alloc] initWithDouble:0.0];
        _creditMoney = [[NSDecimalNumber alloc] initWithDouble:0.0];
        _allMarkMoney = [[NSDecimalNumber alloc] initWithDouble:0.0];
        _diffMoney = [[NSDecimalNumber alloc] initWithDouble:0.0];
        NSString *shipstr = [_shipFee doubleValue]>0?[NSString stringWithFormat:@"¥%0.2f", [_shipFee doubleValue]]:@"全国包邮";
        _otherData = [NSMutableArray arrayWithObjects:
                      [NSArray arrayWithObjects:@"商品金额 :", [NSString stringWithFormat:@"¥%0.2f", [_totalMoney doubleValue]], nil],
                      [NSArray arrayWithObjects:@"运费 :", shipstr, nil],
                      [NSArray arrayWithObjects:@"活动 :", @"¥0.00", nil],
                      [NSArray arrayWithObjects:@"优惠券 :", @"不使用优惠券",nil],
                      [NSArray arrayWithObjects:@"金豆 :", @"可使用金豆 0",nil],
                      nil];
        self.hideNavigationBarWhenPush = YES;
        is_loading = YES;
        couponRecordId = -1;
        creditNum = 0;
        _couponNo = nil;
        _addressID = -1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadOrderPay];
    [self createUI];
    currentVC = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkAddr:) name:@"payAddrSelect" object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    currentVC = YES;
    _payButton.enabled = YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    currentVC = NO;
}

-(void)checkAddr:(NSNotification*)sender
{
    NSDictionary *dict = [sender userInfo];
    if ([[dict objectForKey:@"address"] isKindOfClass:[AddressVO class]]) {
        _addressArr = [NSArray arrayWithObject:[dict objectForKey:@"address"]];
        AddressVO *adVO = _addressArr[0];
        _addressID = [adVO.AddressID integerValue];
    }else{
        _addressArr = nil;
        _addressID = -1;
    }
    
    [self performSelectorOnMainThread:@selector(layoutView) withObject:nil waitUntilDone:YES];
}

-(void)createUI
{
    paytableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    [paytableView setBackgroundColor:[UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1]];
    paytableView.dataSource = self;
    paytableView.delegate =self;
    [self.view addSubview:paytableView];
    [self setExtraCellLineHidden:paytableView];
    paytableView.bounces = NO;
    
    if (IOS_7) {
        CGRect frame = self.view.frame;
        frame.size.height -= (64 + BOTTOMHIGHT);
        paytableView.frame = frame;
    }else{
        CGRect frame = self.view.frame;
        frame.size.height -= (44 + BOTTOMHIGHT);
        paytableView.frame = frame;
    }
    
    _headView = [[UIView alloc] initWithFrame:CGRectZero];
    [_headView setBackgroundColor:[UIColor whiteColor]];
    
    UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap)];
    //点击的次数
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    //给_headView添加一个手势监测；
    [_headView addGestureRecognizer:singleRecognizer];
    
    _bottomView = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(paytableView.frame), ScreenW, BOTTOMHIGHT)];
    [_bottomView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_bottomView];
    
    UILabel *speLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 1)];
    [speLine setBackgroundColor:[UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1]];
    [_bottomView addSubview:speLine];
    
    if(!creditView)
    {
        creditView = [[UIView alloc] initWithFrame:CGRectMake(20, ScreenH/7*2.5, ScreenW-40, ScreenH / 3.5)];
        creditView.layer.masksToBounds = NO;
        creditView.layer.cornerRadius = 8;
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(creditView.frame)-20, -3, 22, 22)];
        cancelBtn.layer.cornerRadius = 22/2;
        [cancelBtn setBackgroundImage:LOCAL_IMG(@"icon_close") forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(closeCredit) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setBackgroundColor:[UIColor colorWithRed:0.98 green:0.33 blue:0.43 alpha:1]];
        [creditView addSubview:cancelBtn];

        
        creditField = [[UITextField alloc] initWithFrame:CGRectMake((CGRectGetWidth(creditView.frame)-100)/2, 23, 100, 30)];
        creditField.layer.masksToBounds = NO;
        creditField.layer.cornerRadius = 5;
        
        [creditField setText:@"0"];
        creditField.keyboardType = UIKeyboardTypeNumberPad;
        creditField.delegate = self;
        [creditField setTextColor:[UIColor colorWithRed:0.98 green:0.3 blue:0.41 alpha:1]];
        [creditField setTextAlignment:NSTextAlignmentCenter];
        creditField.layer.borderColor = [[UIColor colorWithWhite:0.906 alpha:1.000] CGColor];
        creditField.layer.borderWidth = 1.0;
        creditField.userInteractionEnabled = YES;
        [creditView addSubview:creditField];
        
        UILabel *beginLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(creditField.frame)-35, 25, 30, 30)];
        [beginLbl setText:@"使用"];
        [beginLbl setTextColor:[UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1]];
        [beginLbl setFont:[UIFont systemFontOfSize:15.0]];
        [beginLbl setTextAlignment:NSTextAlignmentRight];
        [creditView addSubview:beginLbl];
        
        UILabel *endLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(creditField.frame)+5, 25, 30, 30)];
        [endLbl setText:@"金豆"];
        [endLbl setTextColor:[UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1]];
        [endLbl setFont:[UIFont systemFontOfSize:15.0]];
        [endLbl setTextAlignment:NSTextAlignmentLeft];
        [creditView addSubview:endLbl];
        
        UILabel *limitedLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetHeight(creditView.frame)/2 - 30/2 , CGRectGetWidth(creditView.frame) - 20, 30)];
        limitedLabel.backgroundColor = [UIColor clearColor];
        limitedLabel.font = FONT(15);
        limitedLabel.text = @"每个订单只可用金豆抵扣50%哦~";
        limitedLabel.textAlignment = NSTextAlignmentCenter;
        limitedLabel.textColor = GRAY_COLOR;
        [creditView addSubview:limitedLabel];
        
        UIButton *checkBtn = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(creditView.frame)/2-40), CGRectGetHeight(creditView.frame) - 50, 80, 30)];
//        [checkBtn setBackgroundImage:[UIImage imageNamed:@"red_btn_small"] forState:UIControlStateNormal];
        checkBtn.backgroundColor = ALL_COLOR;
        [checkBtn setTitle:@"使用" forState:UIControlStateNormal];
        [checkBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [checkBtn.titleLabel setTextColor:[UIColor whiteColor]];
        checkBtn.layer.cornerRadius = 3.0;
        [checkBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        [creditView addSubview:checkBtn];
    }
    halfView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    halfView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [[(kata_AppDelegate *)[[UIApplication sharedApplication] delegate] window] addSubview:halfView];
    
    [halfView setHidden:YES];
    
    couponView = [[KTCoupview alloc] initWithFrame:CGRectMake(10, ScreenH/4, ScreenW-20, ScreenH/ 2)];
    
    [self loadWithHud];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.view.frame.size.height == 480 - 64) {
        
        CGRect frame = creditView.frame;
        frame.origin.y -= 50;
        creditView.frame = frame;
    }
    if (self.view.frame.size.height == 568 - 64) {
        
        CGRect frame = creditView.frame;
        frame.origin.y -= 85;
        creditView.frame = frame;
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.view.frame.size.height == 480 - 64) {
        
        CGRect frame = creditView.frame;
        frame.origin.y += 50;
        creditView.frame = frame;
    }
    if (self.view.frame.size.height == 568 - 64) {
        
        CGRect frame = creditView.frame;
        frame.origin.y += 85;
        creditView.frame = frame;
    }
}
-(void)popViewdiss:(UIView *)hiddenView
{
    if ([hiddenView isKindOfClass:[couponView class]]) {
        [self performSelectorOnMainThread:@selector(closeView) withObject:nil waitUntilDone:YES];
    }else if ([hiddenView isKindOfClass:[creditView class]]){
        [self performSelectorOnMainThread:@selector(closeView) withObject:nil waitUntilDone:YES];
    }
}

-(void)SingleTap
{
    if(_addressID < 0){
        kata_AddressEditViewController *addressVC = [[kata_AddressEditViewController alloc] initWithAddessInfo:nil type:@"add"];
        addressVC.navigationController = self.navigationController;
        [addressVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:addressVC animated:YES];
    }else{
        kata_AddressListViewController *addressVC = [[kata_AddressListViewController alloc] initWithSelectID:_addressID isManage:NO];
        addressVC.navigationController = self.navigationController;
        [addressVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:addressVC animated:YES];
    }
}

-(void)layoutView
{
    [self hideHUDView];
    _adressNameLbl.text = nil;
    _adressPhoneLbl.text = nil;
    _adressDetailLbl.text = nil;
    _addressLbl.text = nil;
    is_loading = NO;
    CGFloat w = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    CGFloat _headViewH = 0;
    
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
    }else{
        [_headView setFrame:CGRectMake(0, 0, w, 50)];
        [_imgView setFrame:CGRectMake(12, 12.5, 20, 25)];
        [_rightView setFrame:CGRectMake(w - 20, 17.5, 10, 15)];
        if (!_addressLbl) {
            _addressLbl = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, w - 24, _headView.frame.size.height)];
            [_addressLbl setTextColor:[UIColor colorWithRed:0.98 green:0.19 blue:0.35 alpha:1]];
            [_headView addSubview:_addressLbl];
        }
        [_addressLbl setText:@"请填写收货人信息"];
    }
    [paytableView setTableHeaderView:_headView];
    
    if (!_payButton) {
        _payButton = [[UIButton alloc] initWithFrame:CGRectMake(w - 92, 10, 80, 30)];
        [_payButton setBackgroundImage:[UIImage imageNamed:@"red_btn_small"] forState:UIControlStateNormal];
        [_payButton setBackgroundImage:[UIImage imageNamed:@"red_btn_small"] forState:UIControlStateHighlighted];
        [_payButton setBackgroundImage:[UIImage imageNamed:@"red_btn_small"] forState:UIControlStateSelected];
        [_payButton setTitle:@"立即支付" forState:UIControlStateNormal];
        [_payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_payButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [_payButton addTarget:self action:@selector(payBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:_payButton];
    }
    
    if (!_totalLbl) {
        _totalLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        [_totalLbl setTextColor:[UIColor colorWithRed:0.49 green:0.49 blue:0.49 alpha:1]];
        [_totalLbl setFont:[UIFont systemFontOfSize:15.0]];
        [_totalLbl setText:@"总计 :"];
        [_bottomView addSubview:_totalLbl];
    }
    
    if (!_totalFeeLbl) {
        _totalFeeLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        [_totalFeeLbl setTextColor:LMH_COLOR_SKIN];
        [_totalFeeLbl setFont:LMH_FONT_15];
        [_totalFeeLbl setText:@"¥"];
        [_bottomView addSubview:_totalFeeLbl];
    }
    
    if (!_couponFeeLbl) {
        _couponFeeLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        [_couponFeeLbl setTextColor:LMH_COLOR_GRAY];
        [_couponFeeLbl setFont:LMH_FONT_12];
        [_bottomView addSubview:_couponFeeLbl];
    }
    
    NSDecimalNumber *allMoney = [[NSDecimalNumber alloc] initWithDouble:0.0];
    for (id vo in _productData) {
        if ([vo isKindOfClass:[CartProductVO class]]) {
            CartProductVO *pvo = vo;
            NSDecimalNumber *productDecimalObj = [[NSDecimalNumber alloc] initWithString:[pvo.sell_price stringValue]];
            NSDecimalNumber *brandDecimalObj = [[NSDecimalNumber alloc] initWithInteger:[pvo.qty integerValue]];
            NSDecimalNumber *moneyDecimalObj = [productDecimalObj decimalNumberByMultiplyingBy:brandDecimalObj];
            allMoney = [allMoney decimalNumberByAdding:moneyDecimalObj];
            
            productDecimalObj = [[NSDecimalNumber alloc] initWithString:[pvo.original_price stringValue]];
            brandDecimalObj = [[NSDecimalNumber alloc] initWithInteger:[pvo.qty integerValue]];
            moneyDecimalObj = [productDecimalObj decimalNumberByMultiplyingBy:brandDecimalObj];
            _allMarkMoney = [_allMarkMoney decimalNumberByAdding:moneyDecimalObj];
        }
    }
    if ([_shipFee doubleValue] <= 0) {
        _allMarkMoney = [_allMarkMoney decimalNumberByAdding:[[NSDecimalNumber alloc] initWithInteger:8]];
    }
    
    _activityMoney = [[allMoney decimalNumberByAdding:_shipFee] decimalNumberBySubtracting:_totalMoney];
    if ([_activityMoney doubleValue] <= 0) {
        _activityMoney  = 0;
    }
    
    [_otherData setObject:[NSArray arrayWithObjects:@"商品金额 :", [NSString stringWithFormat:@"¥%0.2f", [allMoney doubleValue]], nil] atIndexedSubscript:0];
    [_otherData setObject:[NSArray arrayWithObjects:@"活动 :", [NSString stringWithFormat:@"-¥%0.2f", [_activityMoney doubleValue]], nil] atIndexedSubscript:2];
    [self performSelectorOnMainThread:@selector(calcMoney) withObject:nil waitUntilDone:YES];
    [paytableView reloadData];
}

-(void)payBtnClick
{
    [_payButton setEnabled:NO];
    //需检查是否已登录 如未登陆则弹出登陆界面
    if (![[kata_UserManager sharedUserManager] isLogin]) {
        [kata_LoginViewController showInViewController:self];
        return;
    }
    if (_addressID <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你还没填写收货地址" delegate:self cancelButtonTitle:@"添加地址" otherButtonTitles:@"取消", nil];
        [alert show];
    }else if(!_orderID){
        [self performSelectorOnMainThread:@selector(orderSubmitOperation) withObject:nil waitUntilDone:YES];
    }else{
        [self performSelectorOnMainThread:@selector(goToPay) withObject:nil waitUntilDone:YES];
    }
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self performSelectorOnMainThread:@selector(SingleTap) withObject:nil waitUntilDone:YES];
    }else{
    }
    [_payButton setEnabled:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma tableView delegate && datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!is_loading) {
        return 2;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return _productData.count;
        case 1:
            return _otherData.count;
        default:
            break;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    static NSString *PRODUCT_CELL = @"product_cell";
    static NSString *BRAND_CELL = @"brand_cell";
    static NSString *OTHER_CELL = @"other_cell";
    
    if (section == 0){
        id vo = [_productData objectAtIndex:row];
        if ([vo isKindOfClass:[CartBrandVO class]]) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BRAND_CELL];
            if (!cell) {
                cell = [[KTShopCartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BRAND_CELL delegate:self];
            }
            [(KTShopCartTableViewCell *)cell setDataVO:vo andSection:-1];
            
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;

        }else if([vo isKindOfClass:[CartProductVO class]]){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PRODUCT_CELL];
            if (!cell) {
                cell = [[KTShopCartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PRODUCT_CELL delegate:self];
            }
            [(KTShopCartTableViewCell *)cell setDataVO:vo andSection:-1];
            
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:OTHER_CELL];
        if (!cell) {
            cell = [[KTOrderCheckTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OTHER_CELL];
        }
        
        [(KTOrderCheckTableViewCell*)cell setCheckArray:_otherData[row]];
        
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    if (section == 0){
        if ([[_productData objectAtIndex:row] isKindOfClass:[CartBrandVO class]]) {
            return 40;
        }else{
            return 85;
        }
    }
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    if (section == 1) {
        if (row == _otherData.count - 2) {
            _creditMoney = [NSDecimalNumber zero];
            if (_couponArr.count > 0) {
                couponView.frame = CGRectMake(20, ScreenH/4, ScreenW-40, ScreenH / 2);
                couponView.coupon_table.frame = CGRectMake(0, 0, ScreenW-40, ScreenH / 2);
                [couponView setBackgroundColor:[UIColor whiteColor]];
                [halfView addSubview:couponView];
                [halfView setHidden:NO];
                
                couponView.dataArray = _couponArr;
                couponView.delegate = self;
                _couponMoney = [NSDecimalNumber zero];
                [self performSelectorOnMainThread:@selector(calcMoney) withObject:nil waitUntilDone:YES];
            }else{
                [self performSelectorOnMainThread:@selector(calcMoney) withObject:nil waitUntilDone:YES];
                couponView.frame = CGRectMake(20, (ScreenH-200)/2, ScreenW-40, 200);
                couponView.coupon_table.frame = CGRectMake(0, 0, ScreenW-40, 200);
                [couponView setBackgroundColor:[UIColor whiteColor]];
                couponView.dataArray = _couponArr;
                couponView.delegate = self;
                [halfView addSubview:couponView];
                [halfView setHidden:NO];
                
                NSArray *arry = [NSArray arrayWithObjects:@"优惠券 :", @"无可用优惠券",nil];
                [_otherData setObject:arry atIndexedSubscript:_otherData.count -2];
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:_otherData.count -2 inSection:1];
                [paytableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            }
            NSString *creditStr = [NSString stringWithFormat:@"可使用金豆 %@", _creditDict.user_max_credit];
            NSArray *arry = [NSArray arrayWithObjects:@"金豆 :", creditStr,nil];
            [_otherData setObject:arry atIndexedSubscript:_otherData.count -1];
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:_otherData.count-1 inSection:1];
            [paytableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }else if(row == _otherData.count - 1){
             _creditMoney = [NSDecimalNumber zero];
            [self performSelectorOnMainThread:@selector(calcMoney) withObject:nil waitUntilDone:YES];
            if ([_creditDict.user_credit integerValue] > 0) {
                [creditView setBackgroundColor:[UIColor whiteColor]];
                NSInteger credit = [_endMoney doubleValue]*50>[_creditDict.user_max_credit integerValue]?[_creditDict.user_max_credit integerValue]:[_endMoney doubleValue]*50;
                [creditField setText:[NSString stringWithFormat:@"%zi",credit]];
                
                [self performSelectorOnMainThread:@selector(closeView) withObject:nil waitUntilDone:YES];
                [halfView addSubview:creditView];
                [halfView setHidden:NO];
            }else{
                NSArray *arry = [NSArray arrayWithObjects:@"金豆 :", @"可使用金豆 0",nil];
                [_otherData setObject:arry atIndexedSubscript:_otherData.count -1];
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:_otherData.count-1 inSection:1];
                [paytableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    }
}

-(void)calcMoney{
    _endMoney = [[_totalMoney decimalNumberBySubtracting:_couponMoney] decimalNumberBySubtracting:_creditMoney];
    [_totalFeeLbl setText:[NSString stringWithFormat:@"¥%0.2f", [_endMoney doubleValue]]];
    
    _diffMoney = [_allMarkMoney decimalNumberBySubtracting:_endMoney];
    if ([_diffMoney doubleValue] > 0) {
        [_couponFeeLbl setHidden:NO];
        [_couponFeeLbl setText:[NSString stringWithFormat:@"(已为您节省%0.2f元)", [_diffMoney doubleValue]]];
        _totalLbl.frame = CGRectMake(12, 5, 40, (BOTTOMHIGHT-10)/2);
        _totalFeeLbl.frame = CGRectMake(CGRectGetMaxX(_totalLbl.frame)+2, 5, 100, (BOTTOMHIGHT-10)/2);
        _couponFeeLbl.frame = CGRectMake(CGRectGetMinX(_totalLbl.frame), CGRectGetMaxY(_totalFeeLbl.frame), CGRectGetMinX(_payButton.frame)-22, (BOTTOMHIGHT-10)/2);
    }else{
        [_couponFeeLbl setHidden:YES];
        _totalLbl.frame = CGRectMake(12, 0, 40, BOTTOMHIGHT);
        _totalFeeLbl.frame = CGRectMake(CGRectGetMaxX(_totalLbl.frame)+2, 0, 100, BOTTOMHIGHT);
    }
}

#pragma mark - Load OrderPay Data
- (void)loadOrderPay
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
    
    [_productidArray removeAllObjects];
    for(id vo in _productData){
        if ([vo isKindOfClass:[CartProductVO class]]) {
            CartProductVO *pvo = vo;
            [_productidArray addObject:pvo.product_id?pvo.product_id:@-1];
        }
    }
    if (userid && usertoken) {
        req = [[KTPayCheckRequest alloc] initWithUserID:[userid intValue] andUserToken:usertoken andPayamount:[_endMoney doubleValue] andIDArray:_productidArray andAddressID:-1];
    }
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(loadOrderPayParseResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        [self performSelectorOnMainThread:@selector(errView) withObject:nil waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (void)loadOrderPayParseResponse:(NSString *)resp
{
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"] && [[respDict objectForKey:@"code"] integerValue] == 0) {
            if ([respDict objectForKey:@"data"] != nil && ![[respDict objectForKey:@"data"] isEqual:[NSNull null]]) {
                id dataObj = [respDict objectForKey:@"data"];
                
                OrderCheckVO *orderVO = [OrderCheckVO OrderCheckVOWithDictionary:dataObj];
                if ([orderVO.code intValue] == 0) {
                    
                    _addressArr = orderVO.address_list;
                    if (_addressArr.count > 0) {
                        AddressVO *vo = _addressArr[0];
                        
                        _addressID = [vo.AddressID intValue];
                    }
                    _couponArr = orderVO.coupon_list;
                    _creditDict = orderVO.credit_list;
                    if(_creditDict){
                        NSString *creditStr = [NSString stringWithFormat:@"可使用金豆 %@", _creditDict.user_max_credit];
                        NSArray *arry = [NSArray arrayWithObjects:@"金豆 :", creditStr,nil];
                        [_otherData setObject:arry atIndexedSubscript:_otherData.count -1];
                    }
                    if (_couponArr.count > 0) {
                        NSArray *arry = [NSArray arrayWithObjects:@"优惠券 :", @"不使用优惠券",nil];
                        [_otherData setObject:arry atIndexedSubscript:_otherData.count -2];
                    }else{
                        NSArray *arry = [NSArray arrayWithObjects:@"优惠券 :", @"无可用优惠券",nil];
                        [_otherData setObject:arry atIndexedSubscript:_otherData.count -2];
                    }
                    [self performSelectorOnMainThread:@selector(layoutView) withObject:nil waitUntilDone:YES];
                    return;
                } else if ([orderVO.code intValue] == -102) {
                    [[kata_UserManager sharedUserManager] logout];
                }
            }
        }
    }
    is_loading = YES;
    [self performSelectorOnMainThread:@selector(errView) withObject:nil waitUntilDone:YES];
    [self hideHUDView];
}

-(void)closeCredit{
    creditNum = 0;
     NSInteger _credit = [[_endMoney decimalNumberBySubtracting:_shipFee] doubleValue]*50>[_creditDict.user_max_credit integerValue]?[_creditDict.user_max_credit integerValue]:[[_endMoney decimalNumberBySubtracting:_shipFee] doubleValue]*50;
    NSString *creditStr = [NSString stringWithFormat:@"可使用金豆 %zi", _credit];
    NSArray *arry = [NSArray arrayWithObjects:@"金豆 :", creditStr,nil];
    [_otherData setObject:arry atIndexedSubscript:_otherData.count -1];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:_otherData.count-1 inSection:1];
    [paytableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
    _creditMoney =  [[NSDecimalNumber alloc] initWithDouble:(double)creditNum/100];
    [self performSelectorOnMainThread:@selector(calcMoney) withObject:nil waitUntilDone:YES];
    [self closeView];
}

- (void) btnClick
{
    creditNum = [creditField.text floatValue];
    NSInteger _credit = [[_endMoney decimalNumberBySubtracting:_shipFee] doubleValue]*50>[_creditDict.user_max_credit integerValue]?[_creditDict.user_max_credit integerValue]:[[_endMoney decimalNumberBySubtracting:_shipFee] doubleValue]*50;
    
    if (creditNum > _credit) {
        [self textStateHUD:[NSString stringWithFormat:@"对不起，您可使用金豆为%zi", _credit]];
        creditField.text = [NSString stringWithFormat:@"%zi", _credit];
        return;
    }

    [self performSelectorOnMainThread:@selector(closeView) withObject:nil waitUntilDone:YES];
    
    NSArray *arry = [NSArray arrayWithObjects:@"金豆 :", [NSString stringWithFormat:@"-¥%0.2f(%zi金豆)",[[[NSDecimalNumber alloc] initWithDouble:(double)creditNum/100] doubleValue], creditNum], nil];
    [_otherData setObject:arry atIndexedSubscript:_otherData.count -1];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:_otherData.count-1 inSection:1];
    [paytableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
    _creditMoney =  [[NSDecimalNumber alloc] initWithDouble:(double)creditNum/100];
    [self performSelectorOnMainThread:@selector(calcMoney) withObject:nil waitUntilDone:YES];
}

#pragma mark - KTCoupviewDelegate
- (void) selectMethod:(NSString *)coupon_id
{
    _couponNo = coupon_id;
    if ([_couponNo isEqualToString:@"no"]) {
        NSArray *arry = [NSArray arrayWithObjects:@"优惠券 :", @"不使用优惠券",nil];
        [_otherData setObject:arry atIndexedSubscript:_otherData.count -2];
        [self performSelectorOnMainThread:@selector(closeView) withObject:nil waitUntilDone:YES];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:_otherData.count -2 inSection:1];
        [paytableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        _creditMoney = [NSDecimalNumber zero];
        _couponMoney = [NSDecimalNumber zero];
        [couponView.checkBtn setUserInteractionEnabled:YES];
        [self performSelectorOnMainThread:@selector(calcMoney) withObject:nil waitUntilDone:YES];
        return;
    }
    [self loadCheckCoupon];
}

-(void)closeView{
    for (UIView *uview in halfView.subviews) {
        [uview removeFromSuperview];
    }
    [halfView setHidden:YES];
}

#pragma mark -
#pragma mark - Check Coupon Data
- (void)loadCheckCoupon
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
        req = [[KTCheckCouponRequest alloc] initWithUserID:[userid integerValue] andUserToken:usertoken andPayAmount:[_endMoney doubleValue] andCouponID:_couponNo];
    }
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(loadCheckCouponParseResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        
        [couponView textStateHUD:@"网络错误"];
    }];
    
    [proxy start];
}

- (void)loadCheckCouponParseResponse:(NSString *)resp
{
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            if ([[respDict objectForKey:@"code"] intValue] == 0) {
                if ([respDict objectForKey:@"data"] != nil && ![[respDict objectForKey:@"data"] isEqual:[NSNull null]]) {
                    id dataObj = [respDict objectForKey:@"data"];
                    
                    if ([dataObj isKindOfClass:[NSDictionary class]]) {
                        CheckCouponVO *couponVO = [CheckCouponVO CheckCouponVOWithDictionary:dataObj];
                        
                        switch ([couponVO.coupon_type intValue]) {
                            case 1:
                                [self performSelector:@selector(dismissCouponView:) withObject:couponVO afterDelay:0];
                                break;
                            case 2:
                                [couponView textStateHUD:@"您没有该优惠券"];
                                [couponView.checkBtn setUserInteractionEnabled:YES];
                                break;
                            case 3:
                                [couponView textStateHUD:@"此优惠券不存在"];
                                [couponView.checkBtn setUserInteractionEnabled:YES];
                                break;
                            case 4:
                                [couponView textStateHUD:@"此优惠券已过期"];
                                [couponView.checkBtn setUserInteractionEnabled:YES];
                                break;
                            case 5:
                                [couponView textStateHUD:@"此优惠券不符合使用条件"];
                                [couponView.checkBtn setUserInteractionEnabled:YES];
                                break;
                            default:
                                [couponView textStateHUD:@"优惠券信息获取失败"];
                                [couponView.checkBtn setUserInteractionEnabled:YES];
                                break;
                        }
                    }
                }
            }
        }
    }
}

-(void)dismissCouponView:(CheckCouponVO*)vo
{
    [self performSelectorOnMainThread:@selector(closeView) withObject:nil waitUntilDone:YES];
    [self performSelector:@selector(textStateHUD:) withObject:[NSString stringWithFormat:@"您将在订单总额中优惠%@元", vo.coupon_amount] afterDelay:0.3];
    NSArray *arry = [NSArray arrayWithObjects:@"优惠券 :", [NSString stringWithFormat:@"%@", vo.coupon_rule],nil];
    [_otherData setObject:arry atIndexedSubscript:_otherData.count -2];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:_otherData.count -2 inSection:1];
    [paytableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
    _couponMoney = [[NSDecimalNumber alloc] initWithString:[vo.coupon_amount stringValue]];
    couponRecordId = [vo.user_coupon_id integerValue];
    _couponNo = vo.couponid;
    _creditMoney = [NSDecimalNumber zero];
    
    [self performSelectorOnMainThread:@selector(calcMoney) withObject:nil waitUntilDone:YES];
    
    NSString *creditStr = @"";
    if ([_endMoney doubleValue] * 50 < [_creditDict.user_max_credit integerValue]) {
        creditStr = [NSString stringWithFormat:@"可使用金豆 %0.0f", [_endMoney doubleValue]*50];
    }else{
        creditStr = [NSString stringWithFormat:@"可使用金豆 %0.0f", [_creditDict.user_max_credit floatValue]];
    }
    NSArray *arrys = [NSArray arrayWithObjects:@"金豆 :", creditStr,nil];
    [_otherData setObject:arrys atIndexedSubscript:_otherData.count -1];
    NSIndexPath *indexPaths=[NSIndexPath indexPathForRow:_otherData.count-1 inSection:1];
    [paytableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPaths,nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Order Submit Post
- (void)orderSubmitOperation
{
    [self loadWithHud];
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
    
    NSMutableArray *productArr = [[NSMutableArray alloc] init];
    for (id vo in _productData) {
        if ([vo isKindOfClass:[CartProductVO class]]) {
            CartProductVO *goodVO = vo;
            NSMutableDictionary *productDict = [NSMutableDictionary new];
            [productDict setObject:goodVO.item_id forKey:@"cart_goods_id"];
            [productDict setObject:goodVO.qty forKey:@"quantity"];
            [productArr addObject:productDict];
        }
    }
    
    _cashGoodsArr = productArr;
    
    KTCartOperateRequest *req = [[KTCartOperateRequest alloc] initWithCartID:cartid
                                                                   andUserID:userid
                                                                andUserToken:usertoken
                                                                     andType:@"create_order"
                                                                  andProduct:_cashGoodsArr
                                                                   andGoodID:nil
                                                                andAddressID:_addressID
                                                                 andCouponNO:_couponNo
                                                              andCoponUserID:couponRecordId
                                                                   andCredit:creditNum
                                                                andSeckillID:_seckillID];
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(orderSubmitParseResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        [_payButton setEnabled:YES];
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (void)orderSubmitParseResponse:(NSString *)resp
{
    NSString * hudPrefixStr = @"提交订单";
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            if (nil != [respDict objectForKey:@"data"] && ![[respDict objectForKey:@"data"] isEqual:[NSNull null]] && [[respDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *dataObj = (NSDictionary *)[respDict objectForKey:@"data"];
                if ([[dataObj objectForKey:@"code"] integerValue] == 0) {
                    
                    _orderID = [[dataObj objectForKey:@"order_id"] stringValue];
                    _get_creditStr = [[dataObj objectForKey:@"get_credit"] stringValue];
                    _get_creditRMB = [[dataObj objectForKey:@"get_money"] stringValue];

                    // add by kevin on 2014.8.27 pm 4:00
                    NSNumber *waitPayNum = [dataObj objectForKey:@"order_wait_pay"];
                    if (waitPayNum) {
                        [[kata_UserManager sharedUserManager] updateWaitPayCnt:waitPayNum];
                    }
                    
                    NSInteger cartNum = [[[kata_CartManager sharedCartManager] cartCounter] intValue];
                    
                    [[kata_CartManager sharedCartManager] updateCartCounter:[NSNumber numberWithInteger:cartNum - _cashGoodsArr.count]];
                    [[kata_CartManager sharedCartManager] removeCartSku];
                    [self performSelectorInBackground:@selector(updateCartNum) withObject:nil];
                    [self performSelectorOnMainThread:@selector(goToPay) withObject:nil waitUntilDone:YES];
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
    [_payButton setEnabled:YES];
    [self hideHUDView];
}

-(void)goToPay
{
    NSMutableDictionary *orderdict = [NSMutableDictionary new];
    [orderdict setObject:_orderID forKey:@"orderid"];
    [orderdict setObject:[NSNumber numberWithFloat:[_endMoney doubleValue]] forKey:@"money"];
    [orderdict setObject:_productidArray[0] forKey:@"product_id"];
    if (currentVC) {
        kata_CashFailedViewController *payVC = [[kata_CashFailedViewController alloc] initWithOrderInfo:orderdict andPay:NO andType:NO];
        payVC.navigationController = self.navigationController;
        payVC.navigationController.ifPopToOrderView = YES;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:payVC animated:YES];
    }
}

-(void)updateCartNum
{
    //购物车数量更新
    UITabBar *tabBar = self.tabBarController.tabBar;
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:3];
    
    NSNumber *countValue = [[kata_CartManager sharedCartManager] cartCounter];
    if ([countValue intValue]>0) {
        [tabBarItem3 setBadgeValue:[[[kata_CartManager sharedCartManager] cartCounter] stringValue]];
    }else{
        [tabBarItem3 setBadgeValue:0];
    }
}

#pragma mark - Login Delegate
- (void)didLogin
{
    
}

- (void)loginCancel
{
    
}

- (void)loadWithHud
{
    if (!stateHud) {
        stateHud = [[MBProgressHUD alloc] initWithView:paytableView];
        stateHud.delegate = self;
        [paytableView addSubview:stateHud];
    }
    stateHud.mode = MBProgressHUDModeIndeterminate;
    [stateHud show:YES];
}

- (void)hideHUDView
{
    [stateHud hide:YES afterDelay:0.3];
}

- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)errView
{
    if (!_errorView) {
         _errorView = [[UIView alloc] initWithFrame:self.view.frame];
        
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
        
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScreen)];
        [_errorView addGestureRecognizer:tapGesture];
        
        [self.view addSubview:_errorView];
    }
    [_errorView setHidden:NO];
}

- (void)tapScreen
{
    [_errorView setHidden:YES];
    [self loadOrderPay];
}

@end
