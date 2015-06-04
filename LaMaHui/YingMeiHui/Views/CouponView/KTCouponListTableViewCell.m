//
//  KTCouponListTableViewCell.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-17.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTCouponListTableViewCell.h"
#import "CouponVO.h"

#define BACKGROUND_COLOR            [UIColor whiteColor]

@interface KTCouponListTableViewCell ()
{
    UIImageView *_couponInfoBgView;
    UIImageView *_couponPriceBgView;
    UIImageView *_shadowView;
    UILabel *_nameLbl;
    UILabel *_useDateLbl;
    
    UILabel *_couponIDLbl;
    UILabel *_moneyLbl;
    
    UILabel *_conditionLbl;
    UILabel *_limitbl;
    UILabel *alb;
    
    UILabel *overduelabel;
}

@end

@implementation KTCouponListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1]];
        [[self contentView] setBackgroundColor:[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1]];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark init view
////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setCellState:(BOOL)cellState
{
    _cellState = cellState;
    
    if (_cellState) {
        _couponInfoBgView.backgroundColor = [UIColor cyanColor];
        _couponInfoBgView.image = [UIImage imageNamed:@"valid_2"];
        _couponPriceBgView.image = [UIImage imageNamed:@"valid_price_2"];
        [_nameLbl setTextColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1]];
//        [_useDateLbl setTextColor:[UIColor colorWithRed:0.22 green:0.76 blue:0.79 alpha:1]];
        [_useDateLbl setTextColor:[UIColor grayColor]];
        [_moneyLbl setTextColor:[UIColor whiteColor]];
        [_conditionLbl setTextColor:[UIColor whiteColor]];
        [_limitbl setTextColor:[UIColor grayColor]];
        [alb setTextColor:[UIColor whiteColor]];
        overduelabel.hidden = YES;
    }else{
        _couponInfoBgView.image = [UIImage imageNamed:@"valid_2"];
//        _couponInfoBgView.backgroundColor = [UIColor whiteColor];
        _couponPriceBgView.image = [UIImage imageNamed:@"invalid_price"];
        [_nameLbl setTextColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1]];
        [_useDateLbl setTextColor:[UIColor grayColor]];
        [_moneyLbl setTextColor:[UIColor whiteColor]];
        [_conditionLbl setTextColor:[UIColor whiteColor]];
        [_limitbl setTextColor:[UIColor grayColor]];
        [alb setTextColor:[UIColor whiteColor]];
        overduelabel.hidden = NO;

    }
}

- (void)setCouponData:(CouponVO *)CouponData
{
    _CouponData = CouponData;
    
    if (_CouponData) {
        CGFloat w = CGRectGetWidth([[UIScreen mainScreen] bounds]);
        
        //信息背景
        if (!_couponInfoBgView) {
            _couponInfoBgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, (w - 20)/4*3 - 3, 80)];
            [self.contentView addSubview:_couponInfoBgView];
        }
        
        //价格背景
        if (!_couponPriceBgView) {
            _couponPriceBgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_couponInfoBgView.frame) - 8, 5, (w - 20)/4 + 5, 80)];
            [self.contentView addSubview:_couponPriceBgView];
        }
        
        //阴影
        if (!_shadowView) {
            _shadowView = [[UIImageView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_couponInfoBgView.frame), (w - 18), 15)];
            [_shadowView setBackgroundColor:[UIColor clearColor]];
            [_shadowView setImage:[UIImage imageNamed:@"shadow"]];
            
//            [self.contentView addSubview:_shadowView];
        }
        
        //优惠券名称
        if (!_nameLbl) {
            _nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, (w - 18)/4*3, 30)];
            [_nameLbl setBackgroundColor:[UIColor clearColor]];
