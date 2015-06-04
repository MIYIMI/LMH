//
//  KTOrderTableViewCell.m
//  YingMeiHui
//
//  Created by work on 14-11-27.
//  Copyright (c) 2014年 xieyanke. All rights reserved.
//

#import "KTOrderTableViewCell.h"
#import "OrderListVO.h"
#import "UIImageView+WebCache.h"

#define TEXTCOLOR [UIColor colorWithRed:0.53 green:0.55 blue:0.56 alpha:1]
#define LINECOLOR [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1]
#define STATECOLOR [UIColor colorWithRed:0.98 green:0.38 blue:0.47 alpha:1]

@interface KTOrderTableViewCell()
{
    UIView *_unitView;
    UILabel *_toplineLbl;
    UILabel *_botlineLbl;
    UILabel *_goodlineLbl;
    
    //商家信息或品牌信息
    UILabel *_brandTitleLbl;
    
    //底部
    UILabel *_backtimeLbl;
    UILabel *_moneydisLbl;
    UILabel *_moneyLbl;
    UIButton *_orderBtn;
    UIButton *_transBtn;
    UILabel *_grayLbl;
    UILabel *freight;
    UILabel *countLbl;
    
    //数据类型
    OrderEventVO *_evenVO;
    OrderListVO *_listVO;
    OrderGoodsVO *_goodsVO;
    
    NSIndexPath *_inPath;
}

@end

@implementation KTOrderTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    
    return self;
}

