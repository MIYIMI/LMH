//
//  CreditVO.h
//  YingMeiHui
//
//  Created by work on 14-10-27.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface CreditVO : NSObject

+ (CreditVO *)CreditVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (CreditVO *)CreditVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)CreditVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

@property(nonatomic, retain)NSNumber *user_credit;
@property(nonatomic, retain)NSNumber *user_max_credit;
@property(nonatomic, retain)NSNumber *credit_to_moeny;

@end
