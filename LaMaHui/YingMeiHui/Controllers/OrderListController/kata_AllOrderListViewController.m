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

#define PAGERSIZE 5

@interface kata_AllOrderListViewController ()<KTOrderTableViewCellDelegate,LoginDelegate,KTOrderDetailProductTableViewCellDelegate>
{
    NSString *_ordertype;
    OrderTotalVO *listVO;
    NSTimer *orderbackTimer;
    NSInteger _orderTypeNum;
    NSString *_cancelOrderID;
    NSInteger _partID;
    NSNumber *_productID;
    NSNumber *_orderPrice;
    NSString *_tabaourl;
    
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
        }else if([_ordertype isEqualToString:@"evaluated"]){//待评价
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(flashOrder) name:@"flashOrder" object:nil];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)createUI{
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 120)];
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
    
    //汇特卖订单
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
    
    UILabel *grayLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_huiview.frame)-1, ScreenW, 1)];
    grayLbl.backgroundColor = LMH_COLOR_LIGHTLINE;
    [_huiview addSubview:grayLbl];
    
    [_huiview setHidden:YES];
    [_headView addSubview:_huiview];
    [_headView addSubview:_taobaoView];
}

//跳转到淘宝订单
- (void)pushTBcart{
    kata_WebViewController *cartWebVC = [[kata_WebViewController alloc] initWithUrl:_tabaourl title:@"淘宝订单" andType:@"taobao"];
    cartWebVC.navigationController = self.navigationController;
    cartWebVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cartWebVC animated:YES];
}

