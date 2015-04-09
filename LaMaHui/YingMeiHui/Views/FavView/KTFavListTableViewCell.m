//
//  KTFavListTableViewCell.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-6-25.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTFavListTableViewCell.h"
#import "EGOImageView.h"
#import "FavListCellVO.h"
#import <QuartzCore/QuartzCore.h>

#define BACKGROUND_COLOR            [UIColor clearColor]

@interface KTFavListTableViewCell ()
{
    EGOImageView *__productImgView;
    UILabel *__productNameLbl;
    UILabel *__ourPriceLbl;
    UILabel *__marketPriceLbl;
    UILabel *__marketLineLbl;
    UILabel *__saleTipLbl;
    UILabel *__favTimeLbl;
}

@end

@implementation KTFavListTableViewCell

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

- (void)setFavData:(FavListCellVO *)FavData
{
    _FavData = FavData;
    
    if (_FavData) {
        CGFloat w = CGRectGetWidth([[UIScreen mainScreen] bounds]);
        
        if (!__productImgView) {
            __productImgView = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 7, 60, 60)];
            __productImgView.placeholderImage = [UIImage imageNamed:@"productph"];
            __productImgView.contentMode = UIViewContentModeScaleAspectFill;
            __productImgView.clipsToBounds = YES;
            
            [self.contentView addSubview:__productImgView];
        }
        
        if (_FavData.Pic) {
            NSString * imgUrlStr = [_FavData Pic];
            [__productImgView setImageURL:[NSURL URLWithString:imgUrlStr]];
        }
        
        if (!__productNameLbl) {
            __productNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(__productImgView.frame) + 8, CGRectGetMinY(__productImgView.frame), 230, 32)];
            __productNameLbl.backgroundColor = [UIColor clearColor];
            __productNameLbl.font = [UIFont systemFontOfSize:13.0];
            __productNameLbl.textColor = [UIColor blackColor];
            __productNameLbl.textAlignment = NSTextAlignmentLeft;
            __productNameLbl.lineBreakMode = NSLineBreakByTruncatingTail;
            __productNameLbl.numberOfLines = 2;
            
            [self.contentView addSubview:__productNameLbl];
        }
        
        if (_FavData.ProductName) {
            [__productNameLbl setText:[_FavData ProductName]];
        }
        
        if (!__ourPriceLbl) {
            __ourPriceLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            __ourPriceLbl.backgroundColor = [UIColor clearColor];
            __ourPriceLbl.font = [UIFont systemFontOfSize:13.0];
            __ourPriceLbl.textColor = [UIColor colorWithRed:0.98 green:0.3 blue:0.4 alpha:1];
            __ourPriceLbl.textAlignment = NSTextAlignmentLeft;
            
            [self.contentView addSubview:__ourPriceLbl];
        }
        
        if (_FavData.OurPrice) {
            [__ourPriceLbl setText:[NSString stringWithFormat:@"%.2f元", [_FavData.OurPrice floatValue]]];
        }
        
        if (!__marketPriceLbl) {
            __marketPriceLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            __marketPriceLbl.backgroundColor = [UIColor clearColor];
            __marketPriceLbl.font = [UIFont systemFontOfSize:12.0];
            __marketPriceLbl.textColor = [UIColor colorWithRed:0.67 green:0.67 blue:0.67 alpha:1];
            __marketPriceLbl.textAlignment = NSTextAlignmentLeft;
            
            [self.contentView addSubview:__marketPriceLbl];
        }
        
        if (_FavData.MarketPrice) {
            [__marketPriceLbl setText:[NSString stringWithFormat:@"%.2f", [_FavData.MarketPrice floatValue]]];
        }
        
        if (!__marketLineLbl) {
            __marketLineLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            [__marketLineLbl setBackgroundColor:[UIColor colorWithRed:0.67 green:0.67 blue:0.67 alpha:1]];
            
            [self.contentView addSubview:__marketLineLbl];
        }
        
        if (!__saleTipLbl) {
            __saleTipLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            __saleTipLbl.backgroundColor = [UIColor clearColor];
            __saleTipLbl.font = [UIFont systemFontOfSize:12.0];
            __saleTipLbl.textColor = [UIColor colorWithRed:0.67 green:0.67 blue:0.67 alpha:1];
            __saleTipLbl.textAlignment = NSTextAlignmentLeft;
            
            [self.contentView addSubview:__saleTipLbl];
        }
        
        if (_FavData.SaleTip) {
            [__saleTipLbl setText:[NSString stringWithFormat:@"%.1f折", [_FavData.SaleTip floatValue]]];
        }
        
        if (!__favTimeLbl) {
            __favTimeLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(__productNameLbl.frame), 59, w - CGRectGetMinX(__productNameLbl.frame) - 10, 12)];
            __favTimeLbl.backgroundColor = [UIColor clearColor];
            __favTimeLbl.font = [UIFont systemFontOfSize:11.0];
            __favTimeLbl.textColor = [UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:1];
            __favTimeLbl.textAlignment = NSTextAlignmentRight;
            
            [self.contentView addSubview:__favTimeLbl];
        }
        
        if (_FavData.FavTime) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSString *dateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[_FavData.FavTime longLongValue]]];
            [__favTimeLbl setText:dateStr];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize ourPriceSize = [__ourPriceLbl.text sizeWithFont:__ourPriceLbl.font];
    [__ourPriceLbl setFrame:CGRectMake(CGRectGetMinX(__productNameLbl.frame), CGRectGetMaxY(__productNameLbl.frame), ourPriceSize.width + 12, 16)];
    CGSize marketPriceSize = [__marketPriceLbl.text sizeWithFont:__marketPriceLbl.font];
    [__marketPriceLbl setFrame:CGRectMake(CGRectGetMaxX(__ourPriceLbl.frame), CGRectGetMinY(__ourPriceLbl.frame) + 2, marketPriceSize.width, 12)];
    [__marketLineLbl setFrame:CGRectMake(CGRectGetMinX(__marketPriceLbl.frame), CGRectGetMinY(__marketPriceLbl.frame) + marketPriceSize.height / 2 - 1.5, marketPriceSize.width, 1.0)];
    CGSize saleSize = [__saleTipLbl.text sizeWithFont:__saleTipLbl.font];
    [__saleTipLbl setFrame:CGRectMake(CGRectGetMinX(__ourPriceLbl.frame), CGRectGetMaxY(__ourPriceLbl.frame), saleSize.width, 16)];
}

- (void)prepareForReuse
{
    __productImgView.imageURL = nil;
}

@end
