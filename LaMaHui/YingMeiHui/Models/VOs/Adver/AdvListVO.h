//
//  AdvListVO.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-14.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdvVO.h"

@interface AdvListVO : NSObject
{
}

+ (AdvListVO *)AdvListVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (AdvListVO *)AdvListVOWithDictionary:(NSDictionary *)dictionary;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

@property(nonatomic, retain) NSNumber *Code;
@property(nonatomic, retain) NSString *Msg;
@property(nonatomic, retain) NSArray *AdvList;

@end
