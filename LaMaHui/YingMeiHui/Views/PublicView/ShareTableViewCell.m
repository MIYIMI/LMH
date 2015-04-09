//
//  ShareTableViewCell.m
//  YingMeiHui
//
//  Created by work on 14-11-15.
//  Copyright (c) 2014年 xieyanke. All rights reserved.
//

#import "ShareTableViewCell.h"

@implementation ShareTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    
    return self;
}

-(void)layoutUI:(NSInteger)row{
    if (!iconView) {
        iconView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 5, 30, 30)];
        [self addSubview:iconView];
        [iconView setImage:LOCAL_IMG(@"sign_share")];
    }

    if (!tentLbL) {
        tentLbL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconView.frame)+20, 10, 120, 20)];
        [tentLbL setTextColor:[UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1]];
        [tentLbL setFont:FONT(14.0)];
        [tentLbL setText:@"邀请好友注册"];
        [self addSubview:tentLbL];
    }
    
    if (!creditLbl) {
        creditLbl = [[UILabel alloc] initWithFrame:CGRectMake(ScreenW - 112, 10, 100, 20)];
        [creditLbl setTextColor:[UIColor colorWithRed:0.98 green:0.33 blue:0.44 alpha:1]];
        [creditLbl setFont:FONT(14.0)];
        [creditLbl setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:creditLbl];
    }
    [creditLbl setText:@"+200金豆"];
    
//    if (!rightBtn) {
//        rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW-30, 10, 20, 20)];
//        [rightBtn setBackgroundImage:LOCAL_IMG(@"icon_share") forState:UIControlStateNormal];
//        [rightBtn setBackgroundImage:LOCAL_IMG(@"icon_share") forState:UIControlStateSelected];
//        [self addSubview:rightBtn];
//    }
}

@end
