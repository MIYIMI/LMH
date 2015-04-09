//
//  SellsoonbrandVO.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-3-31.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "SellsoonbrandVO.h"

@implementation SellsoonbrandVO

@synthesize BrandID;
@synthesize BrandName;
@synthesize Pic;
@synthesize SellTimeFrom;
@synthesize SellTimeTo;
@synthesize IsSubscribed;

+ (SellsoonbrandVO *)SellsoonbrandVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [SellsoonbrandVO SellsoonbrandVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (SellsoonbrandVO *)SellsoonbrandVOWithDictionary:(NSDictionary *)dictionary
{
    SellsoonbrandVO *instance = [[SellsoonbrandVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)SellsoonbrandVOListWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[SellsoonbrandVO SellsoonbrandVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"brand_id"] && ![[dictionary objectForKey:@"brand_id"] isEqual:[NSNull null]]) {
            self.BrandID = [dictionary objectForKey:@"brand_id"];
        }
        
        if (nil != [dictionary objectForKey:@"brand_name"] && ![[dictionary objectForKey:@"brand_name"] isEqual:[NSNull null]]) {
            self.BrandName = [dictionary objectForKey:@"brand_name"];
        }
        
        if (nil != [dictionary objectForKey:@"pic"] && ![[dictionary objectForKey:@"pic"] isEqual:[NSNull null]]) {
            self.Pic = [dictionary objectForKey:@"pic"];
        }
        
        if (nil != [dictionary objectForKey:@"sell_time_from"] && ![[dictionary objectForKey:@"sell_time_from"] isEqual:[NSNull null]]) {
            self.SellTimeFrom = [dictionary objectForKey:@"sell_time_from"];
        }
        
        if (nil != [dictionary objectForKey:@"sell_time_to"] && ![[dictionary objectForKey:@"sell_time_to"] isEqual:[NSNull null]]) {
            self.SellTimeTo = [dictionary objectForKey:@"sell_time_to"];
        }
        
        if (nil != [dictionary objectForKey:@"subscribed"] && ![[dictionary objectForKey:@"subscribed"] isEqual:[NSNull null]]) {
            self.IsSubscribed = [dictionary objectForKey:@"subscribed"];
        }
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
    [descriptionOutput appendFormat: @"BrandID = \"%@\"\r\n", BrandID];
    [descriptionOutput appendFormat: @"BrandName = \"%@\"\r\n", BrandName];
    [descriptionOutput appendFormat: @"Pic = \"%@\"\r\n", Pic];
    [descriptionOutput appendFormat: @"SellTimeFrom = \"%@\"\r\n", SellTimeFrom];
    [descriptionOutput appendFormat: @"SellTimeTo = \"%@\"\r\n", SellTimeTo];
    [descriptionOutput appendFormat: @"IsSubscribed = \"%@\"\r\n", IsSubscribed];
    
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
	[BrandID release];
	[BrandName release];
	[Pic release];
	[SellTimeFrom release];
	[SellTimeTo release];
	[IsSubscribed release];
    
    [super dealloc];
#endif
}

@end
