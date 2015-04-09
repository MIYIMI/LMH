//
//  CategroyCollectionViewCell.m
//  YingMeiHui
//
//  Created by work on 15-1-16.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import "CategroyCollectionViewCell.h"
#import <UIImageView+WebCache.h>

@implementation CategroyCollectionViewCell{
    UIImageView *_imgView;
    UILabel *_titleLbl;
}

//cell视图创建
- (void)layoutView:(CategoryDataModel *)model{
    //列表图片
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (ScreenW/4*3-60)/2, (ScreenW/4*3-60)/2)];
        _imgView.layer.masksToBounds = YES;
        _imgView.layer.cornerRadius  = (ScreenW/4*3-60)/4;
        [self.contentView addSubview:_imgView];
    }
    [_imgView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"place_2"]];
    //列表标题
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_imgView.frame), (ScreenW/4*3-60)/2, (ScreenW/4*3-60)/2*0.3)];
        [_titleLbl setFont:[UIFont systemFontOfSize:14.0f]];
        [_titleLbl setTextColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1]];
        [_titleLbl setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:_titleLbl];
    }
    [_titleLbl setText:model.title];
}

@end
