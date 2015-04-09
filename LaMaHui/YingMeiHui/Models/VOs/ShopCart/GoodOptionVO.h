//
//  GoodOptionVO.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-8-13.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface GoodOptionVO : NSObject
{
}

+ (GoodOptionVO *)GoodOptionVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (GoodOptionVO *)GoodOptionVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)GoodOptionVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

@property(nonatomic, retain) NSString *Value;
@property(nonatomic, retain) NSString *Label;

@end
