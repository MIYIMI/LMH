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
    
    //头部信息
    UILabel *orderStateLbl;
    UIImageView *_clockImgView;
    UILabel *_backtimeLbl;
    
    //商家信息或品牌信息
    UILabel *_brandTitleLbl;
    
    //商品
    UIImageView * _iconView;
    UILabel * _nameLabel;
    UILabel * _optionsLabel;
    UILabel * _priceLabel;
    UILabel * _marketPriceLbl;
    UILabel * _marketLine;
    UILabel * _stockLbl;
    
    //底部
    UILabel *_moneydisLbl;
    UILabel *_moneyLbl;
    UIButton *_orderBtn;
    UIButton *_transBtn;
    UILabel *_grayLbl;
    
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
    
    if(_inPath.row == 0){
        CGFloat h = 30;
        _listVO = dataVO;

        if (!_unitView) {
            _unitView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, h)];
            _unitView.backgroundColor = LMH_COLOR_CELL;
            [self addSubview:_unitView];
        }
        
        if (!orderStateLbl) {
            orderStateLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, h)];
            [orderStateLbl setFont:LMH_FONT_14];
            [orderStateLbl setTextColor:LMH_COLOR_SKIN];
            [orderStateLbl setBackgroundColor:[UIColor clearColor]];
            [_unitView addSubview:orderStateLbl];
        }
        [orderStateLbl setText:_listVO.pay_status_name];
        
        if (!_clockImgView) {
            _clockImgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_unitView.frame)-120, 7.5, 15, 15)];
            [_clockImgView setImage:LOCAL_IMG(@"clock")];
            [_clockImgView setBackgroundColor:[UIColor clearColor]];
            [_unitView addSubview:_clockImgView];
        }
        
        if (!_backtimeLbl) {
            _backtimeLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(_unitView.frame)-100, 0, 90, h)];
            [_backtimeLbl setFont:LMH_FONT_13];
            [_backtimeLbl setBackgroundColor:[UIColor clearColor]];
            [_backtimeLbl setTextColor:LMH_COLOR_GRAY];
            [_backtimeLbl setTextAlignment:NSTextAlignmentRight];
            [_unitView addSubview:_backtimeLbl];
        }
        if ([_listVO.time_diff integerValue] > 0) {
            NSInteger hours = [_listVO.time_diff integerValue]/3600;
            NSInteger minus = [_listVO.time_diff integerValue]%3600/60;
            NSInteger sec = [_listVO.time_diff integerValue]%60;
            [_backtimeLbl setText:[NSString stringWithFormat:@"剩余 %0.2zi:%0.2zi:%0.2zi",hours,minus,sec]];
        }else{
            [_backtimeLbl setText:@"订单即将关闭"];
        }
        
        if ([_listVO.pay_status integerValue] != 4) {
            _clockImgView.hidden = YES;
            _backtimeLbl.hidden = YES;
        }else{
            _clockImgView.hidden = NO;
            _backtimeLbl.hidden = NO;
        }
    }else if ([dataVO isKindOfClass:[OrderEventVO class]]) {
        CGFloat h = 30;
        
        _evenVO = dataVO;
        if (!_unitView) {
            _unitView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, h)];
            _unitView.backgroundColor = [UIColor whiteColor];
            [self addSubview:_unitView];
        }
        
        if (!_brandTitleLbl) {
            _brandTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(_unitView.frame)-90, h)];
            [_brandTitleLbl setBackgroundColor:[UIColor clearColor]];
            [_brandTitleLbl setTextColor:LMH_COLOR_GRAY];
            [_brandTitleLbl setFont:LMH_FONT_13];
            [_unitView addSubview:_brandTitleLbl];
        }
        [_brandTitleLbl setText:_evenVO.event_name];
        
        if (!_toplineLbl) {
            _toplineLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenW-20, 1)];
            [_toplineLbl setBackgroundColor:LMH_COLOR_CELL];
            [_unitView addSubview:_toplineLbl];
        }
        
        if (!_botlineLbl) {
            _botlineLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, h-1, ScreenW-20, 1)];
            [_botlineLbl setBackgroundColor:LMH_COLOR_CELL];
            [_unitView addSubview:_botlineLbl];
        }
        
    }else if([dataVO isKindOfClass:[OrderGoodsVO class]]){
        CGFloat h = ScreenW*0.25;
        _goodsVO = dataVO;
        if (!_unitView) {
            _unitView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, h)];
            _unitView.backgroundColor = [UIColor whiteColor];
            [self addSubview:_unitView];
        }
        
        if (!_iconView) {
            _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, ScreenW*0.2, ScreenW*0.2)];
            [_iconView setBackgroundColor:[UIColor clearColor]];
            [_unitView addSubview:_iconView];
        }
        
        if (!_nameLabel) {
            _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconView.frame)+10, 8, CGRectGetWidth(_unitView.frame)-CGRectGetMaxX(_iconView.frame)-50, 32)];
            [_nameLabel setTextColor:[UIColor colorWithRed:0.23 green:0.23 blue:0.23 alpha:1]];
            [_nameLabel setFont:LMH_FONT_12];
            _nameLabel.numberOfLines = 2;
            _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            [_unitView addSubview:_nameLabel];
        }
        
        if (!_optionsLabel) {
            _optionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_nameLabel.frame), CGRectGetMaxY(_nameLabel.frame), CGRectGetWidth(_nameLabel.frame), 20)];
            [_optionsLabel setTextColor:LMH_COLOR_LIGHTGRAY];
            [_optionsLabel setFont:LMH_FONT_11];
            _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            [_unitView addSubview:_optionsLabel];
        }
        
        if (!_priceLabel) {
            _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_nameLabel.frame), CGRectGetMaxY(_iconView.frame)-15, CGRectGetWidth(_nameLabel.frame)/3, 20)];
            [_priceLabel setTextColor:LMH_COLOR_SKIN];
            [_priceLabel setFont:LMH_FONT_11];
            [_unitView addSubview:_priceLabel];
        }
        
        if (!_marketPriceLbl) {
            _marketPriceLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_priceLabel.frame)+5, CGRectGetMinY(_priceLabel.frame), CGRectGetWidth(_priceLabel.frame), 20)];
            [_marketPriceLbl setTextColor:LMH_COLOR_LIGHTGRAY];
            [_marketPriceLbl setFont:LMH_FONT_10];
            [_unitView addSubview:_marketPriceLbl];
        }
        
        if(!_marketLine){
            _marketLine = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_marketPriceLbl.frame)/2, 10, 1)];
            [_marketLine setBackgroundColor:LMH_COLOR_LIGHTGRAY];
            [_marketPriceLbl addSubview:_marketLine];
        }
        
        if (!_stockLbl) {
            _stockLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(_unitView.frame)-70, (CGRectGetHeight(_unitView.frame)-20)/2, 60, 20)];
            [_stockLbl setTextColor:LMH_COLOR_LIGHTGRAY];
            [_stockLbl setFont:LMH_FONT_11];
            _stockLbl.backgroundColor = [UIColor clearColor];
            [_stockLbl setTextAlignment:NSTextAlignmentRight];
            [_unitView addSubview:_stockLbl];
        }
        
        [self fill_GoodUI];
    }else if(_inPath.row == -1){
        CGFloat h = 40;
        _listVO = dataVO;
        
        if (!_unitView) {
            _unitView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, h)];
            _unitView.backgroundColor = [UIColor whiteColor];
            [self addSubview:_unitView];
        }
        
        if (!_moneydisLbl) {
            _moneydisLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 70, h)];
            [_moneydisLbl setFont:LMH_FONT_15];
            [_moneydisLbl setTextColor:LMH_COLOR_BLACK];
            [_moneydisLbl setText:@"总  计: "];
            [_unitView addSubview:_moneydisLbl];
        }
        
        if (!_moneyLbl) {
            _moneyLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_moneydisLbl.frame)+2, 0, 70, h)];
            [_moneyLbl setFont:LMH_FONT_14];
            [_moneyLbl setTextColor:LMH_COLOR_SKIN];
            [_unitView addSubview:_moneyLbl];
        }
        
        if (!_orderBtn) {
            _orderBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW-70, 7.5, 60, 25)];
            [_orderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_orderBtn.titleLabel setFont:LMH_FONT_13];
            _orderBtn.layer.cornerRadius = 2.0;
            _orderBtn.layer.borderWidth = 0.5;
            _orderBtn.layer.borderColor = [LMH_COLOR_LINE CGColor];
            [_unitView addSubview:_orderBtn];
        }
        
        if (!_transBtn) {
            _transBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW-140, 7.5, 60, 25)];
            [_transBtn setTitleColor:LMH_COLOR_GRAY forState:UIControlStateNormal];
            [_transBtn.titleLabel setFont:LMH_FONT_13];
            [_transBtn setBackgroundColor:[UIColor whiteColor]];
            _transBtn.layer.cornerRadius = 2.0;
            _transBtn.layer.borderWidth = 0.5;
            _transBtn.layer.borderColor = [LMH_COLOR_LINE CGColor];
            [_transBtn setTitle:@"查看物流" forState:UIControlStateNormal];
            [_transBtn setTitleColor:LMH_COLOR_LIGHTGRAY forState:UIControlStateNormal];
            [_transBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            _transBtn.tag = 1099;
            [_unitView addSubview:_transBtn];
        }
    
        [self fill_BootUI];
    }
}
             
