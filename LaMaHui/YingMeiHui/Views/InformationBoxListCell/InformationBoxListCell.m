//
//  InformationBoxListCell.m
//  YingMeiHui
//
//  Created by Zhumingming on 15-3-26.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import "InformationBoxListCell.h"

@implementation InformationBoxListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    [self createUI];
}
- (void)createUI
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20*ScreenW/720,25*ScreenW/720,80*ScreenW/720,80*ScreenW/720)];
    imageView.backgroundColor = [UIColor greenColor];
//    imageView.image = [UIImage imageNamed:@"pulldown"];
    [self addSubview:imageView];
    
    UILabel *styleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+10 , CGRectGetMinY(imageView.frame), 35, 20)];
    styleLabel.layer.borderColor = [GRAY_LINE_COLOR CGColor];
    styleLabel.layer.borderWidth = 0.5;
    styleLabel.layer.masksToBounds = YES;
    styleLabel.layer.cornerRadius = 2.0;
    styleLabel.backgroundColor = [UIColor clearColor];
    styleLabel.text = @"退款";
    styleLabel.textColor = GRAY_LINE_COLOR;
    styleLabel.textAlignment = NSTextAlignmentCenter;
    styleLabel.font = FONT(13);
    [self.contentView addSubview:styleLabel];
    
    
    
}

@end
