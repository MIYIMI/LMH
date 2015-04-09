//
//  ProductListVO.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-3.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "ProductListVO.h"

@implementation ProductListVO

@synthesize Code;
@synthesize Msg;
@synthesize Total;
@synthesize SellTimeTo;
@synthesize ActivityTip;
@synthesize ProductList;

+ (ProductListVO *)ProductListVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [ProductListVO ProductListVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (ProductListVO *)ProductListVOWithDictionary:(NSDictionary *)dictionary
{
    ProductListVO *instance = [[ProductListVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"code"] && ![[dictionary objectForKey:@"code"] isEqual:[NSNull null]]) {
            self.Code = [dictionary objectForKey:@"code"];
        }
        
        if (nil != [dictionary objectForKey:@"msg"] && ![[dictionary objectForKey:@"msg"] isEqual:[NSNull null]]) {
            self.Msg = [dictionary objectForKey:@"msg"];
        }
        
        if (nil != [dictionary objectForKey:@"total_count"] && ![[dictionary objectForKey:@"total_count"] isEqual:[NSNull null]]) {
            self.Total = [dictionary objectForKey:@"total_count"];
        }
        
        if (nil != [dictionary objectForKey:@"sell_time_to"] && ![[dictionary objectForKey:@"sell_time_to"] isEqual:[NSNull null]]) {
            self.SellTimeTo = [dictionary objectForKey:@"sell_time_to"];
        }
        
        if (nil != [dictionary objectForKey:@"activity_tip"] && ![[dictionary objectForKey:@"activity_tip"] isEqual:[NSNull null]]) {
            self.ActivityTip = [dictionary objectForKey:@"activity_tip"];
        }
        
        if (nil != [dictionary objectForKey:@"productlist"] && ![[dictionary objectForKey:@"productlist"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"productlist"] isKindOfClass:[NSArray class]]) {
            self.ProductList = [ProductVO ProductVOListWithArray:[dictionary objectForKey:@"productlist"]];
        }
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
    [descriptionOutput appendFormat: @"Code = \"%@\"\r\n", Code];
    [descriptionOutput appendFormat: @"Msg = \"%@\"\r\n", Msg];
    [descriptionOutput appendFormat: @"Total = \"%@\"\r\n", Total];
    [descriptionOutput appendFormat: @"SellTimeTo = \"%@\"\r\n", SellTimeTo];
    [descriptionOutput appendFormat: @"ActivityTip = \"%@\"\r\n", ActivityTip];
    [descriptionOutput appendFormat: @"ProductList = \"%@\"\r\n", ProductList];
    
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
	[Code release];
	[Msg release];
	[Total release];
	[SellTimeTo release];
	[ActivityTip release];
	[ProductList release];
    
    [super dealloc];
#endif
}

@end
