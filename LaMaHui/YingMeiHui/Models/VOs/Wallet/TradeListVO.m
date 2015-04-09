//
//  TradeListVO.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-21.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "TradeListVO.h"

@implementation TradeListVO

@synthesize Code;
@synthesize Msg;
@synthesize Total;
@synthesize TradeList;

+ (TradeListVO *)TradeListVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [TradeListVO TradeListVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (TradeListVO *)TradeListVOWithDictionary:(NSDictionary *)dictionary
{
    TradeListVO *instance = [[TradeListVO alloc] initWithDictionary:dictionary];
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
        
        if (nil != [dictionary objectForKey:@"total_count"] && ![[dictionary objectForKey:@"total_count"] isEqual:[NSNull null]]) {
            self.Total = [dictionary objectForKey:@"total_count"];
        }
        
        if (nil != [dictionary objectForKey:@"trade_list"] && ![[dictionary objectForKey:@"trade_list"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"trade_list"] isKindOfClass:[NSArray class]]) {
            self.TradeList = [TradeInfoVO TradeInfoVOListWithArray:[dictionary objectForKey:@"trade_list"]];
        }
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
    [descriptionOutput appendFormat: @"Code = \"%@\"\r\n", Code];
    [descriptionOutput appendFormat: @"Msg = \"%@\"\r\n", Msg];
    [descriptionOutput appendFormat: @"Total = \"%@\"\r\n", Total];
    [descriptionOutput appendFormat: @"TradeList = \"%@\"\r\n", TradeList];
    
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
	[Code release];
	[Msg release];
	[Total release];
	[TradeList release];
    
    [super dealloc];
#endif
}

@end
