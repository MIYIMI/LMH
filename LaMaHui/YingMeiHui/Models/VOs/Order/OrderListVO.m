//
//  OrderListVO.m
//  YingMeiHui
//
//  Created by work on 14-11-27.
//  Copyright (c) 2014年 xieyanke. All rights reserved.
//

#import "OrderListVO.h"

@implementation OrderTotalVO
@synthesize order_total;
@synthesize order_list;
@synthesize taobao_order_url;

+ (OrderTotalVO *)OrderTotalVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [OrderTotalVO OrderTotalVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (OrderTotalVO *)OrderTotalVOWithDictionary:(NSDictionary *)dictionary
{
    OrderTotalVO *instance = [[OrderTotalVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)OrderTotalVOListWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[OrderTotalVO OrderTotalVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"order_total"] && ![[dictionary objectForKey:@"order_total"] isEqual:[NSNull null]]) {
            self.order_total = [dictionary objectForKey:@"order_total"];
        }
        
        if (nil != [dictionary objectForKey:@"order_list"] && ![[dictionary objectForKey:@"order_list"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"order_list"] isKindOfClass:[NSArray class]]) {
            self.order_list = [OrderListVO OrderListVOListWithArray:[dictionary objectForKey:@"order_list"]];
        }
        
        if (nil != [dictionary objectForKey:@"taobao_order_url"] && ![[dictionary objectForKey:@"taobao_order_url"] isEqual:[NSNull null]]) {
            self.taobao_order_url = [dictionary objectForKey:@"taobao_order_url"];
        }
    }
    return self;
}

@end


@implementation OrderListVO

@synthesize pay_amount;
@synthesize refund_money;
@synthesize pay_freight;
@synthesize event;
@synthesize create_at;
@synthesize pay_at;
@synthesize time_diff;
@synthesize pay_coupon_money;
@synthesize order_id;
@synthesize pay_status;
@synthesize pay_status_name;

+ (OrderListVO *)OrderListVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [OrderListVO OrderListVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (OrderListVO *)OrderListVOWithDictionary:(NSDictionary *)dictionary
{
    OrderListVO *instance = [[OrderListVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)OrderListVOListWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[OrderListVO OrderListVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"pay_amount"] && ![[dictionary objectForKey:@"pay_amount"] isEqual:[NSNull null]]) {
            self.pay_amount = [dictionary objectForKey:@"pay_amount"];
        }
        
        if (nil != [dictionary objectForKey:@"refund_money"] && ![[dictionary objectForKey:@"refund_money"] isEqual:[NSNull null]]) {
            self.refund_money = [dictionary objectForKey:@"refund_money"];
        }
        
        if (nil != [dictionary objectForKey:@"pay_freight"] && ![[dictionary objectForKey:@"pay_freight"] isEqual:[NSNull null]]) {
            self.pay_freight = [dictionary objectForKey:@"pay_freight"];
        }
        
        if (nil != [dictionary objectForKey:@"event"] && ![[dictionary objectForKey:@"event"] isEqual:[NSNull null]]  && [[dictionary objectForKey:@"event"] isKindOfClass:[NSArray class]]) {
            self.event = [OrderEventVO OrderEventVOListWithArray:[dictionary objectForKey:@"event"]];
        }
        
        if (nil != [dictionary objectForKey:@"create_at"] && ![[dictionary objectForKey:@"create_at"] isEqual:[NSNull null]]) {
            self.create_at = [dictionary objectForKey:@"create_at"];
        }
        
        if (nil != [dictionary objectForKey:@"pay_at"] && ![[dictionary objectForKey:@"pay_at"] isEqual:[NSNull null]]) {
            self.pay_at = [dictionary objectForKey:@"pay_at"];
        }
        
        if (nil != [dictionary objectForKey:@"time_diff"] && ![[dictionary objectForKey:@"time_diff"] isEqual:[NSNull null]]) {
            self.time_diff = [dictionary objectForKey:@"time_diff"];
        }
        
        if (nil != [dictionary objectForKey:@"pay_coupon_money"] && ![[dictionary objectForKey:@"pay_coupon_money"] isEqual:[NSNull null]]) {
            self.pay_coupon_money = [dictionary objectForKey:@"pay_coupon_money"];
        }
        
        if (nil != [dictionary objectForKey:@"order_id"] && ![[dictionary objectForKey:@"order_id"] isEqual:[NSNull null]]) {
            self.order_id = [dictionary objectForKey:@"order_id"];
        }
        
        if (nil != [dictionary objectForKey:@"pay_status"] && ![[dictionary objectForKey:@"pay_status"] isEqual:[NSNull null]]) {
            self.pay_status = [dictionary objectForKey:@"pay_status"];
        }
        
        if (nil != [dictionary objectForKey:@"pay_status_name"] && ![[dictionary objectForKey:@"pay_status_name"] isEqual:[NSNull null]]) {
            self.pay_status_name = [dictionary objectForKey:@"pay_status_name"];
        }
    }
    
    return self;
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
    [order_total release];
    [order_list release];
    [pay_amount release];
    [pay_freight release];
    [event release];
    [create_at release];
    [pay_at release];
    [pay_coupon_money release];
    [order_id release];
    [pay_status release];
    
    [super dealloc];
#endif
}

