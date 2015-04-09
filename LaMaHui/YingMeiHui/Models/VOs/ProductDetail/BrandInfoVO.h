//
//  BrandInfoVO.h
//  YingMeiHui
//
//  Created by work on 14-10-9.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface BrandInfoVO : NSObject

+ (BrandInfoVO *)BrandInfoVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (NSArray *)BrandInfoVOWithArray:(NSArray *)array;
+ (BrandInfoVO *)BrandInfoVOWithDictionary:(NSDictionary *)dictionary;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

@property(nonatomic, retain) NSString *brandTitle;
@property(nonatomic, retain) NSNumber *brandID;
@property(nonatomic, retain) NSString *brandlogo;
@property(nonatomic, retain) NSNumber *composite;
@property(nonatomic, retain) NSNumber *manner;
@property(nonatomic, retain) NSNumber *speed;

@end
