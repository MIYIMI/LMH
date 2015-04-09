//
//  LimitedSeckillCell.m
//  YingMeiHui
//
//  Created by Zhumingming on 14-10-27.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "LimitedSeckillCell.h"
#import "UIImageView+WebCache.h"
@implementation LimitedSeckillCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    
    return self;
}

- (void)configContent:(LimitedSeckillVO *)model
{
    _model = model;
    
    //背景
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, ScreenW - 20, 130)];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgView];
        
        //左侧图片
        _picView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 110, 110)];
        _picView.image = [UIImage imageNamed:@"productph"];
        [_bgView addSubview:_picView];
        
        //已卖光显示
        _outview = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(_picView.frame)/6, CGRectGetWidth(_picView.frame)/6, CGRectGetWidth(_picView.frame)/3*2, CGRectGetWidth(_picView.frame)/3*2)];
        [_outview setHidden:YES];
        [_picView addSubview:_outview];
        
        //title
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_picView.frame)+5, 8, ScreenW - CGRectGetMaxX(_picView.frame)-75, 40)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.numberOfLines = 2;// 不可少Label属性之一
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;// 不可少Label属性之二
        _titleLabel.font = FONT(14);
        _titleLabel.textColor = [UIColor blackColor];
        
        [_bgView addSubview:_titleLabel];
        
        //限购数量图标
        _limitedNumberView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenW-60, 10, 35, 35)];
        _limitedNumberView.image = [UIImage imageNamed:@"limitedNumber"];
        [_bgView addSubview:_limitedNumberView];
        
        _limitedNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 35, 30)];
        _limitedNumberLabel.backgroundColor = [UIColor clearColor];
        _limitedNumberLabel.numberOfLines = 2;
        //    _limitedNumberLabel.text = [NSString stringWithFormat:@"限量%@件",@"12"];
        _limitedNumberLabel.textAlignment = NSTextAlignmentCenter;
        _limitedNumberLabel.font = FONT(12);
        _limitedNumberLabel.textColor = [UIColor whiteColor];
        [_limitedNumberView addSubview:_limitedNumberLabel];
        
        //灰色分隔线
        _graySeparateLine = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_picView.frame)+5, CGRectGetMaxY(_titleLabel.frame)+5, ScreenW - CGRectGetMaxX(_picView.frame)-30, 1)];
        _graySeparateLine.backgroundColor = GRAY_LINE_COLOR;
        [_bgView addSubview:_graySeparateLine];
        
        //原价
        _oldPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_picView.frame)+5, CGRectGetMaxY(_graySeparateLine.frame)+5, 80, 15)];
        _oldPriceLabel.backgroundColor = [UIColor clearColor];
        //    _oldPriceLabel.text = @"原件￥100";
        _oldPriceLabel.textAlignment = NSTextAlignmentLeft;
        _oldPriceLabel.textColor = [UIColor grayColor];
        _oldPriceLabel.font = FONT(10);
        [_bgView addSubview:_oldPriceLabel];
        _lineView = [[UILabel alloc]initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor grayColor];
        [_oldPriceLabel addSubview:_lineView];
        
        //现价
        _monryViewLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_picView.frame)+5, CGRectGetMaxY(_oldPriceLabel.frame)+5, 13, 15)];
        _monryViewLabel.text = @"￥";
        _monryViewLabel.font = FONT(11);
        _monryViewLabel.textColor = [UIColor redColor];
        _monryViewLabel.backgroundColor = [UIColor clearColor];
        [_bgView addSubview:_monryViewLabel];
        
        _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_monryViewLabel.frame)+2, CGRectGetMaxY(_oldPriceLabel.frame), 50, 20)];
        //    _priceLabel.text = @"690:00";
        _priceLabel.font = FONT(16);
        //    _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.textColor = [UIColor redColor];
        _priceLabel.backgroundColor = [UIColor clearColor];
        [_bgView addSubview:_priceLabel];
        
        //VS
        _VSView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_priceLabel.frame), CGRectGetMaxY(_graySeparateLine.frame)+5, 30, 30)];
        _VSView.image = [UIImage imageNamed:@"VS"];
        [_bgView addSubview:_VSView];
        
        //淘宝价
        _taobaoWordLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_VSView.frame), CGRectGetMaxY(_graySeparateLine.frame)+5, 43, 30)];
        _taobaoWordLabel.backgroundColor = [UIColor clearColor];
        _taobaoWordLabel.text = @"淘宝价￥";
        _taobaoWordLabel.font = FONT(10.5);
        _taobaoWordLabel.textColor = [UIColor grayColor];
        [_bgView addSubview:_taobaoWordLabel];
        
        _taobaoPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_taobaoWordLabel.frame), CGRectGetMaxY(_graySeparateLine.frame)+5, ScreenW-88, 30)];
        _taobaoPriceLabel.textColor = [UIColor grayColor];
        _taobaoPriceLabel.font = FONT(13);
        _taobaoPriceLabel.backgroundColor = [UIColor clearColor];
        [_bgView addSubview:_taobaoPriceLabel];
        
        //购买状态按钮
        _buyStatusBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW-100, CGRectGetMaxY(_VSView.frame)+5, 75, 25)];
        _buyStatusBtn.titleLabel.font = FONT(14);
        [_buyStatusBtn addTarget:self action:@selector(buyClick:) forControlEvents:UIControlEventTouchUpInside];
        [_buyStatusBtn setUserInteractionEnabled:NO];
        [_bgView addSubview:_buyStatusBtn];
    }
 //   [_titleLabel setFrame:CGRectMake(120, 8, 130, 40)];