- (void)fill_GoodUI{
    if (_goodsVO) {
        _unitView.hidden = NO;
        _iconView.hidden = NO;
        _nameLabel.hidden = NO;
        _optionsLabel.hidden = NO;
        _priceLabel.hidden = NO;
        _marketPriceLbl.hidden = NO;
        _marketLine.hidden = NO;
        _stockLbl.hidden = NO;
        
        [_iconView sd_setImageWithURL:[NSURL URLWithString:_goodsVO.image] placeholderImage:LOCAL_IMG(@"logoph")];
        [_nameLabel setText:_goodsVO.goods_title];
        
        NSString *optionStr = @"";
        if (_goodsVO.goods_iguige_label) {
            optionStr = [optionStr stringByAppendingString:_goodsVO.goods_iguige_label];
            if (_goodsVO.goods_iguige_label.length > 0) {
                optionStr = [optionStr stringByAppendingString:@":"];
            }
        }
        if (_goodsVO.goods_iguige_value) {
            optionStr = [optionStr stringByAppendingString:_goodsVO.goods_iguige_value];
            if (_goodsVO.goods_iguige_value.length > 0) {
                optionStr = [optionStr stringByAppendingString:@"  "];
            }
        }
        if (_goodsVO.goods_guige_label) {
            optionStr = [optionStr stringByAppendingString:_goodsVO.goods_guige_label];
            if (_goodsVO.goods_guige_label.length > 0) {
                optionStr = [optionStr stringByAppendingString:@":"];
            }
        }
        if (_goodsVO.goods_guige_value) {
            optionStr = [optionStr stringByAppendingString:_goodsVO.goods_guige_value];
        }
        [_optionsLabel setText:optionStr];

        [_priceLabel setText:[NSString stringWithFormat:@"¥%0.2f",[_goodsVO.sales_price floatValue]]];
        
        [_marketPriceLbl setText:[NSString stringWithFormat:@"¥%0.2f",[_goodsVO.market_price floatValue]]];
        CGRect frame = _marketLine.frame;
        CGSize priceSize = [_marketPriceLbl.text sizeWithFont:_marketPriceLbl.font constrainedToSize:CGSizeMake(50, 20)];
        frame.size.width = priceSize.width;
        _marketLine.frame = frame;
        
        [_stockLbl setText:[NSString stringWithFormat:@"共%@件",_goodsVO.quantity]];
    }else{
        _unitView.hidden = YES;
        _iconView.hidden = YES;
        _nameLabel.hidden = YES;
        _optionsLabel.hidden = YES;
        _priceLabel.hidden = YES;
        _marketPriceLbl.hidden = YES;
        _marketLine.hidden = YES;
        _stockLbl.hidden = YES;
    }
}

