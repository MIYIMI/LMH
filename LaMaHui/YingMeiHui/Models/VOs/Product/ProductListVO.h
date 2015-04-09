//
//  ProductListVO.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-3.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductVO.h"

@interface ProductListVO : NSObject
{
}

+ (ProductListVO *)ProductListVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (ProductListVO *)ProductListVOWithDictionary:(NSDictionary *)dictionary;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

@property(nonatomic, retain) NSNumber *Code;
@property(nonatomic, retain) NSString *Msg;
@property(nonatomic, retain) NSNumber *Total;
@property(nonatomic, retain) NSNumber *SellTimeTo;
@property(nonatomic, retain) NSString *ActivityTip;
@property(nonatomic, retain) NSArray *ProductList;

@end