- (void)flashOrder{
    [self performSelectorOnMainThread:@selector(loadNewer) withObject:nil waitUntilDone:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [orderbackTimer invalidate];
    orderbackTimer = nil;
}

#pragma mark - stateful tableview datasource && stateful tableview delegate
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
                            [arry addObject:lvo];
                            if ([lvo.pay_status integerValue] != 2) {
                                for (OrderEventVO *evo in lvo.event) {
                                    [arry addObject:evo];
                                    [arry addObjectsFromArray:evo.goods];
                                }
                                [tmpArray addObject:arry];
                            }else{
                                for (OrderEventVO *evo in lvo.event) {
                                    NSMutableArray *otherArray = [[NSMutableArray alloc] init];
                                    [otherArray addObject:lvo];
                                    [otherArray addObject:evo];
                                    [otherArray addObjectsFromArray:evo.goods];
                                    [tmpArray addObject:otherArray];
                                }
                            }
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
    }else if(_orderTypeNum == 0 || _orderTypeNum == 1){
        [orderbackTimer invalidate];
        orderbackTimer = nil;
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
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.listData.count > 0) {
        if(section == self.listData.count-1){
            return [(NSArray *)self.listData[section] count]+2;
        }else{
            return [(NSArray *)self.listData[section] count]+1;
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    static NSString *HEAD_IDENTIFI = @"HEAD_CELL";
    static NSString *BOOT_IDENTIFI = @"BOOT_CELL";
    static NSString *GOOD_IDENTIFI = @"GOOD_CELL";
    static NSString *BRAND_IDENTIFI = @"BRAND_CELL";
    static NSString *LOAD_MORE_CELL = @"LOAD_MORE_CELL";
    
    if (row < [self.listData[section] count]) {
        id vo = [self.listData[section] objectAtIndex:row];
        if ([vo isKindOfClass:[OrderListVO class]]) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HEAD_IDENTIFI];
            if (!cell) {
                cell = [[KTOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HEAD_IDENTIFI];
            }
            OrderEventVO *evo = [self.listData[section] objectAtIndex:row + 1];
            OrderListVO *lvo = vo;
            lvo.pay_status = evo.pay_status;
            lvo.pay_status_name = evo.pay_status_name;
            
            [(KTOrderTableViewCell *)cell layoutUI:lvo andIndex:indexPath];
            [(KTOrderTableViewCell *)cell setDelegate:self];
            
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;

        }else if ([vo isKindOfClass:[OrderEventVO class]]) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BRAND_IDENTIFI];
            if (!cell) {
                cell = [[KTOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BRAND_IDENTIFI];
            }
            
            [(KTOrderTableViewCell *)cell layoutUI:vo andIndex:indexPath];
            [(KTOrderTableViewCell *)cell setDelegate:self];
            
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }else if([vo isKindOfClass:[OrderGoodsVO class]]){
            OrderGoodsVO *gvo = vo;
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GOOD_IDENTIFI];
            if (!cell) {
                cell = [[KTOrderDetailProductTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GOOD_IDENTIFI];
            }
            [(KTOrderDetailProductTableViewCell*)cell setItemData:gvo andReturnData:nil andType:0];
            [(KTOrderDetailProductTableViewCell*)cell setDelegate:self];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
            
            return cell;
        }
    }else if(row == [self.listData[section] count]){
        id vo = [self.listData[section] objectAtIndex:0];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BOOT_IDENTIFI];
        if (!cell) {
            cell = [[KTOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BOOT_IDENTIFI];
        }
        OrderEventVO *evo = [self.listData[section] objectAtIndex:1];
        OrderListVO *lvo = vo;
        lvo.pay_status = evo.pay_status;
        lvo.pay_status_name = evo.pay_status_name;
        lvo.refund_money = [NSString stringWithFormat:@"%0.2f",[evo.refund_money doubleValue]];
        
        NSIndexPath *inpath = [NSIndexPath indexPathForRow:-1 inSection:section];
        [(KTOrderTableViewCell *)cell layoutUI:vo andIndex:inpath];
        [(KTOrderTableViewCell *)cell setDelegate:self];
        
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
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
        if ([vo isKindOfClass:[OrderListVO class]]) {
            return 30;
        }else if ([vo isKindOfClass:[OrderEventVO class]]) {
            if (row==0) {
                return 40;
            }
            return 30;
        }else if([vo isKindOfClass:[OrderGoodsVO class]]){
            return ScreenW*0.25;
        }
    }else if(row == [self.listData[section] count]){
        return 50;
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
        OrderListVO *lvo = [self.listData[section] objectAtIndex:0];
        OrderEventVO *evo = [self.listData[section] objectAtIndex:1];
        if([vo isKindOfClass:[OrderGoodsVO class]]){
            OrderGoodsVO *gvo = vo;
            NSInteger partner_id = [evo.partner_id integerValue];
            if ([gvo.part_order_status integerValue] == 5 || [gvo.part_order_status integerValue] == 4) {
                partner_id = 0;
            }
            kata_OrderDetailViewController *detailVC = [[kata_OrderDetailViewController alloc] initWithOrderID:lvo.order_id andType:[gvo.part_order_status integerValue] antPartnerID:partner_id];
            detailVC.hidesBottomBarWhenPushed = YES;
            detailVC.navigationController = self.navigationController;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
}

#pragma mark - KTOrdercheckRequest
- (void)checkOrderOperation
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
    
    if (_cancelOrderID) {
        [subParams setObject:_cancelOrderID forKey:@"order_id"];
    }
    
    if (_partID >= 0) {
        [subParams setObject:[NSNumber numberWithInteger:_partID] forKey:@"partner_id"];
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
            [self performSelector:@selector(deleteOrderRow) withObject:nil];
            [self textStateHUD:@"确认收货成功"];
        }else if(code == 308){
            //[self performSelector:@selector(deleteOrderRow) withObject:nil];
            [self textStateHUD:[respDict objectForKey:@"msg"]];
        }else{
            [self textStateHUD:@"确认收货失败，请稍后重试"];
        }
    }else{
        [self textStateHUD:@"确认收货失败，请稍后重试"];
    }
}

