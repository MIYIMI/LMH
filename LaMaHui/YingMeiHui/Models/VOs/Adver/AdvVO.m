//
//  AdvVO.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-14.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "AdvVO.h"

@implementation AdvVO

@synthesize Type;
@synthesize Key;
@synthesize Title;
@synthesize Pic;
@synthesize platform;
@synthesize Pid;

+ (AdvVO *)AdvVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [AdvVO AdvVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (AdvVO *)AdvVOWithDictionary:(NSDictionary *)dictionary
{
    AdvVO *instance = [[AdvVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)AdvVOListWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[AdvVO AdvVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"type"] && ![[dictionary objectForKey:@"type"] isEqual:[NSNull null]]) {
            self.Type = [dictionary objectForKey:@"type"];
        }
        
        if (nil != [dictionary objectForKey:@"key"] && ![[dictionary objectForKey:@"key"] isEqual:[NSNull null]]) {
            self.Key = [dictionary objectForKey:@"key"];
        }else if (nil != [dictionary objectForKey:@"url"] && ![[dictionary objectForKey:@"url"] isEqual:[NSNull null]]) {
            self.Key = [dictionary objectForKey:@"url"];
        }
        
        if (nil != [dictionary objectForKey:@"title"] && ![[dictionary objectForKey:@"title"] isEqual:[NSNull null]]) {
            self.Title = [dictionary objectForKey:@"title"];
        }
        
        if (nil != [dictionary objectForKey:@"pic"] && ![[dictionary objectForKey:@"pic"] isEqual:[NSNull null]]) {
            self.Pic = [dictionary objectForKey:@"pic"];
        }else if (nil != [dictionary objectForKey:@"image"] && ![[dictionary objectForKey:@"image"] isEqual:[NSNull null]]) {
            self.Pic = [dictionary objectForKey:@"image"];
        }
        
        if (nil != [dictionary objectForKey:@"source_platform"] && ![[dictionary objectForKey:@"source_platform"] isEqual:[NSNull null]]) {
            self.platform = [dictionary objectForKey:@"source_platform"];
        }else if(nil != [dictionary objectForKey:@"platform"] && ![[dictionary objectForKey:@"platform"] isEqual:[NSNull null]]) {
            self.platform = [dictionary objectForKey:@"platform"];
        }
        
        if (nil != [dictionary objectForKey:@"aname"] && ![[dictionary objectForKey:@"aname"] isEqual:[NSNull null]]) {
            self.aname = [dictionary objectForKey:@"aname"];
        }
        if (nil != [dictionary objectForKey:@"pid"] && ![[dictionary objectForKey:@"pid"] isEqual:[NSNull null]]) {
            self.Pid = [dictionary objectForKey:@"pid"];
        }
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
    [descriptionOutput appendFormat: @"Type = \"%@\"\r\n", Type];
    [descriptionOutput appendFormat: @"Key = \"%@\"\r\n", Key];
    [descriptionOutput appendFormat: @"Title = \"%@\"\r\n", Title];
    [descriptionOutput appendFormat: @"Pic = \"%@\"\r\n", Pic];
    
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
	[Type release];
	[Key release];
	[Title release];
	[Pic release];
    
    [super dealloc];
#endif
}

@end
