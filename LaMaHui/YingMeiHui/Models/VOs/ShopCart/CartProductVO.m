//
//  CartProductVO.m
//  YingMeiHui
//
//  Created by work on 14-10-20.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "CartProductVO.h"

@implementation CartProductVO
@synthesize product_name;
@synthesize qty;
@synthesize product_id;
@synthesize sku;
@synthesize original_price;
@synthesize sell_price;
@synthesize options;
@synthesize item_id;
@synthesize product_image;
@synthesize brand_name;
@synthesize stock;
@synthesize buy_max;
@synthesize buy_min;
@synthesize discount_word;

+ (CartProductVO *)CartProductVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [CartProductVO CartProductVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (CartProductVO *)CartProductVOWithDictionary:(NSDictionary *)dictionary
{
    CartProductVO *instance = [[CartProductVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)CartProductVOListWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[CartProductVO CartProductVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"product_name"] && ![[dictionary objectForKey:@"product_name"] isEqual:[NSNull null]]) {
            self.product_name = [dictionary objectForKey:@"product_name"];
        }
        
        if (nil != [dictionary objectForKey:@"qty"] && ![[dictionary objectForKey:@"qty"] isEqual:[NSNull null]]) {
            self.qty = [dictionary objectForKey:@"qty"];
        }
        
        if (nil != [dictionary objectForKey:@"product_id"] && ![[dictionary objectForKey:@"product_id"] isEqual:[NSNull null]]) {
            self.product_id = [dictionary objectForKey:@"product_id"];
        }
        
        if (nil != [dictionary objectForKey:@"sku"] && ![[dictionary objectForKey:@"sku"] isEqual:[NSNull null]]) {
            self.sku = [dictionary objectForKey:@"sku"];
        }
        
        if (nil != [dictionary objectForKey:@"original_price"] && ![[dictionary objectForKey:@"original_price"] isEqual:[NSNull null]]) {
            self.original_price = [dictionary objectForKey:@"original_price"];
        }
        
        if (nil != [dictionary objectForKey:@"sell_price"] && ![[dictionary objectForKey:@"sell_price"] isEqual:[NSNull null]]) {
            self.sell_price = [dictionary objectForKey:@"sell_price"];
        }
        
        if (nil != [dictionary objectForKey:@"options"] && ![[dictionary objectForKey:@"options"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"options"] isKindOfClass:[NSArray class]]) {
            self.options = [GoodOptionVO GoodOptionVOListWithArray:[dictionary objectForKey:@"options"]];
        }
        
        if (nil != [dictionary objectForKey:@"discount_word"] && ![[dictionary objectForKey:@"discount_word"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"discount_word"] isKindOfClass:[NSArray class]]) {
            self.discount_word = [CartBrandDis CartBrandDisWithArray:[dictionary objectForKey:@"discount_word"]];
        }
        
        if (nil != [dictionary objectForKey:@"item_id"] && ![[dictionary objectForKey:@"item_id"] isEqual:[NSNull null]]) {
            self.item_id = [dictionary objectForKey:@"item_id"];
        }
        
        if (nil != [dictionary objectForKey:@"product_image"] && ![[dictionary objectForKey:@"product_image"] isEqual:[NSNull null]]) {
            self.product_image = [dictionary objectForKey:@"product_image"];
        }
        
        if (nil != [dictionary objectForKey:@"brand_name"] && ![[dictionary objectForKey:@"brand_name"] isEqual:[NSNull null]]) {
            self.brand_name = [dictionary objectForKey:@"brand_name"];
        }
        
        if (nil != [dictionary objectForKey:@"stock"] && ![[dictionary objectForKey:@"stock"] isEqual:[NSNull null]]) {
            self.stock = [dictionary objectForKey:@"stock"];
        }
        
        if (nil != [dictionary objectForKey:@"user_buy_min"] && ![[dictionary objectForKey:@"user_buy_min"] isEqual:[NSNull null]]) {
            self.buy_min = [dictionary objectForKey:@"user_buy_min"];
        }
        
        if (nil != [dictionary objectForKey:@"user_buy_max"] && ![[dictionary objectForKey:@"user_buy_max"] isEqual:[NSNull null]]) {
            self.buy_max = [dictionary objectForKey:@"user_buy_max"];
        }
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
    [descriptionOutput appendFormat: @"ProductName = \"%@\"\r\n", product_name];
    [descriptionOutput appendFormat: @"ProductImage = \"%@\"\r\n", qty];
    [descriptionOutput appendFormat: @"SkuID = \"%@\"\r\n", product_id];
    [descriptionOutput appendFormat: @"BrandName = \"%@\"\r\n", sku];
    [descriptionOutput appendFormat: @"Options = \"%@\"\r\n", original_price];
    [descriptionOutput appendFormat: @"ProductName = \"%@\"\r\n", sell_price];
    [descriptionOutput appendFormat: @"ProductImage = \"%@\"\r\n", options];
    [descriptionOutput appendFormat: @"SkuID = \"%@\"\r\n", item_id];
    [descriptionOutput appendFormat: @"BrandName = \"%@\"\r\n", product_image];
    [descriptionOutput appendFormat: @"Options = \"%@\"\r\n", brand_name];
    [descriptionOutput appendFormat: @"Options = \"%@\"\r\n", stock];
    
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
    [product_name release];
    [qty release];
    [product_id release];
    [sku release];
    [original_price release];
    [sell_price release];
    [options release];
    [item_id release];
    [product_image release];
    [brand_name release];
    [stock release];
    
    [super dealloc];
#endif
}

@end


@implementation CartBrandDis

+ (CartBrandDis *)CartBrandDisWithDictionary:(NSDictionary *)dictionary{
    
    CartBrandDis *instance = [[CartBrandDis alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)CartBrandDisWithArray:(NSArray *)array{
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[CartBrandDis CartBrandDisWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary{
    
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"discount_title"] && ![[dictionary objectForKey:@"discount_title"] isEqual:[NSNull null]]) {
            self.discount_title = [dictionary objectForKey:@"discount_title"];
        }
        
        if (nil != [dictionary objectForKey:@"discount_end_time"] && ![[dictionary objectForKey:@"discount_end_time"] isEqual:[NSNull null]]) {
            self.discount_end_time = [dictionary objectForKey:@"discount_end_time"];
        }
        
        if (nil != [dictionary objectForKey:@"discount_money"] && ![[dictionary objectForKey:@"discount_money"] isEqual:[NSNull null]]) {
            self.discount_money = [dictionary objectForKey:@"discount_money"];
        }
    }
    
    return self;
}

@end
