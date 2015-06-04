//
//  kata_AllOrderListViewController.m
//  YingMeiHui
//
//  Created by work on 14-11-26.
//  Copyright (c) 2014年 xieyanke. All rights reserved.
//

#import "kata_AllOrderListViewController.h"
#import "KTOrderTableViewCell.h"
#import "kata_UserManager.h"
#import "KTOrderListGetRequest.h"
#import "OrderListVO.h"
#import "kata_OrderDetailViewController.h"
#import "OrderBeanVO.h"
#import "KTOrderCancelRequest.h"
#import "kata_CashFailedViewController.h"
#import "LMHTrackViewController.h"
#import "kata_WebViewController.h"
#import "EvaluationTableViewController.h"
#import "KTOrderDetailProductTableViewCell.h"
#import "kata_ReturnViewController.h"
#import "kata_ReturnOrderDetailViewController.h"

#define PAGERSIZE 5

@interface kata_AllOrderListViewController ()<KTOrderTableViewCellDelegate,LoginDelegate,KTOrderDetailProductTableViewCellDelegate>
{
    NSString *_ordertype;
    OrderTotalVO *listVO;
    NSTimer *orderbackTimer;
    NSInteger _orderTypeNum;
    NSString *_orderID;
    NSInteger _partID;
    NSNumber *_productID;
    NSNumber *_orderPrice;
    NSString *_tabaourl;
    OrderGoodsVO *_goodVO;
    
    UIButton *toHomeBtn;
    UIView *_headView;
    UIView *_taobaoView;
    UIView *_huiview;
}

@end

@implementation kata_AllOrderListViewController
@synthesize mytabController;

- (id)initWithOrderType:(NSString *)ordertype
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.ifShowTableSeparator = NO;
        self.ifShowScrollToTopBtn = NO;
        self.ifShowToTop = YES;
        _partID = -1;
        _ordertype = ordertype;
        
        if ([_ordertype isEqualToString:@"nopay"]) {//待支付
            _orderTypeNum = 1;
            self.title = @"待付款订单";
        } else if ([_ordertype isEqualToString:@"nosend"]) {//待发货
            _orderTypeNum = 2;
            self.title = @"待发货订单";
        } else if ([_ordertype isEqualToString:@"noreceive"]) {//待收货
            _orderTypeNum = 3;
            self.title = @"待收货订单";
        } else if([_ordertype isEqualToString:@"evaluate"]){//待评价
            _orderTypeNum = 4;
            self.title = @"待评价订单";
        }else if([_ordertype isEqualToString:@"refunding"]){//退款中
            _orderTypeNum = 5;
            self.title = @"退款订单";
        }else if([_ordertype isEqualToString:@"refunded"]){//退款完成
            _orderTypeNum = 6;
            self.title = @"退款订单";
        }else if([_ordertype isEqualToString:@"evaluated"]){//已评价
            _orderTypeNum = 7;
            self.title = @"已评价订单";
        }else{//全部订单
            _orderTypeNum = 0;
            self.title = @"全部订单";
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    [self loadNewer];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 只执行1次的代码(这里面默认是线程安全的)
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(flashOrder) name:@"flashOrder" object:nil];
    });
    
    [self createUI];
}

