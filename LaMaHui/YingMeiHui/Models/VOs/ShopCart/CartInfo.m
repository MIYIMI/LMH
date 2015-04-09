//
//  CartInfo.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-8-15.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "CartInfo.h"

@implementation CartInfo

@synthesize CartMoney;
@synthesize Freight;
@synthesize SaleInfos;

+ (CartInfo *)CartInfoWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [CartInfo CartInfoWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (CartInfo *)CartInfoWithDictionary:(NSDictionary *)dictionary
{
    CartInfo *instance = [[CartInfo alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)CartGoodVOListWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[CartInfo CartInfoWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"cart_info"] && ![[dictionary objectForKey:@"cart_info"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"cart_info"] isKindOfClass:[NSDictionary class]]) {
            
            if (nil != [[dictionary objectForKey:@"cart_info"] objectForKey:@"cartMoney"] && ![[[dictionary objectForKey:@"cart_info"] objectForKey:@"cartMoney"] isEqual:[NSNull null]]) {
                self.CartMoney = [[dictionary objectForKey:@"cart_info"] objectForKey:@"cartMoney"];
            }
            
            if (nil != [[dictionary objectForKey:@"cart_info"] objectForKey:@"freight_price"] && ![[[dictionary objectForKey:@"cart_info"] objectForKey:@"freight_price"] isEqual:[NSNull null]]) {
                self.Freight = [[dictionary objectForKey:@"cart_info"] objectForKey:@"freight_price"];
            }
        }
        
        if (nil != [dictionary objectForKey:@"sales_info"] && ![[dictionary objectForKey:@"sales_info"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"sales_info"] isKindOfClass:[NSArray class]]) {
            self.SaleInfos = [SalesInfo SalesInfoListWithArray:[dictionary objectForKey:@"sales_info"]];
        }
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
    [descriptionOutput appendFormat: @"CartMoney = \"%@\"\r\n", CartMoney];
    [descriptionOutput appendFormat: @"Freight = \"%@\"\r\n", Freight];
    [descriptionOutput appendFormat: @"SaleInfos = \"%@\"\r\n", SaleInfos];
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
	[CartMoney release];
	[Freight release];
	[SaleInfos release];
    
    [super dealloc];
#endif
}

@end
