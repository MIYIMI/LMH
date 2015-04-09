//
//  OrderMoneyVO.h
//  YingMeiHui
//
//  Created by work on 14-10-30.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface OrderMoneyVO : NSObject

+ (OrderMoneyVO *)OrderMoneyVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (OrderMoneyVO *)OrderMoneyVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)OrderMoneyVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

@property(nonatomic, retain) NSNumber  *pay_money;
@property(nonatomic, retain) NSNumber *pay_credit;
@property(nonatomic, retain) NSNumber *pay_coupon_money;
@property(nonatomic, retain) NSNumber *app_discount_money;
@property(nonatomic, retain) NSNumber *pay_freight;
@property(nonatomic, retain) NSNumber *pay_amount;

@end
