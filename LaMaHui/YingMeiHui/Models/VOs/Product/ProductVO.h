//
//  ProductVO.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-3.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface ProductVO : NSObject
{
}

+ (ProductVO *)ProductVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (ProductVO *)ProductVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)ProductVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

@property(nonatomic, retain) NSNumber *ProductID;
@property(nonatomic, retain) NSString *ProductName;
@property(nonatomic, retain) NSString *Pic;
@property(nonatomic, retain) NSNumber *OurPrice;
@property(nonatomic, retain) NSNumber *MarketPrice;
@property(nonatomic, retain) NSString *SaleTip;
@property(nonatomic, retain) NSNumber *SoldOut;
@property(nonatomic, retain) NSNumber *Limit;
@property(nonatomic, retain) NSNumber *stock;
@property(nonatomic, retain) NSNumber *brand_id;
@property(nonatomic, retain) NSString *brand_title;

@end
