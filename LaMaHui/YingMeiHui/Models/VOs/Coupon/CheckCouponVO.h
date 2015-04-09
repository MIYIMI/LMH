//
//  CheckCheckCouponVO.h
//  YingMeiHui
//
//  Created by work on 14-9-24.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface CheckCouponVO : NSObject

+ (CheckCouponVO *)CheckCouponVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (CheckCouponVO *)CheckCouponVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)CheckCouponVOWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

@property(nonatomic, retain) NSNumber *code;
@property(nonatomic, retain) NSString *msg;
@property(nonatomic, retain) NSNumber *coupon_type;
@property(nonatomic, retain) NSNumber *order_amount;
@property(nonatomic, retain) NSNumber *coupon_amount;
@property(nonatomic, retain) NSString *coupon_rule;
@property(nonatomic, retain) NSNumber *user_coupon_id;
@property(nonatomic, retain) NSString *couponid;

@end
