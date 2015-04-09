//
//  KTOrderListTableViewCell.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-17.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTOrderListTableViewCell.h"
#import "EGOImageView.h"
#import "OrderBeanVO.h"
#import <QuartzCore/QuartzCore.h>

#define BACKGROUND_COLOR            [UIColor clearColor]

@interface KTOrderListTableViewCell ()
{
    UIView *_orderBgView;
    UILabel *_orderTimeLbl;
    EGOImageView *_productImgView;
    UILabel *_productNameLbl;
    UILabel *_orderIDLbl;
    UILabel *_priceTipLbl;
    UILabel *_orderPriceLbl;
    UILabel *_statusTipLbl;
    UILabel *_orderStatusLbl;
}

@end

@implementation KTOrderListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:BACKGROUND_COLOR];
        [[self contentView] setBackgroundColor:BACKGROUND_COLOR];
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

- (void)setOrderData:(OrderBeanVO *)OrderData
{
    _OrderData = OrderData;
    
    if (_OrderData) {
        CGFloat w = CGRectGetWidth([[UIScreen mainScreen] bounds]);
        
        if (!_orderBgView) {
            _orderBgView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, w - 20, 150)];
            [_orderBgView setBackgroundColor:[UIColor whiteColor]];
            [_orderBgView.layer setBorderWidth:0.5];
            [_orderBgView.layer setBorderColor:[UIColor colorWithRed:0.87 green:0.83 blue:0.84 alpha:1].CGColor];
            [_orderBgView.layer setShadowColor:[UIColor grayColor].CGColor];
            [_orderBgView.layer setShadowOpacity:0.1];
            [_orderBgView.layer setShadowOffset:CGSizeMake(0, 0)];
            [_orderBgView.layer setShadowPath:[UIBezierPath bezierPathWithRect:_orderBgView.bounds].CGPath];
            
            UIView *titleview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_orderBgView.frame), 40)];
            [titleview setBackgroundColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1]];
            [titleview.layer setBorderWidth:0.5];
            [titleview.layer setBorderColor:[UIColor colorWithRed:0.87 green:0.83 blue:0.84 alpha:1].CGColor];
            [_orderBgView addSubview:titleview];
            
            UIImageView *dotline = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logindotline"]];
            [dotline setFrame:CGRectMake(1, 125, 298, 0.5)];
            [_orderBgView addSubview:dotline];
            
            [self.contentView addSubview:_orderBgView];
        }
        
        if (!_orderTimeLbl) {
            _orderTimeLbl = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, CGRectGetWidth(_orderBgView.frame) - 16, 40)];
            [_orderTimeLbl setBackgroundColor:[UIColor clearColor]];
            [_orderTimeLbl setTextColor:[UIColor blackColor]];
            [_orderTimeLbl setTextAlignment:NSTextAlignmentLeft];
            [_orderTimeLbl setFont:[UIFont systemFontOfSize:13.0]];
            
            [_orderBgView addSubview:_orderTimeLbl];
        }
        
        if (_OrderData.CreateTime) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSString *dateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[_OrderData.CreateTime longLongValue]]];
            [_orderTimeLbl setText:[NSString stringWithFormat:@"订单时间： %@", dateStr]];
        }
        
        if (!_productImgView) {
            _productImgView = [[EGOImageView alloc] initWithFrame:CGRectMake(7, 47, 55, 70)];
            _productImgView.placeholderImage = [UIImage imageNamed:@"productph"];
            _productImgView.contentMode = UIViewContentModeScaleAspectFill;
            _productImgView.clipsToBounds = YES;
            
            [_orderBgView addSubview:_productImgView];
        }
        
        if (_OrderData.PicUrl) {
            NSString * imgUrlStr = [_OrderData PicUrl];
            [_productImgView setImageURL:[NSURL URLWithString:imgUrlStr]];
        }
        
        if (!_productNameLbl) {
            _productNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_productImgView.frame) + 11, 53, w - CGRectGetMaxX(_productImgView.frame) - 40, 11)];
            _productNameLbl.backgroundColor = [UIColor clearColor];
            _productNameLbl.font = [UIFont systemFontOfSize:10.0];
            _productNameLbl.textColor = [UIColor colorWithRed:0.29 green:0.29 blue:0.29 alpha:1];
            _productNameLbl.textAlignment = NSTextAlignmentLeft;
            _productNameLbl.lineBreakMode = NSLineBreakByTruncatingTail;
            _productNameLbl.numberOfLines = 1;
            
            [_orderBgView addSubview:_productNameLbl];
        }
        
        if (_OrderData.ProductTitle) {
            [_productNameLbl setText:[_OrderData ProductTitle]];
        }
        
        if (!_orderIDLbl) {
            _orderIDLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_productImgView.frame) + 11, CGRectGetMaxY(_productNameLbl.frame) + 12, w - CGRectGetMaxX(_productImgView.frame) - 40, 11)];
            _orderIDLbl.backgroundColor = [UIColor clearColor];
            _orderIDLbl.font = [UIFont systemFontOfSize:10.0];
            _orderIDLbl.textColor = [UIColor colorWithRed:0.45 green:0.48 blue:0.47 alpha:1];
            _orderIDLbl.textAlignment = NSTextAlignmentLeft;
            _orderIDLbl.lineBreakMode = NSLineBreakByTruncatingTail;
            _orderIDLbl.numberOfLines = 1;
            
            [_orderBgView addSubview:_orderIDLbl];
        }
        
        if (_OrderData.ID) {
            [_orderIDLbl setText:[NSString stringWithFormat:@"订单编号：%@", _OrderData.ID]];
        }
        
        if (!_priceTipLbl) {
            _priceTipLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_productImgView.frame) + 11, CGRectGetMaxY(_orderIDLbl.frame) + 12, w - CGRectGetMaxX(_productImgView.frame) - 40, 11)];
            _priceTipLbl.backgroundColor = [UIColor clearColor];
            _priceTipLbl.font = [UIFont systemFontOfSize:10.0];
            _priceTipLbl.textColor = [UIColor colorWithRed:0.45 green:0.48 blue:0.47 alpha:1];
            _priceTipLbl.textAlignment = NSTextAlignmentLeft;
            _priceTipLbl.lineBreakMode = NSLineBreakByTruncatingTail;
            _priceTipLbl.numberOfLines = 1;
            _priceTipLbl.text = @"订单金额：";
            
            [_orderBgView addSubview:_priceTipLbl];
        }
        
        if (!_orderPriceLbl) {
            _orderPriceLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_productImgView.frame) + 60, CGRectGetMaxY(_orderIDLbl.frame) + 12, w - CGRectGetMaxX(_productImgView.frame) - 90, 11)];
            _orderPriceLbl.backgroundColor = [UIColor clearColor];
            _orderPriceLbl.font = [UIFont systemFontOfSize:10.0];
            _orderPriceLbl.textColor = [UIColor colorWithRed:0.99 green:0.4 blue:0 alpha:1];
            _orderPriceLbl.textAlignment = NSTextAlignmentLeft;
            _orderPriceLbl.lineBreakMode = NSLineBreakByTruncatingTail;
            _orderPriceLbl.numberOfLines = 1;
            
            [_orderBgView addSubview:_orderPriceLbl];
        }
        
        if (_OrderData.OrderPrice) {
            if ((NSInteger)([_OrderData.OrderPrice floatValue] * 100) % 100 == 0) {
                [_orderPriceLbl setText:[NSString stringWithFormat:@"￥%.0f", [_OrderData.OrderPrice floatValue]]];
            } else {
                NSString *orderPrice;
                CGFloat afloat = [_OrderData.OrderPrice floatValue];
                if ((afloat * 10) - (int)(afloat * 10) > 0) {
                    orderPrice = [NSString stringWithFormat:@"¥%0.2f",[_OrderData.OrderPrice floatValue]];
                } else if(afloat - (int)afloat > 0) {
                    orderPrice = [NSString stringWithFormat:@"¥%0.1f",[_OrderData.OrderPrice floatValue]];
                } else {
                    orderPrice = [NSString stringWithFormat:@"¥%0.0f",[_OrderData.OrderPrice floatValue]];
                }
                [_orderPriceLbl setText:orderPrice];
            }
        } else {
            [_orderPriceLbl setText:@"￥"];
        }
        
        if (!_statusTipLbl) {
            _statusTipLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_productImgView.frame), CGRectGetMaxY(_productImgView.frame) + 15, w - CGRectGetMinX(_productImgView.frame) - 40, 11)];
            _statusTipLbl.backgroundColor = [UIColor clearColor];
            _statusTipLbl.font = [UIFont boldSystemFontOfSize:10.0];
            _statusTipLbl.textColor = [UIColor colorWithRed:0.45 green:0.47 blue:0.47 alpha:1];
            _statusTipLbl.textAlignment = NSTextAlignmentLeft;
            _statusTipLbl.lineBreakMode = NSLineBreakByTruncatingTail;
            _statusTipLbl.numberOfLines = 1;
            _statusTipLbl.text = @"订单状态：";
            
            [_orderBgView addSubview:_statusTipLbl];
        }
        
        if (!_orderStatusLbl) {
            _orderStatusLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_productImgView.frame) + 55, CGRectGetMaxY(_productImgView.frame) + 15, w - CGRectGetMinX(_productImgView.frame) - 95, 11)];
            _orderStatusLbl.backgroundColor = [UIColor clearColor];
            _orderStatusLbl.font = [UIFont boldSystemFontOfSize:10.0];
            _orderStatusLbl.textColor = [UIColor colorWithRed:0.98 green:0.76 blue:0.32 alpha:1];
            _orderStatusLbl.textAlignment = NSTextAlignmentLeft;
            _orderStatusLbl.lineBreakMode = NSLineBreakByTruncatingTail;
            _orderStatusLbl.numberOfLines = 1;
            
            [_orderBgView addSubview:_orderStatusLbl];
        }
        
        if (_OrderData.Status) {
            //create by kevin on 2014.8.27 pm 1:40
            _orderStatusLbl.text = [kata_GlobalConst getOrderStatesWithIntValue:[_OrderData.Status intValue]];
        }
        return;
    }
}

@end
