//
//  CommentsVO.h
//  YingMeiHui
//
//  Created by work on 14-10-15.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface CommentsVO : NSObject

+ (CommentsVO *)CommentsVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (NSArray *)CommentsVOWithArray:(NSArray *)array;
+ (CommentsVO *)CommentsVOWithDictionary:(NSDictionary *)dictionary;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

@property(nonatomic, retain) NSNumber *comments_sroce;
@property(nonatomic, retain) NSNumber *comments_count;
@property(nonatomic, retain) NSArray *comments;
@property(nonatomic, retain) NSString *user_name;
@property(nonatomic, retain) NSString *content;
@property(nonatomic, retain) NSString *create_at;
@property(nonatomic, retain) NSString *update_at;
@property(nonatomic, retain) NSArray *spec;
@property(nonatomic, retain) NSString *color;
@property(nonatomic, retain) NSString *size;

@end
