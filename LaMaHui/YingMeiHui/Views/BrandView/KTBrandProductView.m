//
//  KTBrandProductView.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-6-17.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTBrandProductView.h"
#import "EGOImageView.h"
#import "MenuItemVO.h"
#import <QuartzCore/QuartzCore.h>

#define kImageFrameRatio            1.0f
#define BACKGROUND_COLOR            [UIColor whiteColor]

@interface KTBrandProductView ()
{
    EGOImageView *__productImgView;
    EGOImageView *__logoImgView;
    UILabel *__sepratorLine;
    
    UILabel *__saleTipLbl;
    UILabel *__saleInfoLbl;
    
    UILabel *__dollarLbl;
    UILabel *__ourPriceLbl;
    UILabel *__marketPriceLbl;
    UILabel *__discountLbl;
    UIImageView *__discountBg;
}

@end

@implementation KTBrandProductView

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

- (void)setItemData:(MenuItemVO *)ItemData
{
    CGFloat w = self.bounds.size.width;
    //CGFloat h = self.bounds.size.height;
    _ItemData = ItemData;
    
    if (_ItemData) {
        if (!__productImgView) {
            __productImgView = [[EGOImageView alloc] initWithFrame:CGRectMake(0, 0, w, w / kImageFrameRatio)];
            __productImgView.placeholderImage = [UIImage imageNamed:@"productph"];
            __productImgView.contentMode = UIViewContentModeScaleAspectFill;
            __productImgView.clipsToBounds = YES;
            
            [self addSubview:__productImgView];
        }
        
        if (_ItemData.Pic) {
            //NSString * imgUrlStr = [NSString stringWithFormat:@"%@!199x199", [ItemData Pic]];
            NSString * imgUrlStr = [ItemData Pic];
            [__productImgView setImageURL:[NSURL URLWithString:imgUrlStr]];
        }
        
        if (!__logoImgView) {
            __logoImgView = [[EGOImageView alloc] initWithFrame:CGRectMake(10, w / kImageFrameRatio + 6, w / 2 - 20, 25)];
            __logoImgView.placeholderImage = [UIImage imageNamed:@"place_2"];
            __logoImgView.contentMode = UIViewContentModeScaleAspectFill;
            __logoImgView.clipsToBounds = YES;
            
            [self addSubview:__logoImgView];
        }
        
        if (_ItemData.LogoPic) {
            NSString * imgUrlStr = [_ItemData LogoPic];
            [__logoImgView setImageURL:[NSURL URLWithString:imgUrlStr]];
        }
        
        if (!__sepratorLine) {
            __sepratorLine = [[UILabel alloc] initWithFrame:CGRectMake(w / 2, w / kImageFrameRatio + 7, 0.5, 23.5)];
            [__sepratorLine setBackgroundColor:[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1]];
            
            [self addSubview:__sepratorLine];
        }
        
        if ([_ItemData.ItemType integerValue] == 1) {               // 品牌Item
            if (!__saleTipLbl) {
                __saleTipLbl = [[UILabel alloc] initWithFrame:CGRectZero];
                __saleTipLbl.backgroundColor = [UIColor clearColor];
                __saleTipLbl.font = [UIFont boldSystemFontOfSize:17.0];
                __saleTipLbl.textColor = [UIColor colorWithRed:0.96 green:0.3 blue:0.42 alpha:1];
                __saleTipLbl.textAlignment = NSTextAlignmentCenter;
                __saleTipLbl.lineBreakMode = NSLineBreakByTruncatingTail;
                __saleTipLbl.numberOfLines = 1;
                
                [self addSubview:__saleTipLbl];
            }
            
            if (_ItemData.SaleTip) {
                [__saleTipLbl setText:_ItemData.SaleTip];
            }
            CGSize saleTipSize = [__saleTipLbl.text sizeWithFont:__saleTipLbl.font];
            
            if (!__saleInfoLbl) {
                __saleInfoLbl = [[UILabel alloc] initWithFrame:CGRectZero];
                __saleInfoLbl.backgroundColor = [UIColor clearColor];
                __saleInfoLbl.font = [UIFont systemFontOfSize:10.0];
                __saleInfoLbl.textColor = [UIColor blackColor];
                __saleInfoLbl.textAlignment = NSTextAlignmentRight;
                __saleInfoLbl.lineBreakMode = NSLineBreakByTruncatingTail;
                __saleInfoLbl.numberOfLines = 1;
                
                [self addSubview:__saleInfoLbl];
            }
            
            if (_ItemData.SaleInfo) {
                [__saleInfoLbl setText:_ItemData.SaleInfo];
            }
            CGSize saleInfoSize = [__saleInfoLbl.text sizeWithFont:__saleInfoLbl.font];
            
            [__saleTipLbl setFrame:CGRectMake((w / 2 - saleInfoSize.width - saleTipSize.width - 3) / 2 + w / 2, w / kImageFrameRatio + 6, saleTipSize.width, 25)];
            [__saleInfoLbl setFrame:CGRectMake(CGRectGetMaxX(__saleTipLbl.frame) + 3, w / kImageFrameRatio + 6, saleInfoSize.width, 25)];
        }
    }
}

@end
