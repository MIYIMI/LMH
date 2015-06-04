//
//  OrderInfoVO.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-18.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "OrderInfoVO.h"

@implementation OrderInfoVO

@synthesize pay_amount;
@synthesize pay_freight;
@synthesize coupon_title;
@synthesize discount_money;
@synthesize pay_status_name;
@synthesize create_at;
@synthesize part_orders;
@synthesize pay_at;
@synthesize order_id;
@synthesize pay_credit;
@synthesize pay_status;
@synthesize total_money;
@synthesize detail_info;

+ (OrderInfoVO *)OrderInfoVOWithDictionary:(NSDictionary *)dictionary
{
    OrderInfoVO *instance = [[OrderInfoVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)OrderInfoVOListWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[OrderInfoVO OrderInfoVOWithDictionary:entry]];
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
        
        if (nil != [dictionary objectForKey:@"pay_freight"] && ![[dictionary objectForKey:@"pay_freight"] isEqual:[NSNull null]]) {
            self.pay_freight = [dictionary objectForKey:@"pay_freight"];
        }
        
        if (nil != [dictionary objectForKey:@"coupon_title"] && ![[dictionary objectForKey:@"coupon_title"] isEqual:[NSNull null]]) {
            self.coupon_title = [dictionary objectForKey:@"coupon_title"];
        }
        
        if (nil != [dictionary objectForKey:@"discount_money"] && ![[dictionary objectForKey:@"discount_money"] isEqual:[NSNull null]]) {
            self.discount_money = [dictionary objectForKey:@"discount_money"];
        }
        
        if (nil != [dictionary objectForKey:@"pay_status_name"] && ![[dictionary objectForKey:@"pay_status_name"] isEqual:[NSNull null]]) {
            self.pay_status_name = [dictionary objectForKey:@"pay_status_name"];
        }
        
        if (nil != [dictionary objectForKey:@"create_at"] && ![[dictionary objectForKey:@"create_at"] isEqual:[NSNull null]]) {
            self.create_at = [dictionary objectForKey:@"create_at"];
        }
        
        if (nil != [dictionary objectForKey:@"event"] && ![[dictionary objectForKey:@"event"] isEqual:[NSNull null]] &&[[dictionary objectForKey:@"event"] isKindOfClass:[NSArray class]]) {
            self.part_orders = [OrderEventVO OrderEventVOListWithArray:[dictionary objectForKey:@"event"]];
        }
        
        if (nil != [dictionary objectForKey:@"pay_at"] && ![[dictionary objectForKey:@"pay_at"] isEqual:[NSNull null]]) {
            self.pay_at = [dictionary objectForKey:@"pay_at"];
        }
        
        if (nil != [dictionary objectForKey:@"order_id"] && ![[dictionary objectForKey:@"order_id"] isEqual:[NSNull null]]) {
            self.order_id = [dictionary objectForKey:@"order_id"];
        }
        
        if (nil != [dictionary objectForKey:@"pay_credit"] && ![[dictionary objectForKey:@"pay_credit"] isEqual:[NSNull null]]) {
            self.pay_credit = [dictionary objectForKey:@"pay_credit"];
        }
        
        if (nil != [dictionary objectForKey:@"pay_status"] && ![[dictionary objectForKey:@"pay_status"] isEqual:[NSNull null]]) {
            self.pay_status = [dictionary objectForKey:@"pay_status"];
        }
        
        if (nil != [dictionary objectForKey:@"total_money"] && ![[dictionary objectForKey:@"total_money"] isEqual:[NSNull null]]) {
            self.total_money = [dictionary objectForKey:@"total_money"];
        }
      
        if (nil != [dictionary objectForKey:@"detail_info"] && ![[dictionary objectForKey:@"detail_info"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"detail_info"] isKindOfClass:[NSArray class]]) {
            self.detail_info = [dictionary objectForKey:@"detail_info"];
        }
    }
    
    return self;
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
    [pay_amount release];
    [pay_freight release];
    [pay_status_name release];
    [create_at release];
    [part_orders release];
    [pay_at release];
    [order_id release];
    [pay_credit release];
    [pay_status release];
    
    [super dealloc];
#endif
}

@end
