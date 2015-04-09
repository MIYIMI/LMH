//
//  OrderInfoVO.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-18.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OrderListVO.h"

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface OrderInfoVO : NSObject
{
}

+ (OrderInfoVO *)OrderInfoVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)OrderInfoVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property(nonatomic, retain) NSString *pay_amount;
@property(nonatomic, retain) NSString *pay_freight;
@property(nonatomic, retain) NSString *coupon_title;
@property(nonatomic, retain) NSString *discount_money;
@property(nonatomic, retain) NSString *pay_status_name;
@property(nonatomic, retain) NSString *create_at;
@property(nonatomic, retain) NSArray *part_orders;
@property(nonatomic, retain) NSNumber *pay_at;
@property(nonatomic, retain) NSString *order_id;
@property(nonatomic, retain) NSNumber *pay_credit;
@property(nonatomic, retain) NSNumber *pay_status;
@property(nonatomic, retain) NSNumber *total_money;

@end
