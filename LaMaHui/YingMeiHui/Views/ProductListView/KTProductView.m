//
//  KTProductView.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-3.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTProductView.h"
#import "EGOImageView.h"
#import "UIImageView+WebCache.h"
#import "ProductVO.h"
#import "LikeProductVO.h"
#import <QuartzCore/QuartzCore.h>

#define kImageFrameRatio            1.25f
#define BACKGROUND_COLOR            [UIColor whiteColor]

@interface KTProductView ()
{
    EGOImageView *__productImgView;
    UIImageView *__likeProductImgView;
    UILabel *__productNameLbl;
    UILabel *__dollarLbl;
    UILabel *__ourPriceLbl;
    UILabel *__marketPriceLbl;
    UILabel *__discountLbl;
    UIImageView *__discountBg;
    UIImageView *__soldOutImg;
    UIImageView *__limitImg;
    UIImageView *__favImg;
    UILabel *__favNumLbl;
}

@end

@implementation KTProductView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:BACKGROUND_COLOR];
    }
    return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark init view
////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setProductData:(ProductVO *)ProductData 
{
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    _ProductData = ProductData;
    
    if (_ProductData) {
        if (!__productImgView) {
            __productImgView = [[EGOImageView alloc] initWithFrame:CGRectMake(0, 0, w, h/kImageFrameRatio)];
            __productImgView.placeholderImage = [UIImage imageNamed:@"productph"];
            __productImgView.contentMode = UIViewContentModeScaleAspectFill;
            __productImgView.clipsToBounds = YES;
            
            [self addSubview:__productImgView];
        }
        
        if (_ProductData.Pic) {
            NSString * imgUrlStr = [_ProductData Pic];
            [__productImgView setImageURL:[NSURL URLWithString:imgUrlStr]];
        }
        
        if (!__productNameLbl) {
            __productNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(5, h/kImageFrameRatio, w - 10, 15)];
            __productNameLbl.backgroundColor = [UIColor clearColor];
            __productNameLbl.font = [UIFont systemFontOfSize:11.0];
            __productNameLbl.textColor = [UIColor blackColor];
            __productNameLbl.textAlignment = NSTextAlignmentLeft;
            __productNameLbl.lineBreakMode = NSLineBreakByTruncatingTail;
            __productNameLbl.numberOfLines = 1;
            
            [self addSubview:__productNameLbl];
        }
        
        if (_ProductData.ProductName) {
            [__productNameLbl setText:[_ProductData ProductName]];
        }
        
        if (!__dollarLbl) {
            __dollarLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            __dollarLbl.backgroundColor = [UIColor clearColor];
            __dollarLbl.font = [UIFont boldSystemFontOfSize:10.0];
            __dollarLbl.textColor = [UIColor colorWithRed:0.96 green:0.3 blue:0.42 alpha:1];
            __dollarLbl.textAlignment = NSTextAlignmentRight;
            __dollarLbl.lineBreakMode = NSLineBreakByTruncatingTail;
            __dollarLbl.numberOfLines = 1;
            __dollarLbl.text = @"￥";
            
            [self addSubview:__dollarLbl];
        }
        CGSize dollarSize = [__dollarLbl.text sizeWithFont:__dollarLbl.font];
        [__dollarLbl setFrame:CGRectMake(8, CGRectGetMaxY(__productNameLbl.frame) + 7, dollarSize.width, dollarSize.height)];
        
        if (!__ourPriceLbl) {
            __ourPriceLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            __ourPriceLbl.backgroundColor = [UIColor clearColor];
            __ourPriceLbl.font = [UIFont systemFontOfSize:19.0];
            __ourPriceLbl.textColor = [UIColor colorWithRed:0.96 green:0.3 blue:0.42 alpha:1];
            __ourPriceLbl.textAlignment = NSTextAlignmentCenter;
            __ourPriceLbl.lineBreakMode = NSLineBreakByTruncatingTail;
            __ourPriceLbl.numberOfLines = 1;
            
            [self addSubview:__ourPriceLbl];
        }
        
        if (_ProductData.OurPrice) {
            NSString *ourPrice;
            CGFloat afloat = [_ProductData.OurPrice floatValue];
            if ((afloat * 10) - (int)(afloat * 10) > 0) {
                ourPrice = [NSString stringWithFormat:@"¥%0.2f",[_ProductData.OurPrice floatValue]];
            } else if(afloat - (int)afloat > 0) {
                ourPrice = [NSString stringWithFormat:@"¥%0.1f",[_ProductData.OurPrice floatValue]];
            } else {
                ourPrice = [NSString stringWithFormat:@"¥%0.0f",[_ProductData.OurPrice floatValue]];
            }
            __ourPriceLbl.text = ourPrice;
            
        } else {
            [__ourPriceLbl setText:@"￥"];
        }
        CGSize ourSize = [__ourPriceLbl.text sizeWithFont:__ourPriceLbl.font];
        [__ourPriceLbl setFrame:CGRectMake(CGRectGetMaxX(__dollarLbl.frame), CGRectGetMaxY(__productNameLbl.frame), ourSize.width, 20)];
        
        if (!__marketPriceLbl) {
            __marketPriceLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            __marketPriceLbl.backgroundColor = [UIColor clearColor];
            __marketPriceLbl.font = [UIFont systemFontOfSize:11.0];
            __marketPriceLbl.textColor = [UIColor colorWithRed:0.68 green:0.68 blue:0.68 alpha:1];
            __marketPriceLbl.textAlignment = NSTextAlignmentCenter;
            __marketPriceLbl.lineBreakMode = NSLineBreakByTruncatingTail;
            __marketPriceLbl.numberOfLines = 1;
            
            [self addSubview:__marketPriceLbl];
        }
        
        if (_ProductData.MarketPrice) {
            if ((NSInteger)([_ProductData.MarketPrice floatValue] * 100) % 100 == 0) {
                __marketPriceLbl.text = [NSString stringWithFormat:@"￥%.0f", [_ProductData.MarketPrice floatValue]];
            } else {
                NSString *orderPrice;
                CGFloat afloat = [_ProductData.MarketPrice floatValue];
                if(afloat - (int)afloat > 0) {
                    orderPrice = [NSString stringWithFormat:@"¥%0.1f",[_ProductData.MarketPrice floatValue]];
                } else {
                    orderPrice = [NSString stringWithFormat:@"¥%0.0f",[_ProductData.MarketPrice floatValue]];
                }
                __marketPriceLbl.text = orderPrice;
            }
        } else {
            __marketPriceLbl.text = @"￥";
        }
        CGSize marketSize = [__marketPriceLbl.text sizeWithFont:__marketPriceLbl.font];
        [__marketPriceLbl setFrame:CGRectMake(CGRectGetMaxX(__ourPriceLbl.frame), CGRectGetMaxY(__productNameLbl.frame) + 5, marketSize.width + 4, 16)];
        UILabel *marketLine = [[UILabel alloc] initWithFrame:CGRectMake(3, CGRectGetHeight(__marketPriceLbl.frame)/2 - 0.5, marketSize.width, 0.5)];
        marketLine.backgroundColor = [UIColor colorWithRed:0.68 green:0.68 blue:0.68 alpha:1];
        [__marketPriceLbl addSubview:marketLine];
        
        if (!__discountBg) {
            __discountBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"discount_bg"]];
            [__discountBg setFrame:CGRectZero];
            
            [self addSubview:__discountBg];
        }
        
        if (!__discountLbl) {
            __discountLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            __discountLbl.backgroundColor = [UIColor clearColor];
            __discountLbl.font = [UIFont boldSystemFontOfSize:9.0];
            __discountLbl.textColor = [UIColor colorWithRed:0.96 green:0.3 blue:0.42 alpha:1];
            __discountLbl.textAlignment = NSTextAlignmentRight;
            __discountLbl.lineBreakMode = NSLineBreakByTruncatingTail;
            __discountLbl.numberOfLines = 1;
            
            [__discountBg addSubview:__discountLbl];
        }
        
        if (_ProductData.SaleTip && ![_ProductData.SaleTip isEqualToString:@""]) {
            __discountLbl.text = _ProductData.SaleTip;
        }
        CGSize discountSize = [__discountLbl.text sizeWithFont:__discountLbl.font];
        [__discountBg setFrame:CGRectMake(w - 40, h / kImageFrameRatio + 20, 33, 12)];
        [__discountLbl setFrame:CGRectMake((33 - discountSize.width) / 2 + 3, 0.5, discountSize.width, 11)];
        
        if (!__soldOutImg) {
            __soldOutImg = [[EGOImageView alloc] initWithFrame:CGRectZero];
            [__soldOutImg setFrame:CGRectMake((CGRectGetWidth(__productImgView.frame)- CGRectGetWidth(__productImgView.frame)/5*3)/2, (CGRectGetHeight(__productImgView.frame)-CGRectGetWidth(__productImgView.frame)/5*3)/2, CGRectGetWidth(__productImgView.frame)/5*3, CGRectGetWidth(__productImgView.frame)/5*3)];
            
            [self addSubview:__soldOutImg];
        }
        
        if (!__limitImg) {
            __limitImg = [[EGOImageView alloc] initWithImage:[UIImage imageNamed:@"limit"]];
            [__limitImg setFrame:CGRectMake(10, 16, 44, 44)];
            
            [self addSubview:__limitImg];
        }
        
        if ([_ProductData.stock integerValue] <= 0) {
            if ([_ProductData.SoldOut boolValue]) {
                [__soldOutImg setHidden:NO];
                if ([_ProductData.brand_id integerValue] > 0) {
                    __soldOutImg.image = [UIImage imageNamed:@"icon_salesout"];
                }else{
                    __soldOutImg.image = [UIImage imageNamed:@"icon_brandout"];
                }
            } else {
                [__soldOutImg setHidden:YES];
            }
        }else{
            [__soldOutImg setHidden:YES];
        }
        
        if (_ProductData.Limit) {
            if ([_ProductData.Limit boolValue]) {
                [__limitImg setHidden:NO];
            } else {
                [__limitImg setHidden:YES];
            }
        }else{
            [__limitImg setHidden:YES];
        }
    }
}


