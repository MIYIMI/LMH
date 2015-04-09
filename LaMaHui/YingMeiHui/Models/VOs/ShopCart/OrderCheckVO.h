//
//  OrderCheckVO.h
//  YingMeiHui
//
//  Created by work on 14-10-27.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CreditVO.h"

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface OrderCheckVO : NSObject

+ (OrderCheckVO *)OrderCheckVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (OrderCheckVO *)OrderCheckVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)OrderCheckVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

@property(nonatomic, retain)NSArray *address_list;
@property(nonatomic, retain)NSArray *coupon_list;
@property(nonatomic, retain)CreditVO *credit_list;
@property(nonatomic, retain)NSNumber *code;
@property(nonatomic, retain)NSString *msg;

@end
