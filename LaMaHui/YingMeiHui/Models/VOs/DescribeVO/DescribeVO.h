//
//  DescribeVO.h
//  YingMeiHui
//
//  Created by work on 15-1-6.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface DescribeVO : NSObject

+ (DescribeVO *)DescribeVOWithDictionary:(NSDictionary *)dictionary;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property(nonatomic,strong)NSNumber *source_id;
@property(nonatomic,strong)NSString *source_platform;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *short_title;
@property(nonatomic,strong)NSString *sub_title;
@property(nonatomic,strong)NSString *promo_word;
@property(nonatomic,strong)NSString *sales_price;
@property(nonatomic,strong)NSString *market_price;
@property(nonatomic,strong)NSNumber *is_buy_change;
@property(nonatomic,strong)NSString *click_url;
@property(nonatomic,strong)NSNumber *free_postage;
@property(nonatomic,strong)NSString *image;
@property(nonatomic,strong)NSString *image2;
@property(nonatomic,strong)NSString *taobao_images;
@property(nonatomic,strong)NSNumber *taobao_month_orders;
@property(nonatomic,strong)NSString *editor_comment;
@property(nonatomic,strong)NSNumber *fav_num;

@end