- (void)layoutUI:(id)dataVO andIndex:(NSIndexPath *)indexPath{
    self.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    _inPath = indexPath;

    if ([dataVO isKindOfClass:[OrderEventVO class]]) {//专场信息
        CGFloat h = 30;
        _evenVO = dataVO;
        if (!_unitView) {
            _unitView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, h)];
            _unitView.backgroundColor = [UIColor whiteColor];
            [self addSubview:_unitView];
        }
        
        //专场标题
        if (!_brandTitleLbl) {
            _brandTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(_unitView.frame)-90, h)];
            [_brandTitleLbl setBackgroundColor:[UIColor clearColor]];
            [_brandTitleLbl setTextColor:LMH_COLOR_GRAY];
            [_brandTitleLbl setFont:LMH_FONT_13];
            [_unitView addSubview:_brandTitleLbl];
        }
        [_brandTitleLbl setText:_evenVO.event_name];
        NSString *moneyStr = _evenVO.event_name;
        [_brandTitleLbl performSelectorOnMainThread:@selector(setText:) withObject:moneyStr waitUntilDone:YES];
        CGSize size = [moneyStr sizeWithFont:_brandTitleLbl.font constrainedToSize:CGSizeMake(MAXFLOAT, _brandTitleLbl.frame.size.height)];
        _brandTitleLbl.frame = CGRectMake(10, 0, size.width, h);
        
        //上边线
        if (!_toplineLbl) {
            _toplineLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenW-20, 0.5)];
            [_toplineLbl setBackgroundColor:LMH_COLOR_BACK];
            [_unitView addSubview:_toplineLbl];
        }
        
        //底边线
        if (!_botlineLbl) {
            _botlineLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, h-1, ScreenW-20, 0.5)];
            [_botlineLbl setBackgroundColor:LMH_COLOR_BACK];
            [_unitView addSubview:_botlineLbl];
        }
    }else if(_inPath.row == -1){//底部信息
        _listVO = dataVO;
        CGFloat h;
        
        //主订单状态：1 - 代付款  2 - 已付款  3 - 确认收货  4 - 删除订单
        if ([_listVO.pay_status integerValue] == 1 || [_listVO.pay_status integerValue] == 3 || [_listVO.pay_status integerValue] == 4) {
            h = 70;
        } else {
            h = 30;
        }
        
        if (!_unitView) {
            _unitView = [[UIView alloc] initWithFrame:CGRectNull];
            _unitView.backgroundColor = [UIColor whiteColor];
            [self addSubview:_unitView];
            
            UIView *aview = [[UIView alloc] initWithFrame:CGRectMake(10, 0, ScreenW-20, 0.5)];
            [aview setBackgroundColor:LMH_COLOR_BACK];
            [_unitView addSubview:aview];
            
            UIView *bview = [[UIView alloc] initWithFrame:CGRectMake(10, 30, ScreenW-20, 0.5)];
            [bview setBackgroundColor:LMH_COLOR_BACK];
            [_unitView addSubview:bview];
        }
        _unitView.frame = CGRectMake(0, 0, ScreenW, h);
        
        //订单金额
        if (!_moneyLbl) {
            _moneyLbl = [[UILabel alloc] initWithFrame:CGRectNull];
            [_moneyLbl setFont:[UIFont boldSystemFontOfSize:16.0f]];
            [_moneyLbl setTextColor:LMH_COLOR_SKIN];
            [_unitView addSubview:_moneyLbl];
        }
        if (!_moneydisLbl) {
            _moneydisLbl = [[UILabel alloc] initWithFrame:CGRectNull];
            [_moneydisLbl setFont:LMH_FONT_13];
            [_moneydisLbl setTextColor:LMH_COLOR_BLACK];
            [_moneydisLbl setText:@"总计:"];
            [_unitView addSubview:_moneydisLbl];
        }
        
        //订单运费
        if (!freight) {
            freight = [[UILabel alloc] initWithFrame:CGRectNull];
            [freight setFont:LMH_FONT_13];
            [freight setTextColor:LMH_COLOR_BLACK];
            [_unitView addSubview:freight];
        }
        
        //订单商品件数
        if (!countLbl) {
            countLbl = [[UILabel alloc] initWithFrame:CGRectNull];
            [countLbl setFont:LMH_FONT_13];
            [countLbl setTextColor:LMH_COLOR_BLACK];
            [_unitView addSubview:countLbl];
        }
        
        //主订单操作按钮
        if (!_orderBtn) {
            _orderBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW-70, 37.5, 60, 25)];
            [_orderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_orderBtn.titleLabel setFont:LMH_FONT_13];
            _orderBtn.layer.cornerRadius = 2.0;
            _orderBtn.layer.borderWidth = 0.5;
            _orderBtn.layer.borderColor = [LMH_COLOR_LINE CGColor];
            
            [_unitView addSubview:_orderBtn];
        }
        
        //代付款订单剩余支付时间
        if (!_backtimeLbl) {
            _backtimeLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 80, 40)];
            [_backtimeLbl setFont:LMH_FONT_13];
            [_backtimeLbl setTextColor:LMH_COLOR_SKIN];
            [_backtimeLbl setTextAlignment:NSTextAlignmentLeft];
            [_unitView addSubview:_backtimeLbl];
        }
        if ([_listVO.time_diff integerValue] > 0) {
            NSInteger hours = [_listVO.time_diff integerValue]/3600;
            NSInteger minus = [_listVO.time_diff integerValue]%3600/60;
            NSInteger sec = [_listVO.time_diff integerValue]%60;
            [_backtimeLbl setText:[NSString stringWithFormat:@"剩%0.2zi:%0.2zi:%0.2zi",hours,minus,sec]];
        }else{
            [_backtimeLbl setText:@"订单即将关闭"];
        }
        
        //待付款订单显示订单剩余支付时间
        if ([_listVO.pay_status integerValue] != 1) {
            _backtimeLbl.hidden = YES;
        }else{
            _backtimeLbl.hidden = NO;
        }
        
        //取消订单按钮
        if (!_transBtn) {
            _transBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW-140, 37.5, 60, 25)];
            [_transBtn setTitleColor:LMH_COLOR_GRAY forState:UIControlStateNormal];
            [_transBtn.titleLabel setFont:LMH_FONT_13];
            [_transBtn setBackgroundColor:[UIColor whiteColor]];
            _transBtn.layer.cornerRadius = 2.0;
            _transBtn.layer.borderWidth = 0.5;
            _transBtn.layer.borderColor = [LMH_COLOR_LINE CGColor];
            [_transBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [_transBtn setTitleColor:LMH_COLOR_LIGHTGRAY forState:UIControlStateNormal];
            [_transBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            _transBtn.tag = 1003;
            [_unitView addSubview:_transBtn];
        }
        
        //填充底部视图内容及确定视图位置
        [self fill_BootUI];
    }
}

