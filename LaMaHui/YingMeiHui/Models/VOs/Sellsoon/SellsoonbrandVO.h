//
//  SellsoonbrandVO.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-3-31.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface SellsoonbrandVO : NSObject
{
}

+ (SellsoonbrandVO *)SellsoonbrandVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (SellsoonbrandVO *)SellsoonbrandVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)SellsoonbrandVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

@property(nonatomic, retain) NSNumber *BrandID;
@property(nonatomic, retain) NSString *BrandName;
@property(nonatomic, retain) NSString *Pic;
@property(nonatomic, retain) NSNumber *SellTimeFrom;
@property(nonatomic, retain) NSNumber *SellTimeTo;
@property(nonatomic, retain) NSNumber *IsSubscribed;

@end
