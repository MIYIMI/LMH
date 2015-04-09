//
//  UserInfoVO.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-20.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface UserInfoVO : NSObject
{
}

+ (UserInfoVO *)UserInfoVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (UserInfoVO *)UserInfoVOWithDictionary:(NSDictionary *)dictionary;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

@property(nonatomic, retain) NSNumber *Code;
@property(nonatomic, retain) NSString *Msg;
@property(nonatomic, retain) NSString *UserName;
@property(nonatomic, retain) NSNumber *Money;
@property(nonatomic, retain) NSNumber *PayedNum;
@property(nonatomic, retain) NSNumber *WaitPayNum;
@property(nonatomic, retain) NSNumber *AfterSaleNum;
@property(nonatomic, retain) NSArray *cartSkuArr;

@end