#pragma mark - KTOrderCancelRequest
- (void)cancelOrderOperation
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
    
    if (_cancelOrderID != nil && ![_cancelOrderID isEqualToString:@""]) {
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
                                                    andOrderID:_cancelOrderID];
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
                    [self performSelectorOnMainThread:@selector(deleteOrderRow) withObject:nil waitUntilDone:YES];
                    
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

- (void)deleteOrderRow
{
    for (NSInteger i = 0 ; i < self.listData.count; i++) {
        if ([[self.listData objectAtIndex:i] objectAtIndex:0] && [[[self.listData objectAtIndex:i] objectAtIndex:0] isKindOfClass:[OrderListVO class]]) {
            OrderListVO *vo = [[self.listData objectAtIndex:i] objectAtIndex:0];
            if ([_cancelOrderID isEqualToString:vo.order_id]) {
                [self loadFromPullToRefresh];
                break;
            }
        }
    }
    
    [stateHud hide:YES afterDelay:1.0];
    
    if (self.listData.count == 0) {
        self.statefulState = FTStatefulTableViewControllerStateEmpty;
    }
    
    [self performSelectorOnMainThread:@selector(updateWaitPayNum) withObject:nil waitUntilDone:YES];
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

-(void)updateWaitPayNum
{
    UITabBar *tabBar = self.tabBarController.tabBar;
    UITabBarItem *tabBarItem4 = [tabBar.items objectAtIndex:4];
    //未支付订单数量更新
    NSNumber *wntValue = [[kata_UserManager sharedUserManager] userWaitPayCnt];
    if ([wntValue intValue]>0) {
        [[kata_UserManager sharedUserManager] updateWaitPayCnt:[NSNumber numberWithInteger:[wntValue intValue] - 1]];
        [tabBarItem4 setBadgeValue:[NSString stringWithFormat:@"%zi",[wntValue intValue] - 1]];
    }
    else
    {
        [tabBarItem4 setBadgeValue:0];
    }
}

- (UIView *)emptyView
{
    UIView *view = [super emptyView];
    [view setBackgroundColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1]];
    
    CGFloat w = view.frame.size.width;
    CGFloat h = view.center.y;
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"orderlistempty"]];
    [image setFrame:CGRectMake((w - CGRectGetWidth(image.frame)) / 2, h - CGRectGetHeight(image.frame), CGRectGetWidth(image.frame), CGRectGetHeight(image.frame))];
    [view addSubview:image];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, h+10, w, 15)];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setTextColor:[UIColor colorWithRed:0.52 green:0.52 blue:0.52 alpha:1]];
    [lbl setFont:[UIFont systemFontOfSize:14.0]];
    [lbl setText:@"暂无订单信息"];
    [view addSubview:lbl];
    
    toHomeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [toHomeBtn setFrame:CGRectMake((w-w/3)/2, h + 40, w/3 , w/3/3)];
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
    [self.view addSubview:_headView];
    
    view.layer.zPosition=1;
    self.tableView.userInteractionEnabled=YES;
    UITapGestureRecognizer *tapgestrue = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toHomeBtnPressed)];
    tapgestrue.numberOfTapsRequired =1;
    [view addGestureRecognizer:tapgestrue];
    
    return view;
}

