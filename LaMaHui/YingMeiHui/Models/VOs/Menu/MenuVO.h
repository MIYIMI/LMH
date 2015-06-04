//
//  MenuVO.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-3-28.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface StartVO : NSObject
{
}

+ (StartVO *)StartVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)StartVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property(nonatomic, retain) NSArray *menus;
@property(nonatomic, retain) NSNumber *is_show;
@property(nonatomic, retain) NSArray *tutorials;
@property(nonatomic, retain) NSString *user_uuid;
@property(nonatomic, retain) NSArray *tutorials_big;
@property(nonatomic, retain) NSNumber *third_login_flag;
@property(nonatomic, retain) NSString *service_phone;
@property(nonatomic, retain) NSString *app_cache_secret;

@end

@interface MenuVO : NSObject
{
}

+ (MenuVO *)MenuVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (MenuVO *)MenuVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)MenuVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

@property(nonatomic, retain) NSNumber *MID;
@property(nonatomic, retain) NSNumber *ParentID;
@property(nonatomic, retain) NSNumber *TypeID;
@property(nonatomic, retain) NSArray *Icon;
@property(nonatomic, retain) NSString *Name;
@property(nonatomic, retain) NSArray *ChildrenMenu;
@property(nonatomic, retain) NSString *uuid;
@property(nonatomic, retain) NSNumber *sortNum;

@end
