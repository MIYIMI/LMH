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
#define TEXTCOLOR [UIColor colorWithRed:0.53 green:0.55 blue:0.56 alpha:1]

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
    UILabel *typenameLbl;

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
//type=1 标示退款订单详情   type=0 标示商品详情和订单列表
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
            [_productImgView sd_setImageWithURL:[NSURL URLWithString:imgUrlStr] placeholderImage:nil];
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
        
        _propLbl.frame = CGRectMake(CGRectGetMaxX(_productImgView.frame) + 10, CGRectGetMaxY(_productNameLbl.frame)+ (titleSize.height>=15?ScreenW*0.015:ScreenW*0.045) - 3, w - CGRectGetMaxX(_productImgView.frame) - 50, CGRectGetHeight(_productImgView.frame)/5);
        
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
        
        if (!_salesLbl) {
            _salesLbl = [[UILabel alloc] initWithFrame:CGRectMake(ScreenW - 70, CGRectGetMinY(_productImgView.frame), 60, 15)];
            _salesLbl.backgroundColor = [UIColor clearColor];
            _salesLbl.font = LMH_FONT_13;
            _salesLbl.textColor = LMH_COLOR_GRAY;
            _salesLbl.textAlignment = NSTextAlignmentRight;
            [self addSubview:_salesLbl];
        }
        
        if(!_countLbl){
            _countLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            [_countLbl setTextColor:LMH_COLOR_LIGHTGRAY];
            [_countLbl setFont:LMH_FONT_12];
            _countLbl.textAlignment = 2;
            [self addSubview:_countLbl];
        }
        _countLbl.frame = CGRectMake(ScreenW-70, CGRectGetMaxY(_salesLbl.frame), 60, 15);
        
        if (_ItemData.quantity) {
            [_countLbl setText:[NSString stringWithFormat:@"x %@",_ItemData.quantity]];
        }
        
        if (!typenameLbl) {
            typenameLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            [typenameLbl setTextColor:LMH_COLOR_SKIN];
            [typenameLbl setFont:LMH_FONT_12];
            typenameLbl.textAlignment = 0;
            [self addSubview:typenameLbl];
            typenameLbl.frame = CGRectMake(CGRectGetMaxX(_productImgView.frame) + 10, CGRectGetMaxY(_propLbl.frame) + 5, 80, CGRectGetHeight(_productImgView.frame)/4);
        }
        if (_ItemData.pay_status_name) {
            typenameLbl.text = [NSString stringWithFormat:@"%@", _ItemData.pay_status_name];
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
        
//        //市场价标签
//        if (!_markLbl) {
//            _markLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_salesLbl.frame), CGRectGetMaxY(_salesLbl.frame), 60, 15)];
//            _markLbl.backgroundColor = [UIColor clearColor];
//            _markLbl.font = LMH_FONT_11;
//            _markLbl.textColor = LMH_COLOR_LIGHTGRAY;
//            _markLbl.textAlignment = NSTextAlignmentRight;
//            [self addSubview:_markLbl];
//        }
//        
//        if(!_marketLine){
//            _marketLine = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_markLbl.frame)/2, 10, 1)];
//            [_marketLine setBackgroundColor:LMH_COLOR_LIGHTGRAY];
//            [_markLbl addSubview:_marketLine];
//        }
//        
//        if (_ItemData.market_price) {
//            if ((NSInteger)([_ItemData.market_price floatValue] * 100) % 100 == 0) {
//                [_markLbl setText:[NSString stringWithFormat:@"￥%.0f", [_ItemData.market_price floatValue]]];
//            } else {
//                NSString *market_price;
//                CGFloat afloat = [_ItemData.market_price floatValue];
//                if ((afloat * 10) - (int)(afloat * 10) > 0) {
//                    market_price = [NSString stringWithFormat:@"¥%0.2f",[_ItemData.market_price floatValue]];
//                } else if(afloat - (int)afloat > 0) {
//                    market_price = [NSString stringWithFormat:@"¥%0.1f",[_ItemData.market_price floatValue]];
//                } else {
//                    market_price = [NSString stringWithFormat:@"¥%0.0f",[_ItemData.market_price floatValue]];
//                }
//                [_markLbl setText:market_price];
//            }
//        }
//    
//        CGRect frame = _marketLine.frame;
//        CGSize priceSize = [_markLbl.text sizeWithFont:_markLbl.font constrainedToSize:CGSizeMake(50, 20)];
//        frame.size.width = priceSize.width;
//        frame.origin.x = CGRectGetWidth(_markLbl.frame)-frame.size.width;
//        _marketLine.frame = frame;
        
        //按钮的宽度
        CGFloat btnW = ScreenW/7;
        CGFloat btnset = 5;
        
        //删除订单操作按钮
        for (UIButton *rbtn in self.contentView.subviews) {
            if (rbtn.tag > 10000) {
                [rbtn removeFromSuperview];
            }
        }
        //添加订单操作按钮
        for (int i = 0; i< _ItemData.orderBtn.count && !_detailData; i++) {
            OrderButtonVO *btnvo = _ItemData.orderBtn[i];
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW-btnW*(i+1)-btnset*i-10, CGRectGetMinY(typenameLbl.frame), btnW, CGRectGetHeight(_productImgView.frame)/4)];
            btn.layer.cornerRadius = 3.0;
            btn.layer.borderWidth = 0.5;
            btn.layer.borderColor = [LMH_COLOR_LINE CGColor];
            [btn setTitleColor:LMH_COLOR_GRAY forState:UIControlStateNormal];
            if ([btnvo.btn_color isEqualToString:@"red"]) {
                [btn setTitleColor:LMH_COLOR_SKIN forState:UIControlStateNormal];
            }
            [btn setTitle:btnvo.btn_name forState:UIControlStateNormal];
            [btn.titleLabel setFont:LMH_FONT_10];
            
            btn.tag = 10000 + [btnvo.btn_type integerValue];
            [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.contentView addSubview:btn];
        }
        
        if (!stateBtn && _detailData) {
            stateBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW-btnW-10, CGRectGetMaxY(typenameLbl.frame)+10, btnW, 20)];
            [stateBtn setTitle:@"取消退款" forState:UIControlStateNormal];
            [stateBtn setTitleColor:LMH_COLOR_GRAY forState:UIControlStateNormal];
            stateBtn.layer.cornerRadius = 3.0;
            stateBtn.layer.borderWidth = 0.5;
            [stateBtn.titleLabel setFont:LMH_FONT_10];
            stateBtn.layer.borderColor = [LMH_COLOR_LINE CGColor];
            stateBtn.tag = 10008;
            stateBtn.hidden = YES;
            [self.contentView addSubview:stateBtn];
            [stateBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        if (!writeBtn && _detailData) {
            writeBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW-2*(btnW+10)-btnW*0.5, CGRectGetMaxY(typenameLbl.frame)+10, btnW*1.5, 20)];
            [writeBtn setTitle:@"填写寄件信息" forState:UIControlStateNormal];
            [writeBtn setTitleColor:LMH_COLOR_GRAY forState:UIControlStateNormal];
            writeBtn.layer.cornerRadius = 3.0;
            writeBtn.layer.borderWidth = 0.5;
            [writeBtn.titleLabel setFont:LMH_FONT_10];
            writeBtn.layer.borderColor = [LMH_COLOR_LINE CGColor];
            writeBtn.hidden = YES;
            [self.contentView addSubview:writeBtn];
            [writeBtn addTarget:self action:@selector(writeClick) forControlEvents:UIControlEventTouchUpInside];
        }
        
        NSInteger refund_status = [_detailData.refund_status integerValue];
        if (_detailData && refund_status == 1) {
            [writeBtn setHidden:NO];
        }
        if(_detailData && (refund_status == 4 || refund_status == 5 || refund_status == -1)){
            [stateBtn setHidden:YES];
        }else{
            stateBtn.hidden = NO;
        }
        lineLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, h-0.5, ScreenW-20, 0.5)];
        lineLbl.backgroundColor = LMH_COLOR_CELL;
        [self addSubview:lineLbl];
    }
}

//填写寄件信息
- (void)writeClick{
    if ([self.delegate respondsToSelector:@selector(writeOrder:)]) {
        [self.delegate writeOrder:_detailData];
    }
}

- (void)clickBtn:(UIButton *)sender{
    NSInteger tag = sender.tag - 10000;
    switch (tag) {
        case 1://申请退款
            tag = 1;
            break;
        case 2://提醒发货
            tag = 2;
            break;
        case 3://查看物流
            tag = 3;
            break;
        case 4://确认收货
            tag = 4;
            break;
        case 5://评价订单
            tag = 5;
            break;
        case 6://等待审核
            tag = 6;
            break;
        case 7://审核通过
            tag = 7;
            break;
        case 8://取消退款
            tag = 8;
            break;
        case 9://退款成功
            tag = 9;
            break;
        default:
            break;
    }
    
    if ([self.delegate respondsToSelector:@selector(orderBtnClick:andVO:)]) {
        [self.delegate orderBtnClick:tag andVO:_ItemData];
    }
}


@end