//    [_picView sd_setImageWithURL:[NSURL URLWithString:_model.pic]];
    NSString *picStr;
    if (_model.pic && ![_model.pic isEqual:[NSNull null]]) {
        picStr = _model.pic;
    }
    
    [_picView sd_setImageWithURL:[NSURL URLWithString:picStr] placeholderImage:[UIImage imageNamed:@"productph"]];
    _limitedNumberLabel.text = [NSString stringWithFormat:@"限量%@件",_model.stock];
    NSString *salesPrice;
    CGFloat bfloat = [_model.market_price floatValue];
    if ((bfloat * 10) - (int)(bfloat * 10) > 0) {
        salesPrice = [NSString stringWithFormat:@"%0.2f",[_model.market_price floatValue]];
    } else if(bfloat - (int)bfloat > 0) {
        salesPrice = [NSString stringWithFormat:@"%0.1f",[_model.market_price floatValue]];
    } else {
        salesPrice = [NSString stringWithFormat:@"%0.0f",[_model.market_price floatValue]];
    }
    _oldPriceLabel.text = [NSString stringWithFormat:@"原价 ￥%@",salesPrice];
    
    CGSize oldPriceLineHight = [salesPrice sizeWithFont:FONT(10) constrainedToSize:CGSizeMake(500, 15)];
    _lineView.frame = CGRectMake(22, 7, oldPriceLineHight.width +12, 1);
    
    NSString *ourPrice;
    CGFloat sive = [_model.our_price floatValue];
    if ((sive * 10) - (int)(sive * 10) > 0) {
        ourPrice = [NSString stringWithFormat:@"%0.2f",[_model.our_price floatValue]];
    } else if(sive - (int)sive > 0) {
        ourPrice = [NSString stringWithFormat:@"%0.1f",[_model.our_price floatValue]];
    } else {
        ourPrice = [NSString stringWithFormat:@"%0.0f",[_model.our_price floatValue]];
    }
    _priceLabel.text = ourPrice;
    
    NSString *taobao_price;
    CGFloat afloat = [_model.taobao_price floatValue];
    if ((afloat * 10) - (int)(afloat * 10) > 0) {
        taobao_price = [NSString stringWithFormat:@"%0.2f",[_model.taobao_price floatValue]];
    } else if(afloat - (int)afloat > 0) {
        taobao_price = [NSString stringWithFormat:@"%0.1f",[_model.taobao_price floatValue]];
    } else {
        taobao_price = [NSString stringWithFormat:@"%0.0f",[_model.taobao_price floatValue]];
    }
    _taobaoPriceLabel.text = taobao_price;
    _titleLabel.text = _model.product_name;
    
    self.taobaoDetailURL = model.taobao_detail_url;
    
    if ([model.surplus integerValue] == 0) {
        if (stringIsEmpty(self.taobaoDetailURL)) {
            _outview.image = [UIImage imageNamed:@"icon_salesout"];
        }else{
            _outview.image = [UIImage imageNamed:@"outofstock_taobao"];
        }
        [_buyStatusBtn setBackgroundImage:[UIImage imageNamed:@"outOfStockBtnBg"] forState:UIControlStateNormal];
        [_buyStatusBtn setTitle:@"已抢光" forState:UIControlStateNormal];
        [_outview setHidden:NO];
    }else if([model.is_start_sale integerValue] == 0){
        _buyStatusBtn.userInteractionEnabled = YES;
        [_outview setHidden:YES];

        if ([_model.outTimeNum longLongValue] <= 300) {
            [_buyStatusBtn setBackgroundImage:[UIImage imageNamed:@"willStartBtn"] forState:UIControlStateNormal];
            _buyStatusBtn.userInteractionEnabled = NO;
            [_buyStatusBtn setTitle:@"即将开始" forState:UIControlStateNormal];
        }
        else if ([_model.is_seckill_remind integerValue] == 1) {
            [_buyStatusBtn setBackgroundImage:[UIImage imageNamed:@"remind_already"] forState:UIControlStateNormal];
            [_buyStatusBtn setTitle:@"" forState:UIControlStateNormal];
        }else{
            [_buyStatusBtn setBackgroundImage:[UIImage imageNamed:@"remind_go"] forState:UIControlStateNormal];
            [_buyStatusBtn setTitle:@"" forState:UIControlStateNormal];
        }
        
    }else{
        [_buyStatusBtn setBackgroundImage:[UIImage imageNamed:@"red_btn_small"] forState:UIControlStateNormal];
        [_buyStatusBtn setTitle:@"立即抢购" forState:UIControlStateNormal];
        [_outview setHidden:YES];
    }
}

- (void)buyClick:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(buyBtnClick:)]) {
        [self.delegate buyBtnClick:_model];
    }
}


@end
