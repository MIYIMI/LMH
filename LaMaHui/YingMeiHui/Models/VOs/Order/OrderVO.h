//
//  OrderVO.h
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

@interface OrderVO : NSObject

+ (OrderVO *)OrderVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (OrderVO *)OrderVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)OrderVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

@property(nonatomic, retain) NSDictionary   *order;
@property(nonatomic, retain) NSArray *paymentlist;
@property(nonatomic, retain) NSDictionary *address;

@end
