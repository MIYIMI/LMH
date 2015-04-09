//
//  ProductInfoVO.h
//  YingMeiHui
//
//  Created by work on 14-10-9.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface ProductInfoVO : NSObject

+ (ProductInfoVO *)ProductInfoVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (NSArray *)ProductInfoVOWithArray:(NSArray *)array;
+ (ProductInfoVO *)ProductInfoVOWithDictionary:(NSDictionary *)dictionary;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

@property(nonatomic, retain) NSString *Title;
@property(nonatomic, retain) NSString *productURL;
@property(nonatomic, retain) NSString *share_content;
@property(nonatomic, retain) NSString *share_title;
@property(nonatomic, retain) NSNumber *OurPrice;
@property(nonatomic, retain) NSNumber *MarketPrice;
@property(nonatomic, retain) NSNumber *soldoutDate;
@property(nonatomic, retain) NSNumber *beginDate;
@property(nonatomic, retain) NSNumber *diffTime;
@property(nonatomic, retain) NSString *SaleTip;
@property(nonatomic, retain) NSNumber *SoldOut;
@property(nonatomic, retain) NSArray *ExtraInfo;
@property(nonatomic, retain) NSArray *detailArray;
@property(nonatomic, retain) NSArray *Pics;
@property(nonatomic, retain) NSString *ColorPropName;
@property(nonatomic, retain) NSString *SizePropName;
@property(nonatomic, retain) NSArray *ColorInfo;
@property(nonatomic, retain) NSArray *SizeInfo;
@property(nonatomic, retain) NSArray *PropTable;
@property(nonatomic, retain) NSNumber *IsFaved;
@property(nonatomic, retain) NSNumber *commentsNum;
@property(nonatomic, retain) NSArray *eventArray;
@property(nonatomic, retain) NSNumber *buy_min;
@property(nonatomic, retain) NSNumber *buy_max;
@property(nonatomic, retain) NSNumber *is_exclusive;
@property(nonatomic, retain) NSNumber *exclusive_price;
@property(nonatomic, retain) NSArray *cartSku;
@property(nonatomic, retain) NSNumber *Cartnum;
@property(nonatomic, retain) NSString *type;
@property(nonatomic, retain) NSNumber *seckill_id;
@property(nonatomic, retain) NSNumber *is_start_buy;

@end