@end



//订单中活动专场
@implementation OrderEventVO
@synthesize goods;
@synthesize partner_id;
@synthesize pay_status;
@synthesize pay_status_name;
@synthesize event_name;
@synthesize refund_money;

+ (NSArray *)OrderEventVOListWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[OrderEventVO OrderEventVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

+ (OrderEventVO *)OrderEventVOWithDictionary:(NSDictionary *)dictionary
{
    OrderEventVO *instance = [[OrderEventVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"goods"] && ![[dictionary objectForKey:@"goods"] isEqual:[NSNull null]]  && [[dictionary objectForKey:@"goods"] isKindOfClass:[NSArray class]]) {
            self.goods = [OrderGoodsVO OrderGoodsVOListWithArray:[dictionary objectForKey:@"goods"]];
        }
        
        if (nil != [dictionary objectForKey:@"event_name"] && ![[dictionary objectForKey:@"event_name"] isEqual:[NSNull null]]) {
            self.event_name = [dictionary objectForKey:@"event_name"];
        }
        
        if (nil != [dictionary objectForKey:@"partner_id"] && ![[dictionary objectForKey:@"partner_id"] isEqual:[NSNull null]]) {
            self.partner_id = [dictionary objectForKey:@"partner_id"];
        }
        
        if (nil != [dictionary objectForKey:@"pay_status"] && ![[dictionary objectForKey:@"pay_status"] isEqual:[NSNull null]]) {
            self.pay_status = [dictionary objectForKey:@"pay_status"];
        }
        
        if (nil != [dictionary objectForKey:@"pay_status_name"] && ![[dictionary objectForKey:@"pay_status_name"] isEqual:[NSNull null]]) {
            self.pay_status_name = [dictionary objectForKey:@"pay_status_name"];
        }
        
        if (nil != [dictionary objectForKey:@"refund_money"] && ![[dictionary objectForKey:@"refund_money"] isEqual:[NSNull null]]) {
            self.refund_money = [dictionary objectForKey:@"refund_money"];
        }
    }
    
    return self;
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
    [goods release];
    [pay_status release];
    [event_name release];
    [pay_status_name release];
    
    [super dealloc];
#endif
}

@end


//订单中活动专场的商品
@implementation OrderGoodsVO

@synthesize order_part_id;
@synthesize goods_title;
@synthesize goods_guige_label;
@synthesize brand_id;
@synthesize image;
@synthesize goods_iguige_value;
@synthesize sales_price;
@synthesize goods_iguige_label;
@synthesize goods_guige_value;
@synthesize part_order_status;
@synthesize market_price;
@synthesize goods_id;
@synthesize quantity;

