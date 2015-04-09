//
//  BrandInfoVO.m
//  YingMeiHui
//
//  Created by work on 14-10-9.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "BrandInfoVO.h"

@implementation BrandInfoVO

@synthesize brandTitle;
@synthesize brandID;
@synthesize brandlogo;
@synthesize composite;
@synthesize manner;
@synthesize speed;

+ (BrandInfoVO *)BrandInfoVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [BrandInfoVO BrandInfoVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (NSArray *)BrandInfoVOWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[BrandInfoVO BrandInfoVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

+ (BrandInfoVO *)BrandInfoVOWithDictionary:(NSDictionary *)dictionary
{
    BrandInfoVO *instance = [[BrandInfoVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"brand_title"] && ![[dictionary objectForKey:@"brand_title"] isEqual:[NSNull null]]) {
            self.brandTitle = [dictionary objectForKey:@"brand_title"];
        }
        
        if (nil != [dictionary objectForKey:@"brand_id"] && ![[dictionary objectForKey:@"brand_id"] isEqual:[NSNull null]]) {
            self.brandID = [dictionary objectForKey:@"brand_id"];
        }
        
        if (nil != [dictionary objectForKey:@"brand_logo"] && ![[dictionary objectForKey:@"brand_logo"] isEqual:[NSNull null]]) {
            self.brandlogo = [dictionary objectForKey:@"brand_logo"];
        }
        
        if (nil != [dictionary objectForKey:@"composite"] && ![[dictionary objectForKey:@"composite"] isEqual:[NSNull null]]) {
            self.composite = [dictionary objectForKey:@"composite"];
        }
        
        if (nil != [dictionary objectForKey:@"manner"] && ![[dictionary objectForKey:@"manner"] isEqual:[NSNull null]]) {
            self.manner = [dictionary objectForKey:@"manner"];
        }
        
        if (nil != [dictionary objectForKey:@"speed"] && ![[dictionary objectForKey:@"speed"] isEqual:[NSNull null]]) {
            self.speed = [dictionary objectForKey:@"speed"];
        }
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
    [descriptionOutput appendFormat: @"Code = \"%@\"\r\n", brandTitle];
    [descriptionOutput appendFormat: @"Msg = \"%@\"\r\n", brandID];
    [descriptionOutput appendFormat: @"BrandTitle = \"%@\"\r\n", brandlogo];
    [descriptionOutput appendFormat: @"Pics = \"%@\"\r\n", composite];
    [descriptionOutput appendFormat: @"Title = \"%@\"\r\n", manner];
    [descriptionOutput appendFormat: @"Title = \"%@\"\r\n", speed];
    
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
    [brandTitle release];
    [brandID release];
    [brandlogo release];
    [composite release];
    [manner release];
    [speed release];
    
    [super dealloc];
#endif
}

@end
