//
//  PaymentListVO.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-13.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaymentVO.h"

@interface PaymentListVO : NSObject
{
}

+ (PaymentListVO *)PaymentListVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (PaymentListVO *)PaymentListVOWithDictionary:(NSDictionary *)dictionary;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

@property(nonatomic, retain) NSNumber *Code;
@property(nonatomic, retain) NSString *Msg;
@property(nonatomic, retain) NSArray *PaymentList;

@end
