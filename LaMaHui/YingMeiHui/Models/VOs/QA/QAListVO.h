//
//  QAListVO.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-7-3.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QAInfoVO.h"

@interface QAListVO : NSObject
{
}

+ (QAListVO *)QAListVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (QAListVO *)QAListVOWithDictionary:(NSDictionary *)dictionary;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

@property(nonatomic, retain) NSNumber *Code;
@property(nonatomic, retain) NSString *Msg;
@property(nonatomic, retain) NSArray *QAList;

@end