//            _nameLbl.backgroundColor = [UIColor redColor];
            [_nameLbl setTextAlignment:NSTextAlignmentLeft];
            [_nameLbl setFont:LMH_FONT_15];
            
            [_couponInfoBgView addSubview:_nameLbl];
        }
        [_nameLbl setText:_CouponData.title];
        
        // 优惠券使用限制
        if (!_limitbl) {
            _limitbl = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_nameLbl.frame)-5, (w - 18)/4*3, 20)];
            [_limitbl setBackgroundColor:[UIColor clearColor]];
            [_limitbl setTextAlignment:NSTextAlignmentLeft];
            [_limitbl setFont:[UIFont systemFontOfSize:12.0]];
            [_couponInfoBgView addSubview:_limitbl];
        }
        [_limitbl setText:_CouponData.special_condition];
        //优惠券使用期限
        if (!_useDateLbl) {
             _useDateLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_nameLbl.frame)+15, (w - 18)/4*3, 20)];
            [_useDateLbl setBackgroundColor:[UIColor clearColor]];
            [_useDateLbl setTextAlignment:NSTextAlignmentLeft];
            [_useDateLbl setFont:[UIFont systemFontOfSize:13.0]];
//            _useDateLbl.backgroundColor = [UIColor orangeColor];
            
            [_couponInfoBgView addSubview:_useDateLbl];
        }
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy.MM.dd"];
        
        _CouponData.end_time = [NSNumber numberWithDouble:1451491200];
        
        NSDate *begin = [NSDate dateWithTimeIntervalSince1970:[_CouponData.begin_time longLongValue]];
        NSDate *end = [NSDate dateWithTimeIntervalSince1970:[_CouponData.end_time longLongValue]];
        NSString *beginTimespStr = [formatter stringFromDate:begin];
        NSString *endTimespStr = [formatter stringFromDate:end];
        NSString *useDate = [NSString stringWithFormat:@"使用期限 %@-%@", beginTimespStr, endTimespStr];
        [_useDateLbl setText:useDate];

        //优惠券金额
        if (!_moneyLbl) {
            _moneyLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 14, CGRectGetWidth(_couponPriceBgView.frame), 20)];
            [_moneyLbl setBackgroundColor:[UIColor clearColor]];
            [_moneyLbl setTextAlignment:NSTextAlignmentCenter];
            [_moneyLbl setFont:[UIFont boldSystemFontOfSize:27.0]];
            [_moneyLbl setNumberOfLines:1];
            [_moneyLbl setLineBreakMode:NSLineBreakByTruncatingTail];
            [_couponPriceBgView addSubview:_moneyLbl];
        }
        [_moneyLbl setText:[NSString stringWithFormat:@"￥%0.0f", [_CouponData.coupon_amount floatValue]]];
        
        //优惠券使用规则
        if (!_conditionLbl) {
            _conditionLbl = [[UILabel alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(_moneyLbl.frame), CGRectGetWidth(_couponPriceBgView.frame) - 16, 50)];
            [_conditionLbl setBackgroundColor:[UIColor clearColor]];
            [_conditionLbl setTextAlignment:NSTextAlignmentCenter];
            [_conditionLbl setFont:[UIFont systemFontOfSize:12.0]];
            [_conditionLbl setNumberOfLines:3];
            [_conditionLbl setLineBreakMode:NSLineBreakByCharWrapping];
            
            [_couponPriceBgView addSubview:_conditionLbl];
        }
            [_conditionLbl setText:_CouponData.coupon_rule];
      
        // 已过期标志
        if(!overduelabel) {
            overduelabel = [[UILabel alloc] init];
            overduelabel.frame = CGRectMake(0, 0, _couponPriceBgView.frame.size.width/5*4, _couponPriceBgView.frame.size.height/16*5);
            overduelabel.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:overduelabel];
            overduelabel.center = _couponPriceBgView.center;
            overduelabel.transform = CGAffineTransformRotate(overduelabel.transform, -M_PI_4/3);
            overduelabel.layer.borderWidth = 1;
            overduelabel.layer.borderColor = [[UIColor grayColor] CGColor];
            overduelabel.alpha = 0.5;
            overduelabel.text = @"已过期";
            overduelabel.textColor = [UIColor grayColor];
            overduelabel.textAlignment = 1;
            [overduelabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
            

        }
        //优惠券状态
        self.cellState = [_CouponData.is_valid boolValue];
    }
}

@end
