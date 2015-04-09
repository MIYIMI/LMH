//
//  KTBrandListTableViewCell.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-3-31.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTBrandListTableViewCell.h"
#import "EGOImageView.h"
#import "BrandVO.h"
#import <QuartzCore/QuartzCore.h>

#define kTopicImagePadding          5.0f
#define kImageFrameRatio            1.75f
#define BACKGROUND_COLOR            [UIColor clearColor]

@interface KTBrandListTableViewCell ()
{
    UIView *__brandFrameView;
    EGOImageView *__brandImgView;
    UILabel *__brandNameLbl;
    UILabel *__saleTipLbl;
    UILabel *__leftTimeLbl;
    UILabel *__timeBgLbl;
    UILabel *__activityLbl;
    UIImageView *__activityBg;
}

@end

@implementation KTBrandListTableViewCell

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

- (void)setBrandData:(BrandVO *)BrandData
{
    _BrandData = BrandData;
    
    if (_BrandData) {
        if (!__brandFrameView) {
            __brandFrameView = [[UIView alloc] initWithFrame:CGRectZero];
            [__brandFrameView setBackgroundColor:[UIColor whiteColor]];
            
            [self.contentView addSubview:__brandFrameView];
        }
        
        if (!__brandImgView) {
            __brandImgView = [[EGOImageView alloc] initWithFrame:CGRectZero];
            __brandImgView.placeholderImage = [UIImage imageNamed:@"brandph"];
            __brandImgView.contentMode = UIViewContentModeScaleAspectFill;
            __brandImgView.clipsToBounds = YES;
            
            [__brandFrameView addSubview:__brandImgView];
        }
        
        if (_BrandData.Pic) {
            NSString * imgUrlStr = [_BrandData Pic];
            [__brandImgView setImageURL:[NSURL URLWithString:imgUrlStr]];
        }
        
        if (!__brandNameLbl) {
            __brandNameLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            __brandNameLbl.backgroundColor = [UIColor clearColor];
            __brandNameLbl.font = [UIFont systemFontOfSize:14.0];
            __brandNameLbl.textColor = [UIColor blackColor];
            __brandNameLbl.textAlignment = NSTextAlignmentLeft;
            __brandNameLbl.lineBreakMode = NSLineBreakByTruncatingTail;
            __brandNameLbl.numberOfLines = 1;
            
            [__brandFrameView addSubview:__brandNameLbl];
        }
        
        if (_BrandData.BrandName) {
            [__brandNameLbl setText:[_BrandData BrandName]];
        }
        
        if (!__saleTipLbl) {
            __saleTipLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            __saleTipLbl.backgroundColor = [UIColor clearColor];
            __saleTipLbl.font = [UIFont boldSystemFontOfSize:14.0];
            __saleTipLbl.textColor = [UIColor colorWithRed:0.99 green:0.45 blue:0.01 alpha:1];
            __saleTipLbl.textAlignment = NSTextAlignmentRight;
            __saleTipLbl.lineBreakMode = NSLineBreakByTruncatingTail;
            __saleTipLbl.numberOfLines = 1;
            
            [__brandFrameView addSubview:__saleTipLbl];
        }
        
        if (_BrandData.SaleTip) {
            [__saleTipLbl setText:[_BrandData SaleTip]];
        }
        
        if (!__timeBgLbl) {
            __timeBgLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            __timeBgLbl.backgroundColor = [UIColor colorWithRed:0.13 green:0.18 blue:0.22 alpha:0.8];
            
            UIImageView *clock = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clocktime"]];
            [clock setFrame:CGRectMake(4, 3, 13, 13)];
            [__timeBgLbl addSubview:clock];
            
            [__brandFrameView addSubview:__timeBgLbl];
        }
        
        if (!__leftTimeLbl) {
            __leftTimeLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            __leftTimeLbl.backgroundColor = [UIColor clearColor];
            __leftTimeLbl.font = [UIFont systemFontOfSize:12.0];
            __leftTimeLbl.textColor = [UIColor colorWithRed:0.76 green:0.78 blue:0.8 alpha:1];
            __leftTimeLbl.textAlignment = NSTextAlignmentRight;
            __leftTimeLbl.lineBreakMode = NSLineBreakByTruncatingTail;
            __leftTimeLbl.numberOfLines = 1;
            
            [__brandFrameView addSubview:__leftTimeLbl];
        }
        
        if (_BrandData.SellTimeTo) {
            NSInteger interval = [_BrandData.SellTimeTo integerValue] -  [[NSDate date] timeIntervalSince1970];
            if (interval > 0) {
                NSInteger days = interval/3600/24;
                NSInteger hours = interval/3600;
                NSInteger mins = (interval%3600)/60;
                NSInteger seconds = interval%60;
                
                if (days > 0) {
                    [__leftTimeLbl setText:[NSString stringWithFormat:@"剩%zi天", days]];
                } else if (hours > 0) {
                    [__leftTimeLbl setText:[NSString stringWithFormat:@"剩%zi小时", hours]];
                } else if (mins > 0) {
                    [__leftTimeLbl setText:[NSString stringWithFormat:@"剩%zi分钟", mins]];
                } else if (seconds > 0) {
                    [__leftTimeLbl setText:[NSString stringWithFormat:@"剩%zi秒钟", seconds]];
                } else {
                    [__leftTimeLbl setText:@"已结束"];
                }
            }
            
            [__saleTipLbl setText:[_BrandData SaleTip]];
        }
        
        if (_BrandData.ActivityTip && ![_BrandData.ActivityTip isEqualToString:@""]) {
            if (!__activityBg) {
                UIImage *image = [UIImage imageNamed:@"activitytipbg"];
                image = [image stretchableImageWithLeftCapWidth:10.0f topCapHeight:10.0f];
                __activityBg = [[UIImageView alloc] initWithImage:image];
                [__brandFrameView addSubview:__activityBg];
            }
        }
        
        if (!__activityLbl) {
            __activityLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            __activityLbl.backgroundColor = [UIColor clearColor];
            __activityLbl.font = [UIFont systemFontOfSize:14.0];
            __activityLbl.textColor = [UIColor blackColor];
            __activityLbl.textAlignment = NSTextAlignmentCenter;
            __activityLbl.lineBreakMode = NSLineBreakByTruncatingTail;
            __activityLbl.numberOfLines = 1;
            
            [__brandFrameView addSubview:__activityLbl];
        }
        
        if (_BrandData.ActivityTip && ![_BrandData.ActivityTip isEqualToString:@""]) {
            [__activityLbl setText:[_BrandData ActivityTip]];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat w = 300.0f;
    
    [__brandFrameView setFrame:CGRectMake(10, kTopicImagePadding, w, w/kImageFrameRatio)];
    [__brandImgView setFrame:CGRectMake(0, 0, CGRectGetWidth(__brandFrameView.frame), CGRectGetHeight(__brandFrameView.frame) - 28.0)];
    [__brandNameLbl setFrame:CGRectMake(5, CGRectGetMaxY(__brandImgView.frame), w - 10, 28)];
    [__saleTipLbl setFrame:CGRectMake(0, CGRectGetMaxY(__brandImgView.frame), w - 10, 28)];
    
    CGSize leftTimeSize = [__leftTimeLbl.text sizeWithFont:__leftTimeLbl.font];
    [__leftTimeLbl setFrame:CGRectMake(CGRectGetMaxX(__brandImgView.frame) - leftTimeSize.width - 23, 0, leftTimeSize.width + 20, 18)];
    [__timeBgLbl setFrame:CGRectMake(CGRectGetMinX(__leftTimeLbl.frame), 0, CGRectGetMaxX(__brandImgView.frame) - CGRectGetMinX(__leftTimeLbl.frame), 18)];
    
    CGSize activityTipSize = [__activityLbl.text sizeWithFont:__activityLbl.font];
    [__activityLbl setFrame:CGRectMake(-2, 118, activityTipSize.width + 15, 21)];
    [__activityBg setFrame:__activityLbl.frame];
    
//    __brandFrameView.layer.shadowColor = [UIColor grayColor].CGColor;
//    __brandFrameView.layer.shadowOpacity = 0.4;
//    __brandFrameView.layer.shadowOffset = CGSizeMake(0, 0);
//    __brandFrameView.layer.shadowPath = [UIBezierPath bezierPathWithRect:__brandFrameView.bounds].CGPath;
}

- (void)prepareForReuse
{
    __brandImgView.imageURL = nil;
}

@end
