//
//  AdvVO.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-14.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface AdvVO : NSObject
{
}

+ (AdvVO *)AdvVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (AdvVO *)AdvVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)AdvVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

@property(nonatomic, retain) NSNumber *Type;
@property(nonatomic, retain) NSString *Key;
@property(nonatomic, retain) NSString *Title;
@property(nonatomic, retain) NSString *Pic;
@property(nonatomic, retain) NSString *platform;
@property(nonatomic, retain) NSString *aname;
@property(nonatomic, retain) NSNumber *Pid;

@end
