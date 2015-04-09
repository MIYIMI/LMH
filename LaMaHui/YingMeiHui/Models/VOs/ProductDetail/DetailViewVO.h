//
//  DetailViewVO.h
//  YingMeiHui
//
//  Created by work on 14-10-9.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductInfoVO.h"
#import "BrandInfoVO.h"
#import "LikeProductVO.h"
#import "CommentsVO.h"

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface DetailViewVO : NSObject

+ (DetailViewVO *)DetailViewVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (NSArray *)DetailViewVOWithArray:(NSArray *)array;
+ (DetailViewVO *)DetailViewVOWithDictionary:(NSDictionary *)dictionary;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

@property(nonatomic, retain) NSNumber *Code;
@property(nonatomic, retain) NSString *Msg;
@property(nonatomic, retain) ProductInfoVO *productDict;
@property(nonatomic, retain) BrandInfoVO *brandDict;
@property(nonatomic, retain) NSArray *likeArray;


@property(nonatomic, retain) NSNumber *comments_sroce;
@property(nonatomic, retain) NSNumber *comments_count;
@property(nonatomic, retain) CommentsVO  *comments;
//@property(nonatomic, retain) NSString *user_name;
//@property(nonatomic, retain) NSString *content;
//@property(nonatomic, retain) NSString *create_at;
//@property(nonatomic, retain) NSString *update_at;
//@property(nonatomic, retain) NSArray  *spec;
//@property(nonatomic, retain) NSString *color;
//@property(nonatomic, retain) NSString *size;

@end
