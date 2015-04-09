//
//  OrderBeanListVO.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-17.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderBeanVO.h"

@interface OrderBeanListVO : NSObject
{
}

+ (OrderBeanListVO *)OrderBeanListVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (OrderBeanListVO *)OrderBeanListVOWithDictionary:(NSDictionary *)dictionary;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

@property(nonatomic, retain) NSNumber *Code;
@property(nonatomic, retain) NSString *Msg;
@property(nonatomic, retain) NSNumber *Total;
@property(nonatomic, retain) NSArray *OrderBeanList;

@end
