//
//  CartInfo.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-8-15.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SalesInfo.h"

@interface CartInfo : NSObject
{
}

+ (CartInfo *)CartInfoWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (CartInfo *)CartInfoWithDictionary:(NSDictionary *)dictionary;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

@property(nonatomic, retain) NSString *CartMoney;
@property(nonatomic, retain) NSNumber *Freight;
@property(nonatomic, retain) NSArray *SaleInfos;

@end
