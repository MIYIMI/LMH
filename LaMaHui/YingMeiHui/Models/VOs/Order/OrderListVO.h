//
//  OrderListVO.h
//  YingMeiHui
//
//  Created by work on 14-11-27.
//  Copyright (c) 2014年 xieyanke. All rights reserved.
//

#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface OrderTotalVO : NSObject

+ (OrderTotalVO *)OrderTotalVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (OrderTotalVO *)OrderTotalVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)OrderTotalVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property(nonatomic, retain) NSNumber *order_total;
@property(nonatomic, retain) NSArray *order_list;
@property(nonatomic, retain) NSString *taobao_order_url;

@end


@interface OrderListVO : NSObject

+ (OrderListVO *)OrderListVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)OrderListVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property(nonatomic, retain) NSString *pay_amount;
@property(nonatomic, retain) NSString *refund_money;
@property(nonatomic, retain) NSString *pay_freight;
@property(nonatomic, retain) NSArray *event;
@property(nonatomic, retain) NSString *create_at;
@property(nonatomic, retain) NSString *pay_at;
@property(nonatomic, retain) NSNumber *time_diff;
@property(nonatomic, retain) NSString *pay_coupon_money;
@property(nonatomic, retain) NSString *order_id;
@property(nonatomic, retain) NSNumber *pay_status;
@property(nonatomic, retain) NSString *pay_status_name;
@property(nonatomic, retain) NSString *goods_total;

@end

@interface OrderEventVO : NSObject

+ (OrderEventVO *)OrderEventVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)OrderEventVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property(nonatomic, retain) NSArray *goods;
@property(nonatomic, retain) NSNumber *partner_id;
@property(nonatomic, retain) NSString *event_name;
@property(nonatomic, retain) NSNumber *pay_status;
@property(nonatomic, retain) NSString *pay_status_name;
@property(nonatomic, retain) NSNumber *refund_money;

@end


@interface OrderGoodsVO : NSObject

+ (OrderGoodsVO *)OrderGoodsVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)OrderGoodsVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property(nonatomic, retain) NSString *order_part_id;
@property(nonatomic, retain) NSString *goods_title;
@property(nonatomic, retain) NSString *goods_guige_label;
@property(nonatomic, retain) NSNumber *brand_id;
@property(nonatomic, retain) NSString *image;
@property(nonatomic, retain) NSString *goods_iguige_value;
@property(nonatomic, retain) NSNumber *sales_price;
@property(nonatomic, retain) NSString *goods_iguige_label;
@property(nonatomic, retain) NSString *goods_guige_value;
@property(nonatomic, retain) NSNumber *part_order_status;
@property(nonatomic, retain) NSString *part_order_status_name;
@property(nonatomic, retain) NSNumber *market_price;
@property(nonatomic, retain) NSNumber *goods_id;
@property(nonatomic, retain) NSNumber *quantity;
@property(nonatomic, retain) NSString *pay_status_name;
@property(nonatomic, retain) NSArray *orderBtn;
@property(nonatomic, retain) NSString *order_id;

@end


//订单按钮属性
@interface OrderButtonVO : NSObject

+ (OrderButtonVO *)OrderButtonVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)OrderButtonVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property(nonatomic, retain) NSString *btn_color;
@property(nonatomic, retain) NSString *btn_name;
@property(nonatomic, retain) NSNumber *btn_type;

@end
