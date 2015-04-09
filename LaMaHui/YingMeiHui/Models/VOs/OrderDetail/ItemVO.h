//
//  ItemVO.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-18.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface ItemVO : NSObject
{
}

+ (ItemVO *)ItemVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (ItemVO *)ItemVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)ItemVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

@property(nonatomic, retain) NSNumber *ProductID;
@property(nonatomic, retain) NSString *ProductTitle;
@property(nonatomic, retain) NSString *PicUrl;
@property(nonatomic, retain) NSNumber *ProductPrice;
@property(nonatomic, retain) NSString *ColorName;
@property(nonatomic, retain) NSString *SizeName;
@property(nonatomic, retain) NSString *ColorPropName;
@property(nonatomic, retain) NSString *SizePropName;
@property(nonatomic, retain) NSNumber *ItemNum;
@property(nonatomic, retain) NSNumber *Status;
@end
