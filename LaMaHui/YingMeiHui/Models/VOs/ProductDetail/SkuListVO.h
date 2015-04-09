//
//  SkuListVO.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-24.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface SkuListVO : NSObject
{
}

+ (SkuListVO *)SkuListVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (SkuListVO *)SkuListVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)SkuListVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

@property(nonatomic, retain) NSNumber *ColorID;
@property(nonatomic, retain) NSNumber *SizeID;
@property(nonatomic, retain) NSNumber *SkuNum;
@property(nonatomic, retain) NSString *SkuID;
@property(nonatomic, retain) NSString *ColorName;
@property(nonatomic, retain) NSString *SizeName;
@property(nonatomic, retain) NSString *imageUrl;

@end
