//
//  CouponVO.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-16.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface CouponVO : NSObject
{
}

+ (CouponVO *)CouponVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (CouponVO *)CouponVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)CouponVOWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

@property(nonatomic, retain) NSNumber *is_valid;
@property(nonatomic, retain) NSString *title;
@property(nonatomic, retain) NSNumber *begin_time;
@property(nonatomic, retain) NSNumber *end_time;
@property(nonatomic, retain) NSNumber *coupon_amount;
@property(nonatomic, retain) NSString *coupon_rule;
@property(nonatomic, retain) NSString *coupon_id;
@property(nonatomic, retain) NSString *user_coupon_id;
@property(nonatomic, retain) NSNumber *order_amount;
@property(nonatomic, retain) NSNumber *condition_money;
@property(nonatomic, retain) NSString *special_condition;

@end
