//
//  CartNumVO.h
//  YingMeiHui
//
//  Created by work on 14-11-4.
//  Copyright (c) 2014年 xieyanke. All rights reserved.
//

#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface CartNumVO : NSObject

+ (CartNumVO *)CartNumVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (CartNumVO *)CartNumVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)CartNumVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

@property(nonatomic, retain) NSArray *product_no_stock;
@property(nonatomic, retain) NSArray *product_stock;

@property(nonatomic, retain) NSNumber *product_id;
@property(nonatomic, retain) NSNumber *stock;
@property(nonatomic, retain) NSString *sku_id;

@end
