//
//  ExtraInfoVO.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-7.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "ExtraInfoVO.h"

@implementation ExtraInfoVO

@synthesize Title;
@synthesize Info;

+ (ExtraInfoVO *)ExtraInfoVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [ExtraInfoVO ExtraInfoVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (ExtraInfoVO *)ExtraInfoVOWithDictionary:(NSDictionary *)dictionary
{
    ExtraInfoVO *instance = [[ExtraInfoVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)ExtraInfoVOListWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[ExtraInfoVO ExtraInfoVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"label"] && ![[dictionary objectForKey:@"label"] isEqual:[NSNull null]]) {
            self.Title = [dictionary objectForKey:@"label"];
        }
        
        if (nil != [dictionary objectForKey:@"title"] && ![[dictionary objectForKey:@"title"] isEqual:[NSNull null]]) {
            self.Info = [dictionary objectForKey:@"title"];
        }
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
    [descriptionOutput appendFormat: @"Title = \"%@\"\r\n", Title];
    [descriptionOutput appendFormat: @"Info = \"%@\"\r\n", Info];
    
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
	[Title release];
	[Info release];
    
    [super dealloc];
#endif
}

@end