+ (NSArray *)OrderGoodsVOListWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[OrderGoodsVO OrderGoodsVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

+ (OrderGoodsVO *)OrderGoodsVOWithDictionary:(NSDictionary *)dictionary
{
    OrderGoodsVO *instance = [[OrderGoodsVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"order_part_id"] && ![[dictionary objectForKey:@"order_part_id"] isEqual:[NSNull null]]) {
            self.order_part_id = [dictionary objectForKey:@"order_part_id"];
        }
        
        if (nil != [dictionary objectForKey:@"goods_title"] && ![[dictionary objectForKey:@"goods_title"] isEqual:[NSNull null]]) {
            self.goods_title = [dictionary objectForKey:@"goods_title"];
        }
        
        if (nil != [dictionary objectForKey:@"goods_guige_label"] && ![[dictionary objectForKey:@"goods_guige_label"] isEqual:[NSNull null]]) {
            self.goods_guige_label = [dictionary objectForKey:@"goods_guige_label"];
        }
        
        if (nil != [dictionary objectForKey:@"brand_id"] && ![[dictionary objectForKey:@"brand_id"] isEqual:[NSNull null]]) {
            self.brand_id = [dictionary objectForKey:@"brand_id"];
        }
        
        if (nil != [dictionary objectForKey:@"image"] && ![[dictionary objectForKey:@"image"] isEqual:[NSNull null]]) {
            self.image = [dictionary objectForKey:@"image"];
        }
        
        if (nil != [dictionary objectForKey:@"goods_iguige_value"] && ![[dictionary objectForKey:@"goods_iguige_value"] isEqual:[NSNull null]]) {
            self.goods_iguige_value = [dictionary objectForKey:@"goods_iguige_value"];
        }
        
        if (nil != [dictionary objectForKey:@"sales_price"] && ![[dictionary objectForKey:@"sales_price"] isEqual:[NSNull null]]) {
            self.sales_price = [dictionary objectForKey:@"sales_price"];
        }
        
        if (nil != [dictionary objectForKey:@"goods_iguige_label"] && ![[dictionary objectForKey:@"goods_iguige_label"] isEqual:[NSNull null]]) {
            self.goods_iguige_label = [dictionary objectForKey:@"goods_iguige_label"];
        }
        
        if (nil != [dictionary objectForKey:@"goods_guige_value"] && ![[dictionary objectForKey:@"goods_guige_value"] isEqual:[NSNull null]]) {
            self.goods_guige_value = [dictionary objectForKey:@"goods_guige_value"];
        }
        
        if (nil != [dictionary objectForKey:@"part_order_status"] && ![[dictionary objectForKey:@"part_order_status"] isEqual:[NSNull null]]) {
            self.part_order_status = [dictionary objectForKey:@"part_order_status"];
        }
        
        if (nil != [dictionary objectForKey:@"part_order_status_name"] && ![[dictionary objectForKey:@"part_order_status_name"] isEqual:[NSNull null]]) {
            self.part_order_status_name = [dictionary objectForKey:@"part_order_status_name"];
        }
        
        if (nil != [dictionary objectForKey:@"market_price"] && ![[dictionary objectForKey:@"market_price"] isEqual:[NSNull null]]) {
            self.market_price = [dictionary objectForKey:@"market_price"];
        }
        
        if (nil != [dictionary objectForKey:@"goods_id"] && ![[dictionary objectForKey:@"goods_id"] isEqual:[NSNull null]]) {
            self.goods_id = [dictionary objectForKey:@"goods_id"];
        }
        
        if (nil != [dictionary objectForKey:@"quantity"] && ![[dictionary objectForKey:@"quantity"] isEqual:[NSNull null]]) {
            self.quantity = [dictionary objectForKey:@"quantity"];
        }
    }
    
    return self;
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
    [order_part_id release];
    [goods_title release];
    [goods_guige_label release];
    [brand_id release];
    [image release];
    [goods_iguige_value release];
    [sales_price release];
    [goods_iguige_label release];
    [goods_guige_value release];
    [part_order_status release];
    [market_price release];
    [goods_id release];
    [quantity release];
    
    [super dealloc];
#endif
}

@end
