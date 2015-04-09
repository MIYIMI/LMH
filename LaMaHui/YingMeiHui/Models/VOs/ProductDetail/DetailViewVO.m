//
//  DetailViewVO.m
//  YingMeiHui
//
//  Created by work on 14-10-9.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "DetailViewVO.h"
#import "CommentsVO.h"

@implementation DetailViewVO
@synthesize Code;
@synthesize Msg;
@synthesize productDict;
@synthesize brandDict;
@synthesize likeArray;
@synthesize comments;

+ (DetailViewVO *)DetailViewVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [DetailViewVO DetailViewVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

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
            self.likeArray = [LikeProductVO LikeProductVOWithArray:[dictionary objectForKey:@"like_goods"]];
        }
        
        if (nil != [dictionary objectForKey:@"comments"] && ![[dictionary objectForKey:@"comments"] isEqual:[NSNull null]]) {
            self.comments = [CommentsVO CommentsVOWithDictionary:[dictionary objectForKey:@"comments"]];
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
