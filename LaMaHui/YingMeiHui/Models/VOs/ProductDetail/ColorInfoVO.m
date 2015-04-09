//
//  ColorInfoVO.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-10.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "ColorInfoVO.h"

@implementation ColorInfoVO

@synthesize ColorID;
@synthesize Name;
@synthesize Pic;
@synthesize SkuNum;

+ (ColorInfoVO *)ColorInfoVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [ColorInfoVO ColorInfoVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (ColorInfoVO *)ColorInfoVOWithDictionary:(NSDictionary *)dictionary
{
    ColorInfoVO *instance = [[ColorInfoVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)ColorInfoVOListWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[ColorInfoVO ColorInfoVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"color_id"] && ![[dictionary objectForKey:@"color_id"] isEqual:[NSNull null]]) {
            self.ColorID = [dictionary objectForKey:@"color_id"];
        }
        
        if (nil != [dictionary objectForKey:@"name"] && ![[dictionary objectForKey:@"name"] isEqual:[NSNull null]]) {
            self.Name = [dictionary objectForKey:@"name"];
        }
        
        if (nil != [dictionary objectForKey:@"image"] && ![[dictionary objectForKey:@"image"] isEqual:[NSNull null]]) {
            self.Pic = [dictionary objectForKey:@"image"];
        }
        
        if (nil != [dictionary objectForKey:@"sku_num"] && ![[dictionary objectForKey:@"sku_num"] isEqual:[NSNull null]]) {
            self.SkuNum = [dictionary objectForKey:@"sku_num"];
        }
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
    [descriptionOutput appendFormat: @"ColorID = \"%@\"\r\n", ColorID];
    [descriptionOutput appendFormat: @"Name = \"%@\"\r\n", Name];
    [descriptionOutput appendFormat: @"Pic = \"%@\"\r\n", Pic];
    [descriptionOutput appendFormat: @"SkuNum = \"%@\"\r\n", SkuNum];
    
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
	[ColorID release];
	[Name release];
	[Pic release];
	[SkuNum release];
    
    [super dealloc];
#endif
}

@end
