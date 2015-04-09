//
//  KTOrderSubmitProductTableViewCell.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-12.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTOrderSubmitProductTableViewCell.h"
#import "EGOImageView.h"

#import <QuartzCore/QuartzCore.h>

#define BACKGROUND_COLOR            [UIColor clearColor]

@interface KTOrderSubmitProductTableViewCell ()
{
    UIView *_productBgView;
    EGOImageView *_productImgView;
    UILabel *_titleLbl;
    UILabel *_propDesLbl;
    UIImageView *_dotline;
    UIButton *_couponBtn;
    KTCounterTextField *_counterView;
    UILabel *_priceTipLbl;
    UILabel *_priceLbl;
}

@end

@implementation KTOrderSubmitProductTableViewCell

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

- (void)couponBtn
{
    if (self.submitProductCellDelegate && [self.submitProductCellDelegate respondsToSelector:@selector(couponBtnPressed)]) {
        [self.submitProductCellDelegate couponBtnPressed];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark init view
////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setOrderProductDict:(NSDictionary *)orderProductDict
{
    _orderProductDict = orderProductDict;
    
    if (_orderProductDict) {
        if (!_productBgView) {
            _productBgView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 141)];
            [_productBgView setBackgroundColor:[UIColor whiteColor]];
            [_productBgView.layer setBorderColor:[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1].CGColor];
            [_productBgView.layer setBorderWidth:0.5];
            
            [self.contentView addSubview:_productBgView];
        }
        
        if (!_productImgView) {
            _productImgView = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 10, 89, 89)];
            _productImgView.placeholderImage = [UIImage imageNamed:@"productph"];
            _productImgView.contentMode = UIViewContentModeScaleAspectFill;
            _productImgView.clipsToBounds = YES;
            
            [_productBgView addSubview:_productImgView];
        }
        
        if ([_orderProductDict objectForKey:@"pic"]) {
            NSString * imgUrlStr = [_orderProductDict objectForKey:@"pic"];
            [_productImgView setImageURL:[NSURL URLWithString:imgUrlStr]];
        }
        
        if (!_titleLbl) {
            _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            _titleLbl.backgroundColor = [UIColor clearColor];
            _titleLbl.font = [UIFont systemFontOfSize:12.0];
            _titleLbl.textColor = [UIColor colorWithRed:0.14 green:0.14 blue:0.14 alpha:1];
            _titleLbl.textAlignment = NSTextAlignmentLeft;
            _titleLbl.lineBreakMode = NSLineBreakByCharWrapping;
            _titleLbl.numberOfLines = 0;
            
            [_productBgView addSubview:_titleLbl];
        }
        
        if ([_orderProductDict objectForKey:@"title"]) {
            _titleLbl.text = [_orderProductDict objectForKey:@"title"];
        }
        
        if (!_propDesLbl) {
            _propDesLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            _propDesLbl.backgroundColor = [UIColor clearColor];
            _propDesLbl.font = [UIFont systemFontOfSize:12.0];
            _propDesLbl.textColor = [UIColor colorWithRed:0.7 green:0.72 blue:0.73 alpha:1];
            _propDesLbl.textAlignment = NSTextAlignmentLeft;
            _propDesLbl.lineBreakMode = NSLineBreakByCharWrapping;
            _propDesLbl.numberOfLines = 0;
            
            [_productBgView addSubview:_propDesLbl];
        }
        
        NSString *propStr = @"";
        if ([_orderProductDict objectForKey:@"colorpropname"] && [[_orderProductDict objectForKey:@"colorpropname"] isKindOfClass:[NSString class]]) {
            propStr = [propStr stringByAppendingFormat:@"%@：",[_orderProductDict objectForKey:@"colorpropname"]];
        }
        
        if ([_orderProductDict objectForKey:@"colorname"] && [[_orderProductDict objectForKey:@"colorname"] isKindOfClass:[NSString class]]) {
            propStr = [propStr stringByAppendingFormat:@"%@\t",[_orderProductDict objectForKey:@"colorname"]];
        }
        
        if ([_orderProductDict objectForKey:@"sizepropname"] && [[_orderProductDict objectForKey:@"sizepropname"] isKindOfClass:[NSString class]]) {
            propStr = [propStr stringByAppendingFormat:@"%@：",[_orderProductDict objectForKey:@"sizepropname"]];
        }
        
        if ([_orderProductDict objectForKey:@"sizename"] && [[_orderProductDict objectForKey:@"sizename"] isKindOfClass:[NSString class]]) {
            propStr = [propStr stringByAppendingString:[_orderProductDict objectForKey:@"sizename"]];
        }
        _propDesLbl.text = propStr;
        
        if (!_counterView) {
            _counterView = [[KTCounterTextField alloc] init];
            _counterView.counterTFDelegate = self;
            [_counterView setFrame:CGRectMake(CGRectGetMaxX(_productImgView.frame) + 10, CGRectGetMaxY(_productImgView.frame) - CGRectGetHeight(_counterView.frame), CGRectGetWidth(_counterView.frame), CGRectGetHeight(_counterView.frame))];
            [_productBgView addSubview:_counterView];
        }
        
        if (!_dotline) {
            _dotline = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logindotline"]];
            [_dotline setFrame:CGRectMake(0, 109, 300, 1)];
            [_productBgView addSubview:_dotline];
        }

        if (!_couponBtn) {
            _couponBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [_couponBtn setFrame:CGRectMake(7, CGRectGetMaxY(_dotline.frame) + 9, 107, 32)];
            [_couponBtn setTitle:@"使用优惠券" forState:UIControlStateNormal];
            [_couponBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_couponBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
            
            UIImage *image = [UIImage imageNamed:@"couponbtn"];
            image = [image stretchableImageWithLeftCapWidth:10.0f topCapHeight:10.0f];
            [_couponBtn setBackgroundImage:image forState:UIControlStateNormal];
            image = [UIImage imageNamed:@"couponbtn_selected"];
            image = [image stretchableImageWithLeftCapWidth:10.0f topCapHeight:10.0f];
            [_couponBtn setBackgroundImage:image forState:UIControlStateHighlighted];
            [_couponBtn setBackgroundImage:image forState:UIControlStateSelected];
            [_couponBtn addTarget:self action:@selector(couponBtn) forControlEvents:UIControlEventTouchUpInside];
            
//            [_productBgView addSubview:_couponBtn];
        }
        
        if (!_priceTipLbl) {
            _priceTipLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            [_priceTipLbl setBackgroundColor:[UIColor clearColor]];
            [_priceTipLbl setFont:[UIFont systemFontOfSize:13.0]];
            [_priceTipLbl setTextAlignment:NSTextAlignmentLeft];
            [_priceTipLbl setTextColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1]];
            [_priceTipLbl setText:@"单价:"];
            [_productBgView addSubview:_priceTipLbl];
        }
        
        if (!_priceLbl) {
            _priceLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            [_priceLbl setBackgroundColor:[UIColor clearColor]];
            [_priceLbl setFont:[UIFont systemFontOfSize:13.0]];
            [_priceLbl setTextAlignment:NSTextAlignmentLeft];
            [_priceLbl setTextColor:[UIColor colorWithRed:0.96 green:0.3 blue:0.39 alpha:1]];
            [_productBgView addSubview:_priceLbl];
        }
        
        if ([_orderProductDict objectForKey:@"price"]) {
            NSString *orderPrice;
            CGFloat afloat = [[_orderProductDict objectForKey:@"price"] floatValue];
            if ((afloat * 10) - (int)(afloat * 10) > 0) {
                orderPrice = [NSString stringWithFormat:@"¥%0.2f",[[_orderProductDict objectForKey:@"price"] floatValue]];
            } else if(afloat - (int)afloat > 0) {
                orderPrice = [NSString stringWithFormat:@"¥%0.1f",[[_orderProductDict objectForKey:@"price"] floatValue]];
            } else {
                orderPrice = [NSString stringWithFormat:@"¥%0.0f",[[_orderProductDict objectForKey:@"price"] floatValue]];
            }
            [_priceLbl setText:orderPrice];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize titlesize = [_titleLbl.text sizeWithFont:_titleLbl.font constrainedToSize:CGSizeMake(180, 35) lineBreakMode:_titleLbl.lineBreakMode];
    [_titleLbl setFrame:CGRectMake(CGRectGetMaxX(_productImgView.frame) + 10, CGRectGetMinY(_productImgView.frame) + 3, titlesize.width, titlesize.height)];
    CGSize propsize = [_propDesLbl.text sizeWithFont:_propDesLbl.font constrainedToSize:CGSizeMake(200, 35) lineBreakMode:_propDesLbl.lineBreakMode];
    [_propDesLbl setFrame:CGRectMake(CGRectGetMaxX(_productImgView.frame) + 10, CGRectGetMinY(_productImgView.frame) + 40, propsize.width, propsize.height)];
    [_priceTipLbl setFrame:CGRectMake(CGRectGetMinX(_productImgView.frame), CGRectGetMaxY(_dotline.frame), 40, CGRectGetHeight(_productBgView.frame) - CGRectGetMaxY(_dotline.frame))];
    CGSize priceSize = [_priceLbl.text sizeWithFont:_priceLbl.font];
    [_priceLbl setFrame:CGRectMake(CGRectGetMaxX(_priceTipLbl.frame), CGRectGetMaxY(_dotline.frame), priceSize.width, CGRectGetHeight(_productBgView.frame) - CGRectGetMaxY(_dotline.frame))];
}

#pragma mark - KTCounterTextField Delegate
- (void)cntTFBeginEditting:(UITextField *)tf
{
    if (self.submitProductCellDelegate && [self.submitProductCellDelegate respondsToSelector:@selector(countTFBeginEditting:)]) {
        if (tf) {
            [self.submitProductCellDelegate countTFBeginEditting:tf];
        }
    }
}

- (void)cntChanged:(NSInteger)count
{
    if (self.submitProductCellDelegate && [self.submitProductCellDelegate respondsToSelector:@selector(productCountChanged:)]) {
        [self.submitProductCellDelegate productCountChanged:count];
    }
}

@end
