//
//  CateVO.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-4.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SizeVO.h"

@interface CateVO : NSObject
{
}

+ (CateVO *)CateVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (CateVO *)CateVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)CateVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

@property(nonatomic, retain) NSNumber *CateID;
@property(nonatomic, retain) NSString *CateName;
@property(nonatomic, retain) NSNumber *Cnt;
@property(nonatomic, retain) NSArray *SizeList;

@end
