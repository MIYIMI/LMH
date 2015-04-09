//
//  CouponListVO.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-17.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CouponVO.h"

@interface CouponListVO : NSObject
{
}

+ (CouponListVO *)CouponListVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (CouponListVO *)CouponListVOWithDictionary:(NSDictionary *)dictionary;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

@property(nonatomic, retain) NSNumber *Code;
@property(nonatomic, retain) NSString *Msg;
@property(nonatomic, retain) NSNumber *invalid;
@property(nonatomic, retain) NSNumber *valid;
@property(nonatomic, retain) NSArray *coupon_list;
@property(nonatomic, retain) NSNumber *has_order;
@property(nonatomic, retain) NSNumber *will_invalid;

@end
