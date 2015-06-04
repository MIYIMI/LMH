//
//  CartProductVO.h
//  YingMeiHui
//
//  Created by work on 14-10-20.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodOptionVO.h"

@interface CartProductVO : NSObject

+ (CartProductVO *)CartProductVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (CartProductVO *)CartProductVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)CartProductVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

@property(nonatomic, retain)NSString *product_name;
@property(nonatomic, retain)NSNumber *qty;
@property(nonatomic, retain)NSNumber *product_id;
@property(nonatomic, retain)NSString *sku;
@property(nonatomic, retain)NSNumber *original_price;
@property(nonatomic, retain)NSNumber *sell_price;
@property(nonatomic, retain)NSArray  *options;
@property(nonatomic, retain)NSNumber *item_id;
@property(nonatomic, retain)NSString *product_image;
@property(nonatomic, retain)NSString *brand_name;
@property(nonatomic, retain)NSNumber *stock;
@property(nonatomic, retain)NSNumber *buy_min;
@property(nonatomic, retain)NSNumber *buy_max;
@property(nonatomic, retain)NSArray  *discount_word;

@end

@interface CartBrandDis : NSObject

+ (CartBrandDis *)CartBrandDisWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)CartBrandDisWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property(nonatomic, retain)NSString *discount_title;
@property(nonatomic, retain)NSNumber *discount_end_time;
@property(nonatomic, retain)NSString *discount_money;

@end
