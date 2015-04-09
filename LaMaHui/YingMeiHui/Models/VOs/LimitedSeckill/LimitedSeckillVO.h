//
//  LimitedSeckillVO.h
//  YingMeiHui
//
//  Created by 辣妈汇 on 14-10-24.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface LimitedSeckillVO : NSObject

+ (LimitedSeckillVO *)LimitedSeckillVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (LimitedSeckillVO *)LimitedSeckillVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)LimitedSeckillVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic,assign)NSNumber *freight_free;
@property (nonatomic,strong)NSNumber *product_id;
@property (nonatomic,strong)NSNumber *sold_quantity;
@property (nonatomic,strong)NSString *product_name;
@property (nonatomic,strong)NSString *pic;
@property (nonatomic,strong)NSNumber *seckill_id;
@property (nonatomic,strong)NSString *our_price;
@property (nonatomic,strong)NSString *market_price;
@property (nonatomic,strong)NSNumber *stock;
@property (nonatomic,strong)NSNumber *surplus;
@property (nonatomic,strong)NSNumber *taobao_price;
@property (nonatomic,strong)NSNumber *is_start_sale;
@property (nonatomic,strong)NSString *sale_tip;
@property (nonatomic,strong)NSNumber *brand_id;
@property (nonatomic,strong)NSString *brand_title;
@property (nonatomic,strong)NSString *taobao_detail_url;
@property (nonatomic,strong)NSNumber *begin_at;
@property (nonatomic,strong)NSNumber *is_seckill_remind;
@property (nonatomic,strong)NSNumber *outTimeNum;

@end
