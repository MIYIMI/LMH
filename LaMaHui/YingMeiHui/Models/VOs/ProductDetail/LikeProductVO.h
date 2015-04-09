//
//  LikeProductVO.h
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

@interface LikeProductVO : NSObject

+ (LikeProductVO *)LikeProductVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (NSArray *)LikeProductVOWithArray:(NSArray *)array;
+ (LikeProductVO *)LikeProductVOWithDictionary:(NSDictionary *)dictionary;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

@property(nonatomic, retain) NSString *title;
@property(nonatomic, retain) NSNumber *productID;
@property(nonatomic, retain) NSString *salesPrice;
@property(nonatomic, retain) NSString *marketPrice;
@property(nonatomic, retain) NSString *imageUrl;
@property(nonatomic, retain) NSNumber *favNum;
@property(nonatomic, retain) NSString *click_url;

@end
