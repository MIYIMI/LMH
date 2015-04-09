//
//  BrandVO.h
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

@interface BrandVO : NSObject
{
}

+ (BrandVO *)BrandVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (BrandVO *)BrandVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)BrandVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

@property(nonatomic, retain) NSNumber *BrandID;
@property(nonatomic, retain) NSString *BrandName;
@property(nonatomic, retain) NSString *Pic;
@property(nonatomic, retain) NSString *SaleTip;
@property(nonatomic, retain) NSString *ActivityTip;
@property(nonatomic, retain) NSNumber *SellTimeFrom;
@property(nonatomic, retain) NSNumber *SellTimeTo;

@end

/* 写这个类主要是因为 分类中展示品牌的接口返回的 品牌属性是 item_id 和 item_name ,其它属性都一样，为了避免再多写代码,这里用继承.*/
@interface BrandVOcounterpart : BrandVO

@end