- (void)createUI{
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 125)];
    [_headView setBackgroundColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1]];
    
    //淘宝订单
    _taobaoView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenW, 50)];
    [_taobaoView setBackgroundColor:[UIColor whiteColor]];
    UITapGestureRecognizer *tapClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushTBcart)];
    tapClick.numberOfTapsRequired = 1;
    [_taobaoView addGestureRecognizer:tapClick];
    
    UIImageView *taobaoImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 40, 40)];
    [taobaoImg setImage:[UIImage imageNamed:@"taobao"]];
    [_taobaoView addSubview:taobaoImg];
    
    UILabel *taobaoLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(taobaoImg.frame)+10, CGRectGetMinY(taobaoImg.frame), 150, 40)];
    taobaoLbl.numberOfLines = 0;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"淘宝商品订单\n点击查看淘宝商品订单"];
    [str addAttribute:NSForegroundColorAttributeName value:LMH_COLOR_ORANGE range:NSMakeRange(0,6)];
    [str addAttribute:NSForegroundColorAttributeName value:LMH_COLOR_LIGHTGRAY range:NSMakeRange(6,11)];
    [str addAttribute:NSFontAttributeName value:LMH_FONT_16 range:NSMakeRange(0, 6)];
    [str addAttribute:NSFontAttributeName value:LMH_FONT_12 range:NSMakeRange(6, 11)];
    taobaoLbl.attributedText = str;
    [_taobaoView addSubview:taobaoLbl];
    
    UIImageView *rightView= [[UIImageView alloc] initWithFrame:CGRectMake(ScreenW-20, (CGRectGetHeight(_taobaoView.frame)-15)/2, 10, 15)];
    [rightView setImage:[UIImage imageNamed:@"right_arrow"]];
    [_taobaoView addSubview:rightView];
    
    //汇特卖订单
    _huiview = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_taobaoView.frame)+10, ScreenW, 50)];
    [_huiview setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *huiImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 40, 40)];
    huiImgView.image = [UIImage imageNamed:@"huitemai"];
    [_huiview addSubview:huiImgView];
    
    UILabel *huiLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(huiImgView.frame)+10, CGRectGetMinY(huiImgView.frame), 150, 40)];
    huiLbl.numberOfLines = 0;
    NSMutableAttributedString *huistr = [[NSMutableAttributedString alloc] initWithString:@"汇特卖商品订单\n专注高性价比母婴特卖"];
    [huistr addAttribute:NSForegroundColorAttributeName value:LMH_COLOR_SKIN range:NSMakeRange(0,7)];
    [huistr addAttribute:NSForegroundColorAttributeName value:LMH_COLOR_LIGHTGRAY range:NSMakeRange(7,11)];
    [huistr addAttribute:NSFontAttributeName value:LMH_FONT_16 range:NSMakeRange(0, 7)];
    [huistr addAttribute:NSFontAttributeName value:LMH_FONT_12 range:NSMakeRange(7, 11)];
    huiLbl.attributedText = huistr;
    [_huiview addSubview:huiLbl];
    
    [_huiview setHidden:YES];
    [_headView addSubview:_huiview];
    [_headView addSubview:_taobaoView];
}

#pragma mark - 跳转到淘宝订单
- (void)pushTBcart{
    kata_WebViewController *cartWebVC = [[kata_WebViewController alloc] initWithUrl:_tabaourl title:@"淘宝订单" andType:@"taobao"];
    cartWebVC.navigationController = self.navigationController;
    cartWebVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cartWebVC animated:YES];
}

#pragma mark - 刷新当前页面
- (void)flashOrder{
    _orderTypeNum = [[[NSUserDefaults standardUserDefaults] objectForKey:@"orderNum"] integerValue];
    _ordertype = [[NSUserDefaults standardUserDefaults] objectForKey:@"orderType"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadFromPullToRefresh];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:_orderTypeNum] forKey:@"orderNum"];
    if (_ordertype) {
        [[NSUserDefaults standardUserDefaults] setObject:_ordertype forKey:@"orderType"];
    }
    
    [orderbackTimer invalidate];
    orderbackTimer = nil;
}

