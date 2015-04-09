//
//  MenuItemVO.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-6-17.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "MenuItemVO.h"

@implementation MenuItemVO

@synthesize ItemID;
@synthesize ItemType;
@synthesize ItemName;
@synthesize Pic;
@synthesize LogoPic;
@synthesize SaleTip;
@synthesize SaleInfo;
@synthesize SalePrice;
@synthesize MarketPrice;

+ (MenuItemVO *)MenuItemVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [MenuItemVO MenuItemVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (MenuItemVO *)MenuItemVOWithDictionary:(NSDictionary *)dictionary
{
    MenuItemVO *instance = [[MenuItemVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)MenuItemVOListWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[MenuItemVO MenuItemVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"item_id"] && ![[dictionary objectForKey:@"item_id"] isEqual:[NSNull null]]) {
            self.ItemID = [dictionary objectForKey:@"item_id"];
        }
        
        if (nil != [dictionary objectForKey:@"item_type"] && ![[dictionary objectForKey:@"item_type"] isEqual:[NSNull null]]) {
            self.ItemType = [dictionary objectForKey:@"item_type"];
        }
        
        if (nil != [dictionary objectForKey:@"item_name"] && ![[dictionary objectForKey:@"item_name"] isEqual:[NSNull null]]) {
            self.ItemName = [dictionary objectForKey:@"item_name"];
        }
        
        if (nil != [dictionary objectForKey:@"pic"] && ![[dictionary objectForKey:@"pic"] isEqual:[NSNull null]]) {
            self.Pic = [dictionary objectForKey:@"pic"];
        }
        
        if (nil != [dictionary objectForKey:@"logo_pic"] && ![[dictionary objectForKey:@"logo_pic"] isEqual:[NSNull null]]) {
            self.LogoPic = [dictionary objectForKey:@"logo_pic"];
        }
        
        if (nil != [dictionary objectForKey:@"sale_tip"] && ![[dictionary objectForKey:@"sale_tip"] isEqual:[NSNull null]]) {
            self.SaleTip = [dictionary objectForKey:@"sale_tip"];
        }
        
        if (nil != [dictionary objectForKey:@"sale_info"] && ![[dictionary objectForKey:@"sale_info"] isEqual:[NSNull null]]) {
            self.SaleInfo = [dictionary objectForKey:@"sale_info"];
        }
        
        if (nil != [dictionary objectForKey:@"sale_price"] && ![[dictionary objectForKey:@"sale_price"] isEqual:[NSNull null]]) {
            self.SalePrice = [dictionary objectForKey:@"sale_price"];
        }
        
        if (nil != [dictionary objectForKey:@"market_price"] && ![[dictionary objectForKey:@"market_price"] isEqual:[NSNull null]]) {
            self.MarketPrice = [dictionary objectForKey:@"market_price"];
        }
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
    [descriptionOutput appendFormat: @"ItemID = \"%@\"\r\n", ItemID];
    [descriptionOutput appendFormat: @"ItemType = \"%@\"\r\n", ItemType];
    [descriptionOutput appendFormat: @"ItemName = \"%@\"\r\n", ItemName];
    [descriptionOutput appendFormat: @"Pic = \"%@\"\r\n", Pic];
    [descriptionOutput appendFormat: @"LogoPic = \"%@\"\r\n", LogoPic];
    [descriptionOutput appendFormat: @"SaleTip = \"%@\"\r\n", SaleTip];
    [descriptionOutput appendFormat: @"SaleInfo = \"%@\"\r\n", SaleInfo];
    [descriptionOutput appendFormat: @"SalePrice = \"%@\"\r\n", SalePrice];
    [descriptionOutput appendFormat: @"MarketPrice = \"%@\"\r\n", MarketPrice];
    
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
	[ItemID release];
	[ItemType release];
	[ItemName release];
	[Pic release];
	[LogoPic release];
	[SaleTip release];
	[SaleInfo release];
	[SalePrice release];
	[MarketPrice release];
    
    [super dealloc];
#endif
}

@end
