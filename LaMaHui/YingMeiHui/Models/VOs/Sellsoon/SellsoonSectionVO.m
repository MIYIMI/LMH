//
//  SellsoonSectionVO.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-3-31.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "SellsoonSectionVO.h"

@implementation SellsoonSectionVO

@synthesize Title;
@synthesize TitleTip;
@synthesize SellsoonList;

+ (SellsoonSectionVO *)SellsoonSectionVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [SellsoonSectionVO SellsoonSectionVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (SellsoonSectionVO *)SellsoonSectionVOWithDictionary:(NSDictionary *)dictionary
{
    SellsoonSectionVO *instance = [[SellsoonSectionVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)SellsoonSectionVOListWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        if (nil != [entry objectForKey:@"sellsoonbrands"] && ![[entry objectForKey:@"sellsoonbrands"] isEqual:[NSNull null]] && [[entry objectForKey:@"sellsoonbrands"] isKindOfClass:[NSArray class]] && [[entry objectForKey:@"sellsoonbrands"] count] != 0) {
            [resultsArray addObject:[SellsoonSectionVO SellsoonSectionVOWithDictionary:entry]];
        }
//        [resultsArray addObject:[SellsoonSectionVO SellsoonSectionVOWithDictionary:entry]];
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
        
        if (nil != [dictionary objectForKey:@"title_tip"] && ![[dictionary objectForKey:@"title_tip"] isEqual:[NSNull null]]) {
            self.TitleTip = [dictionary objectForKey:@"title_tip"];
        }
        
        if (nil != [dictionary objectForKey:@"sellsoonbrands"] && ![[dictionary objectForKey:@"sellsoonbrands"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"sellsoonbrands"] isKindOfClass:[NSArray class]]) {
            self.SellsoonList = [SellsoonbrandVO SellsoonbrandVOListWithArray:[dictionary objectForKey:@"sellsoonbrands"]];
        }
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
    [descriptionOutput appendFormat: @"Title = \"%@\"\r\n", Title];
    [descriptionOutput appendFormat: @"TitleTip = \"%@\"\r\n", TitleTip];
    [descriptionOutput appendFormat: @"SellsoonList = \"%@\"\r\n", SellsoonList];
    
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
	[Title release];
	[TitleTip release];
	[SellsoonList release];
    
    [super dealloc];
#endif
}

@end