#pragma mark - 获取列表页数据
//stateful表格的数据和委托
//////////////////////////////////////////////////////////////////////////////////
- (KTBaseRequest *)request
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
    
    if(_orderTypeNum != 5 && _orderTypeNum != 6){
        req = [[KTOrderListGetRequest alloc] initWithUserID:[userid integerValue]
                                               andUserToken:usertoken
                                                    andType:_ordertype
                                                andPageSize:PAGERSIZE
                                                 andPageNum:self.current];
    }else{
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:3];
        if (userid) {
            [subParams setObject:[NSNumber numberWithInteger:[userid integerValue]] forKey:@"user_id"];
        }
        
        if (usertoken) {
            [subParams setObject:usertoken forKey:@"user_token"];
        }
        
        [subParams setObject:[NSNumber numberWithInteger:PAGERSIZE] forKey:@"page_size"];
        
        if (_ordertype) {
            [subParams setObject:_ordertype forKey:@"type"];
        }
        
        if (self.current >= 0) {
            [subParams setObject:[NSNumber numberWithInteger:self.current] forKey:@"page_no"];
        }
        
        NSMutableDictionary *paramsDict = [req params];
        [paramsDict setObject:@"get_user_refund_orders" forKey:@"method"];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    
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
                    listVO = [OrderTotalVO OrderTotalVOWithDictionary:dataObj];
                    _tabaourl = listVO.taobao_order_url;
                    
                    NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
                    if ([[respDict objectForKey:@"code"] intValue] == 0) {
                        for (OrderListVO *lvo in listVO.order_list) {
                            NSMutableArray *arry = [[NSMutableArray alloc] init];
                            for (OrderEventVO *evo in lvo.event) {
                                [arry addObject:evo];
                                [arry addObjectsFromArray:evo.goods];
                            }
                            [arry addObject:lvo];
                            [tmpArray addObject:arry];
                        }
                        
                        objArr = tmpArray;
                        
                        if (self.listData.count > 0 || objArr.count > 0) {
                            [self performSelector:@selector(startTimer) withObject:nil afterDelay:0];
                            [_huiview setHidden:NO];
                            [toHomeBtn setHidden:YES];
                        }else{
                            [_huiview setHidden:YES];
                            [toHomeBtn setHidden:NO];
                        }
                        
                        self.max = ceil([listVO.order_total floatValue] / PAGERSIZE);
                        
                        return objArr;
                    } else {
                        //listVO.Msg
                        self.statefulState = FTStatefulTableViewControllerError;
                        if ([[respDict objectForKey:@"code"] intValue] == -102) {
                            [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[respDict objectForKey:@"msg"] waitUntilDone:YES];
                            [[kata_UserManager sharedUserManager] logout];
                            //[self performSelectorOnMainThread:@selector(checkLogin) withObject:nil waitUntilDone:YES];
                        }
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
    } else {
        self.statefulState = FTStatefulTableViewControllerError;
    }
    [_huiview setHidden:YES];
    return objArr;
}

- (void)startTimer{
    [self.tableView setTableHeaderView:_headView];
    if (!orderbackTimer && (_orderTypeNum == 0 || _orderTypeNum == 1)) {
        orderbackTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(compareTime) userInfo:nil repeats:YES];
    }
}

