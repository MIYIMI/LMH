//
//  ProductDetailVO.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-7.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExtraInfoVO.h"
#import "ColorInfoVO.h"
#import "SizeInfoVO.h"
#import "SkuListVO.h"

@interface ProductDetailVO : NSObject
{
}

+ (ProductDetailVO *)ProductDetailVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (ProductDetailVO *)ProductDetailVOWithDictionary:(NSDictionary *)dictionary;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

@property(nonatomic, retain) NSNumber *Code;
@property(nonatomic, retain) NSString *Msg;
@property(nonatomic, retain) NSString *BrandTitle;
@property(nonatomic, retain) NSArray *Pics;
@property(nonatomic, retain) NSString *Title;
@property(nonatomic, retain) NSNumber *OurPrice;
@property(nonatomic, retain) NSNumber *MarketPrice;
@property(nonatomic, retain) NSString *SaleTip;
@property(nonatomic, retain) NSString *SizeTablePic;
@property(nonatomic, retain) NSArray *ExtraInfo;
@property(nonatomic, retain) NSString *MoreDetail;
@property(nonatomic, retain) NSNumber *SoldOut;
@property(nonatomic, retain) NSString *ColorPropName;
@property(nonatomic, retain) NSArray *ColorInfo;
@property(nonatomic, retain) NSString *SizePropName;
@property(nonatomic, retain) NSArray *SizeInfo;
@property(nonatomic, retain) NSNumber *IsFaved;
@property(nonatomic, retain) NSArray *PropTable;
@property(nonatomic, retain) NSArray *cartSku;
@property(nonatomic, retain) NSNumber *Cartnum;
@property(nonatomic, strong) NSString *productURL;
@property(nonatomic, strong) NSArray *detailArray;
@end
