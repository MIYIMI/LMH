//
//  SizeInfoVO.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-10.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "SizeInfoVO.h"

@implementation SizeInfoVO

@synthesize SizeID;
@synthesize Name;
@synthesize SkuNum;

+ (SizeInfoVO *)SizeInfoVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [SizeInfoVO SizeInfoVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (SizeInfoVO *)SizeInfoVOWithDictionary:(NSDictionary *)dictionary
{
    SizeInfoVO *instance = [[SizeInfoVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)SizeInfoVOListWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[SizeInfoVO SizeInfoVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"size_id"] && ![[dictionary objectForKey:@"size_id"] isEqual:[NSNull null]]) {
            self.SizeID = [dictionary objectForKey:@"size_id"];
        }
        
        if (nil != [dictionary objectForKey:@"name"] && ![[dictionary objectForKey:@"name"] isEqual:[NSNull null]]) {
            self.Name = [dictionary objectForKey:@"name"];
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
    [descriptionOutput appendFormat: @"SizeID = \"%@\"\r\n", SizeID];
    [descriptionOutput appendFormat: @"Name = \"%@\"\r\n", Name];
    [descriptionOutput appendFormat: @"SkuNum = \"%@\"\r\n", SkuNum];
    
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
	[SizeID release];
	[Name release];
	[SkuNum release];
    
    [super dealloc];
#endif
}

@end
