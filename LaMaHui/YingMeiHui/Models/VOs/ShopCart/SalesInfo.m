//
//  SalesInfo.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-8-15.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "SalesInfo.h"

@implementation SalesInfo

@synthesize Title;
@synthesize Discount;

+ (SalesInfo *)SalesInfoWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [SalesInfo SalesInfoWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (SalesInfo *)SalesInfoWithDictionary:(NSDictionary *)dictionary
{
    SalesInfo *instance = [[SalesInfo alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)SalesInfoListWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[SalesInfo SalesInfoWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"title"] && ![[dictionary objectForKey:@"title"] isEqual:[NSNull null]]) {
            self.Title = [dictionary objectForKey:@"title"];
        }
        
        if (nil != [dictionary objectForKey:@"discount_money"] && ![[dictionary objectForKey:@"discount_money"] isEqual:[NSNull null]]) {
            self.Discount = [dictionary objectForKey:@"discount_money"];
        }
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
    [descriptionOutput appendFormat: @"Title = \"%@\"\r\n", Title];
    [descriptionOutput appendFormat: @"Discount = \"%@\"\r\n", Discount];
    
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
	[Title release];
	[Discount release];
    
    [super dealloc];
#endif
}

@end
