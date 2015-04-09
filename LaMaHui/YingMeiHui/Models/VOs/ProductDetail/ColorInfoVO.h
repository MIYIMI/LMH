//
//  ColorInfoVO.h
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

@interface ColorInfoVO : NSObject
{
}

+ (ColorInfoVO *)ColorInfoVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (ColorInfoVO *)ColorInfoVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)ColorInfoVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

@property(nonatomic, retain) NSNumber *ColorID;
@property(nonatomic, retain) NSString *Name;
@property(nonatomic, retain) NSString *Pic;
@property(nonatomic, retain) NSNumber *SkuNum;

@end
