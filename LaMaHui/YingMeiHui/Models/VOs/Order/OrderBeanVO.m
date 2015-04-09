//
//  OrderBeanVO.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-17.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "OrderBeanVO.h"

@implementation OrderBeanVO

@synthesize ID;
@synthesize OrderPrice;
@synthesize CreateTime;
@synthesize PayTime;
@synthesize Status;
@synthesize ProductID;
@synthesize ProductTitle;
@synthesize PicUrl;
@synthesize ItemNum;
@synthesize ItemPrice;
@synthesize AddressID;
@synthesize Freight;

+ (OrderBeanVO *)OrderBeanVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [OrderBeanVO OrderBeanVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (OrderBeanVO *)OrderBeanVOWithDictionary:(NSDictionary *)dictionary
{
    OrderBeanVO *instance = [[OrderBeanVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)OrderBeanVOListWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[OrderBeanVO OrderBeanVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"id"] && ![[dictionary objectForKey:@"id"] isEqual:[NSNull null]]) {
            self.ID = [dictionary objectForKey:@"id"];
        }
        
        if (nil != [dictionary objectForKey:@"order_price"] && ![[dictionary objectForKey:@"order_price"] isEqual:[NSNull null]]) {
            self.OrderPrice = [dictionary objectForKey:@"order_price"];
        }
        
        if (nil != [dictionary objectForKey:@"create_time"] && ![[dictionary objectForKey:@"create_time"] isEqual:[NSNull null]]) {
            self.CreateTime = [dictionary objectForKey:@"create_time"];
        }
        
        if (nil != [dictionary objectForKey:@"pay_time"] && ![[dictionary objectForKey:@"pay_time"] isEqual:[NSNull null]]) {
            self.PayTime = [dictionary objectForKey:@"pay_time"];
        }
        
        if (nil != [dictionary objectForKey:@"status"] && ![[dictionary objectForKey:@"status"] isEqual:[NSNull null]]) {
            self.Status = [dictionary objectForKey:@"status"];
        }
        
        
        if (nil != [dictionary objectForKey:@"product_id"] && ![[dictionary objectForKey:@"product_id"] isEqual:[NSNull null]]) {
            self.ProductID = [dictionary objectForKey:@"product_id"];
        }
        
        if (nil != [dictionary objectForKey:@"product_title"] && ![[dictionary objectForKey:@"product_title"] isEqual:[NSNull null]]) {
            self.ProductTitle = [dictionary objectForKey:@"product_title"];
        }
        
        if (nil != [dictionary objectForKey:@"pic_url"] && ![[dictionary objectForKey:@"pic_url"] isEqual:[NSNull null]]) {
            self.PicUrl = [dictionary objectForKey:@"pic_url"];
        }
        
        if (nil != [dictionary objectForKey:@"image"] && ![[dictionary objectForKey:@"image"] isEqual:[NSNull null]]) {
            self.PicUrl = [dictionary objectForKey:@"image"];
        }
        
        if (nil != [dictionary objectForKey:@"item_num"] && ![[dictionary objectForKey:@"item_num"] isEqual:[NSNull null]]) {
            self.ItemNum = [dictionary objectForKey:@"item_num"];
        }
        
        if (nil != [dictionary objectForKey:@"product_num"] && ![[dictionary objectForKey:@"product_num"] isEqual:[NSNull null]]) {
            self.ItemNum = [dictionary objectForKey:@"product_num"];
        }
        
        if (nil != [dictionary objectForKey:@"order_price"] && ![[dictionary objectForKey:@"order_price"] isEqual:[NSNull null]]) {
            self.ItemPrice = [dictionary objectForKey:@"order_price"];
        }
        
        if (nil != [dictionary objectForKey:@"address_id"] && ![[dictionary objectForKey:@"address_id"] isEqual:[NSNull null]]) {
            self.AddressID = [dictionary objectForKey:@"address_id"];
        }
        
        if (nil != [dictionary objectForKey:@"freight"] && ![[dictionary objectForKey:@"freight"] isEqual:[NSNull null]]) {
            self.Freight = [dictionary objectForKey:@"freight"];
        }
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
    [descriptionOutput appendFormat: @"ID = \"%@\"\r\n", ID];
    [descriptionOutput appendFormat: @"OrderPrice = \"%@\"\r\n", OrderPrice];
    [descriptionOutput appendFormat: @"CreateTime = \"%@\"\r\n", CreateTime];
    [descriptionOutput appendFormat: @"PayTime = \"%@\"\r\n", PayTime];
    [descriptionOutput appendFormat: @"Status = \"%@\"\r\n", Status];
    [descriptionOutput appendFormat: @"ProductID = \"%@\"\r\n", ProductID];
    [descriptionOutput appendFormat: @"ProductTitle = \"%@\"\r\n", ProductTitle];
    [descriptionOutput appendFormat: @"PicUrl = \"%@\"\r\n", PicUrl];
    [descriptionOutput appendFormat: @"ItemNum = \"%@\"\r\n", ItemNum];
    [descriptionOutput appendFormat: @"ItemPrice = \"%@\"\r\n", ItemPrice];
    [descriptionOutput appendFormat: @"AddressID = \"%@\"\r\n", AddressID];
    [descriptionOutput appendFormat: @"Freight = \"%@\"\r\n", Freight];
    
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
	[ID release];
	[OrderPrice release];
	[CreateTime release];
	[PayTime release];
	[Status release];
	[ProductID release];
	[ProductTitle release];
	[PicUrl release];
	[ItemNum release];
	[ItemPrice release];
	[AddressID release];
	[Freight release];
    
    [super dealloc];
#endif
}

@end
