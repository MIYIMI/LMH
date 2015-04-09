//
//  KTCouponListTableViewCell.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-17.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CouponVO;

@protocol KTCouponListTableViewCellDelegate;

@interface KTCouponListTableViewCell : UITableViewCell

@property (assign, nonatomic) id<KTCouponListTableViewCellDelegate> couponCellDelegate;
@property (strong, nonatomic) CouponVO *CouponData;
@property (nonatomic) BOOL cellState;

@end

@protocol KTCouponListTableViewCellDelegate <NSObject>

- (void)selectCoupon:(CouponVO *)coupon;

@end
