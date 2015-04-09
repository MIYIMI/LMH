//
//  TrackInfoCell.m
//  YingMeiHui
//
//  Created by Zhumingming on 14-11-6.
//  Copyright (c) 2014年 xieyanke. All rights reserved.
//

#import "TrackInfoCell.h"

@implementation TrackInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    _trackAddressInfoLabel = [[UILabel alloc]init];//WithFrame:CGRectMake(40, 12, ScreenW - 60, 50)];
    _trackAddressInfoLabel.numberOfLines = 0;
    _trackAddressInfoLabel.backgroundColor = [UIColor clearColor];
    _trackAddressInfoLabel.font = LMH_FONT_14;
    [self.contentView addSubview:_trackAddressInfoLabel];
    
    
    _trackTimeInfoLabel = [[UILabel alloc]init];//WithFrame:CGRectMake(40, 50 + 15, ScreenW - 60, 30)];
    _trackTimeInfoLabel.backgroundColor = [UIColor clearColor];
    _trackTimeInfoLabel.font = LMH_FONT_13;
    [self.contentView addSubview:_trackTimeInfoLabel];
    
    
    _lineView = [[UIView alloc]initWithFrame:CGRectZero];
    _lineView.backgroundColor = LMH_COLOR_LIGHTLINE;
    [self.contentView addSubview:_lineView];
    
    if (!imgview) {
        imgview = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self addSubview:imgview];
    }
}

- (void)configContent:(TrackInfoModel *)model andRow:(NSInteger)row andCount:(NSInteger)cout
{
    
    self.trackAddressInfoLabel.text = model.contentText;
    self.trackTimeInfoLabel.text    = model.contentTime;
    
    //计算label高度 --
    CGSize labelSize = [self.trackAddressInfoLabel.text sizeWithFont:LMH_FONT_14 constrainedToSize:CGSizeMake(260, 1000)];
    _trackAddressInfoLabel.frame = CGRectMake(40, 10, 260, labelSize.height);
    if (row == 0) {
        imgview.image = [UIImage imageNamed:@"icon_trackOne"];
        imgview.frame = CGRectMake(5, 20, 30, 80);
    }else if(row == cout - 1){
        imgview.image = [UIImage imageNamed:@"icon_trackThree"];
        imgview.frame = CGRectMake(5, -20, 30, 60);
    }else{
        imgview.image = [UIImage imageNamed:@"icon_trackTwo"];
        imgview.frame = CGRectMake(5, 0, 30, labelSize.height + 40);
    }
    
    _trackTimeInfoLabel.frame = CGRectMake(40, labelSize.height + 10, 260, 30);
    _lineView.frame = CGRectMake(40, labelSize.height+40-1, FULL_HEIGHT - 40, 0.5);
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

@end
