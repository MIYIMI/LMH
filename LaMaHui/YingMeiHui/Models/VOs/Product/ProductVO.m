//
//  ProductVO.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-3.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "ProductVO.h"

@implementation ProductVO

@synthesize ProductID;
@synthesize ProductName;
@synthesize Pic;
@synthesize OurPrice;
@synthesize MarketPrice;
@synthesize SaleTip;
@synthesize SoldOut;
@synthesize Limit;
@synthesize stock;
@synthesize brand_id;
@synthesize brand_title;

+ (ProductVO *)ProductVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [ProductVO ProductVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (ProductVO *)ProductVOWithDictionary:(NSDictionary *)dictionary
{
    ProductVO *instance = [[ProductVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)ProductVOListWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[ProductVO ProductVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"product_id"] && ![[dictionary objectForKey:@"product_id"] isEqual:[NSNull null]]) {
            self.ProductID = [dictionary objectForKey:@"product_id"];
        }
        
        if (nil != [dictionary objectForKey:@"product_name"] && ![[dictionary objectForKey:@"product_name"] isEqual:[NSNull null]]) {
            self.ProductName = [dictionary objectForKey:@"product_name"];
        }
        
        if (nil != [dictionary objectForKey:@"pic"] && ![[dictionary objectForKey:@"pic"] isEqual:[NSNull null]]) {
            self.Pic = [dictionary objectForKey:@"pic"];
        }
        
        if (nil != [dictionary objectForKey:@"sales_price"] && ![[dictionary objectForKey:@"sales_price"] isEqual:[NSNull null]]) {
            self.OurPrice = [dictionary objectForKey:@"sales_price"];
        }
        else if(nil != [dictionary objectForKey:@"our_price"] && ![[dictionary objectForKey:@"our_price"] isEqual:[NSNull null]])
        {
            self.OurPrice = [dictionary objectForKey:@"our_price"];
        }
        
        if (nil != [dictionary objectForKey:@"market_price"] && ![[dictionary objectForKey:@"market_price"] isEqual:[NSNull null]]) {
            self.MarketPrice = [dictionary objectForKey:@"market_price"];
        }
        
        if (nil != [dictionary objectForKey:@"sale_tip"] && ![[dictionary objectForKey:@"sale_tip"] isEqual:[NSNull null]]) {
            self.SaleTip = [dictionary objectForKey:@"sale_tip"];
        }
        
        if (nil != [dictionary objectForKey:@"sold_out"] && ![[dictionary objectForKey:@"sold_out"] isEqual:[NSNull null]]) {
            self.SoldOut = [dictionary objectForKey:@"sold_out"];
        }
        
        if (nil != [dictionary objectForKey:@"is_limit"] && ![[dictionary objectForKey:@"is_limit"] isEqual:[NSNull null]]) {
            self.Limit = [dictionary objectForKey:@"is_limit"];
        }
        
        if (nil != [dictionary objectForKey:@"stock"] && ![[dictionary objectForKey:@"stock"] isEqual:[NSNull null]]) {
            self.stock = [dictionary objectForKey:@"stock"];
        }
        
        if (nil != [dictionary objectForKey:@"brand_id"] && ![[dictionary objectForKey:@"brand_id"] isEqual:[NSNull null]]) {
            self.brand_id = [dictionary objectForKey:@"brand_id"];
        }
        
        if (nil != [dictionary objectForKey:@"brand_title"] && ![[dictionary objectForKey:@"brand_title"] isEqual:[NSNull null]]) {
            self.brand_title = [dictionary objectForKey:@"brand_title"];
        }
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
    [descriptionOutput appendFormat: @"ProductID = \"%@\"\r\n", ProductID];
    [descriptionOutput appendFormat: @"ProductName = \"%@\"\r\n", ProductName];
    [descriptionOutput appendFormat: @"Pic = \"%@\"\r\n", Pic];
    [descriptionOutput appendFormat: @"OurPrice = \"%@\"\r\n", OurPrice];
    [descriptionOutput appendFormat: @"MarketPrice = \"%@\"\r\n", MarketPrice];
    [descriptionOutput appendFormat: @"SaleTip = \"%@\"\r\n", SaleTip];
    [descriptionOutput appendFormat: @"SoldOut = \"%@\"\r\n", SoldOut];
    
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
	[ProductID release];
	[ProductName release];
	[Pic release];
	[OurPrice release];
	[MarketPrice release];
	[SaleTip release];
	[SoldOut release];
    [Limit release];
    [stock release];
    
    [super dealloc];
#endif
}

@end