#pragma mark -
#pragma tableView delegate && datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.listData.count > 0) {
        return self.listData.count;
    }
    
    [_huiview setHidden:YES];
    [toHomeBtn setHidden:NO];
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.listData.count > 0) {
        if(section == self.listData.count-1){
            return [(NSArray *)self.listData[section] count]+1;
        }else{
            return [(NSArray *)self.listData[section] count];
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    static NSString *BOOT_IDENTIFI = @"BOOT_CELL";
    static NSString *GOOD_IDENTIFI = @"GOOD_CELL";
    static NSString *BRAND_IDENTIFI = @"BRAND_CELL";
    static NSString *LOAD_MORE_CELL = @"LOAD_MORE_CELL";
    
    if (row < [self.listData[section] count]) {
        id vo = [self.listData[section] objectAtIndex:row];
        
        if ([vo isKindOfClass:[OrderEventVO class]]) {//专场标题
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BRAND_IDENTIFI];
            if (!cell) {
                cell = [[KTOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BRAND_IDENTIFI];
            }
            [(KTOrderTableViewCell *)cell layoutUI:vo andIndex:indexPath];
            [(KTOrderTableViewCell *)cell setDelegate:self];
            
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }else if([vo isKindOfClass:[OrderGoodsVO class]]){//商品信息
            OrderGoodsVO *gvo = vo;
            OrderListVO *lvo = [self.listData[section] objectAtIndex:[self.listData[section] count]-1];
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
        }else if([vo isKindOfClass:[OrderListVO class]]){//订单尾部综合信息
            id vo = [self.listData[section] objectAtIndex:[self.listData[section] count]-1];
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BOOT_IDENTIFI];
            if (!cell) {
                cell = [[KTOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BOOT_IDENTIFI];
            }
            
            NSIndexPath *inpath = [NSIndexPath indexPathForRow:-1 inSection:section];
            [(KTOrderTableViewCell *)cell layoutUI:vo andIndex:inpath];
            [(KTOrderTableViewCell *)cell setDelegate:self];
            
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LOAD_MORE_CELL];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LOAD_MORE_CELL];
            [cell.contentView setBackgroundColor:[UIColor clearColor]];
            [cell setBackgroundColor:[UIColor clearColor]];
            
            UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            activityIndicator.center = cell.center;
            activityIndicator.tag = 999;
            
            UILabel *emptyLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 30)];
            emptyLbl.textAlignment = NSTextAlignmentCenter;
            emptyLbl.font = [UIFont systemFontOfSize:14.0];
            emptyLbl.tag = 1000;
            emptyLbl.textColor = [UIColor colorWithRed:0.57 green:0.57 blue:0.57 alpha:1];
            emptyLbl.text = @"已经到底了";
            emptyLbl.hidden = YES;
            [cell addSubview:emptyLbl];
            
            [cell addSubview:activityIndicator];
            
            if (self.max > self.current) {
                [activityIndicator startAnimating];
            }else if(self.listData.count > 1){
                [emptyLbl setHidden:NO];
            }
            cell.userInteractionEnabled = NO;
        }else{
            UILabel *lbl = (UILabel *)[cell viewWithTag:1000];
            UIActivityIndicatorView * activityIndicator = (UIActivityIndicatorView * )[cell viewWithTag:999];
            if (self.max > self.current) {
                [activityIndicator startAnimating];
                [lbl setHidden:YES];
            }else if(self.listData.count > 1){
                [activityIndicator setHidden:YES];
                [lbl setHidden:NO];
            }
        }
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    if (row < [self.listData[section] count]) {
        id vo = [self.listData[section] objectAtIndex:row];
        if ([vo isKindOfClass:[OrderEventVO class]]) {
            return 30;
        }else if([vo isKindOfClass:[OrderGoodsVO class]]){
            return ScreenW*0.25;
        }else if ([vo isKindOfClass:[OrderListVO class]]) {
            id vo = [self.listData[section] objectAtIndex:[self.listData[section] count]-1];
            if ([vo isKindOfClass:[OrderListVO class]]) {
                OrderListVO *oderVo = vo;
                //主订单状态：1 - 代付款  2 - 已付款  3 - 确认收货  4 - 删除订单
                if ([oderVo.pay_status integerValue] == 1 || [oderVo.pay_status integerValue] == 3 || [oderVo.pay_status integerValue] == 4) {
                    return 75;
                }
                return 35;
            }
        }
    }else{
        if(self.listData.count > 1)
        return 30;
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    if(row < [self.listData[section] count]){
        id vo = [self.listData[section] objectAtIndex:row];
        OrderListVO *lvo = [self.listData[section] objectAtIndex:[self.listData[section] count]-1];
        if([vo isKindOfClass:[OrderGoodsVO class]]){
            OrderGoodsVO *gvo = vo;
            kata_OrderDetailViewController *detailVC = [[kata_OrderDetailViewController alloc] initWithOrderID:lvo.order_id andType:[gvo.part_order_status integerValue] antPartnerID:0];
            detailVC.hidesBottomBarWhenPushed = YES;
            detailVC.navigationController = self.navigationController;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
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
    
    NSMutableDictionary *paramsDict = [req params];
    [paramsDict setObject:@"confirm_receive_goods" forKey:@"method"];
    [paramsDict setObject:subParams forKey:@"params"];
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        [loading stop];
        [self performSelectorOnMainThread:@selector(checkOrderParseResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        [loading stop];
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
            [self loadFromPullToRefresh];
            [self textStateHUD:@"确认收货成功"];
        }else if(code == 308){
            [self textStateHUD:[respDict objectForKey:@"msg"]];
        }else{
            [self textStateHUD:@"确认收货失败，请稍后重试"];
        }
    }else{
        [self textStateHUD:@"确认收货失败，请稍后重试"];
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
        [loading stop];
        [self performSelectorOnMainThread:@selector(deleteOrderParseResponse:) withObject:resp waitUntilDone:YES];
    } failed:^(NSError *error) {
        [loading stop];
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
            [self performSelector:@selector(deleteOrderRow) withObject:nil];
            [self textStateHUD:@"订单删除成功"];
        }else if(code == 308){
            [self textStateHUD:respDict[@"msg"]];
        }else{
            [self textStateHUD:@"订单删除失败，请稍后重试"];
        }
    }else{
        [self textStateHUD:@"订单删除失败，请稍后重试"];
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
        [loading stop];
        [self performSelectorOnMainThread:@selector(cancelOrderParseResponse:) withObject:resp waitUntilDone:YES];
    } failed:^(NSError *error) {
        [loading stop];
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
                    [self loadFromPullToRefresh];
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

//删除数据源数据
- (void)deleteOrderRow
{
    for (NSInteger i = 0 ; i < self.listData.count; i++) {
        NSArray *oArray = [self.listData objectAtIndex:i];
        if ([oArray objectAtIndex:oArray.count-1] && [[oArray objectAtIndex:oArray.count-1] isKindOfClass:[OrderListVO class]]) {
            OrderListVO *vo = (OrderListVO *)[oArray objectAtIndex:oArray.count - 1];
            if ([_orderID isEqualToString:vo.order_id]) {
                [self.listData removeObjectAtIndex:i];
                [self.tableView reloadData];
                break;
            }
        }
    }
    
    if (self.listData.count == 0) {
        self.statefulState = FTStatefulTableViewControllerStateEmpty;
        _huiview.hidden = YES;
    }
    
    [self performSelectorOnMainThread:@selector(updateWaitPayNum) withObject:nil waitUntilDone:YES];
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
        [loading stop];
        [self performSelectorOnMainThread:@selector(cancelRefundResponse:) withObject:resp waitUntilDone:YES];
    } failed:^(NSError *error) {
        [loading stop];
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
            [self loadFromPullToRefresh];
        }else{
            [self textStateHUD:[respDict objectForKey:@"msg"]];
        }
    }else {
        [self textStateHUD:@"取消退款失败"];
    }
}

#pragma mark - 弹出选择框
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self loadHUD];
    
    NSInteger tag = alertView.tag;
    if (tag == 3030) {//取消订单
        if (buttonIndex == 0) {
            [self cancelOrderOperation];
        }
    }else if (tag == 3010){//确认收货
        if (buttonIndex == 0) {
            [self checkOrderOperation];
        }
    }else if(tag == 3020){//取消退款
        if (buttonIndex == 0) {
            [self cancelRefundOperation];
        }
    }else if(tag == 3040){//删除订单
        if (buttonIndex == 0) {
            [self deleteOrderOperation];
        }
    }
}