- (void)fill_BootUI{
    if (_listVO) {
        _unitView.hidden = NO;
        _clockImgView.hidden = NO;
        _backtimeLbl.hidden = NO;
        _moneydisLbl.hidden = NO;
        _moneyLbl.hidden = NO;
        _transBtn.hidden = NO;
        _orderBtn.hidden = NO;
    
        [_moneyLbl setText:[NSString stringWithFormat:@"¥%0.2f", [_listVO.pay_amount floatValue]]];
        [_orderBtn setBackgroundColor:[UIColor whiteColor]];
        _orderBtn.layer.borderColor = [[UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1] CGColor];
        [_orderBtn setTitleColor:TEXTCOLOR forState:UIControlStateNormal];
        _moneydisLbl.text = @"总  计: ";

        _orderBtn.layer.borderWidth = 1.0;
        switch ([_listVO.pay_status integerValue]) {
            case 0:
                _transBtn.hidden = YES;
                _clockImgView.hidden = YES;
                _backtimeLbl.hidden = YES;
                _orderBtn.hidden = YES;
                break;
            case 1://待发货
                _transBtn.hidden = YES;
                _clockImgView.hidden = YES;
                _backtimeLbl.hidden = YES;
                [_orderBtn setTitle:@"提醒发货" forState:UIControlStateNormal];
                break;
            case 2://待收货
                _clockImgView.hidden = YES;
                _backtimeLbl.hidden = YES;
                [_orderBtn setTitle:@"确认收货" forState:UIControlStateNormal];
                
                break;
            case 3://交易完成
                _transBtn.hidden = YES;
                _clockImgView.hidden = YES;
                _backtimeLbl.hidden = YES;
                _orderBtn.hidden = YES;
                break;
            case 4://待付款
                _transBtn.hidden = YES;
                [_backtimeLbl setText:_listVO.pay_at];
                [_orderBtn setTitle:@"立即付款" forState:UIControlStateNormal];
                [_orderBtn setBackgroundColor:ALL_COLOR];
                _orderBtn.layer.borderColor = [STATECOLOR CGColor];
                [_orderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                break;
            case 5://取消订单删除
                _transBtn.hidden = YES;
                _clockImgView.hidden = YES;
                _backtimeLbl.hidden = YES;
                _orderBtn.hidden = YES;
                break;
            case 6://退款订单
                _transBtn.hidden = YES;
                _clockImgView.hidden = YES;
                _backtimeLbl.hidden = YES;
                _orderBtn.hidden = YES;
//                [_orderBtn setTitle:@"退款进度" forState:UIControlStateNormal];
                break;
            case 7://换货订单
                _transBtn.hidden = YES;
                _clockImgView.hidden = YES;
                _backtimeLbl.hidden = YES;
                _orderBtn.hidden = YES;
                //[_orderBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                break;
            case 8://取消售后
                _transBtn.hidden = YES;
                _clockImgView.hidden = YES;
                _backtimeLbl.hidden = YES;
                _orderBtn.hidden = YES;
                //[_orderBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                break;
            case 9://待确定售后
                _transBtn.hidden = YES;
                _clockImgView.hidden = YES;
                _backtimeLbl.hidden = YES;
                _orderBtn.hidden = YES;
                [_orderBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                break;
            case 10://待上传快递单号
                _transBtn.hidden = YES;
                _clockImgView.hidden = YES;
                _backtimeLbl.hidden = YES;
                _orderBtn.hidden = YES;
//                [_orderBtn setTitle:@"退款进度" forState:UIControlStateNormal];
                break;
            case 11://待商家收货
                _transBtn.hidden = YES;
                _clockImgView.hidden = YES;
                _backtimeLbl.hidden = YES;
                _orderBtn.hidden = YES;
//                [_orderBtn setTitle:@"退款进度" forState:UIControlStateNormal];
                break;
            case 12://退款中订单
                _transBtn.hidden = YES;
                _clockImgView.hidden = YES;
                _backtimeLbl.hidden = YES;
                _orderBtn.hidden = YES;
//                [_orderBtn setTitle:@"退款进度" forState:UIControlStateNormal];
                _moneydisLbl.text = @"退款金额: ";
                [_moneyLbl setText:[NSString stringWithFormat:@"￥%0.2f", [_listVO.refund_money floatValue]]];
                break;
            case 13://退款完成订单
                _transBtn.hidden = YES;
                _clockImgView.hidden = YES;
                _backtimeLbl.hidden = YES;
                _orderBtn.hidden = YES;
                _moneydisLbl.text = @"退款金额: ";
                [_moneyLbl setText:[NSString stringWithFormat:@"￥%0.2f", [_listVO.refund_money floatValue]]];
                break;
            case 14://已评价
                _transBtn.hidden = YES;
                _clockImgView.hidden = YES;
                _backtimeLbl.hidden = YES;
                _orderBtn.hidden = YES;
                break;
            case 15://待评价
                _transBtn.hidden = YES;
                _clockImgView.hidden = YES;
                _backtimeLbl.hidden = YES;
                _orderBtn.hidden = NO;
                [_orderBtn setTitle:@"立即评价" forState:UIControlStateNormal];
                break;
            case 16://未知
                _transBtn.hidden = YES;
                _clockImgView.hidden = YES;
                _backtimeLbl.hidden = YES;
                _orderBtn.hidden = YES;
                break;
            default:
                _transBtn.hidden = YES;
                _clockImgView.hidden = YES;
                _backtimeLbl.hidden = YES;
                _orderBtn.hidden = YES;
                break;
        }
        _orderBtn.tag = 1000 + [_listVO.pay_status integerValue];
        [_orderBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        _unitView.hidden = YES;
        _clockImgView.hidden = YES;
        _backtimeLbl.hidden = YES;
        _moneydisLbl.hidden = YES;
        _moneyLbl.hidden = YES;
        _transBtn.hidden = YES;
        _orderBtn.hidden = YES;
    }
}


- (void)clickBtn:(UIButton *)sender{
    NSInteger tag = sender.tag - 1000;
    switch (tag) {
        case 1://提醒发货
            tag = 1;
            break;
        case 2://确认收货
            tag = 2;
            break;
        case 3://已完成订单删除
            tag = 3;
            break;
        case 4://支付订单
            tag = 4;
            break;
        case 5://取消订单删除
            tag = 5;
            break;
        case 6://退款订单
            tag = 6;
            break;
        case 15://评价订单
            tag = 15;
            break;
        case 99:
            tag = 99;
            break;
        default:
            break;
    }
    
    if ([self.delegate respondsToSelector:@selector(orderBtnClick:andIndex:andEventVO:)]) {
        [self.delegate orderBtnClick:tag andIndex:_inPath andEventVO:_listVO.event[0]];
    }
}

@end
