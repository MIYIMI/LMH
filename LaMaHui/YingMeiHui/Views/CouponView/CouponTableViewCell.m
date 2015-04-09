//
//  CouponTableViewCell.m
//  YingMeiHui
//
//  Created by work on 14-11-26.
//  Copyright (c) 2014年 xieyanke. All rights reserved.
//

#import "CouponTableViewCell.h"

@implementation CouponTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [[self contentView] setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)layoutUI:(CouponVO *)vo{
    _couponVO = vo;
    if (!cellBtn) {
        cellBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 60, 9, 22, 22)];
        [cellBtn setBackgroundImage:[UIImage imageNamed:@"noselect"] forState:UIControlStateNormal];
        [cellBtn setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateHighlighted];
        [cellBtn setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
        [cellBtn setUserInteractionEnabled:NO];
        [self addSubview:cellBtn];
    }
    
    self.textLabel.text = vo.coupon_rule;
    self.textLabel.font = [UIFont systemFontOfSize:15];
    self.textLabel.textAlignment = NSTextAlignmentLeft;
}

- (void)selectBtn{
    if ([self.delegte respondsToSelector:@selector(btnClick:)]) {
        [self.delegte btnClick:_couponVO.coupon_id];
        cellBtn.selected = YES;
    }
}

- (void)setBtnState:(BOOL)flag{
    cellBtn.selected = flag;
}

@end
