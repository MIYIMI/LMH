//
//  OrderBeanListVO.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-17.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "OrderBeanListVO.h"

@implementation OrderBeanListVO

@synthesize Code;
@synthesize Msg;
@synthesize Total;
@synthesize OrderBeanList;

+ (OrderBeanListVO *)OrderBeanListVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [OrderBeanListVO OrderBeanListVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (OrderBeanListVO *)OrderBeanListVOWithDictionary:(NSDictionary *)dictionary
{
    OrderBeanListVO *instance = [[OrderBeanListVO alloc] initWithDictionary:dictionary];
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
        
        if (nil != [dictionary objectForKey:@"list"] && ![[dictionary objectForKey:@"list"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"list"] isKindOfClass:[NSArray class]]) {
            self.OrderBeanList = [OrderBeanVO OrderBeanVOListWithArray:[dictionary objectForKey:@"list"]];
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
    [descriptionOutput appendFormat: @"OrderBeanList = \"%@\"\r\n", OrderBeanList];
    
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
	[Code release];
	[Msg release];
	[Total release];
	[OrderBeanList release];
    
    [super dealloc];
#endif
}

@end
