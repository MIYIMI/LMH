//
//  FavListCellVO.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-6-25.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "FavListCellVO.h"

@implementation FavListCellVO

@synthesize ProductID;
@synthesize ProductName;
@synthesize Pic;
@synthesize OurPrice;
@synthesize MarketPrice;
@synthesize SaleTip;
@synthesize FavTime;

+ (FavListCellVO *)FavListCellVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [FavListCellVO FavListCellVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (FavListCellVO *)FavListCellVOWithDictionary:(NSDictionary *)dictionary
{
    FavListCellVO *instance = [[FavListCellVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)FavListCellVOListWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[FavListCellVO FavListCellVOWithDictionary:entry]];
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
        
        if (nil != [dictionary objectForKey:@"our_price"] && ![[dictionary objectForKey:@"our_price"] isEqual:[NSNull null]]) {
            self.OurPrice = [dictionary objectForKey:@"our_price"];
        }
        
        if (nil != [dictionary objectForKey:@"market_price"] && ![[dictionary objectForKey:@"market_price"] isEqual:[NSNull null]]) {
            self.MarketPrice = [dictionary objectForKey:@"market_price"];
        }
        
        if (nil != [dictionary objectForKey:@"salt_tip"] && ![[dictionary objectForKey:@"salt_tip"] isEqual:[NSNull null]]) {
            self.SaleTip = [dictionary objectForKey:@"salt_tip"];
        }
        
        if (nil != [dictionary objectForKey:@"fav_time"] && ![[dictionary objectForKey:@"fav_time"] isEqual:[NSNull null]]) {
            self.FavTime = [dictionary objectForKey:@"fav_time"];
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
    [descriptionOutput appendFormat: @"FavTime = \"%@\"\r\n", FavTime];
    
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
	[FavTime release];
    
    [super dealloc];
#endif
}

@end
