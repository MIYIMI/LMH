//
//  PaymentVO.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-13.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface PaymentVO : NSObject
{
}

+ (PaymentVO *)PaymentVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (PaymentVO *)PaymentVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)PaymentVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

@property(nonatomic, retain) NSNumber *PayType;
@property(nonatomic, retain) NSString *PayName;
@property(nonatomic, retain) NSNumber *Bind;
@property(nonatomic, retain) NSNumber *Money;

@end
