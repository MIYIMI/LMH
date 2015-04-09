//
//  SellsoonSectionListVO.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-1.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SellsoonSectionVO.h"

@interface SellsoonSectionListVO : NSObject
{
}

+ (SellsoonSectionListVO *)SellsoonSectionListVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (SellsoonSectionListVO *)SellsoonSectionListVOWithDictionary:(NSDictionary *)dictionary;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

@property(nonatomic, retain) NSNumber *Code;
@property(nonatomic, retain) NSString *Msg;
@property(nonatomic, retain) NSArray *SellsoonSectionList;

@end
