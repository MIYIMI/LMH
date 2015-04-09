//
//  OrderBeanVO.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-17.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface OrderBeanVO : NSObject
{
}

+ (OrderBeanVO *)OrderBeanVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (OrderBeanVO *)OrderBeanVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)OrderBeanVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

//@property(nonatomic, retain) NSString *ID;
@property(nonatomic, retain) NSNumber   *ID;
@property(nonatomic, retain) NSNumber *OrderPrice;
@property(nonatomic, retain) NSNumber *CreateTime;
@property(nonatomic, retain) NSNumber *PayTime;
@property(nonatomic, retain) NSNumber *Status;
@property(nonatomic, retain) NSNumber *ProductID;
@property(nonatomic, retain) NSString *ProductTitle;
@property(nonatomic, retain) NSString *PicUrl;
@property(nonatomic, retain) NSNumber *ItemNum;
@property(nonatomic, retain) NSNumber *ItemPrice;
@property(nonatomic, retain) NSNumber *AddressID;
@property(nonatomic, retain) NSNumber *Freight;

@end
