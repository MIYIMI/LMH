//
//  KTOrderDetailProductTableViewCell.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-19.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTOrderDetailProductTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "OrderListVO.h"
#import "ReturnOrderDetailVO.h"

#define BACKGROUND_COLOR            [UIColor whiteColor]

@interface KTOrderDetailProductTableViewCell ()
{
    UIImageView *_productImgView;
    UILabel *_productNameLbl;
    UILabel *_propLbl;
    UILabel *_countLbl;
    UILabel *_salesLbl;
    UILabel *_markLbl;
    UIButton *stateBtn;
    UIButton *writeBtn;
    UILabel *_marketLine;
    UILabel *lineLbl;
    
    OrderGoodsVO *_ItemData;
    ReturnOrderDetailVO *_detailData;
    NSInteger _type;
}

@end

@implementation KTOrderDetailProductTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:BACKGROUND_COLOR];
        [[self contentView] setBackgroundColor:BACKGROUND_COLOR];
    }
    return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark init view
////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setItemData:(OrderGoodsVO *)ItemData andReturnData:(ReturnOrderDetailVO *)returnData andType:(NSInteger)type
{
    _ItemData = ItemData;
    _detailData = returnData;
    _type = type;
    CGFloat h = ScreenW*0.25;
    
    self.backgroundColor = [UIColor whiteColor];
    if (_ItemData) {
        CGFloat w = CGRectGetWidth([[UIScreen mainScreen] bounds]);
        
        if (!_productImgView) {
            _productImgView = [[UIImageView alloc] initWithFrame:CGRectMake(12, (h-ScreenW*0.2)/2, ScreenW*0.2, ScreenW*0.2)];
            _productImgView.contentMode = UIViewContentModeScaleAspectFill;
            _productImgView.clipsToBounds = YES;
            [self addSubview:_productImgView];
        }
        
        if (_ItemData.image) {
            NSString * imgUrlStr = [_ItemData image];
            [_productImgView sd_setImageWithURL:[NSURL URLWithString:imgUrlStr] placeholderImage:[UIImage imageNamed:@"productph"]];
        }
        
        if (!_productNameLbl) {
            _productNameLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            _productNameLbl.backgroundColor = [UIColor clearColor];
            _productNameLbl.font = LMH_FONT_12;
            _productNameLbl.textColor = LMH_COLOR_GRAY;
            _productNameLbl.textAlignment = NSTextAlignmentLeft;
            _productNameLbl.lineBreakMode = NSLineBreakByTruncatingTail;
            _productNameLbl.numberOfLines = 2;
            [self addSubview:_productNameLbl];
            
        }
        
        CGSize titleSize = [_ItemData.goods_title sizeWithFont:LMH_FONT_12 constrainedToSize:CGSizeMake(ScreenW - CGRectGetMaxX(_productImgView.frame) - 80, 30) lineBreakMode:NSLineBreakByWordWrapping];
        if (_ItemData.goods_title) {
            [_productNameLbl setText:[_ItemData goods_title]];
            
            _productNameLbl.frame = CGRectMake(CGRectGetMaxX(_productImgView.frame) + 10, CGRectGetMinY(_productImgView.frame), ScreenW - CGRectGetMaxX(_productImgView.frame) - 80, titleSize.height>=28?30:15);
        }
        
        if (!_propLbl) {
            _propLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            _propLbl.backgroundColor = [UIColor clearColor];
            _propLbl.font = LMH_FONT_11;
            _propLbl.textColor = LMH_COLOR_LIGHTGRAY;
            _propLbl.textAlignment = NSTextAlignmentLeft;
            _propLbl.lineBreakMode = NSLineBreakByTruncatingTail;
            _propLbl.numberOfLines = 1;
            
            [self addSubview:_propLbl];
        }
        
        _propLbl.frame = CGRectMake(CGRectGetMaxX(_productImgView.frame) + 10, CGRectGetMaxY(_productNameLbl.frame)+ (titleSize.height>=15?ScreenW*0.015:ScreenW*0.045), w - CGRectGetMaxX(_productImgView.frame) - 100, 15);
        
        NSString *propStr = @"";
        if (_ItemData.goods_iguige_label && ![_ItemData.goods_iguige_label isEqualToString:@""] && _ItemData.goods_iguige_value && ![_ItemData.goods_iguige_value isEqualToString:@""]) {
            propStr = [propStr stringByAppendingFormat:@"%@：",_ItemData.goods_iguige_label];
            propStr = [propStr stringByAppendingFormat:@"%@ ",_ItemData.goods_iguige_value];
        }
        
         if (_ItemData.goods_guige_label && ![_ItemData.goods_guige_label isEqualToString:@""] && _ItemData.goods_guige_value && ![_ItemData.goods_guige_value isEqualToString:@""]) {
             propStr = [propStr stringByAppendingFormat:@"%@：",_ItemData.goods_guige_label];
             propStr = [propStr stringByAppendingString:_ItemData.goods_guige_value];
        }
        _propLbl.text = propStr;
        
        if(!_countLbl){
            _countLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            [_countLbl setTextColor:LMH_COLOR_LIGHTGRAY];
            [_countLbl setFont:LMH_FONT_12];
            [self addSubview:_countLbl];
        }
        _countLbl.frame = CGRectMake(CGRectGetMaxX(_productImgView.frame)+10, CGRectGetMaxY(_propLbl.frame), 60, 15);
        
        if (_ItemData.quantity) {
            [_countLbl setText:[NSString stringWithFormat:@"x %@件",_ItemData.quantity]];
        }
        
        if (!_salesLbl) {
            _salesLbl = [[UILabel alloc] initWithFrame:CGRectMake(ScreenW - 70, CGRectGetMinY(_productImgView.frame), 60, 15)];
            _salesLbl.backgroundColor = [UIColor clearColor];
            _salesLbl.font = LMH_FONT_13;
            _salesLbl.textColor = LMH_COLOR_GRAY;
            _salesLbl.textAlignment = NSTextAlignmentRight;
            [self addSubview:_salesLbl];
        }
        
        if (_ItemData.sales_price) {
            NSString *sales_price;
            CGFloat able = [_ItemData.sales_price floatValue];
            if ((able * 10) - (int)(able * 10) > 0) {
                sales_price = [NSString stringWithFormat:@"¥%0.2f",[_ItemData.sales_price floatValue]];
            } else if(able - (int)able > 0) {
                sales_price = [NSString stringWithFormat:@"¥%0.1f",[_ItemData.sales_price floatValue]];
            } else {
                sales_price = [NSString stringWithFormat:@"¥%0.0f",[_ItemData.sales_price floatValue]];
            }
            [_salesLbl setText:sales_price];
        }
        
        if (!_markLbl) {
            _markLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_salesLbl.frame), CGRectGetMaxY(_salesLbl.frame), 60, 15)];
            _markLbl.backgroundColor = [UIColor clearColor];
            _markLbl.font = LMH_FONT_11;
            _markLbl.textColor = LMH_COLOR_LIGHTGRAY;
            _markLbl.textAlignment = NSTextAlignmentRight;
            [self addSubview:_markLbl];
        }
        
        if(!_marketLine){
            _marketLine = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_markLbl.frame)/2, 10, 1)];
            [_marketLine setBackgroundColor:LMH_COLOR_LIGHTGRAY];
            [_markLbl addSubview:_marketLine];
        }
        
        if (_ItemData.market_price) {
            if ((NSInteger)([_ItemData.market_price floatValue] * 100) % 100 == 0) {
                [_markLbl setText:[NSString stringWithFormat:@"￥%.0f", [_ItemData.market_price floatValue]]];
            } else {
                NSString *market_price;
                CGFloat afloat = [_ItemData.market_price floatValue];
                if ((afloat * 10) - (int)(afloat * 10) > 0) {
                    market_price = [NSString stringWithFormat:@"¥%0.2f",[_ItemData.market_price floatValue]];
                } else if(afloat - (int)afloat > 0) {
                    market_price = [NSString stringWithFormat:@"¥%0.1f",[_ItemData.market_price floatValue]];
                } else {
                    market_price = [NSString stringWithFormat:@"¥%0.0f",[_ItemData.market_price floatValue]];
                }
                [_markLbl setText:market_price];
            }
        }
    
        CGRect frame = _marketLine.frame;
        CGSize priceSize = [_markLbl.text sizeWithFont:_markLbl.font constrainedToSize:CGSizeMake(50, 20)];
        frame.size.width = priceSize.width;
        frame.origin.x = CGRectGetWidth(_markLbl.frame)-frame.size.width;
        _marketLine.frame = frame;
        
        if (!stateBtn && _type) {
            stateBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW-80, h - 32.5, 70, 25)];
            [stateBtn setTitleColor:LMH_COLOR_GRAY forState:UIControlStateNormal];
            [stateBtn.titleLabel setFont:LMH_FONT_13];
            [stateBtn.layer setBorderWidth:0.5];
            [stateBtn.layer setBorderColor:[LMH_COLOR_LINE CGColor]];
            [stateBtn.layer setCornerRadius:5.0];
            [stateBtn addTarget:self action:@selector(returnClick) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:stateBtn];
        }
        
        if (!writeBtn && _type) {
            writeBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW-165, h - 32.5, 80, 25)];
            [writeBtn setTitleColor:LMH_COLOR_GRAY forState:UIControlStateNormal];
            [writeBtn.titleLabel setFont:LMH_FONT_13];
            [writeBtn.layer setBorderWidth:0.5];
            [writeBtn.layer setBorderColor:[LMH_COLOR_LINE CGColor]];
            [writeBtn.layer setCornerRadius:5.0];
            [writeBtn addTarget:self action:@selector(writeClick) forControlEvents:UIControlEventTouchUpInside];
            [writeBtn setHidden:YES];
            [self addSubview:writeBtn];
        }
        
        switch ([_ItemData.part_order_status integerValue]) {
            case 0://其它
                [stateBtn setHidden:YES];
                break;
            case 1://待发货
                [stateBtn setTitle:@"申请退款" forState:UIControlStateNormal];
                break;
            case 2://待收货
                [stateBtn setTitle:@"申请退款" forState:UIControlStateNormal];
                break;
            case 3://已完成
                [stateBtn setTitle:@"申请退款" forState:UIControlStateNormal];
                break;
            case 4://待付款
                [stateBtn setHidden:YES];
                break;
            case 5://取消订单
                [stateBtn setHidden:YES];
                break;
            case 6://退款订单
                [stateBtn setTitle:@"退款进度" forState:UIControlStateNormal];
                break;
            case 7://换货订单
                [stateBtn setHidden:YES];
                break;
            case 8://取消售后
//                [stateBtn setTitle:@"申请退款" forState:UIControlStateNormal];
                [stateBtn setHidden:YES];
                break;
            case 9://待确定售后
                [stateBtn setTitle:@"退款进度" forState:UIControlStateNormal];
                break;
            case 10://待上传退货物流信息
                [stateBtn setTitle:@"退款进度" forState:UIControlStateNormal];
                break;
            case 11://待商家收货
                [stateBtn setTitle:@"退款进度" forState:UIControlStateNormal];
                break;
            case 12://退款中订单
                [stateBtn setTitle:@"退款进度" forState:UIControlStateNormal];
                break;
            case 13://退款完成订单
                [stateBtn setTitle:@"退款进度" forState:UIControlStateNormal];
                break;
            case 14://已评价
                [stateBtn setTitle:@"申请退款" forState:UIControlStateNormal];
                break;
            case 15://待评价
                [stateBtn setTitle:@"申请退款" forState:UIControlStateNormal];
                break;
            case 16://未知
                [stateBtn setHidden:YES];
                break;
            default:
                [stateBtn setHidden:YES];
                break;
        }
        
        NSInteger refund_status = [_detailData.refund_status integerValue];
        if (_detailData && refund_status != 4) {
            [stateBtn setTitle:@"取消退款" forState:UIControlStateNormal];
        }
        if (_detailData && refund_status == 1) {
            [writeBtn setTitle:@"填写寄件信息" forState:UIControlStateNormal];
            [writeBtn setHidden:NO];
        }
        if(_detailData && (refund_status == 4 || refund_status == 5 || refund_status == -1)){
            [stateBtn setHidden:YES];
        }
        lineLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, h-0.5, ScreenW-20, 0.5)];
        lineLbl.backgroundColor = LMH_COLOR_CELL;
        [self addSubview:lineLbl];
    }
}

- (void)returnClick{
    if ([self.delegate respondsToSelector:@selector(returnOrder:)]) {
        [self.delegate returnOrder:_ItemData];
    }
}

- (void)writeClick{
    if ([self.delegate respondsToSelector:@selector(writeOrder:)]) {
        [self.delegate writeOrder:_detailData];
    }
}

@end
