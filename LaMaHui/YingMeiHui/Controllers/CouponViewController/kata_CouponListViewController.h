//
//  kata_CouponListViewController.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-17.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "FTStatefulTableViewController.h"
#import "kata_LoginViewController.h"
#import "KTCouponListTableViewCell.h"

@protocol kata_CouponListViewControllerDelegate;

@interface kata_CouponListViewController : FTStatefulTableViewController <LoginDelegate, KTCouponListTableViewCellDelegate>

@property (assign, nonatomic) id<kata_CouponListViewControllerDelegate> couponListDelegate;

- (id)initWithListType:(NSString *)type;
- (id)initWithListType:(NSString *)type
         andOrderPrice:(float)price;

@end

@protocol kata_CouponListViewControllerDelegate <NSObject>

- (void)selectCouponTicket:(CouponVO *)coupon;

@end
