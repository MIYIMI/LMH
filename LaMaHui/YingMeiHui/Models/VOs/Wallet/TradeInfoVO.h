//
//  TradeInfoVO.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-21.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface TradeInfoVO : NSObject
{
}

+ (TradeInfoVO *)TradeInfoVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (TradeInfoVO *)TradeInfoVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)TradeInfoVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

@property(nonatomic, retain) NSNumber *ID;
@property(nonatomic, retain) NSString *TypeName;
@property(nonatomic, retain) NSNumber *Time;
@property(nonatomic, retain) NSNumber *Value;

@end
