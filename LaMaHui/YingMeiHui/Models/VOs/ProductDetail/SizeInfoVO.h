//
//  SizeInfoVO.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-10.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface SizeInfoVO : NSObject
{
}

+ (SizeInfoVO *)SizeInfoVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (SizeInfoVO *)SizeInfoVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)SizeInfoVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

@property(nonatomic, retain) NSNumber *SizeID;
@property(nonatomic, retain) NSString *Name;
@property(nonatomic, retain) NSNumber *SkuNum;

@end
