//
//  LikeProductVO.m
//  YingMeiHui
//
//  Created by work on 14-10-9.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "LikeProductVO.h"

@implementation LikeProductVO

@synthesize title;
@synthesize productID;
@synthesize salesPrice;
@synthesize marketPrice;
@synthesize imageUrl;
@synthesize favNum;
@synthesize click_url;

+ (LikeProductVO *)LikeProductVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [LikeProductVO LikeProductVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (NSArray *)LikeProductVOWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[LikeProductVO LikeProductVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

+ (LikeProductVO *)LikeProductVOWithDictionary:(NSDictionary *)dictionary
{
    LikeProductVO *instance = [[LikeProductVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"title"] && ![[dictionary objectForKey:@"title"] isEqual:[NSNull null]]) {
            self.title = [dictionary objectForKey:@"title"];
        }
        
        if (nil != [dictionary objectForKey:@"id"] && ![[dictionary objectForKey:@"id"] isEqual:[NSNull null]]) {
            self.productID = [dictionary objectForKey:@"id"];
        }
        
        if (nil != [dictionary objectForKey:@"sales_price"] && ![[dictionary objectForKey:@"sales_price"] isEqual:[NSNull null]]) {
            self.salesPrice = [dictionary objectForKey:@"sales_price"];
        }
        
        if (nil != [dictionary objectForKey:@"market_price"] && ![[dictionary objectForKey:@"market_price"] isEqual:[NSNull null]]) {
            self.marketPrice = [dictionary objectForKey:@"market_price"];
        }
        
        if (nil != [dictionary objectForKey:@"image"] && ![[dictionary objectForKey:@"image"] isEqual:[NSNull null]]) {
            self.imageUrl = [dictionary objectForKey:@"image"];
        }
        
        if (nil != [dictionary objectForKey:@"fav_num"] && ![[dictionary objectForKey:@"fav_num"] isEqual:[NSNull null]]) {
            self.favNum = [dictionary objectForKey:@"fav_num"];
        }
        
        if (nil != [dictionary objectForKey:@"click_url"] && ![[dictionary objectForKey:@"click_url"] isEqual:[NSNull null]]) {
            self.click_url = [dictionary objectForKey:@"click_url"];
        }
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
    [descriptionOutput appendFormat: @"Code = \"%@\"\r\n", title];
    [descriptionOutput appendFormat: @"Msg = \"%@\"\r\n", productID];
    [descriptionOutput appendFormat: @"BrandTitle = \"%@\"\r\n", salesPrice];
    [descriptionOutput appendFormat: @"Pics = \"%@\"\r\n", marketPrice];
    [descriptionOutput appendFormat: @"Title = \"%@\"\r\n", imageUrl];
    [descriptionOutput appendFormat: @"Title = \"%@\"\r\n", favNum];
    
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
    [title release];
    [productID release];
    [salesPrice release];
    [marketPrice release];
    [imageUrl release];
    [favNum release];
    
    [super dealloc];
#endif
}


@end