- (void)fill_BootUI{
    if (_listVO) {
        _unitView.hidden = NO;
        _transBtn.hidden = YES;
        _orderBtn.hidden = YES;
        
        //显示订单金额
        NSString *moneyStr = [NSString stringWithFormat:@"¥%0.2f", [_listVO.pay_amount floatValue]];
        [_moneyLbl performSelectorOnMainThread:@selector(setText:) withObject:moneyStr waitUntilDone:YES];
        CGSize size = [moneyStr sizeWithFont:_moneyLbl.font constrainedToSize:CGSizeMake(MAXFLOAT, _moneyLbl.frame.size.height)];
        _moneyLbl.frame = CGRectMake(ScreenW - 10 - size.width, 0, size.width, 30);
        [_moneyLbl setText:[NSString stringWithFormat:@"¥%0.2f", [_listVO.pay_amount floatValue]]];
        _moneydisLbl.frame = CGRectMake(ScreenW - 42 - size.width, 0, 32, 30);
        
        //显示订单运费
        NSString *freightstr = [NSString stringWithFormat:@"运费:%@", _listVO.pay_freight];
        freight.text = freightstr;
        [freight performSelectorOnMainThread:@selector(setText:) withObject:freightstr waitUntilDone:YES];
        CGSize freightsize = [freightstr sizeWithFont:freight.font constrainedToSize:CGSizeMake(MAXFLOAT, freight.frame.size.height)];
        freight.frame = CGRectMake(CGRectGetMinX(_moneydisLbl.frame) - freightsize.width - 5, 0, freightsize.width, 30);
        
        //显示订单商品件数
        NSString *countstr = [NSString stringWithFormat:@"共%zi件商品", [_listVO.goods_total integerValue]];
        [countLbl performSelectorOnMainThread:@selector(setText:) withObject:countstr waitUntilDone:YES];
        CGSize countsize = [countstr sizeWithFont:countLbl.font constrainedToSize:CGSizeMake(MAXFLOAT, countLbl.frame.size.height)];
        countLbl.frame = CGRectMake(CGRectGetMinX(freight.frame) - countsize.width - 5, 0, countsize.width, 30);
        
        //退款订单列表改变底部UI
        if ([_listVO.pay_status integerValue] >= 8 && [_listVO.pay_status integerValue] <= 13) {
            freight.hidden = YES;
            countLbl.hidden = YES;
            [_moneydisLbl setText:@"退款金额:"];
            _moneydisLbl.frame = CGRectMake(10, 0, 60, 30);
            _moneyLbl.frame = CGRectMake(CGRectGetMaxX(_moneydisLbl.frame), 0, size.width, 30);
        }
        
        //根据数据属性改变按钮属性
        _orderBtn.layer.borderWidth = 1.0;
        if ([_listVO.pay_status integerValue] == 1) {//待付款
            _orderBtn.hidden = NO;
            _transBtn.hidden = NO;
            [_orderBtn setTitle:@"立即付款" forState:UIControlStateNormal];
            [_orderBtn setBackgroundColor:ALL_COLOR];
            _orderBtn.layer.borderColor = [STATECOLOR CGColor];
            [_orderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _orderBtn.tag = 1001;
            [_orderBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        }else if ([_listVO.pay_status integerValue] == 3) {//待收货
            _orderBtn.hidden = NO;
            [_orderBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            [_orderBtn setBackgroundColor:ALL_COLOR];
            _orderBtn.layer.borderColor = [STATECOLOR CGColor];
            [_orderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _orderBtn.tag = 1002;
            [_orderBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        }else if([_listVO.pay_status integerValue] == 4){//删除订单
            _orderBtn.hidden = NO;
            [_orderBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            [_orderBtn setBackgroundColor:ALL_COLOR];
            _orderBtn.layer.borderColor = [STATECOLOR CGColor];
            [_orderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _orderBtn.tag = 1004;
            [_orderBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

//主订单按钮代理事件
- (void)clickBtn:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(btnVO:andTag:)]) {
        [self.delegate btnVO:_listVO andTag:sender.tag-1000];
    }
}

@end
