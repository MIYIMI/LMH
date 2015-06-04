//
//  CartBrandVO.m
//  YingMeiHui
//
//  Created by work on 14-10-20.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "CartBrandVO.h"

@implementation CartBrandVO
@synthesize event_title;
@synthesize brand_id;
@synthesize logo_url;
@synthesize discount_word;
@synthesize product_arr;
@synthesize event_discount;

+ (CartBrandVO *)CartBrandVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [CartBrandVO CartBrandVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (CartBrandVO *)CartBrandVOWithDictionary:(NSDictionary *)dictionary
{
    CartBrandVO *instance = [[CartBrandVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)CartBrandVOListWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[CartBrandVO CartBrandVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"event_title"] && ![[dictionary objectForKey:@"event_title"] isEqual:[NSNull null]]) {
            self.event_title = [dictionary objectForKey:@"event_title"];
        }
        
        if (nil != [dictionary objectForKey:@"brand_id"] && ![[dictionary objectForKey:@"brand_id"] isEqual:[NSNull null]]) {
            self.brand_id = [dictionary objectForKey:@"brand_id"];
        }
        
        if (nil != [dictionary objectForKey:@"logo_url"] && ![[dictionary objectForKey:@"logo_url"] isEqual:[NSNull null]]) {
            self.logo_url = [dictionary objectForKey:@"logo_url"];
        }
        
        if (nil != [dictionary objectForKey:@"discount_word"] && ![[dictionary objectForKey:@"discount_word"] isEqual:[NSNull null]]) {
            self.discount_word = [dictionary objectForKey:@"discount_word"];
        }
        
        if (nil != [dictionary objectForKey:@"product_arr"] && ![[dictionary objectForKey:@"product_arr"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"product_arr"] isKindOfClass:[NSArray class]]) {
            self.product_arr = [CartProductVO CartProductVOListWithArray:[dictionary objectForKey:@"product_arr"]];
        }
        
        if (nil != [dictionary objectForKey:@"event_discount"] && ![[dictionary objectForKey:@"event_discount"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"event_discount"] isKindOfClass:[NSArray class]]) {
            self.event_discount = [CartBrandDis CartBrandDisWithArray:[dictionary objectForKey:@"event_discount"]];
        }
    }
    
    return self;
}

@end

