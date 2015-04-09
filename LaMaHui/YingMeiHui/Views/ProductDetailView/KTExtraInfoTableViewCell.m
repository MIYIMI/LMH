//
//  KTExtraInfoTableViewCell.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-10.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTExtraInfoTableViewCell.h"
#import "ExtraInfoVO.h"

#define BACKGROUND_COLOR            [UIColor clearColor]

@interface KTExtraInfoTableViewCell ()
{
    UILabel *__titleLbl;
    UILabel *__infoLbl;
    UIImageView *__dotline;
}

@end

@implementation KTExtraInfoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:BACKGROUND_COLOR];
        [[self contentView] setBackgroundColor:BACKGROUND_COLOR];
        if (!__dotline) {
            __dotline = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellline"]];
            [__dotline setFrame:CGRectZero];
            [self.contentView addSubview:__dotline];
        }
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

- (void)setExtraInfoData:(ExtraInfoVO *)ExtraInfoData
{
    _ExtraInfoData = ExtraInfoData;
    
    if (_ExtraInfoData) {
        if (!__titleLbl) {
            __titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, (self.frame.size.height - 14) / 2, 35, 14)];
            __titleLbl.backgroundColor = [UIColor clearColor];
            __titleLbl.font = [UIFont systemFontOfSize:15.0];
            __titleLbl.textColor = [UIColor colorWithRed:0.61 green:0.61 blue:0.61 alpha:1];
            __titleLbl.textAlignment = NSTextAlignmentLeft;
            __titleLbl.lineBreakMode = NSLineBreakByCharWrapping;
            __titleLbl.numberOfLines = 0;
            
            [self.contentView addSubview:__titleLbl];
        }
        
        if (_ExtraInfoData.Title) {
            [__titleLbl setText:[NSString stringWithFormat:@"%@：", [_ExtraInfoData Title]]];
        }
        
        if (!__infoLbl) {
            __infoLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, (self.frame.size.height - 14) / 2, CGRectGetMaxX(__titleLbl.frame)+2, 14)];
            __infoLbl.backgroundColor = [UIColor clearColor];
            __infoLbl.font = [UIFont systemFontOfSize:15.0];
            __infoLbl.textColor = [UIColor blackColor];
            __infoLbl.textAlignment = NSTextAlignmentLeft;
            __infoLbl.lineBreakMode = NSLineBreakByCharWrapping;
            __infoLbl.numberOfLines = 0;
            
            [self.contentView addSubview:__infoLbl];
        }
        
        if (_ExtraInfoData.Info) {
            [__infoLbl setText:[_ExtraInfoData Info]];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize labelsize = [__titleLbl.text sizeWithFont:__titleLbl.font constrainedToSize:CGSizeMake(235, 100000) lineBreakMode:__titleLbl.lineBreakMode];
    __titleLbl.frame = CGRectMake(10.0, (self.frame.size.height - 14)/2, labelsize.width, 14);
    
    CGSize infosize = [__infoLbl.text sizeWithFont:__infoLbl.font constrainedToSize:CGSizeMake(235, 100000) lineBreakMode:__infoLbl.lineBreakMode];
    [__infoLbl setFrame:CGRectMake(CGRectGetMaxX(__titleLbl.frame), CGRectGetMinY(__titleLbl.frame), 235, infosize.height)];
    [__dotline setFrame:CGRectMake(11, CGRectGetMaxY(self.contentView.frame) - 1, 298, 0.5)];
}

@end