- (void)setLikeData:(LikeProductVO *)LikeData
{
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    _LikeData = LikeData;
    
    if (_LikeData) {
        if (!__likeProductImgView) {
            __likeProductImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, w, h/kImageFrameRatio)];
            __likeProductImgView.contentMode = UIViewContentModeScaleAspectFill;
            __likeProductImgView.clipsToBounds = YES;
            
            [self addSubview:__likeProductImgView];
        }
        
        if (_LikeData.imageUrl) {
            NSString * imgUrlStr = [_LikeData imageUrl];
            [__likeProductImgView sd_setImageWithURL:[NSURL URLWithString:imgUrlStr] placeholderImage:[UIImage imageNamed:@"productph"]];
        }
        
        if (!__ourPriceLbl) {
            __ourPriceLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            __ourPriceLbl.backgroundColor = [UIColor clearColor];
            __ourPriceLbl.font = [UIFont systemFontOfSize:13.0];
            __ourPriceLbl.textColor = [UIColor colorWithRed:0.96 green:0.3 blue:0.42 alpha:1];
            __ourPriceLbl.textAlignment = NSTextAlignmentCenter;
            __ourPriceLbl.lineBreakMode = NSLineBreakByTruncatingTail;
            __ourPriceLbl.numberOfLines = 1;
            
            [self addSubview:__ourPriceLbl];
        }
        
        if (_LikeData.salesPrice) {
            NSString *salesPrice;
            CGFloat bfloat = [_LikeData.salesPrice floatValue];
            if ((bfloat * 10) - (int)(bfloat * 10) > 0) {
                salesPrice = [NSString stringWithFormat:@"¥%0.2f",[_LikeData.salesPrice floatValue]];
            } else if(bfloat - (int)bfloat > 0) {
                salesPrice = [NSString stringWithFormat:@"¥%0.1f",[_LikeData.salesPrice floatValue]];
            } else {
                salesPrice = [NSString stringWithFormat:@"¥%0.0f",[_LikeData.salesPrice floatValue]];
            }
            __ourPriceLbl.text = salesPrice;
            
        } else {
            [__ourPriceLbl setText:@"￥"];
        }
        CGSize ourSize = [__ourPriceLbl.text sizeWithFont:__ourPriceLbl.font];
        [__ourPriceLbl setFrame:CGRectMake(CGRectGetMinX(__likeProductImgView.frame), CGRectGetMaxY(__likeProductImgView.frame) + 5, ourSize.width, 20)];
        
        if (!__favImg) {
            __favImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(__likeProductImgView.frame)/2+10, CGRectGetMaxY(__likeProductImgView.frame) + 9, 12, 12)];
            [__favImg setImage:[UIImage imageNamed:@"fav"]];
            [self addSubview:__favImg];
        }
        
        if (!__favNumLbl) {
            __favNumLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(__favImg.frame)+2, CGRectGetMaxY(__likeProductImgView.frame) + 9, CGRectGetMaxX(__likeProductImgView.frame) - CGRectGetMaxX(__favImg.frame)-2, 12)];
            [__favNumLbl setText:@"0"];
            [__favNumLbl setTextColor:[UIColor grayColor]];
            [__favNumLbl setFont:[UIFont systemFontOfSize:11.0]];
            
            [self addSubview:__favNumLbl];
        }
        
        if (_LikeData.favNum) {
            [__favNumLbl setText:[NSString stringWithFormat:@"%@", _LikeData.favNum]];
        }
    }
}

@end
