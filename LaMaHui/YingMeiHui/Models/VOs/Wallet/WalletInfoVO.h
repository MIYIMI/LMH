//
//  WalletInfoVO.h
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

@interface WalletInfoVO : NSObject
{
}

+ (WalletInfoVO *)WalletInfoVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (WalletInfoVO *)WalletInfoVOWithDictionary:(NSDictionary *)dictionary;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

@property(nonatomic, retain) NSNumber *Code;
@property(nonatomic, retain) NSString *Msg;
@property(nonatomic, retain) NSNumber *Total;
@property(nonatomic, retain) NSNumber *Usable;
@property(nonatomic, retain) NSNumber *Dealing;
@property(nonatomic, retain) NSNumber *Bind;

@end
