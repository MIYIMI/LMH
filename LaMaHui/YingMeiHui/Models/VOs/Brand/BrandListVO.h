//
//  BrandListVO.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-3-31.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MenuItemVO.h"
#import "BrandVO.h"

@interface BrandListVO : NSObject
{
}

+ (BrandListVO *)BrandListVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (BrandListVO *)BrandListVOWithDictionary:(NSDictionary *)dictionary;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

@property(nonatomic, retain) NSNumber *Code;
@property(nonatomic, retain) NSString *Msg;
@property(nonatomic, retain) NSString *SectionValue;
@property(nonatomic, retain) NSNumber *Total;
@property(nonatomic, retain) NSArray *BrandList;

@end
