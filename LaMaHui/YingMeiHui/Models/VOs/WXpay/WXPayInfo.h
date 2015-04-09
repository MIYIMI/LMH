//
//  WXPayInfo.h
//  YingMeiHui
//
//  Created by work on 14-9-2.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface WXPayInfo : NSObject
+ (WXPayInfo *)WXPayInfoWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (WXPayInfo *)WXPayInfoWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)WXPayInfoListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

@property(nonatomic, retain) NSString *AppId;
@property(nonatomic, retain) NSString *NonceStr;
@property(nonatomic, retain) NSString *Wxpackage;
@property(nonatomic, retain) NSString *PartnerId;
@property(nonatomic, retain) NSString *Prepayid;
@property(nonatomic, retain) NSNumber *Timestamp;
@property(nonatomic, retain) NSString *Sign;

@end
