//
//  ExtraInfoVO.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-7.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface ExtraInfoVO : NSObject
{
}

+ (ExtraInfoVO *)ExtraInfoVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (ExtraInfoVO *)ExtraInfoVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)ExtraInfoVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

@property(nonatomic, retain) NSString *Title;
@property(nonatomic, retain) NSString *Info;

@end
