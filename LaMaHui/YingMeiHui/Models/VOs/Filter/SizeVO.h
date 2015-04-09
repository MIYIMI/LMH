//
//  SizeVO.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-4.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface SizeVO : NSObject
{
}

+ (SizeVO *)SizeVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (SizeVO *)SizeVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)SizeVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

@property(nonatomic, retain) NSNumber *SizeID;
@property(nonatomic, retain) NSString *SizeName;

@end
