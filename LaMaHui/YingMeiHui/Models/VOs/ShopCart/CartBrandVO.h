//
//  CartBrandVO.h
//  YingMeiHui
//
//  Created by work on 14-10-20.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CartProductVO.h"

@interface CartBrandVO : NSObject

+ (CartBrandVO *)CartBrandVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (CartBrandVO *)CartBrandVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)CartBrandVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

@property(nonatomic, retain)NSString *event_title;
@property(nonatomic, retain)NSNumber *brand_id;
@property(nonatomic, retain)NSString *logo_url;
@property(nonatomic, retain)NSString *discount_word;
@property(nonatomic, retain)NSArray *product_arr;
@property(nonatomic, retain)NSArray *event_discount;

@end