-(void)toHomeBtnPressed
{
    if (self.tabBarController == nil) {
        NSArray *viewControllers =[[[mytabController childViewControllers] objectAtIndex:0] childViewControllers];
        for (UIViewController *vc in viewControllers) {
            if ([vc isKindOfClass:[KTChannelViewController class]]) {
                [(KTChannelViewController *)vc selectedTabIndex:0];
            }
        }
        mytabController.selectedIndex = 0;
    }
    NSArray *viewControllers =[[[self.tabBarController childViewControllers] objectAtIndex:0] childViewControllers];
    for (UIViewController *vc in viewControllers) {
        if ([vc isKindOfClass:[KTChannelViewController class]]) {
            [(KTChannelViewController *)vc selectedTabIndex:0];
        }
    }
    self.tabBarController.selectedIndex = 0;
    if (self.tabBarController.selectedIndex == 0) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

//倒计时
-(void)compareTime
{
    for(NSArray *array in self.listData){
        OrderListVO *lvo = [array objectAtIndex:0];
        if ([lvo.time_diff integerValue] > 0) {
            lvo.time_diff = [NSNumber numberWithInteger:[lvo.time_diff integerValue]-1];
        }
    }
    [self.tableView reloadData];
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger tag = alertView.tag;
    if (tag == 3030) {
        if (buttonIndex == 0) {
            [self cancelOrderOperation];
        }
    }else if (tag == 3010){
        if (buttonIndex == 0) {
            [self checkOrderOperation];
        }
    }
}

- (void)orderBtnClick:(NSInteger)btnType andIndex:(NSIndexPath *)indexPath andEventVO:(OrderEventVO *)eventVO{
    NSInteger section = indexPath.section;
    
    NSDictionary *dict;
    kata_CashFailedViewController *payVC;
    LMHTrackViewController *trackViewController;
    if (self.listData.count > 0) {
        OrderListVO *lvo = [self.listData[section] objectAtIndex:0];
        _cancelOrderID = lvo.order_id;
        _orderPrice = [NSNumber numberWithDouble:[lvo.pay_amount doubleValue]];
        OrderEventVO *evo = [self.listData[section] objectAtIndex:1];
        _partID = [evo.partner_id integerValue];
        OrderGoodsVO *gvo = [self.listData[section] objectAtIndex:2];
        _productID = gvo.goods_id;
    
        dict = [NSDictionary dictionaryWithObjectsAndKeys:_orderPrice, @"money", _cancelOrderID, @"orderid", _productID, @"product_id", nil];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
    switch (btnType) {
            case 0://详情页删除订单
                [self cancelOrderOperation];
            break;
        case 1://提醒发货
            [self textStateHUD:@"已提醒卖家发货"];
            break;
        case 2://确认收货
            alert.title = @"确认收货";
            alert.message = @"是否确认收货？";
            alert.tag = 3010;
            
            [alert show];
            break;
        case 3://已完成订单删除
            alert.title = @"删除订单";
            alert.message = @"是否确定删除订单？";
            alert.tag = 3030;
            [alert show];
            break;
        case 4://支付订单
            if (![[kata_UserManager sharedUserManager] isLogin]) {
                [kata_LoginViewController showInViewController:self];
                return;
            }
            payVC = [[kata_CashFailedViewController alloc] initWithOrderInfo:dict andPay:NO andType:NO];
            payVC.navigationController = self.navigationController;
            
            [self.navigationController pushViewController:payVC animated:YES];
            break;
        case 5://取消订单删除
            alert.title = @"删除订单";
            alert.message = @"是否确定删除订单？";
            alert.tag = 3030;
            [alert show];
            break;
        case 15:
        {
            EvaluationTableViewController * eventVC = [[EvaluationTableViewController alloc] initWithOrderEventVO:eventVO];
            eventVC.navigationController = self.navigationController;
            eventVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:eventVC animated:YES];
        }
            break;
        case 13://退款完成订单删除
            alert.title = @"删除订单";
            alert.message = @"是否确定删除订单？";
            alert.tag = 3030;
            [alert show];
            break;
        case 99://查看物流
            trackViewController = [[LMHTrackViewController alloc] initWithStyle:UITableViewStylePlain];
            
            trackViewController.productIDStr = [_productID stringValue];
            trackViewController.orderIDStr   = _cancelOrderID;
            
            [self.navigationController pushViewController:trackViewController animated:YES];
        default:
            break;
    }
}

#pragma mark - LoginDelegate
- (void)didLogin{

}

- (void)loginCancel{

}

#pragma mark - KTOrderDetailProductTableViewCellDelegate
- (void)returnOrder:(OrderGoodsVO*)orderData{

}

- (void)writeOrder:(ReturnOrderDetailVO*)returnData{

}

@end
