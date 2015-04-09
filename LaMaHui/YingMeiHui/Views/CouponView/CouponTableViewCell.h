//
//  CouponTableViewCell.h
//  YingMeiHui
//
//  Created by work on 14-11-26.
//  Copyright (c) 2014年 xieyanke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponVO.h"

@protocol CouponTableViewCellDelegate <NSObject>

- (void)btnClick:(NSString *)selectStr;

@end

@interface CouponTableViewCell : UITableViewCell
{
    CouponVO *_couponVO;
    UIButton *cellBtn;
}

- (void)layoutUI:(CouponVO *)vo;
- (void)setBtnState:(BOOL)flag;
@property (nonatomic,strong) id<CouponTableViewCellDelegate> delegte;

@end
