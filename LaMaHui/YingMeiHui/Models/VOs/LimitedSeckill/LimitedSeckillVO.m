//
//  LimitedSeckillVO.m
//  YingMeiHui
//
//  Created by 辣妈汇 on 14-10-24.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "LimitedSeckillVO.h"

@implementation LimitedSeckillVO

@synthesize freight_free;
@synthesize product_id;
@synthesize sold_quantity;
@synthesize product_name;
@synthesize pic;
@synthesize seckill_id;
@synthesize our_price;
@synthesize market_price;
@synthesize stock;
@synthesize surplus;
@synthesize taobao_price;
@synthesize is_start_sale;
@synthesize sale_tip;

+ (LimitedSeckillVO *)LimitedSeckillVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [LimitedSeckillVO LimitedSeckillVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (NSArray *)LimitedSeckillVOListWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[LimitedSeckillVO LimitedSeckillVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

+ (LimitedSeckillVO *)LimitedSeckillVOWithDictionary:(NSDictionary *)dictionary
{
    LimitedSeckillVO *instance = [[LimitedSeckillVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"freight_free"] && ![[dictionary objectForKey:@"freight_free"] isEqual:[NSNull null]]) {
            self.freight_free = [dictionary objectForKey:@"freight_free"];
        }
        
        if (nil != [dictionary objectForKey:@"product_id"] && ![[dictionary objectForKey:@"product_id"] isEqual:[NSNull null]]) {
            self.product_id = [dictionary objectForKey:@"product_id"];
        }
        
        if (nil != [dictionary objectForKey:@"sold_quantity"] && ![[dictionary objectForKey:@"sold_quantity"] isEqual:[NSNull null]]) {
            self.sold_quantity = [dictionary objectForKey:@"sold_quantity"];
        }
        if (nil != [dictionary objectForKey:@"product_name"] && ![[dictionary objectForKey:@"product_name"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"product_name"] isKindOfClass:[NSArray class]]) {
            self.product_name = [dictionary objectForKey:@"product_name"];
        }
        if (nil != [dictionary objectForKey:@"pic"] && ![[dictionary objectForKey:@"pic"] isEqual:[NSNull null]] ) {
            self.pic = [dictionary objectForKey:@"pic"];
        }
        if (nil != [dictionary objectForKey:@"seckill_id"] && ![[dictionary objectForKey:@"seckill_id"] isEqual:[NSNull null]]) {
            self.seckill_id = [dictionary objectForKey:@"seckill_id"];
        }
        if (nil != [dictionary objectForKey:@"our_price"] && ![[dictionary objectForKey:@"our_price"] isEqual:[NSNull null]]) {
            self.our_price = [dictionary objectForKey:@"our_price"];
        }
        if (nil != [dictionary objectForKey:@"market_price"] && ![[dictionary objectForKey:@"market_price"] isEqual:[NSNull null]]) {
            self.market_price = [dictionary objectForKey:@"market_price"];
        }
        if (nil != [dictionary objectForKey:@"stock"] && ![[dictionary objectForKey:@"stock"] isEqual:[NSNull null]]) {
            self.stock = [dictionary objectForKey:@"stock"];
        }
        if (nil != [dictionary objectForKey:@"surplus"] && ![[dictionary objectForKey:@"surplus"] isEqual:[NSNull null]]) {
            self.surplus = [dictionary objectForKey:@"surplus"];
        }
        if (nil != [dictionary objectForKey:@"taobao_price"] && ![[dictionary objectForKey:@"taobao_price"] isEqual:[NSNull null]]) {
            self.taobao_price = [dictionary objectForKey:@"taobao_price"];
        }
        if (nil != [dictionary objectForKey:@"is_start_sale"] && ![[dictionary objectForKey:@"is_start_sale"] isEqual:[NSNull null]]) {
            self.is_start_sale = [dictionary objectForKey:@"is_start_sale"];
        }
        if (nil != [dictionary objectForKey:@"sale_tip"] && ![[dictionary objectForKey:@"sale_tip"] isEqual:[NSNull null]]) {
            self.sale_tip = [dictionary objectForKey:@"sale_tip"];
        }
        if (nil != [dictionary objectForKey:@"taobao_detail_url"] && ![[dictionary objectForKey:@"taobao_detail_url"] isEqual:[NSNull null]]) {
            self.taobao_detail_url = [dictionary objectForKey:@"taobao_detail_url"];
        }
    }
    
    return self;
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
    [code release];
    [msg release];
    
    [super dealloc];
#endif
}

@end
