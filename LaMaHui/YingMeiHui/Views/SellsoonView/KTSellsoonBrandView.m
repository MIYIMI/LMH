//
//  KTSellsoonBrandView.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-1.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTSellsoonBrandView.h"
#import "EGOImageView.h"
#import "SellsoonbrandVO.h"
#import <QuartzCore/QuartzCore.h>

#define kImageFrameRatio            1.085f
#define BACKGROUND_COLOR            [UIColor whiteColor]

@interface KTSellsoonBrandView ()
{
    EGOImageView *__brandImgView;
    UILabel *__brandNameLbl;
    UILabel *__isSubscribedLbl;
    UIView *__isSubBgView;
    UIImageView *__subLblImg;
}

@end

@implementation KTSellsoonBrandView

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

- (void)setSellsoonBrandData:(SellsoonbrandVO *)SellsoonBrandData
{
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    _SellsoonBrandData = SellsoonBrandData;
    
    if (_SellsoonBrandData) {
        if (!__brandImgView) {
            __brandImgView = [[EGOImageView alloc] initWithFrame:CGRectMake(0, 0, w, w / kImageFrameRatio)];
            __brandImgView.placeholderImage = [UIImage imageNamed:@"productph"];
            __brandImgView.contentMode = UIViewContentModeScaleAspectFill;
            __brandImgView.clipsToBounds = YES;
            
            [self addSubview:__brandImgView];
        }
        
        if (_SellsoonBrandData.Pic) {
            NSString * imgUrlStr = [_SellsoonBrandData Pic];
            [__brandImgView setImageURL:[NSURL URLWithString:imgUrlStr]];
        }
        
        if (!__brandNameLbl) {
            __brandNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(5, w / kImageFrameRatio, w - 10, h - w / kImageFrameRatio)];
            __brandNameLbl.backgroundColor = [UIColor clearColor];
            __brandNameLbl.font = [UIFont systemFontOfSize:14.0];
            __brandNameLbl.textColor = [UIColor colorWithRed:0.35 green:0.35 blue:0.35 alpha:1];
            __brandNameLbl.textAlignment = NSTextAlignmentCenter;
            __brandNameLbl.lineBreakMode = NSLineBreakByTruncatingTail;
            __brandNameLbl.numberOfLines = 1;
            
            [self addSubview:__brandNameLbl];
        }
        
        if (_SellsoonBrandData.BrandName) {
            [__brandNameLbl setText:[_SellsoonBrandData BrandName]];
        }
        
        if (!__isSubscribedLbl) {
            __isSubscribedLbl = [[UILabel alloc] initWithFrame:CGRectMake((w - 62) / 2, (w / kImageFrameRatio - 25) / 2, 62, 25)];
            __isSubscribedLbl.backgroundColor = [UIColor clearColor];
            __isSubscribedLbl.font = [UIFont boldSystemFontOfSize:14.0];
            __isSubscribedLbl.textAlignment = NSTextAlignmentCenter;
            __isSubscribedLbl.lineBreakMode = NSLineBreakByTruncatingTail;
            __isSubscribedLbl.numberOfLines = 1;
            
            [self addSubview:__isSubscribedLbl];
        }
        
        if (!__isSubBgView) {
            __isSubBgView = [[UIView alloc] initWithFrame:__isSubscribedLbl.frame];
            __isSubBgView.backgroundColor = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:0.7];
            __isSubBgView.layer.cornerRadius = 5.0;
            
            [self insertSubview:__isSubBgView belowSubview:__isSubscribedLbl];
        }
        
        if (_SellsoonBrandData.IsSubscribed) {
            if (![_SellsoonBrandData.IsSubscribed boolValue]) {
                [__isSubscribedLbl setTextColor:[UIColor colorWithRed:0.99 green:0.48 blue:0.02 alpha:1]];
                [__isSubscribedLbl setText:@"    订阅"];
                
                if (!__subLblImg) {
                    __subLblImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nosubscribed"]];
                    [__subLblImg setFrame:CGRectMake(10, 8, 10, 10)];
                    
                    [__isSubscribedLbl addSubview:__subLblImg];
                }
            } else {
                [__isSubscribedLbl setTextColor:[UIColor colorWithRed:0.39 green:0.39 blue:0.39 alpha:1]];
                [__isSubscribedLbl setText:@"   已订阅"];
                
                if (!__subLblImg) {
                    __subLblImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"subscribed"]];
                    [__subLblImg setFrame:CGRectMake(4, 9, 11, 8)];
                    
                    [__isSubscribedLbl addSubview:__subLblImg];
                }
            }
        }
    }
}

@end
