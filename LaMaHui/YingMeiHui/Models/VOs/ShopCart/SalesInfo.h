//
//  SalesInfo.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-8-15.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface SalesInfo : NSObject
{
}

+ (SalesInfo *)SalesInfoWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (SalesInfo *)SalesInfoWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)SalesInfoListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

@property(nonatomic, retain) NSString *Title;
@property(nonatomic, retain) NSNumber *Discount;

@end
