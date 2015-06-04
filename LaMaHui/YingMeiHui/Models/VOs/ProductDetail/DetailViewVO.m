//
//  DetailViewVO.m
//  YingMeiHui
//
//  Created by work on 14-10-9.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "DetailViewVO.h"
#import "CommentsVO.h"
#import "HomeVO.h"

@implementation DetailViewVO
@synthesize Code;
@synthesize Msg;
@synthesize productDict;
@synthesize brandDict;
@synthesize likeArray;
@synthesize comments;
@synthesize evaluate_count;
@synthesize evaluate_list;
@synthesize fav_count;
@synthesize fav_img;

+ (NSArray *)DetailViewVOWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[DetailViewVO DetailViewVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

+ (DetailViewVO *)DetailViewVOWithDictionary:(NSDictionary *)dictionary
{
    DetailViewVO *instance = [[DetailViewVO alloc] initWithDictionary:dictionary];
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
        
        if (nil != [dictionary objectForKey:@"product_info"] && ![[dictionary objectForKey:@"product_info"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"product_info"] isKindOfClass:[NSDictionary class]]) {
            self.productDict = [ProductInfoVO ProductInfoVOWithDictionary:[dictionary objectForKey:@"product_info"]];
        }
        
        if (nil != [dictionary objectForKey:@"brand_info"] && ![[dictionary objectForKey:@"brand_info"] isEqual:[NSNull null]]) {
            self.brandDict = [BrandInfoVO BrandInfoVOWithDictionary:[dictionary objectForKey:@"brand_info"]];
        }
        
        if (nil != [dictionary objectForKey:@"like_goods"] && ![[dictionary objectForKey:@"like_goods"] isEqual:[NSNull null]]) {
            self.likeArray = [HomeProductVO HomeProductVOListWithArray:[dictionary objectForKey:@"like_goods"]];
        }
        
        if (nil != [dictionary objectForKey:@"comments"] && ![[dictionary objectForKey:@"comments"] isEqual:[NSNull null]]) {
            self.comments = [CommentsVO CommentsVOWithDictionary:[dictionary objectForKey:@"comments"]];
        }
        
        if (dictionary[@"evaluate_data"][@"evaluate_list"] && [dictionary[@"evaluate_data"][@"evaluate_list"] isKindOfClass:[NSArray class]]) {
            self.evaluate_list = [LMH_EvaluatedVO LMH_EvaluatedVOListWithArray:dictionary[@"evaluate_data"][@"evaluate_list"]];
        }
        
        if (dictionary[@"evaluate_data"][@"evaluate_list"] && ![dictionary[@"evaluate_data"][@"evaluate_count"] isEqual:[NSNull null]]) {
            self.evaluate_count = dictionary[@"evaluate_data"][@"evaluate_count"];
        }
        
        if (dictionary[@"fav_data"][@"fav_img"] && [dictionary[@"fav_data"][@"fav_img"] isKindOfClass:[NSArray class]]) {
            self.fav_img = dictionary[@"fav_data"][@"fav_img"];
        }
        
        if (dictionary[@"fav_data"][@"fav_count"] && ![dictionary[@"fav_data"][@"fav_count"] isEqual:[NSNull null]]) {
            self.fav_count = dictionary[@"fav_data"][@"fav_count"];
        }
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
    [descriptionOutput appendFormat: @"Code = \"%@\"\r\n", Code];
    [descriptionOutput appendFormat: @"Msg = \"%@\"\r\n", Msg];
    [descriptionOutput appendFormat: @"BrandTitle = \"%@\"\r\n", productDict];
    [descriptionOutput appendFormat: @"Pics = \"%@\"\r\n", brandDict];
    [descriptionOutput appendFormat: @"Title = \"%@\"\r\n", likeArray];
    
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
    [Code release];
    [Msg release];
    [productDict release];
    [brandDict release];
    [likeArray release];
    
    [super dealloc];
#endif
}

@end