#pragma mark 主订单按钮操作
- (void)btnVO:(OrderListVO *)orderVO andTag:(NSInteger)tag{
    switch (tag) {
        case 1://支付订单
        {
            if (![[kata_UserManager sharedUserManager] isLogin]) {
                [kata_LoginViewController showInViewController:self];
                return;
            }
            
            //获取第一个商品id用于付款成功页面商品推荐
            OrderEventVO *evo = orderVO.event[0];
            OrderGoodsVO *gvo = evo.goods[0];
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:orderVO.pay_amount, @"money", orderVO.order_id, @"orderid", gvo.goods_id, @"product_id", nil];
            kata_CashFailedViewController *payVC = [[kata_CashFailedViewController alloc] initWithOrderInfo:dict andPay:NO andType:NO];
            payVC.navigationController = self.navigationController;
            [self.navigationController pushViewController:payVC animated:YES];
        }
            break;
        case 2://确认收货
        {
            _orderID = orderVO.order_id;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            alert.title = @"确认收货";
            alert.message = @"是否确认收货？";
            alert.tag = 3010;
            [alert show];
        }
            break;
        case 3://取消订单
        {
            _orderID = orderVO.order_id;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            alert.title = @"取消订单";
            alert.message = @"是否确定取消订单？";
            alert.tag = 3030;
            [alert show];
        }
            break;
        case 4://删除订单
        {
            _orderID = orderVO.order_id;
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

//订单按钮操作
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
            trackViewController.orderIDStr = orderData.order_id;
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
            kata_ReturnOrderDetailViewController *applyVC = [[kata_ReturnOrderDetailViewController alloc] initWithGoodVO:_goodVO andOrderID:_goodVO.order_id andType:1];
            applyVC.navigationController = self.navigationController;
            applyVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:applyVC animated:YES];
        }
            break;
        case 7://审核通过
        {
            kata_ReturnOrderDetailViewController *applyVC = [[kata_ReturnOrderDetailViewController alloc] initWithGoodVO:_goodVO andOrderID:_goodVO.order_id andType:1];
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
            kata_ReturnOrderDetailViewController *applyVC = [[kata_ReturnOrderDetailViewController alloc] initWithGoodVO:_goodVO andOrderID:_goodVO.order_id andType:1];
            applyVC.navigationController = self.navigationController;
            applyVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:applyVC animated:YES];
        }
            break;
        default:
            break;
    }
}

