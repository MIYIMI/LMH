//
//  KTQAContentTableViewCell.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-7-3.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTQAContentTableViewCell.h"

#define BACKGROUND_COLOR            [UIColor clearColor]

@interface KTQAContentTableViewCell ()
{
    UILabel *__contentBg;
    UILabel *__contentLbl;
}

@end

@implementation KTQAContentTableViewCell

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

- (void)setQaContent:(NSString *)qaContent
{
    _qaContent = qaContent;
    
    if (_qaContent) {
        if (!__contentBg) {
            __contentBg = [[UILabel alloc] initWithFrame:CGRectZero];
            __contentBg.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
            
            [self.contentView addSubview:__contentBg];
        }
        
        if (!__contentLbl) {
            __contentLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            __contentLbl.backgroundColor = [UIColor clearColor];
            __contentLbl.font = [UIFont systemFontOfSize:11.0];
            __contentLbl.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
            __contentLbl.textAlignment = NSTextAlignmentLeft;
            __contentLbl.lineBreakMode = NSLineBreakByCharWrapping;
            __contentLbl.numberOfLines = 0;
            
            [self.contentView addSubview:__contentLbl];
        }
        
        if (_qaContent) {
            [__contentLbl setText:_qaContent];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat w = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    CGSize contentSize = [__contentLbl.text sizeWithFont:__contentLbl.font constrainedToSize:CGSizeMake(w - 34, 10000) lineBreakMode:__contentLbl.lineBreakMode];
    [__contentBg setFrame:CGRectMake(10, 0, w - 20, contentSize.height + 14)];
    [__contentLbl setFrame:CGRectMake(17, 7, contentSize.width, contentSize.height)];
}

@end
