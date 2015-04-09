//
//  MessageBeanVO.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-21.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "MessageBeanVO.h"

@implementation MessageBeanVO

@synthesize ID;
@synthesize Content;
@synthesize Time;
@synthesize FromClient;
@synthesize IsRead;

+ (MessageBeanVO *)MessageBeanVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [MessageBeanVO MessageBeanVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (MessageBeanVO *)MessageBeanVOWithDictionary:(NSDictionary *)dictionary
{
    MessageBeanVO *instance = [[MessageBeanVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)MessageBeanVOListWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[MessageBeanVO MessageBeanVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"id"] && ![[dictionary objectForKey:@"id"] isEqual:[NSNull null]]) {
            self.ID = [dictionary objectForKey:@"id"];
        }
        
        if (nil != [dictionary objectForKey:@"content"] && ![[dictionary objectForKey:@"content"] isEqual:[NSNull null]]) {
            self.Content = [dictionary objectForKey:@"content"];
        }
        
        if (nil != [dictionary objectForKey:@"time"] && ![[dictionary objectForKey:@"time"] isEqual:[NSNull null]]) {
            self.Time = [dictionary objectForKey:@"time"];
        }
        
        if (nil != [dictionary objectForKey:@"form_client"] && ![[dictionary objectForKey:@"form_client"] isEqual:[NSNull null]]) {
            self.FromClient = [dictionary objectForKey:@"form_client"];
        }
        
        if (nil != [dictionary objectForKey:@"is_read"] && ![[dictionary objectForKey:@"is_read"] isEqual:[NSNull null]]) {
            self.IsRead = [dictionary objectForKey:@"is_read"];
        }
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
    [descriptionOutput appendFormat: @"ID = \"%@\"\r\n", ID];
    [descriptionOutput appendFormat: @"OrderPrice = \"%@\"\r\n", Content];
    [descriptionOutput appendFormat: @"CreateTime = \"%@\"\r\n", Time];
    [descriptionOutput appendFormat: @"PayTime = \"%@\"\r\n", FromClient];
    [descriptionOutput appendFormat: @"Status = \"%@\"\r\n", IsRead];
    
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
	[ID release];
	[Content release];
	[Time release];
	[FromClient release];
	[IsRead release];
    
    [super dealloc];
#endif
}

@end
