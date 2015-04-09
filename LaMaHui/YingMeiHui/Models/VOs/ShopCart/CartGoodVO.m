//
//  CartGoodVO.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-8-13.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "CartGoodVO.h"

@implementation CartGoodVO

@synthesize total_fee;
@synthesize count;
@synthesize discount_fee;
@synthesize discount_info;
@synthesize shipping_fee;
@synthesize event_data;
@synthesize taobao_cart_url;

+ (CartGoodVO *)CartGoodVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [CartGoodVO CartGoodVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (CartGoodVO *)CartGoodVOWithDictionary:(NSDictionary *)dictionary
{
    CartGoodVO *instance = [[CartGoodVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)CartGoodVOListWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[CartGoodVO CartGoodVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"total_fee"] && ![[dictionary objectForKey:@"total_fee"] isEqual:[NSNull null]]) {
            self.total_fee = [dictionary objectForKey:@"total_fee"];
        }
        
        if (nil != [dictionary objectForKey:@"count"] && ![[dictionary objectForKey:@"count"] isEqual:[NSNull null]]) {
            self.count = [dictionary objectForKey:@"count"];
        }
        
        if (nil != [dictionary objectForKey:@"discount_fee"] && ![[dictionary objectForKey:@"discount_fee"] isEqual:[NSNull null]]) {
            self.discount_fee = [dictionary objectForKey:@"discount_fee"];
        }
        
        if (nil != [dictionary objectForKey:@"discount_info"] && ![[dictionary objectForKey:@"discount_info"] isEqual:[NSNull null]]) {
            self.discount_info = [dictionary objectForKey:@"discount_info"];
        }
        
        if (nil != [dictionary objectForKey:@"shipping_fee"] && ![[dictionary objectForKey:@"shipping_fee"] isEqual:[NSNull null]]) {
            self.shipping_fee = [dictionary objectForKey:@"shipping_fee"];
        }
        
        if (nil != [dictionary objectForKey:@"event_data"] && ![[dictionary objectForKey:@"event_data"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"event_data"] isKindOfClass:[NSArray class]]) {
            self.event_data = [CartBrandVO CartBrandVOListWithArray:[dictionary objectForKey:@"event_data"]];
        }
        
        if (nil != [dictionary objectForKey:@"taobao_cart_url"] && ![[dictionary objectForKey:@"taobao_cart_url"] isEqual:[NSNull null]]) {
            self.taobao_cart_url = [dictionary objectForKey:@"taobao_cart_url"];
        }
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
    [descriptionOutput appendFormat: @"ItemID = \"%@\"\r\n", total_fee];
    [descriptionOutput appendFormat: @"SellPrice = \"%@\"\r\n", count];
    [descriptionOutput appendFormat: @"OriginalPrice = \"%@\"\r\n", discount_fee];
    [descriptionOutput appendFormat: @"Qty = \"%@\"\r\n", discount_info];
    [descriptionOutput appendFormat: @"ProductName = \"%@\"\r\n", shipping_fee];
    [descriptionOutput appendFormat: @"ProductImage = \"%@\"\r\n", event_data];
    
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
	[total_fee release];
	[count release];
	[discount_fee release];
	[discount_info release];
	[shipping_fee release];
	[event_data release];
    
    [super dealloc];
#endif
}

@end
