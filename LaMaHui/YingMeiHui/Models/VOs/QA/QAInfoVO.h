//
//  QAInfoVO.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-7-3.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface QAInfoVO : NSObject
{
}

+ (QAInfoVO *)QAInfoVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (QAInfoVO *)QAInfoVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)QAInfoVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

@property(nonatomic, retain) NSString *QATitle;
@property(nonatomic, retain) NSString *QAContent;

@end
