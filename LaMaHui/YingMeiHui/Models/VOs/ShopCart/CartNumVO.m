//
//  CartNumVO.m
//  YingMeiHui
//
//  Created by work on 14-11-4.
//  Copyright (c) 2014年 xieyanke. All rights reserved.
//

#import "CartNumVO.h"

@implementation CartNumVO

@synthesize product_no_stock;
@synthesize product_stock;
@synthesize stock;
@synthesize product_id;
@synthesize sku_id;

+ (CartNumVO *)CartNumVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [CartNumVO CartNumVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (CartNumVO *)CartNumVOWithDictionary:(NSDictionary *)dictionary
{
    CartNumVO *instance = [[CartNumVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)CartNumVOListWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[CartNumVO CartNumVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"product_stock"] && ![[dictionary objectForKey:@"product_stock"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"product_stock"] isKindOfClass:[NSArray class]]) {
            self.product_stock = [CartNumVO CartNumVOListWithArray:[dictionary objectForKey:@"product_stock"]];
        }
        
        if (nil != [dictionary objectForKey:@"product_no_stock"] && ![[dictionary objectForKey:@"product_no_stock"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"product_no_stock"] isKindOfClass:[NSArray class]]) {
            self.product_no_stock = [CartNumVO CartNumVOListWithArray:[dictionary objectForKey:@"product_no_stock"]];
        }
        
        if (nil != [dictionary objectForKey:@"stock"] && ![[dictionary objectForKey:@"stock"] isEqual:[NSNull null]]) {
            self.stock = [dictionary objectForKey:@"stock"];
        }
        
        if (nil != [dictionary objectForKey:@"product_id"] && ![[dictionary objectForKey:@"product_id"] isEqual:[NSNull null]]) {
            self.product_id = [dictionary objectForKey:@"product_id"];
        }
        
        if (nil != [dictionary objectForKey:@"sku_id"] && ![[dictionary objectForKey:@"sku_id"] isEqual:[NSNull null]]) {
            self.sku_id = [dictionary objectForKey:@"sku_id"];
        }
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
    [descriptionOutput appendFormat: @"Title = \"%@\"\r\n", product_id];
    [descriptionOutput appendFormat: @"Discount = \"%@\"\r\n", product_no_stock];
    [descriptionOutput appendFormat: @"Title = \"%@\"\r\n", product_stock];
    [descriptionOutput appendFormat: @"Discount = \"%@\"\r\n", sku_id];
    [descriptionOutput appendFormat: @"Title = \"%@\"\r\n", stock];

    
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
    [product_id release];
    [product_no_stock release];
    [product_stock release];
    [sku_id release];
    [stock release];
    
    [super dealloc];
#endif
}

@end
