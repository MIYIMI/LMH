//
//  HomeVO.h
//  YingMeiHui
//
//  Created by work on 14-11-10.
//  Copyright (c) 2014年 xieyanke. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AdvListVO.h"
#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface HomeVO : NSObject

+ (HomeVO *)HomeVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (HomeVO *)HomeVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)HomeVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic,strong) NSNumber *sell_time;
@property (nonatomic,strong) NSArray *activity;
@property (nonatomic,strong) NSArray *seckill_list;
@property (nonatomic,strong) NSArray *event_list;
@property (nonatomic,strong) NSArray *event_goods;
@property (nonatomic,strong) NSArray *product_hot_list;
@property (nonatomic,strong) NSArray *productlist;
@property (nonatomic,strong) NSString *productlist_name;
@property (nonatomic,strong) NSArray *banner;
@property (nonatomic,strong) NSArray *category_list;
@property (nonatomic,strong) NSNumber *total_count;
@property (nonatomic,strong) NSString *brandBanner;
@end


@interface HomeActivityVO : NSObject

+ (HomeActivityVO *)HomeActivityVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)HomeActivityVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic,strong) NSString *imgeUrl;
@property (nonatomic,strong) NSString *destID;
@property (nonatomic,strong) NSString *title;
@property(nonatomic, retain) NSString *Key;

@end


@interface HomeBrandVO : NSObject

+ (HomeBrandVO *)HomeBrandVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)HomeBrandVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic,strong) NSString *Title;
@property (nonatomic,strong) NSString *postion;
@property (nonatomic,strong) NSArray *brandArray;

@end


@interface HomeProductVO : NSObject

+ (HomeProductVO *)HomeProductVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)HomeProductVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic,strong) NSNumber *product_id;
@property (nonatomic,strong) NSString *product_name;
@property (nonatomic,strong) NSString *age_group;
@property (nonatomic,strong) NSString *pic;
@property (nonatomic,strong) NSString *begin_time;
@property (nonatomic,strong) NSNumber *our_price;
@property (nonatomic,strong) NSNumber *market_price;
@property (nonatomic,strong) NSString *sale_tip;
@property (nonatomic,strong) NSString *detail_label;
@property (nonatomic,strong) NSString *final_price;
@property (nonatomic,strong) NSNumber *sold_out;
@property (nonatomic,strong) NSNumber *sales_num;
@property (nonatomic,strong) NSString *product_status;
@property (nonatomic,strong) NSNumber *total_count;
@property (nonatomic,strong) NSNumber *exclusive_price;
@property (nonatomic,strong) NSNumber *is_exclusive;
@property (nonatomic,strong) NSString *sales_title;
@property (nonatomic,strong) NSNumber *stock;
@property (nonatomic,strong) NSNumber *brand_id;
@property (nonatomic,strong) NSString *brand_title;
@property (nonatomic,strong) NSArray *product_tags;
@property (nonatomic,strong) NSString *click_url;
@property (nonatomic,strong) NSString *source_platform;
@property (nonatomic,strong) NSNumber *is_check;
@property (nonatomic,strong) NSString *logo;
@property (nonatomic,strong) NSNumber *is_buy_change;
@property (nonatomic,strong) NSNumber *free_postage;
@property (nonatomic,strong) NSNumber *is_boutique;
@property (nonatomic,strong) NSString *source_platform_cn;
@property (nonatomic,strong) NSNumber *is_activity;
@property (nonatomic,strong) NSNumber *activity_type;
@property (nonatomic,strong) NSString *activity_key;
@property (nonatomic,strong) NSString *activity_image_w;
@property (nonatomic,strong) NSString *activity_image_h;

@end

