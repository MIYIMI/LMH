//
//  BrandListVO.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-3-31.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "BrandListVO.h"

@implementation BrandListVO

@synthesize Code;
@synthesize Msg;
@synthesize SectionValue;
@synthesize Total;
@synthesize BrandList;

+ (BrandListVO *)BrandListVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [BrandListVO BrandListVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (BrandListVO *)BrandListVOWithDictionary:(NSDictionary *)dictionary
{
    BrandListVO *instance = [[BrandListVO alloc] initWithDictionary:dictionary];
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
        
        if (nil != [dictionary objectForKey:@"section_value"] && ![[dictionary objectForKey:@"section_value"] isEqual:[NSNull null]]) {
            self.SectionValue = [dictionary objectForKey:@"section_value"];
        }
        
        if (nil != [dictionary objectForKey:@"total_count"] && ![[dictionary objectForKey:@"total_count"] isEqual:[NSNull null]]) {
            self.Total = [dictionary objectForKey:@"total_count"];
        }
        
        if (nil != [dictionary objectForKey:@"itemslist"] && ![[dictionary objectForKey:@"itemslist"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"itemslist"] isKindOfClass:[NSArray class]]) {
            self.BrandList = [MenuItemVO MenuItemVOListWithArray:[dictionary objectForKey:@"itemslist"]];
        }
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
    [descriptionOutput appendFormat: @"Code = \"%@\"\r\n", Code];
    [descriptionOutput appendFormat: @"Msg = \"%@\"\r\n", Msg];
    [descriptionOutput appendFormat: @"SectionValue = \"%@\"\r\n", SectionValue];
    [descriptionOutput appendFormat: @"Total = \"%@\"\r\n", Total];
    [descriptionOutput appendFormat: @"BrandList = \"%@\"\r\n", BrandList];
    
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
	[Code release];
	[Msg release];
	[SectionValue release];
	[Total release];
	[BrandList release];
    
    [super dealloc];
#endif
}

@end
