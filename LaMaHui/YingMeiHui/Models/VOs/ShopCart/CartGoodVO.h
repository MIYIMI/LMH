//
//  CartGoodVO.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-8-13.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CartBrandVO.h"

@interface CartGoodVO : NSObject
{
}

+ (CartGoodVO *)CartGoodVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (CartGoodVO *)CartGoodVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)CartGoodVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

@property(nonatomic, retain) NSNumber *cartCount;
@property(nonatomic, retain) NSNumber *total_fee;
@property(nonatomic, retain) NSNumber *count;
@property(nonatomic, retain) NSNumber *discount_fee;
@property(nonatomic, retain) NSArray *discount_info;
@property(nonatomic, retain) NSNumber *shipping_fee;
@property(nonatomic, retain) NSArray *event_data;
@property(nonatomic, retain) NSString *taobao_cart_url;

@end
