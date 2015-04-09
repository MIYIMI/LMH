//
//  MenuItemVO.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-6-17.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface MenuItemVO : NSObject
{
}

+ (MenuItemVO *)MenuItemVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (MenuItemVO *)MenuItemVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)MenuItemVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

@property(nonatomic, retain) NSNumber *ItemID;
@property(nonatomic, retain) NSNumber *ItemType;
@property(nonatomic, retain) NSString *ItemName;
@property(nonatomic, retain) NSString *Pic;
@property(nonatomic, retain) NSString *LogoPic;
@property(nonatomic, retain) NSString *SaleTip;
@property(nonatomic, retain) NSString *SaleInfo;
@property(nonatomic, retain) NSNumber *SalePrice;
@property(nonatomic, retain) NSNumber *MarketPrice;

@end
