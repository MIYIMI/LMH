//
//  FavListCellVO.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-6-25.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface FavListCellVO : NSObject
{
}

+ (FavListCellVO *)FavListCellVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (FavListCellVO *)FavListCellVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)FavListCellVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

@property(nonatomic, retain) NSNumber *ProductID;
@property(nonatomic, retain) NSString *ProductName;
@property(nonatomic, retain) NSString *Pic;
@property(nonatomic, retain) NSNumber *OurPrice;
@property(nonatomic, retain) NSNumber *MarketPrice;
@property(nonatomic, retain) NSString *SaleTip;
@property(nonatomic, retain) NSNumber *FavTime;

@end
