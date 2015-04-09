//
//  TradeInfoVO.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-21.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "TradeInfoVO.h"

@implementation TradeInfoVO

@synthesize ID;
@synthesize TypeName;
@synthesize Time;
@synthesize Value;

+ (TradeInfoVO *)TradeInfoVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [TradeInfoVO TradeInfoVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (TradeInfoVO *)TradeInfoVOWithDictionary:(NSDictionary *)dictionary
{
    TradeInfoVO *instance = [[TradeInfoVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)TradeInfoVOListWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[TradeInfoVO TradeInfoVOWithDictionary:entry]];
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
        
        if (nil != [dictionary objectForKey:@"type_name"] && ![[dictionary objectForKey:@"type_name"] isEqual:[NSNull null]]) {
            self.TypeName = [dictionary objectForKey:@"type_name"];
        }
        
        if (nil != [dictionary objectForKey:@"time"] && ![[dictionary objectForKey:@"time"] isEqual:[NSNull null]]) {
            self.Time = [dictionary objectForKey:@"time"];
        }
        
        if (nil != [dictionary objectForKey:@"values"] && ![[dictionary objectForKey:@"values"] isEqual:[NSNull null]]) {
            self.Value = [dictionary objectForKey:@"values"];
        }
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
    [descriptionOutput appendFormat: @"ID = \"%@\"\r\n", ID];
    [descriptionOutput appendFormat: @"TypeName = \"%@\"\r\n", TypeName];
    [descriptionOutput appendFormat: @"Time = \"%@\"\r\n", Time];
    [descriptionOutput appendFormat: @"Value = \"%@\"\r\n", Value];
    
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
	[ID release];
	[TypeName release];
	[Time release];
	[Value release];
    
    [super dealloc];
#endif
}

@end
