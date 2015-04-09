//
//  SellsoonSectionVO.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-3-31.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SellsoonbrandVO.h"

@interface SellsoonSectionVO : NSObject
{
}

+ (SellsoonSectionVO *)SellsoonSectionVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (SellsoonSectionVO *)SellsoonSectionVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)SellsoonSectionVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

@property(nonatomic, retain) NSString *Title;
@property(nonatomic, retain) NSString *TitleTip;
@property(nonatomic, retain) NSArray *SellsoonList;

@end