//退款订单页使用，该页面不使用
- (void)writeOrder:(ReturnOrderDetailVO*)returnData{
    
}

#pragma mark - LoginDelegate
- (void)didLogin{

}

- (void)loginCancel{

}

#pragma mark - 确认是否登录
- (void)checkLogin
{
    if (![[kata_UserManager sharedUserManager] isLogin]) {
        [self performSelector:@selector(showLoginView) withObject:nil afterDelay:0.1];
    }
}

#pragma mark 显示登录视图
- (void)showLoginView
{
    [kata_LoginViewController showInViewController:self];
}

#pragma mark - 更新未支付订单数量
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

#pragma mark - 绘制数据为空的视图
- (UIView *)emptyView
{
    UIView *view = [super emptyView];
 
    [view setBackgroundColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1]];
    if ([self.view viewWithTag:1010]){
        [[self.view viewWithTag:1010] removeFromSuperview];
    }
    if([view viewWithTag:1012]){
        for (UIView *itemV in view.subviews) {
            [itemV removeFromSuperview];
        }
    }
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"orderlistempty"]];
    [image setFrame:CGRectMake((ScreenW - CGRectGetWidth(image.frame))/2,  ScreenH/4, CGRectGetWidth(image.frame), CGRectGetHeight(image.frame))];
    [view addSubview:image];
    image.tag=1012;
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(image.frame)+10, ScreenW, 15)];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setTextColor:[UIColor colorWithRed:0.52 green:0.52 blue:0.52 alpha:1]];
    [lbl setFont:[UIFont systemFontOfSize:14.0]];
    [lbl setText:@"暂无订单信息"];
    [view addSubview:lbl];
    
    toHomeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [toHomeBtn setFrame:CGRectMake((ScreenW-ScreenW/3)/2, CGRectGetMaxY(lbl.frame)+20, ScreenW/3 , ScreenW/8)];
    
    [toHomeBtn setTitle:@"去首页逛逛" forState:UIControlStateNormal];
    [toHomeBtn setTitleColor:LMH_COLOR_SKIN forState:UIControlStateNormal];
    [toHomeBtn addTarget:self action:@selector(toHomeBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [toHomeBtn.layer setCornerRadius:4];
    toHomeBtn.layer.borderWidth = 0.5;
    toHomeBtn.layer.borderColor = LMH_COLOR_SKIN.CGColor;
    [toHomeBtn setTag:1010];
    
    [self.view addSubview:toHomeBtn];
    [self.view addSubview:_taobaoView];
    
    return view;
}

#pragma mark 点击按钮去首页
-(void)toHomeBtnPressed
{
    if (self.tabBarController == nil) {
        mytabController.selectedIndex = 0;
    }
    self.tabBarController.selectedIndex = 0;
    if (self.tabBarController.selectedIndex == 0) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - 倒计时
-(void)compareTime
{
    for(NSArray *array in self.listData){
        OrderListVO *lvo = [array objectAtIndex:array.count-1];
        if ([lvo.time_diff integerValue] > 0) {
            lvo.time_diff = [NSNumber numberWithInteger:[lvo.time_diff integerValue]-1];
        }
    }
    
    [self.tableView reloadData];
}

@end
