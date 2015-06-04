//
//  LMH_ToolTableViewCell.m
//  YingMeiHui
//
//  Created by work on 15/5/27.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import "LMH_ToolTableViewCell.h"

#define SPACE_HEIGHT    10.0f

@interface LMH_ToolTableViewCell(){
    UIButton *favBtn;
    UIButton *reviewBtn;
    UIButton *shareBtn;
    
    CampaignVO *_camvo;
    NSDictionary *toolDict;
}

@end

@implementation LMH_ToolTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)layoutUI:(id)camvo and_home:(BOOL)flag{
    if ([camvo isKindOfClass:[CampaignVO class]]) {
        _camvo = camvo;
    }else if ([camvo isKindOfClass:[NSDictionary class]]){
        toolDict = camvo;
        _camvo = [[CampaignVO alloc] init];
        _camvo.like_count = toolDict[@"favcount"];
        _camvo.comment_count = toolDict[@"evaluate"];
        _camvo.campaign_goods_count = @"分享";
    }
    
    if (!favBtn) {
        favBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        favBtn.frame = CGRectMake(SPACE_HEIGHT, SPACE_HEIGHT, (ScreenW-2*SPACE_HEIGHT)/3, 20);
        favBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        favBtn.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
        [favBtn setImage:LOCAL_IMG(@"new_fav") forState:UIControlStateNormal];
        [favBtn.titleLabel setFont:LMH_FONT_15];
        [favBtn setTitleColor:LMH_COLOR_BLACK forState:UIControlStateNormal];
        favBtn.tag = 10001;
        [favBtn addTarget:self action:@selector(toolClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:favBtn];
    }
    if ([toolDict[@"fav"] boolValue]) {
        [favBtn setImage:LOCAL_IMG(@"new_favis") forState:UIControlStateNormal];
    }else{
        [favBtn setImage:LOCAL_IMG(@"new_fav") forState:UIControlStateNormal];
    }
    NSString *favTitle = [NSString stringWithFormat:@"喜欢(%zi)",[_camvo.like_count intValue]];
    [favBtn setTitle:favTitle forState:UIControlStateNormal];
    
    if (!reviewBtn) {
        reviewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        reviewBtn.frame = CGRectMake(CGRectGetMaxX(favBtn.frame), CGRectGetMinY(favBtn.frame), (ScreenW-2*SPACE_HEIGHT)/3, 20);
        reviewBtn.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
        reviewBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
        [reviewBtn setImage:LOCAL_IMG(@"new_coment") forState:UIControlStateNormal];
        [reviewBtn setTitleColor:LMH_COLOR_BLACK forState:UIControlStateNormal];
        [reviewBtn.titleLabel setFont:LMH_FONT_15];
        reviewBtn.tag = 10002;
        [reviewBtn addTarget:self action:@selector(toolClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [reviewBtn setImageEdgeInsets:UIEdgeInsetsMake(2, 0, 0, 0)];
        
        [self.contentView addSubview:reviewBtn];
    }
    NSString *reviewTitle = [NSString stringWithFormat:@"评论(%zi)",[_camvo.comment_count intValue]];
    [reviewBtn setTitle:reviewTitle forState:UIControlStateNormal];
    
    if (!shareBtn) {
        shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        shareBtn.frame = CGRectMake(CGRectGetMaxX(reviewBtn.frame), CGRectGetMinY(favBtn.frame), (ScreenW-2*SPACE_HEIGHT)/3, 20);
        shareBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        shareBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [shareBtn.titleLabel setFont:LMH_FONT_15];
        [shareBtn setTitleColor:LMH_COLOR_BLACK forState:UIControlStateNormal];
        [shareBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
        shareBtn.tag = 10003;
        [shareBtn addTarget:self action:@selector(toolClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:shareBtn];
    }
    [shareBtn setImage:LOCAL_IMG(@"new_share") forState:UIControlStateNormal];
    if (flag) {
        [shareBtn setTitle:_camvo.campaign_goods_count forState:UIControlStateNormal];
        [shareBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 20)];
        [shareBtn setImageEdgeInsets:UIEdgeInsetsMake(0, CGRectGetWidth(shareBtn.frame)/5*4, 0, 0)];
        [shareBtn setImage:LOCAL_IMG(@"new_rightrow") forState:UIControlStateNormal];
    }
    [shareBtn setTitle:_camvo.campaign_goods_count forState:UIControlStateNormal];
}

- (void)toolClick:(UIButton *)sender{
    NSInteger tag = sender.tag - 10000;
    if ([self.toolDelegate respondsToSelector:@selector(toolClick:andVO:)]) {
        [self.toolDelegate toolClick:tag andVO:_camvo];
    }
}

@end
